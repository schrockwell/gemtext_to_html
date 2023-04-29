defmodule GemtextToHTML.MixProject do
  use Mix.Project

  def project do
    [
      app: :gemtext_to_html,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:floki, "~> 0.34.2", only: [:dev, :test]},
      {:gemtext, "~> 0.2.0"},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:phoenix_live_view, "~> 0.18.0"}
    ]
  end

  defp docs do
    [
      main: "GemtextToHTML"
    ]
  end

  defp package do
    [
      description: "Render Gemini Gemtext documents as HTML",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/schrockwell/gemtext_to_html"}
    ]
  end
end
