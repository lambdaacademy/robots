defmodule Bot.Service.Mock do

  @type action_id :: String.t
  @type action_description :: String.t
  @type action_result :: String.t
  @type action :: {action_id, action_description}

  @spec actions() :: [action]
  def actions(), do: [{"action1", "desc1"}, {"action2", "desc2"}]

  @spec run_action(action) :: {:ok | :error, action_result}
  def run_action("action1"), do: {:ok, "running action1"}
  def run_action("action2"), do: {:ok, "running action2"}
  def run_action(_), do: {:error, "unknown_action"}

end
