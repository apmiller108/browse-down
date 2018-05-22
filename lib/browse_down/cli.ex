defmodule BrowseDown.CLI do
  @moduledoc false
  alias BrowseDown.RenderServer

  def main(args) do
    args
    |> parse_args
    |> process_args
  end

  defp parse_args(args) do
    {params, _, _} = OptionParser.parse(args, switches: [dir: :string])
    params
  end

  defp process_args([dir: dir]) do
    dir
    |> RenderServer.select_random
    |> open_in_browser
  end

  defp process_args(_) do
    # RenderServer.select_random |> open_in_browser
  end

  defp open_in_browser(path) do
    path
    |> RenderServer.open_file
    |> RenderServer.render_to_browser
  end
end
