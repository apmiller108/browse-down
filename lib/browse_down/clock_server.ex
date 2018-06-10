defmodule BrowseDown.ClockServer do
  @moduledoc """
  Schedules calls to the RenderServer at regular intervals.
  """
  use GenServer
  require Logger

  alias BrowseDown.RenderServer

  @default_interval "24"

  # Client

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def start_clock(server) do
    GenServer.cast(server, :start)
  end

  # Server

  def init(state) do
    schedule_browse_down()
    {:ok, state}
  end

  def handle_info(:work, state) do
    schedule_browse_down()
    case RenderServer.render(RenderServer) do
      {:ok, html} ->
        Logger.info fn -> "Successfully rendered #{html}" end
        {:noreply, state}
      {:error, markdown} ->
        Logger.error fn -> "Error rendering #{markdown}" end
        {:noreply, state}
    end
    {:noreply, state}
  end

  # Helper Functions

  defp schedule_browse_down() do
    inverval = Application.get_env(:browse_down, :interval) || @default_interval
    Process.send_after(self(), :work, hours_to_ms(inverval))
  end

  defp hours_to_ms(hours) when is_binary(hours) do
    {hours_float, _} = Float.parse(hours)
    trunc(hours_float * 60 * 60 * 1000)
  end
end
