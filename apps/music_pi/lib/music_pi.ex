defmodule MusicPi do
  use Application

  def start(_type, args) do
    import Supervisor.Spec, warn: false

    children = [worker(MusicPi.Player, args)]
    opts = [strategy: :one_for_one, name: MusicPi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
