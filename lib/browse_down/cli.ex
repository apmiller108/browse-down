defmodule BrowseDown.CLI do
  def main(args) do
    parse_args(args) |> process_args
  end

  defp parse_args(args) do
    {params, _, _} = OptionParser.parse(args, switches: [path: :string])
    params
  end

  defp process_args([path: path]) do
  end

  defp process_args(_) do
    IO.puts "--path flag is required\n Example:\n\s\s--path=/path/to/notes"
  end
end
