defmodule Bot.Service.Responder do
  @moduledoc """
  This is the Hedwig responder that discovers actions available in
  the configured service.
  """

  use Hedwig.Responder
  require Logger

  @service Application.get_env(:bot, Bot.Service)[:callback]
  @bot_name Application.get_env(:bot, Bot.Robot)[:name]

  # API

  @usage """
  hedwig: actions - Lists available actions provided by this bot
  """
  respond ~r/actions$/i, %Hedwig.Message{user: u} = msg do
    Logger.debug "Responding to /actions requested by #{u.name}"
    reply msg, on_actions()
  end

  @usage """
  hedwig: action <action_id> - Performs an action provided by this bot
  """
  respond ~r/action (?<action_id>\w+)$/, msg do
    action_id = msg.matches["action_id"]
    Logger.debug "Performing /action #{action_id} requested by #{msg.user.name}"
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
    Key in `#{@bot_name} action <action_id>` to perform the action.
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
      {:error, error} -> "failed to run action #{action_id}: #{error}"
    end
  end

end
