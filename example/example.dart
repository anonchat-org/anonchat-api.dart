import 'dart:isolate';

import 'package:anonchat_api/anonchat/anonchat_api.dart';

Future<void> main() async {
  final bot = await Anonchat.connect(host: 'localhost', port: 6969);

  Isolate.current.setErrorsFatal(false);

  bot.onMessage.where((c) => c.msg == '!ping').listen((m) {
    bot.sendMessage(Message(user: 'Anonbot', msg: '!pong'));
  });
}
