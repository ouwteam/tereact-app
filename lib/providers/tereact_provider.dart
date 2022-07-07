import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:tereact/common/constant.dart';
import 'package:tereact/entities/contact.dart';
import 'package:tereact/entities/room.dart';
import 'package:tereact/entities/room_message.dart';
import 'package:tereact/entities/user.dart';

class TereactProvider extends ChangeNotifier {
  final String listMessagesUrl = "/messenger/messages";
  final String listContactsUrl = "/contact/list";
  final String createRoomUrl = "/room/create";
  final String sentToRoomUrl = "/messenger/send-to-room";
  final dio = Dio();

  late Socket socket;

  Future<List<RoomMessage>> getListMessages({
    required int roomId,
    required int userId,
  }) async {
    log("here..");
    try {
      Response response = await dio.get(
        baseUrl + listMessagesUrl,
        queryParameters: {"user_id": userId, "room_id": roomId},
      );

      if (response.statusCode != 200) {
        throw response.statusMessage ?? "Failed to get list message";
      }

      var data = response.data;
      if (!data['ok']) {
        throw data['message'] ?? "Undefined error message";
      }

      List<RoomMessage> messages = (data['data']['messages'] as Iterable)
          .map((e) => RoomMessage.fromJson(e))
          .toList();

      return messages;
    } catch (e, stack) {
      log(e.toString());
      log("Here is the stack:");
      log(stack.toString());
    }

    return [];
  }

  Future<List<Contact>> getListContacts({
    required int userId,
    String? search,
  }) async {
    try {
      String url = baseUrl + listContactsUrl;
      Response response = await dio.get(
        url,
        queryParameters: {
          "user_id": userId,
          "search": search,
        },
      );

      if (response.statusCode != 200) {
        throw response.statusMessage ?? "Failed to get list contacts";
      }

      var data = response.data;
      if (!data['ok']) {
        throw data['message'] ?? "Undefined error contacts";
      }

      List<Contact> contacts = (data['data']['contacts'] as Iterable)
          .map((e) => Contact.fromJson(e))
          .toList();

      return contacts;
    } catch (e, stack) {
      log(e.toString());
      log("Here is the stack:");
      log(stack.toString());
    }

    return [];
  }

  // Return nya adalah message yang
  // barusan di input
  Future<RoomMessage?> sendMessageToRoom({
    required int userId,
    required int roomId,
    required String strMessage,
  }) async {
    var url = baseUrl + sentToRoomUrl;
    try {
      Response response = await dio.post(
        url,
        data: {
          "user_id": userId,
          "room_id": roomId,
          "message": strMessage,
        },
      );

      log("response.data: ");
      log(response.data.toString());
      if (response.statusCode != 200) {
        throw response.statusMessage ?? "Failed to send message";
      }

      var data = response.data;
      if (!data['ok']) {
        throw data['message'] ?? "Undefined error message";
      }

      RoomMessage message = RoomMessage.fromJson(data['data']['message']);
      User sender = User.fromJson(data['data']['sender']);

      message.sender = sender;
      return message;
    } catch (e, stack) {
      log(e.toString());
      log("Here is the stack:");
      log(stack.toString());
    }

    return null;
  }

  Future<Room?> createRoomPrivate({
    required int userId,
    required int guestId,
  }) async {
    try {
      Map<String, dynamic> body = {
        "title": "",
        "description": "",
        "room_type": "PRIVATE",
        "user_ids": [userId, guestId]
      };
      Response response = await dio.post(baseUrl + createRoomUrl, data: body);
      if (response.statusCode != 200) {
        throw response.statusMessage ?? "Failed to create room";
      }

      var data = response.data;
      if (!data['ok']) {
        throw data['message'] ?? "Undefined error";
      }

      Room room = Room.fromJson(data['data']['room']);
      return room;
    } catch (e, stack) {
      log(e.toString());
      log("Here is the stack:");
      log(stack.toString());
    }

    return null;
  }
}
