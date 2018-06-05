defmodule BrowseDown.ClockServer do
  @moduledoc """
  Schedules calls to the RenderServer at regular intervals.
  """
  use GenServer

  alias BrowseDown.RenderServer

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
    schedule_browse_down()
    case RenderServer.render(RenderServer) do
      {:ok, _html} -> {:noreply, state}
      {:error, markdown} ->
        # TODO: Log errors
        IO.puts "Error rendering #{markdown}"
        {:noreply, state}
    end
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
