defmodule BrowseDown.RenderServer do
  @moduledoc false
  @prism_css File.read! "priv/prism.css"
  @prism_js File.read! "priv/prism.js"
  use GenServer
  # TODO: make this an config var
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
    case render do
      {:ok, temp_dir} ->
        BrowseDown.AppState.put_dir(temp_dir)
        {:reply, :ok, state}
      _ -> {:reply, :ok, state}
    end
  end

  # Helper Functions

  def render do
    BrowseDown.TaskSupervisor
    |> Task.Supervisor.async(fn -> select_random() end)
    |> Task.await()
    |> open_file
    |> render_to_browser
  end

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
    {:ok, temp_dir} = Briefly.create(directory: true)
    markup = build_html(file, file_name, temp_dir)
    page = Path.join(temp_dir, "#{file_name}.html")
    File.write!(page, markup)
    System.cmd("open", [page])
    File.close(file)
    {:ok, temp_dir}
  end

  defp build_html(file, file_name, temp_dir) do
    {:ok, stylesheet} = write_style_sheet(temp_dir)
    {:ok, javascript} = write_js(temp_dir)
    html_head(file_name, stylesheet, javascript) <> html_body_from_markdown(file)
  end

  defp write_style_sheet(temp_dir) do
    stylesheet = Path.join(temp_dir, "prism.css")
    File.write!(stylesheet, prism_css())
    {:ok, stylesheet}
  end

  defp write_js(temp_dir) do
    js = Path.join(temp_dir, "prism.js")
    File.write!(js, prism_js())
    {:ok, js}
  end

  defp prism_css, do: @prism_css

  defp prism_js, do: @prism_js

  defp html_head(file_name, stylesheet, javascript) do
    """
    <head>
    <title>#{file_name}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="#{stylesheet}" />
    <script src="#{javascript}"></script>
    </head>
    """
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

  defp cleanup_tempfiles({:ok, temp_dir}) do
    {:ok, files} = File.ls(temp_dir)
    delete_files(expand(files, temp_dir))
    File.rmdir!(temp_dir)
  end

  defp expand(files, dir) do
    Enum.map(files, fn(file) -> "#{dir}/#{file}" end)
  end

  defp delete_files([]) do
    []
  end

  defp delete_files([path | rest]) do
    File.rm!(path)
    delete_files(rest)
  end
end
