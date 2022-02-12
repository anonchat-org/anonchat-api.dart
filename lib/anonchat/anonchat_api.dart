import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

/// Basic message class.
class Message {
  /// Message author
  final String user;

  /// Message text
  final String msg;

  Message({required this.user, required this.msg});

  /// Construct class from [Map] of [String] and [dynamic] type
  Message.fromJson(Map<String, dynamic> json)
      : user = json['user'],
        msg = json['msg'];

  /// Retrurn [Map] presentation of the [Message]
  Map<String, dynamic> toJson() => {'user': user, 'msg': msg};
}

/// Main class to communicate with anonchat
class Anonchat {
  /// Actual connection socket
  final Socket socket;

  /// Fires when the new raw bytes are received
  final Stream<Uint8List> onRawBytes;

  /// Fires when the new JSON map is received
  final Stream<Map<String, dynamic>> onRawMap;

  /// Fires when the new message is received
  final Stream<Message> onMessage;

  /// Construct class from existing [Socket]
  Anonchat.fromSocket(this.socket)
      : onRawBytes = socket.asBroadcastStream(),
        onRawMap = socket.asBroadcastStream().map(
              (v) => jsonDecode(utf8.decode(v)),
            ),
        onMessage = socket.asBroadcastStream().map(
              (v) => Message.fromJson(jsonDecode(utf8.decode(v))),
            );

  Future<void> sendMessage(Message message) async {
    socket.add(utf8.encode(jsonEncode(message.toJson())));
  }

  /// Create a new TCP connection and construct class
  static Future<Anonchat> connect({
    required String host,
    required int port,
  }) async {
    final socket = await Socket.connect(host, port);
    return Anonchat.fromSocket(socket);
  }
}
