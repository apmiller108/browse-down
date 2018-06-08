defmodule BrowseDown do
  @moduledoc "Starts the Supervisor"
  use Application

  def start(_type, _args) do
    Application.put_env(:browse_down, :markdown_dir, System.get_env("BROWSE_DOWN_DIR"))
    Application.put_env(:browse_down, :interval, System.get_env("BROWSE_DOWN_INTERVAL"))
    BrowseDown.Supervisor.start_link(name: BrowseDown.Supervisor)
  end
end
