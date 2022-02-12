import 'dart:isolate';

import 'package:anonchat_api/anonchat/anonchat_api.dart';

class Command extends Message {
  final String prefix;
  String get command => msg.split(' ').first.substring(prefix.length);
  List<String> get arguments => msg.split(' ').sublist(1);

  Command({
    required String user,
    required String msg,
    required this.prefix,
  }) : super(user: user, msg: msg);
}

class Commander {
  final Anonchat anonchat;
  final String prefix;

  final Stream<Command> onCommand;

  Commander(this.anonchat, {required this.prefix})
      : onCommand = anonchat.onMessage
            .where((v) => v.msg.startsWith(prefix))
            .map((v) => Command(user: v.user, msg: v.msg, prefix: prefix))
            .asBroadcastStream();
}

Future<void> main() async {
  final anonchat = await Anonchat.connect(host: 'localhost', port: 6969);
  final commander = Commander(anonchat, prefix: '?');

  Isolate.current.setErrorsFatal(false);

  commander.onCommand
    ..where((c) => c.command == 'ping').listen((m) {
      anonchat.sendMessage(
        Message(user: 'Anonbot', msg: '!pong'),
      );
    })
    ..where((c) => c.command == 'echo').listen((m) {
      anonchat.sendMessage(
        Message(user: 'Anonbot', msg: m.arguments.join(' ')),
      );
    });
}
