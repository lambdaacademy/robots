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
    
    @spec defaults :: %Data{}
    def defaults do
      %__MODULE__{
        songs_path: Application.get_env(:music_pi, :songs_path, :code.priv_dir(:music_pi)),
        player_exec: "omxplayer",
        player_opts: Application.get_env(:music_pi, :player_opts, "-o local"),
        player_pid: nil
      }
    end
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, [name: __MODULE__])
  end

  @spec actions :: [Bot.Service.action]
  def actions do
    GenServer.call(__MODULE__, :actions)
  end

  @spec run_action(Bot.Service.action_id) :: Bot.Service.action_run_result
  def run_action(id) do
    GenServer.cast(__MODULE__, {:run_action, id})
    {:ok, "Wait for song..."}
  end

  ## Callbacks
  def init(_args) do
    {:ok, Data.defaults}
  end

  def handle_call(:actions, _from, state) do
    songs = [{"0", "Stop music"}] ++ refresh_songs(state.songs_path)
    {:reply, songs, state}
  end

  def handle_cast({:run_action, "0"}, state) do
    maybe_stop_song(state) 
    {:noreply, %Data{state | player_pid: nil}}
  end
  def handle_cast({:run_action, id}, state) do
    song = refresh_songs(state.songs_path)
           |> get_song(id)
    case song do
      nil ->
        Logger.warn "Wrong action id"
        {:noreply, state}
      val ->
        Logger.info "Playing #{val}"  
        {:noreply, play_song(val, state)}
    end 
  end

  def handle_info({pid, :result, _result}, state) do
    case state.player_pid do
      nil -> {:noreply, state}
      _ -> {:noreply, update_player_pid(pid, state)}
    end
  end

  ## Internals
  @spec play_song(String.t, %Data{}) :: %Data{}
  defp play_song(song, state) do
    song_path = Path.join(state.songs_path, song)
    cmd = get_player_command(state, song_path)
    maybe_stop_song(state) 
    player_pid = Porcelain.spawn_shell(cmd, out: {:send, self()})
    %Data{state | player_pid: player_pid}
  end

  @spec refresh_songs(String.t) :: [{String.t, String.t}]
  defp refresh_songs(songs_path) do
    File.ls!(songs_path)
    |> format_songs
  end

  @spec format_songs([String.t]) :: [{String.t, String.t}]
  defp format_songs(song_files) do
    ids = 1..length(song_files)
          |> Enum.to_list
          |> Enum.map(&Integer.to_string/1)
    List.zip([ids, song_files])
  end

  @spec get_player_command(%Data{}, String.t) :: String.t
  defp get_player_command(state, song_path) do
    "#{state.player_exec} #{state.player_opts} #{song_path}"
  end

  @spec get_song([{String.t, String.t}], String.t) :: String.t | nil
  defp get_song(songs, id) do
    song_tuple = songs
                 |> Enum.find(fn({song_id, _song}) -> song_id == id end)
    case song_tuple do
      nil -> nil
      {^id, song} -> song
    end
  end

  @spec update_player_pid(pid, %Data{}) :: %Data{}
  defp update_player_pid(incoming_pid, state) do
    case state.player_pid do
      ^incoming_pid ->
        Logger.info "Music has been stopped!"
        %Data{state | player_pid: nil}
      _ -> state
    end
  end

  @spec maybe_stop_song(%Data{}) :: boolean
  def maybe_stop_song(state) do
    if state.player_pid do
      Porcelain.Process.send_input(state.player_pid, "q")
      Porcelain.Process.stop(state.player_pid)
    else
      false
    end
  end
end
