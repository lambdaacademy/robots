defmodule PhotoPi.Executor do
  @moduledoc false

  use GenServer

  @action_ids ["1", "2"]
  @actions [{"1", "take a photo"}, {"2", "take a photo and post it on Twitter"}]

  require Logger

  @spec actions :: [Bot.Service.action]
  def actions, do: @actions

  @spec run_action(Bot.Service.action_id) :: Bot.Service.action_run_result
  def run_action(action_id) when action_id in @action_ids do
    GenServer.cast(__MODULE__, {:run_action, action_id})
    {:ok, "Taking a photo"}
  end
  def run_action(_), do: {:error, "Action unavailable"}

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

  defp handle_action("1") do
    path = PhotoPi.Camera.take_photo()
    Logger.debug(path)
  end

  defp handle_action("2") do
    path = PhotoPi.Camera.take_photo()
    Process.sleep(2_000)
    PhotoPi.Twitter.post_status_with_image(path)
  end
end
