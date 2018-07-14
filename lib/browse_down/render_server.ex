defmodule BrowseDown.RenderServer do
  @moduledoc """
  Selects and opens a random markdown file.  Calls MarkdownConverter with the
  randomly selected markdown.  Opens the returned HTML document in the system's
  default browser.
  """

  use GenServer
  require Logger

  # Client

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def render(server) do
    GenServer.call(server, :render)
  end

  # Server

  def init(state) do
    {:ok, state}
  end

  def handle_call(:render, _form, state) do
    case render() do
      {:ok, html} -> {:reply, {:ok, html}, state}
      {:error, markdown} -> {:reply, {:error, markdown}, state}
    end
  end

  # Helper Functions

  def render do
    "#{Application.get_env(:browse_down, :markdown_dir)}/**/*.{md,markdown,html}"
    |> select_random_file
    |> open_file
    |> convert
    |> open_in_browser
  end

  defp select_random_file(path) do
    path
    |> Path.wildcard
    |> Enum.random
  end

  defp open_file(path) do
    {:ok, file} = File.open(path, [:read])
    {:ok, file, path}
  end

  defp convert({:ok, file, path}) do
    %{"ext" => ext} = Regex.named_captures(~r/(?<ext>\..+$)/, path)
    do_conversion({file, path, ext})
  end

  defp do_conversion(file_path_ext_tuple, converter \\ BrowseDown.MarkdownConverter)

  defp do_conversion({file, path, ext}, converter)
  when ext == ".md" or ext == ".markdown" do
    case converter.convert(file, path) do
      {:ok, document} -> {:ok, document}
      {:error, reason, path} ->
        Logger.error "Unable to convert markdown: #{reason}"
        {:error, path}
    end
  end

  defp do_conversion({_file, path, ext}, _converter) when ext == ".html", do: {:ok, path}

  defp open_in_browser({:ok, document}) do
    System.cmd("open", [document])
    {:ok, document}
  end

  defp open_in_browser({:error, markdown}) do
    {:error, markdown}
  end
end
