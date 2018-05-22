defmodule BrowseDown.RenderServer do
  @moduledoc false
  use GenServer
  # TODO: make this configurable
  # TODO: handle assets better
  @base_path "/Users/upgraydd/Desktop/markdown_notes"

  # Client

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def render(server) do
    GenServer.call(server, :render)
  end

  # Server

  def init(state) do
    BrowseDown.ClockServer.start_work(BrowseDown.ClockServer)
    {:ok, state}
  end

  def handle_call(:render, _form, state) do
    BrowseDown.TaskSupervisor
    |> Task.Supervisor.async(fn -> select_random() end)
    |> Task.await()
    |> open_file
    |> render_to_browser
    {:reply, :ok, state}
  end

  # Helper Functions

  def select_random do
    "#{@base_path}/**/*.{md,markdown}"
    |> Path.wildcard
    |> Enum.random
  end

  def select_random(path) do
    "#{path}/**/*.{md,markdown}"
    |> Path.wildcard
    |> Enum.random
  end

  def open_file(path) do
    path
    |> File.open([:read])
    |> case do
         {:ok, file}     -> {:ok, file, Path.basename(path)}
         {:error, error} -> {:error, error}
       end
  end

  def render_to_browser({:ok, file, file_name}) do
    {:ok, temp} = Briefly.create([extname: '.html'])
    markup = html_head(file_name) <> html_body_from_markdown(file)
    File.write!(temp, markup)
    System.cmd("open", [temp])
    File.close(file)
    File.rm(temp)
  end

  def render_to_browser({:error, message}) do
    IO.puts message
  end

  defp html_head(basename) do
    """
    <head>
    <title>#{basename}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="#{stylesheet_asset_path()}" />
    <script src="#{javascript_asset_path()}"></script>
    </head>
    """
  end

  defp javascript_asset_path do
    Path.expand("assets/prism.js")
  end

  defp stylesheet_asset_path do
    Path.expand("assets/prism.css")
  end

  defp html_body_from_markdown(file) do
    case Earmark.as_html(IO.read(file, :all), earmark_options()) do
      {:ok, html_doc, []} -> html_doc
      _ -> "<p style=\"color:red;\">Could not parse markdown</p>"
    end
  end

  defp earmark_options do
    %Earmark.Options{code_class_prefix: "lang- language-"}
  end
end
