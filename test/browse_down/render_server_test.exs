defmodule BrowseDown.RenderServerTest do
  use ExUnit.Case, async: true

  setup do
    renderer = start_supervised(BrowseDown.RenderServer)
    %{renderer: renderer}
  end
end
