defmodule MusicPi.Player do
  @moduledoc """
  Responsible for playing music using omxplayer.
  You can specify music directory.
  """
  use GenServer
  require Logger

  defmodule Data do
    @moduledoc false
    defstruct [:songs_path, :player_exec, :player_opts, :player_pid]
    
    def defaults do
      %__MODULE__{
        songs_path: :code.priv_dir(:music_pi),
        player_exec: "omxplayer",
        player_opts: "-o local",
        player_pid: nil
      }
    end

    def merge(opts) do
      case Keyword.get(opts, :songs_path) do
        nil -> defaults()
        val -> %Data{defaults() | songs_path: val}
      end
    end
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, [name: __MODULE__])
  end

  def actions do
    GenServer.call(__MODULE__, :actions)
  end

  def run_action(id) do
    GenServer.cast(__MODULE__, {:run_action, id})
  end

  ## Callbacks
  def init(args) do
    {:ok, Data.merge(args)}
  end

  def handle_call(:actions, _from, state) do
    songs = [{0, "Stop music"}] ++ refresh_songs(state.songs_path)
    {:reply, songs, state}
  end

  def handle_cast({:run_action, 0}, state) do
    if !is_nil(state.player_pid) do
      Porcelain.Process.stop(state.player_pid)
    end
    {:noreply, %Data{state | player_pid: nil}}
  end
  def handle_cast({:run_action, id}, state) when id >= 1 do
    song = refresh_songs(state.songs_path)
           |> get_song(id)
    case song do
      nil ->
        Logger.warn "Wrong action id"
        {:noreply, state}
      val -> play_song(val, state)
    end 
  end
  def handle_cast({:run_action, _id}, state) do
    Logger.warn "Wrong request"
    {:noreply, state}
  end

  def handle_info({pid, :result, _result}, state) do
    case state.player_pid do
      nil -> {:noreply, state}
      _ -> update_player_pid(pid, state)
    end
  end

  ## Internals
  defp play_song(song, state) do
    song_path = Path.join(state.songs_path, song)
    cmd = get_player_command(state, song_path)
    if !is_nil(state.player_pid) do
      Porcelain.Process.stop(state.player_pid)
    end
    player_pid = Porcelain.spawn_shell(cmd, out: {:send, self()})
    {:noreply, %Data{state | player_pid: player_pid}}
  end

  defp refresh_songs(songs_path) do
    File.ls!(songs_path)
    |> format_songs
  end

  defp format_songs(song_files) do
    List.zip([Enum.to_list(1..length(song_files)), song_files])
  end

  defp get_player_command(state, song_path) do
    "#{state.player_exec} #{state.player_opts} #{song_path}"
  end

  defp get_song(songs, id) do
    song_tuple = songs
                 |> Enum.at(id - 1)
    case song_tuple do
      nil -> nil
      {^id, song} -> song
    end
  end

  defp update_player_pid(incoming_pid, state) do
    case state.player_pid do
      ^incoming_pid ->
        Logger.info "Music has been stopped!"
        {:noreply, %Data{state | player_pid: nil}}
      _ ->
        Logger.info "Ignored info"
        {:noreply, state}
    end
  end
end
