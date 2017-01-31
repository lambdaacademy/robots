defmodule PhotoPi do
  @moduledoc """
  Photo service for Lambda Days chatbot
  """

  @behaviour Bot.Service


  defdelegate actions, to: PhotoPi.Executor

  defdelegate run_action(action_id), to: PhotoPi.Executor
end
