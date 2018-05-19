defmodule BrowseDown.Supervisor do
  @moduledoc false
  use Supervisor

  # Client

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  # Server

  def init(:ok) do
    children = [
      {Task.Supervisor, name: BrowseDown.TaskSupervisor},
      {BrowseDown.ClockServer, name: BrowseDown.ClockServer},
      {BrowseDown.RenderServer, name: BrowseDown.RenderServer}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
