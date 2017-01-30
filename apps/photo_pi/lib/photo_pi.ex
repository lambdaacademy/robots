defmodule PhotoPi do
  @moduledoc """
  Photo service for Lambda Days chatbot
  """

  require Logger

  @type action_id :: non_neg_integer
  @type action :: {action_id, description :: String.t}

  @spec actions :: [action]
  defdelegate actions, to: PhotoPi.Executor

  @spec run_action(action_id) :: :ok
  defdelegate run_action(action_id), to: PhotoPi.Executor
end
