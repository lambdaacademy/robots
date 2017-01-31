use Mix.Config

config :porcelain,
  driver: Porcelain.Driver.Basic

config :photo_pi, PhotoPi.Twitter,
  status_message: "Test photo from PhotoPi bot"
