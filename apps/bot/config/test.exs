use Mix.Config

config :logger,
  # This is required for tests to run properly as the %Hedwig.Message{}
  # struct doesn't contain the %Hedwig.User{} as a value in the user
  # field.
  compile_time_purge_level: :error
