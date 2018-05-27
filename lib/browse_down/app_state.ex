defmodule BrowseDown.AppState do
  use Agent

  def start_link(opts) do
    Agent.start_link(fn -> %{temp_dirs: []} end, opts)
  end

  def put_dir(dir) do
    Agent.update(
      BrowseDown.AppState,
      fn(state) ->
        {:ok, dirs} = Map.fetch(state, :temp_dirs)
        Map.put(state, :temp_dirs, [dir | dirs])
      end
    )
  end

  def index do
    Agent.get(BrowseDown.AppState, fn(state) -> state end)
  end
end
