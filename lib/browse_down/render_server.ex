defmodule BrowseDown.RenderServer do
  @moduledoc """
  Selects and opens a random markdown file.  Calls MarkdownConverter with the
  randomly selected markdown.  Opens the returned HTML document in the system's
  default browser.
  """

  @base_path Application.get_env(:browse_down, :markdown_dir)

  use GenServer

  alias BrowseDown.ClockServer


  # Client

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def render(server) do
    GenServer.call(server, :render)
  end

  # Server

  def init(state) do
    ClockServer.start_clock(ClockServer)
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
    "#{@base_path}/**/*.{md,markdown}"
    |> select_random_file
    |> open_file
    |> convert_to_html
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

  defp convert_to_html({:ok, file, path}, converter \\ BrowseDown.MarkdownConverter) do
    case converter.convert(file, path) do
      {:ok, document} -> {:ok, document}
      {:error, reason, path} -> {:error, path}
    end
  end

  defp open_in_browser({:ok, document}) do
    System.cmd("open", [document])
    {:ok, document}
  end

  defp open_in_browser({:error, markdown}) do
    {:error, markdown}
  end
end
