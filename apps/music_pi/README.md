# MusicPi

Play your favourite music on Raspberry Pi with omxplayer!

## Configuration

In `config/config.exs` provide a path to directory with music:
```elixir
config :music_pi,
  songs_path: "/home/music"
```
> Note that this directory should contain ONLY music

## Running

Just run application by e.g. `iex -S mix`.
API is simple:
`MusicPi.actions/0` - returns list with ids' and songs which are read from
`songs_path` in `config/config.exs`
`MusicPi.run_action/1` - plays music with specified id, or stops when id is
equal to "0"

## How it works

Application spawns `omxplayer` process with option `-o local` to pass music
via mini-jack (not HDMI), and interacts with it.
