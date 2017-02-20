use Mix.Config

config :bot, Bot.Robot,
  adapter: Hedwig.Adapters.XMPP,
  name: "test_bot",
  responders: [
    {Bot.Service.Responder, []}
  ],
  jid: "test_bot@xmpp.lambdadays.org",
  password: "test_bot",
  rooms: [{"test_room@muc.xmpp.lambdadays.org", []}]

config :bot, Bot.Service,
  callback: Bot.Service.Mock

import_config "#{Mix.env}.exs"
