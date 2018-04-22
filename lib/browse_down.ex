defmodule BrowseDown do
  @moduledoc """
  Documentation for BrowseDown.
  """

  @doc """
  ## Examples

      iex> BrowseDown.view

  """
  def pick do
    path = "/Users/upgraydd/Desktop/iex.md"
    case open_file(path) do
      {:ok, file}     -> render_to_browser(file, path)
      {:error, error} -> IO.puts error
    end
  end

  defp open_file(path) do: File.open(path, [:read])

  defp render_to_browser(file, path) do
    {:ok, temp} = Briefly.create([extname: '.html'])
    markup = html_head(Path.basename(path)) <> html_body_from_markdown(file)
    File.write!(temp, markup)
    System.cmd("open", [temp])
    File.close(file)
  end

  defp html_head(basename) do
  """
  <head>
    <title>#{basename}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="#{stylesheet_asset_path()}" />
    <script src="#{javascript_asset_path()}"></script>
  </head>
  """
  end

  defp javascript_asset_path do
    Path.expand("assets/prism.js")
  end

  defp stylesheet_asset_path do
    Path.expand("assets/prism.css")
  end

  defp html_body_from_markdown(file) do
    case Earmark.as_html(IO.read(file, :all), earmark_options()) do
      {:ok, html_doc, []} -> open_in_browser(html_doc)
    end
  end

  defp earmark_options do
    %Earmark.Options{code_class_prefix: "lang- language-"}
  end
end
