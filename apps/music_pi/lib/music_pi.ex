defmodule MusicPi do

  @behaviour Bot.Service

  defdelegate actions, to: MusicPi.Player

  defdelegate run_action(action_id), to: MusicPi.Player
end
