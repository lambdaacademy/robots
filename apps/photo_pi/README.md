# PhotoPi

Take photos with Elixir and Raspberry Pi!

To take a photo start an application and call:

```elixir
iex> PhotoPi.run_action "1"
```

This will take a photo and put it into `priv/photos` directory.
