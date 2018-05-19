defmodule BrowseDown.CLI do
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
    # TODO: implement start and stopping of the daemonized app
  end

  defp process_args(_) do
    IO.puts "--dir flag is required\n Example:\n\s\s--dir=/path/to/notes"
  end
end
