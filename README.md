# BrowseDown

## Overview
This is an effort to be reminded of previously taken notes. After accumulating
several hundred notes, it's easy to forget what topics have been recorded.
This application runs daemonized, and selects one random markdown file
from a directory of your choosing, and renders it in your system's default
browser. The application will continue to render random markdown files at a time
interval of your choosing.

I made this because I've taken serveral hundred notes in the last couple of years
and I too easily forget them. With this, I am reminded once a day of something I
learned (and forgotten).

## Setup and Running
1. Set up the following environment variables:
  - `BROWSE_DOWN_DIR` - Required. This is the directory that contains your
  markdown notes.
  - `BROWSE_DOWN_INTERVAL` - Optional. This is the render interval in hours. The
  default is `24`.
2. `mix deps.get` - to install dependencies.
3. `mix run --no-halt` - You can use Mix to run the app or...
4. `MIX_ENV=prod mix release` - Use Distillery to build a release for your system.
  - The output from Distillery will provide instructions for running the application
  daemonized.

## Other Details
- Syntax highlighting is supported. It uses [Prismjs](https://prismjs.com/).
- The HTML and supporting assets are written as temp files, prior to rendering.
The old temp files are cleaned up, when rendering the next interval.
- The production environment will write logs to `~/.browse_down/`, while development
will output logs to the console.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `browse_down` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:browse_down, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/browse_down](https://hexdocs.pm/browse_down).

