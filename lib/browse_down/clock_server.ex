defmodule BrowseDown.ClockServer do
  @moduledoc false
  use GenServer

  # Client

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def start_clock(server) do
    GenServer.cast(server, :work)
  end

  # Server

  def init(state) do
    {:ok, state}
  end

  def handle_cast(:work, state) do
    BrowseDown.RenderServer.render(BrowseDown.RenderServer)
    schedule_browse_down()
    {:noreply, state}
  end

  def handle_info(:work, state) do
    schedule_browse_down()
    {:noreply, state}
  end

  # Helper Functions

  defp schedule_browse_down() do
    Process.send_after(self(), :work, hours_to_ms(24))
  end

  defp hours_to_ms(hours) do
    hours * 60 * 60 * 1000
  end
end
