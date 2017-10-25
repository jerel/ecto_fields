defmodule EctoFields.Mixfile do
  use Mix.Project

  def project() do
    [app: :ecto_fields,
     version: "1.1.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package(),
     description: description()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application() do
    [applications: [:logger]]
  end

  def package() do
    [licenses: ["MIT"],
     maintainers: ["jerel"],
     links: %{"GitHub" => "https://github.com/jerel/ecto_fields"}]
  end

  def description() do
    """
    Provides commonly used fields for Ecto projects.
    """
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps() do
    [{:ecto, "~> 2.0"},
     {:ex_doc, ">= 0.0.0", only: :dev},
     {:mix_test_watch, "~> 0.2", only: :dev}]
  end
end
