use Mix.Config

config :bot, Bot.Robot,
  adapter: Hedwig.Adapters.XMPP,
  name: "photo_bot",
  responders: [
    {Bot.Service.Responder, []}
  ],
  jid: "photo_bot@xmpp.lambdadays.org",
  password: "photo_bot",
  rooms: [{"photo_room@muc.xmpp.lambdadays.org", []}]

config :porcelain,
  driver: Porcelain.Driver.Basic

config :bot, Bot.Service,
  callback: PhotoPi

config :photo_pi, PhotoPi.Twitter,
  status_message: "New photo from lambdadays bot"
