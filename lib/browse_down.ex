defmodule BrowseDown do
  @moduledoc """
  Documentation for BrowseDown.
  """

  @doc """
  ## Examples

      iex> BrowseDown.parse

  """
  def view do
    case open_file() do
      {:ok, file} -> parse_file(file)
    end
  end

  defp open_file do
    File.open("/Users/upgraydd/Desktop/iex.md", [:read])
  end

  defp parse_file(file) do
    case Earmark.as_html(IO.read(file, :all), earmark_options()) do
      {:ok, html_doc, []} -> open_in_browser(html_doc)
    end
    File.close(file)
  end

  defp earmark_options do
    %Earmark.Options{code_class_prefix: "lang- language-"}
  end

  defp open_in_browser(html) do
    {:ok, path} = Briefly.create([extname: '.html'])
    markup = html_head() <> html
    File.write!(path, markup)
    System.cmd("open", [path])
  end

  defp html_head do
    """
    <head>
      <title>Your Stuff</title>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/prismjs@1.14.0/themes/prism-solarizedlight.css" />
      <script src="https://cdn.jsdelivr.net/npm/prismjs@1.14.0/prism.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/prismjs@1.14.0/components/prism-elixir.js"></script>
    </head>
    """
  end
end
