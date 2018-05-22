defmodule BrowseDown.ClockServer do
  @moduledoc false
  use GenServer

  # Client

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def start_work(server) do
    GenServer.cast(server, :work)
  end

  # Server

  def init(state) do
    {:ok, state}
  end

  def handle_cast(:work, state) do
    schedule_work()
    {:noreply, state}
  end

  def handle_info(:work, state) do
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    BrowseDown.RenderServer.render(BrowseDown.RenderServer)
    Process.send_after(self(), :work, hours_to_ms(2))
  end

  defp hours_to_ms(hours) do
    hours * 60 * 60 * 1000
  end
end
