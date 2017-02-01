use Mix.Config

if Mix.env in [:prod, :dev, :test] do
  import_config "../apps/*/config/config.exs"
else
  import_config "#{Mix.env}.exs"
end

if Mix.env != :music_pi do
  import_config "secrets.exs"
end
