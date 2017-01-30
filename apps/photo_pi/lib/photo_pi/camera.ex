defmodule PhotoPi.Camera do
  @moduledoc false

  use GenServer

  @base_path :code.priv_dir(:photo_pi)

  @spec start_link :: GenServer.on_start
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @spec take_photo :: Path.t
  def take_photo do
    GenServer.call(__MODULE__, :take_photo)
  end

  ## GenServer callbacks

  def handle_call(:take_photo, _from, state) do
    {:reply, "potatoes", state}
  end
end
