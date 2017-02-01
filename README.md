# Robots

## Test the Bot with MongooseIM

1. Clone Mongooseim: `git clone https://github.com/esl/MongooseIM`
2. Copy customized configuration files and build it:

   ```bash
   cp mongooseim/vars.config MongooseIM/rel/vars.config.in
   cp mongooseim/ejabberd.cfg MongooseIM/rel/files
   cd MongooseIM && make rel
   ```
3. Add `lambdadays.org` as an alternative name for 127.0.0.1 in your `/etc/hosts`
3. Start MongooseIM: `_build/prod/rel/mongooseim/bin/mongooseimctl live`
4. Register accounts for the Bot (`test_bot`) and a sample user (`test_user`):

   > Run the commands from the MongooseIM directory

   ```bash
   _build/prod/rel/mongooseim/bin/mongooseimctl register test_user lambdadays.org test_user
   _build/prod/rel/mongooseim/bin/mongooseimctl register test_bot lambdadays.org test_bot
   ```

5. Create a test MUC room (`test_room`) in MongooseIM:
   ```erlang
   User = <<"user1">>.
   Server = <<"lambdadays.org">>.
   From = {jid, User, Server, <<"res">>, User, Server, <<"res">>}.
   mod_muc:create_instant_room(Server, <<"test_room">>, From, <<"foto">>, []).
   ```
   > You can verify that the room was created with `ets:tab2list(muc_online_room).`
6. Start the Bot
   > The default bot configuration sits in `apps/bot/config/config.exs`

   ```bash
   mix do deps.get, compile
   iex -S mix
   ```
7. Check that the Bot is connectd to the `test_room`:

   ```erlang
   mod_muc_room:get_room_users(jid:from_binary(<<"test_room@muc.lambdadays.org">>)).
   ```
8. Connect the sample user to the room using the [PSI] client.
   * General -> Join Groupchat
   * Host: `muc.lambdadays.org`
   * Room: `test_room`
   * Nickname: `user1`
   * Password: (empty)

9. Talk to the Bot:

   ```
   <user1> test_bot help
   <test_bot> test_bot help - Displays all of the help commands that test_bot knows about.
   test_bot help <query> - Displays all help commands that match <query>.
   test_bot: ping - Responds with 'pong'
   test_bot: actions - Lists available actions provided by this bot
   test_bot: action <action_id> - Performs an action provided by this bot
   <user1> test_bot actions
   <test_bot> user1: Here are the actions you can perform:
   Action id: action1	Desription: desc1
   Action id: action2	Desription: desc2
   Key in `test_bot action <action_id>` to perform the action.
   <user1> test_bot action action1
   <test_bot> user1: running action
   ```

   The `actions` and `action ID` commands are provided by the `Bot.Service.Responder`
   which delegates to a service through its callback:

   ```elixir
   config :bot, Bot.Service,
   callback: Bot.Service.Mock
   ```

## Creating a Service

To implement a service one has to create an umbrella application in the `apps` and implement
the `Bot.Service` behaviour. Then the module fulfilling that behaviour has to be pointed to
in the configuration:

```elixir
config :bot, Bot.Service,
  callback: MyService.API
```

## Running the **Photo-Pi** bot

1. Start the MongooseIM server with `lambdadays.org` domain
2. Register the `photo_bot` and the sample user:

    ```bash
   _build/prod/rel/mongooseim/bin/mongooseimctl register photo_bot lambdadays.org photo_bot
   _build/prod/rel/mongooseim/bin/mongooseimctl register test_user lambdadays.org test_user
   ```
3. Create the `photo_room` in the server:

   ```erlang
   User = <<"user1">>.
   Server = <<"lambdadays.org">>.
   From = {jid, User, Server, <<"res">>, User, Server, <<"res">>}.
   mod_muc:create_instant_room(Server, <<"photo_room">>, From, <<"foto">>, []).
   ```

4. Make sure that the configuration in the `config/photo_pi.exs` is correct and start the bot:

    ```bash
    MIX_ENV=photo_pi mix do deps.get, compile, run --no-halt
    MIX_ENV=photo_pi iex -S mix
    ```

5. Make sure that Twitter API access tokens are configured in `config/secrets.exs` file

    ```elixir
    config :extwitter,
      oauth: [
        consumer_key: "...",
        consumer_secret: "...",
        access_token: "...",
        access_token_secret: "..."
      ]
    ```

6. Configure default status message which will be posted with a photo

    ```elixir
    config :photo_pi, PhotoPi.Twitter,
        status_message: "blah blah"
    ```

7. Check who is in the room:

    ```erlang
    mod_muc_room:get_room_users(jid:from_binary(<<"photo_room@muc.lambdadays.org">>)).
    ```

    > Use the instructions from the previous chapter to connect a `test_user` to the room.

## Running the **Music-Pi** bot

1. Start the MongooseIM server with `lambdadays.org` domain
2. Register the `music_bot` and the sample user:

    ```bash
   _build/prod/rel/mongooseim/bin/mongooseimctl register music_bot lambdadays.org music_bot
   _build/prod/rel/mongooseim/bin/mongooseimctl register test_user lambdadays.org test_user
   ```
3. Create the `music_room` in the server:

   ```erlang
   User = <<"user1">>.
   Server = <<"lambdadays.org">>.
   From = {jid, User, Server, <<"res">>, User, Server, <<"res">>}.
   mod_muc:create_instant_room(Server, <<"music_room">>, From, <<"music">>, []).
   ```

4. Make sure that the configuration in the `config/music_pi.exs` is correct and start the bot:

    ```bash
    MIX_ENV=music_pi mix do deps.get, compile, run --no-halt
    MIX_ENV=music_pi iex -S mix
    ```
5. Check who is in the room:

    ```erlang
    mod_muc_room:get_room_users(jid:from_binary(<<"music_room@muc.lambdadays.org">>)).
    ```

    > Use the instructions from the previous chapter to connect a `test_user` to the room.
