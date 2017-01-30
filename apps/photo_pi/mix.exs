defmodule PhotoPi.Mixfile do
  use Mix.Project

  def project do
    [app: :photo_pi,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {PhotoPi.Application, []}]
  end

  defp deps do
    [{:porcelain, "~> 2.0"},
     {:extwitter, "~> 0.8"},
     {:bot, in_umbrella: true}]
  end
end
