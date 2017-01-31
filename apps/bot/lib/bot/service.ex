defmodule Bot.Service do
  @doc "Defines a behaviour for the Service callback module"

  @type action_id :: String.t
  @type action_description :: String.t
  @type action_result :: String.t
  @type action :: {action_id, action_description}

  @doc "Returns a list of actions provided by the service"
  @callback actions() :: [action]

  @doc "Runs an action"
  @callback run_action(action_id) :: {:ok | :error, action_result}

end
