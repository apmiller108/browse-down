defmodule BrowseDown.Worker do
  use GenServer
  @name :bd_worker

  # CLIENT API

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, :ok, [{:name, @name} | options])
  end

  # SERVER

  def init(:ok) do
    {:ok}
  end
end
