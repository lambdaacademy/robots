# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :bot, Bot.Robot,
  adapter: Hedwig.Adapters.XMPP,
  name: "music_bot",
  aka: "/",
  responders: [
    {Hedwig.Responders.Help, []},
    {Hedwig.Responders.Ping, []},
    {Bot.Service.Responder, []}
  ],
  jid: "music_bot@lambdadays.org",
  password: "music_bot",
  rooms: [{"music_room@muc.lambdadays.org", []}]

config :porcelain,
  driver: Porcelain.Driver.Basic

config :bot, Bot.Service,
  callback: MusicPi
