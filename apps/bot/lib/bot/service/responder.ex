defmodule Bot.Service.Responder do
  @moduledoc """
  This is the Hedwig responder that discovers actions available in
  the configured service.
  """

  use Hedwig.Responder
  require Logger

  @service Application.get_env(:bot, Bot.Service)[:callback]

  # API

  @usage """
  hedwig: help - Lists available actions provided by this bot
  """
  hear ~r/help\s*$/i, %Hedwig.Message{user: u} = msg do
    Logger.debug "Responding to 'help' requested by #{u.name}"
    reply msg, on_actions()
  end

  @usage """
  hedwig: <action_id> - Performs an action provided by this bot
  """
  hear ~r/^(?!.*?help\s*)(?<action_id>\w+)$/, msg do
    action_id = msg.matches["action_id"]
    Logger.debug "Performing action '#{action_id}' requested by #{msg.user.name}"
    reply msg, on_perform_action(action_id)
  end

  @doc false
  def format_action({action_id, action_desc}) do
    "Action id: #{action_id}\tDesription: #{action_desc}"
  end

  # Internal functions

  defp on_actions() do
    """
    Here are the actions you can perform:
    #{actions()}
    Key in `<action_id>` to perform the action.
    """
  end

  defp actions() do
    @service.actions()
    |> Enum.map(&format_action/1)
    |> Enum.join("\n")
  end

  defp on_perform_action(action_id) do
    case @service.run_action(action_id) do
      {:ok, response} -> response
      {:error, error} ->
        """
        Failed to run action '#{action_id}': #{error}

        #{on_actions()}
        """
    end
  end

end
