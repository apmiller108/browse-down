defmodule BrowseDown.MarkdownConverter do
  @moduledoc """
  Converts markdown to HTML.  Writes HTML document with CSS and JS assets
  needed for syntax highlighting.

  """

  use GenServer

  @prism_css File.read! "priv/prism.css"
  @prism_js  File.read! "priv/prism.js"

  # Client

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def convert(markdown, path) do
    GenServer.call(MarkdownConverter, {:convert, markdown, path})
  end

  # Server

  def init(state) do
    {:ok, state}
  end

  def handle_call({:convert, markdown, path}, _from, state) do
    temp_dir      = create_temp_directory()
    filename      = Path.basename(path)
    html_content  = build_html(markdown, filename, temp_dir)
    html_document = Path.join(temp_dir, "#{filename}.html")
    File.close(markdown)
    case File.write(html_document, html_content) do
      :ok -> {:reply, {:ok, html_document}, state}
      {:error, reason} -> {:reply, {:error, reason, path}, state}
    end
  end

  # Helper Functions

  defp create_temp_directory do
    BrowseDown.AppState.cleanup()
    {:ok, temp_dir} = Briefly.create(directory: true)
    BrowseDown.AppState.put_dir(temp_dir)
    temp_dir
  end

  defp build_html(file, title, temp_dir) do
    {:ok, stylesheet} = write_style_sheet(temp_dir)
    {:ok, javascript} = write_js(temp_dir)
    html_head(title, stylesheet, javascript) <> html_body_from_markdown(file)
  end

  @spec write_style_sheet(String.t) :: {atom, String.t}
  defp write_style_sheet(temp_dir) do
    stylesheet = Path.join(temp_dir, "prism.css")
    File.write!(stylesheet, prism_css())
    {:ok, stylesheet}
  end

  defp write_js(temp_dir) do
    js = Path.join(temp_dir, "prism.js")
    File.write!(js, prism_js())
    {:ok, js}
  end

  defp prism_css, do: @prism_css

  defp prism_js, do: @prism_js

  defp html_head(title, stylesheet, javascript) do
    """
    <head>
    <title>#{title}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="#{stylesheet}" />
    <script src="#{javascript}"></script>
    </head>
    """
  end

  defp html_body_from_markdown(file) do
    case Earmark.as_html(IO.read(file, :all), earmark_options()) do
      {:ok, html_doc, []} -> html_doc
      _ -> "<p style=\"color:red;\">Could not parse markdown</p>"
    end
  end

  defp earmark_options do
    %Earmark.Options{code_class_prefix: "lang- language-"}
  end
end
