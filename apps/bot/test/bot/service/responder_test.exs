defmodule Bot.Service.ResponderTest do
  use Hedwig.RobotCase
  alias Bot.Service.Responder
  
  @responders [{Responder, []}]
  @service Application.get_env(:bot, Bot.Service)[:callback]

  # Tests

  @tag start_robot: true, name: "test_bot", responders: @responders
  test "list actions on /actions", %{adapter: adapter, msg: msg} do
    send_to_bot(adapter, msg, "test_bot actions")

    received = receive_from_bot()
    for a <- @service.actions() do
      assert String.contains?(received, Responder.format_action(a))
    end
  end

  @tag start_robot: true, name: "test_bot", responders: @responders
  test "run an action on /action ID", %{adapter: adapter, msg: msg} do
    action_id = random_action_id()

    send_to_bot(adapter, msg, "test_bot action #{action_id}")

    received = receive_from_bot()
    assert String.contains?(received, "running #{action_id}")
  end

  @tag start_robot: true, name: "test_bot", responders: @responders
  test "send error on /action INVALID_ID",
    %{adapter: adapter, msg: msg} do
    action_id = invalid_action_id()
    
    send_to_bot(adapter, msg, "test_bot action #{action_id}")
    
    received = receive_from_bot()
    assert String.contains?(received,
      "failed to run action #{action_id}")
  end

  # Internal functions

  defp send_to_bot(adapter, msg, text) do
    send adapter, {:message, %{msg | text: text}}
  end

  defp receive_from_bot() do
    assert_receive {:message, %{text: text}}, 1_000
    text
  end

  defp random_action_id() do
    [{action_id, _}] = Enum.take_random(@service.actions(), 1)
    action_id
  end

  defp invalid_action_id(), do: random_action_id() |> String.reverse()
  
end
