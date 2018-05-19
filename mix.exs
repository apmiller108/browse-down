defmodule BrowseDown.MixProject do
  use Mix.Project

  def project do
    [
      app: :browse_down,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BrowseDown, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:earmark, "~> 1.2"},
      {:briefly, "~> 0.3.0"},
      {:dogma, "~> 0.1", only: :dev},
      {:credo, "~> 0.7", only: :dev}
    ]
  end

  defp escript do
    [main_module: BrowseDown.CLI]
  end
end
