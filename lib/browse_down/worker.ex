defmodule BrowseDown.Worker do
  use GenServer
  @name :file_picker
  # TODO: timer worker, file picker worker, renderer worker, supervisor

  # CLIENT API

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, :ok, [{:name, @name} | options])
  end

  def pick_markdown(pid) do
    GenServer.call(pid, :pick)
  end

  # SERVER

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call(:pick, {from, _ref}, state) do
    path = select_random("/Users/upgraydd/Desktop/markdown_notes")
    new_state = Map.put(state, path, DateTime.utc_now)
    {:reply, [path: path], new_state}
  end

  # HELPER FUNCTIONS

  defp select_random(basepath) do
    "#{basepath}/**/*.{md,markdown}"
    |> Path.wildcard
    |> Enum.random
  end
end
