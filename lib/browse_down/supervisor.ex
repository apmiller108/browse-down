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
      {BrowseDown.AppState, name: BrowseDown.AppState},
      {BrowseDown.ClockServer, name: BrowseDown.ClockServer},
      {BrowseDown.RenderServer, name: BrowseDown.RenderServer},
      {BrowseDown.MarkdownConverter, name: MarkdownConverter}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
