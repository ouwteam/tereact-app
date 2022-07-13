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
  final String sentToRoomUrl = "/messenger/send-to-room";
  final dio = Dio();

  late Client socket;

  Future<List<RoomMessage>> getMessageFromRoom({
    required Room room,
    required User user,
  }) async {
    try {
      String url = baseUrl + listMessagesUrl;
      log(url);
      Response response = await dio.get(
        url,
        queryParameters: {"room_id": room.id},
        options: Options(
          headers: {"Authorization": "Bearer ${user.token}"},
        ),
      );

      log(response.data.toString());
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
  }) async {
    try {
      String url = baseUrl + listRoomUrl;
      log(url);
      Response response = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${user.token}",
          },
        ),
      );

      log(response.data.toString());
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

  Future<Room> getRoom(int roomId) async {
    return Room(groupName: "", id: 1, isGroup: 2123, name: "", userId: 1212);
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
