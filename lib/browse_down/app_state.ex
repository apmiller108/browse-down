defmodule BrowseDown.AppState do
  use Agent

  def start_link(opts) do
    Agent.start_link(fn -> %{temp_dirs: []} end, opts)
  end

  def put_dir(dir) do
    Agent.update(
      __MODULE__,
      fn(state) ->
        {:ok, dirs} = Map.fetch(state, :temp_dirs)
        Map.put(state, :temp_dirs, [dir | dirs])
      end
    )
  end

  def index do
    Agent.get(__MODULE__, fn(state) -> state end)
  end

  def cleanup do
    Agent.update(__MODULE__, fn(state) -> reset_tempdirs(state) end)
  end

  defp reset_tempdirs(state) do
    {:ok, dirs} = Map.fetch(state, :temp_dirs)
    cleanup_tempdirs(dirs)
    Map.put(state, :temp_dirs, [])
  end

  defp cleanup_tempdirs([]), do: []

  defp cleanup_tempdirs([dir | dirs]) do
    dir
    |> expand_paths
    |> cleanup_tempfiles
    File.rmdir(dir)
    cleanup_tempdirs(dirs)
  end

  defp expand_paths(dir) do
    {:ok, files} = File.ls(dir)
    Enum.map(files, fn(file) -> "#{dir}/#{file}" end)
  end

  defp cleanup_tempfiles([]), do: []

  defp cleanup_tempfiles([file | files]) do
    File.rm(file)
    cleanup_tempfiles(files)
  end
end
