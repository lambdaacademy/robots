defmodule PhotoPi.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(PhotoPi.Camera, []),
      worker(PhotoPi.Executor, [])
    ]

    opts = [strategy: :one_for_one, name: PhotoPi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
