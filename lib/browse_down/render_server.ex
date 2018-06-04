defmodule BrowseDown.RenderServer do
  @moduledoc false

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
    BrowseDown.ClockServer.start_clock(BrowseDown.ClockServer)
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
