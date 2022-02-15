import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:anonchat_api/anonchat/anonchat_api.dart';

Future<void> main(List<String> arguments) async {
  final host = arguments[0].split(':')[0];
  final port = int.parse(arguments[0].split(':')[1]);
  final nickname = arguments[1];

  final bot = await Anonchat.connect(host: host, port: port);
  Isolate.current.setErrorsFatal(false);

  bot.onMessage.listen((msg) {
    print('<${msg.user}> ${msg.msg}');
  });

  stdin.map(utf8.decode).listen((msg) {
    bot.sendMessage(Message(user: nickname, msg: msg.trim()));
  });
}
