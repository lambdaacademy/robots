defmodule PhotoPi.Camera do
  @moduledoc false

  use GenServer

  alias Porcelain.Process, as: Proc

  require Logger

  @base_path :code.priv_dir(:photo_pi)
  @exec_path @base_path |> Path.join("camera")
  @photos_path @base_path |> Path.join("photos")
  @format ".jpeg"

  @spec start_link :: GenServer.on_start
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @spec take_photo :: Path.t
  def take_photo do
    GenServer.call(__MODULE__, :take_photo)
  end

  ## GenServer callbacks

  def init([]) do
    File.mkdir_p! @photos_path
    proc = Porcelain.spawn_shell(@exec_path, in: :receive, out: {:send, self()})
    {:ok, %{proc: proc}}
  end

  def handle_call(:take_photo, _from, %{proc: proc} = state) do
    path = new_photo_path()
    Proc.send_input(proc, path <> "\n")
    {:reply, path, state}
  end

  def handle_info({pid, :result, _result}, %{proc: %Proc{pid: pid}} = state) do
    {:stop, "Camera executable finished", state}
  end

  def handle_info(_, state), do: {:noreply, state}

  ## Internals

  defp new_photo_path do
    Path.join(@photos_path, new_photo_name())
  end

  defp new_photo_name do
    (DateTime.utc_now() |> DateTime.to_iso8601()) <> @format
  end
end
