use Mix.Config

config :bot, Bot.Robot,
  adapter: Hedwig.Adapters.XMPP,
  name: "test_bot",
  aka: "/",
  responders: [
    {Hedwig.Responders.Help, []},
    {Hedwig.Responders.Ping, []}
  ],
  jid: "test_bot@lambdadays.org",
  password: "test_bot",
  rooms: [{"test_room@muc.lambdadays.org", []}]
