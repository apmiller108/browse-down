defmodule BrowseDown.MixProject do
  use Mix.Project

  def project do
    [
      app: :browse_down,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {BrowseDown, []}
    ]
  end

  defp deps do
    [
      {:earmark, "~> 1.2"},
      {:briefly, "~> 0.3.0"},
      {:logger_file_backend, "~> 0.0.10"},
      {:distillery, "~> 1.5", runtime: false},
      {:dogma, "~> 0.1", only: :dev},
      {:credo, "~> 0.7", only: :dev},
      {:dialyxir, "~> 0.5", only: :dev, runtime: false}
    ]
  end
end
