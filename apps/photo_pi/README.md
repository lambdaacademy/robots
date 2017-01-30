# PhotoPi

Take photos with Elixir and Raspberry Pi!

1. To take a photo start an application and call:

    ```elixir
    iex> PhotoPi.run_action "1"
    ```

   This will take a photo and put it into `priv/photos` directory.

2. To take a photo and post it on Twitter you need to configure access tokens
   to Twitter API

    ```elixir
    config :extwitter,
      oauth: [
        consumer_key: "...",
        consumer_secret: "...",
        access_token: "...",
        access_token_secret: "..."
      ]
    ```

   Remember to not check this configuration into version control!

   You also need to configure default status message which will be posted with a photo

    ```elixir
    config :photo_pi, PhotoPi.Twitter,
      status_message: "blah blah"
    ```
