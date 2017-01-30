# Robots

## Test the Bot with MongooseIM

1. Clone Mongooseim: `git clone https://github.com/esl/MongooseIM`
2. Copy customized configuration files and build it:

   ```bash
   cp mongooseim/vars.config MongooseIM/rel/
   cp mongooseim/ejabberd.cfg MongooseIM/rel/files
   cd MongooseIM && make rel
   ```
3. Add `lambdadays.org` as an alternative name for 172.0.0.1 in your `/etc/hosts`
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
   [12:33:31] <user1> test_bot help
   [12:33:31] <test_bot> test_bot help - Displays all of the help commands that test_bot knows about.
   test_bot help <query> - Displays all help commands that match <query>.
   test_bot: ping - Responds with 'pong'
   [12:33:35] <user1> test_bot ping
   [12:33:35] <test_bot> user1: pong
   ```
   
   

