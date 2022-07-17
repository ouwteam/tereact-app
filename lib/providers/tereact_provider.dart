import 'dart:convert';
import 'dart:developer';
import 'package:centrifuge/centrifuge.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tereact/common/constant.dart';
import 'package:tereact/entities/room.dart';
import 'package:tereact/entities/room_message.dart';
import 'package:tereact/entities/user.dart';

class TereactProvider extends ChangeNotifier {
  final String listMessagesUrl = "/chat";
  final String listRoomUrl = "/room";
  final String createRoomUrl = "/room/create";
  final String sentToRoomUrl = "/chat";
  final dio = Dio(BaseOptions(
    connectTimeout: 9000,
    receiveDataWhenStatusError: true,
    validateStatus: (status) {
      return (status ?? 0) < 500;
    },
  ));

  late Client socket;

  Future<List<RoomMessage>> getMessageFromRoom({
    required Room room,
    required User user,
  }) async {
    try {
      String url = baseUrl + listMessagesUrl;
      log(url);
      log({"room_id": room.id}.toString());
      log("user.token: ${user.token}");
      Response response = await dio.get(
        url,
        queryParameters: {"room_id": room.id},
        options: Options(
          headers: {"Authorization": "Bearer ${user.token}"},
        ),
      );

      if (response.statusCode != 200) {
        throw response.statusMessage ?? "Failed to get list message";
      }

      var data = response.data;
      if (!data['status']) {
        throw data['message'] ?? "Undefined error message";
      }

      List<RoomMessage> messages = (data['data']['chat'] as Iterable)
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

  Future<List<Room>> getRooms({
    required User user,
    int page = 1,
    String search = "",
  }) async {
    try {
      String url = baseUrl + listRoomUrl;
      log(url);
      log({
        "queryParameters": {
          "page": page,
          "query": search,
        }
      }.toString());
      Response response = await dio.get(
        url,
        queryParameters: {
          "page": page,
          "query": search,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer ${user.token}",
          },
        ),
      );

      log(json.encode(response.data));
      if (response.statusCode != 200) {
        throw response.statusMessage ?? "Failed to get list contacts";
      }

      var data = response.data;
      if (!data['status']) {
        throw data['message'] ?? "Undefined error get rooms";
      }

      List<Room> rooms = [];
      if (data['data']['room'] == null) {
        return rooms;
      }

      rooms = (data['data']['room'] as Iterable)
          .map((e) => Room.fromJson(e))
          .toList();

      return rooms;
    } catch (e, stack) {
      log(e.toString());
      log("Here is the stack:");
      log(stack.toString());
    }

    return [];
  }

  Future<Room?> getRoom(int roomId) async {
    return null;
  }

  // Return nya adalah message yang
  // barusan di input
  Future<RoomMessage?> sendMessageToRoom({
    required User user,
    required int roomId,
    required String strMessage,
  }) async {
    var url = baseUrl + sentToRoomUrl;
    try {
      var payload = {
        "room_id": roomId,
        "type": 1,
        "is_reply": 0,
        "reply_chat_id": 0,
        "value": strMessage
      };
      log(url);
      log(payload.toString());
      Response response = await dio.post(
        url,
        data: payload,
        options: Options(
          headers: {
            "Authorization": "Bearer ${user.token}",
          },
        ),
      );

      log("response.data: ");
      log(response.data.toString());
      if (response.statusCode != 200) {
        throw response.statusMessage ?? "Failed to send message";
      }

      var data = response.data;
      if (!data['status']) {
        throw data['message'] ?? "Undefined error message";
      }

      RoomMessage message = RoomMessage.fromJson(data['data']['chat']);
      return message;
    } catch (e, stack) {
      log(e.toString());
      log("Here is the stack:");
      log(stack.toString());
    }

    return null;
  }
}
