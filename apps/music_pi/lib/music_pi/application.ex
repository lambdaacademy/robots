defmodule MusicPi.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    musician = [worker(MusicPi.Player, [])]
    Supervisor.start_link(musician, [strategy: :one_for_one, name: MusicPi.Supervisor])
  end

end
