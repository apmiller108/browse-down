defmodule BrowseDown do
  @moduledoc "Starts the Supervisor"
  use Application

  def start(_type, _args) do
    BrowseDown.Supervisor.start_link(name: BrowseDown.Supervisor)
  end
end
