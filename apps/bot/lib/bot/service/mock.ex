defmodule Bot.Service.Mock do
  @behaviour Bot.Service

  def actions(), do: [{"action1", "desc1"}, {"action2", "desc2"}]

  def run_action("action1"), do: {:ok, "running action1"}
  def run_action("action2"), do: {:ok, "running action2"}
  def run_action(_), do: {:error, "unknown_action"}

end
