defmodule PhotoPi.Executor do
  @moduledoc false

  use GenServer

  require Logger

  @spec actions :: [PhotoPi.action]
  def actions do
    [{1, "Take a photo"},
     {2, "Take a photo and post it on Twitter"}]
  end

  @spec run_action(PhotoPi.action_id) :: :ok
  def run_action(action_id) do
    GenServer.cast(__MODULE__, {:run_action, action_id})
  end

  @spec start_link :: GenServer.on_start
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  ## GenServer callbacks

  def handle_cast({:run_action, action_id}, state) do
    handle_action(action_id)
    {:noreply, state}
  end

  ## Internals

  def handle_action(1) do
    path = PhotoPi.Camera.take_photo()
    Logger.debug(path)
  end
end
