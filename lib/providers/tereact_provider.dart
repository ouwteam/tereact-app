// ignore_for_file: unnecessary_getters_setters

import 'dart:convert';
import 'dart:developer';
import 'package:centrifuge/centrifuge.dart';
import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tereact/entities/room.dart';
import 'package:tereact/entities/room_message.dart';
import 'package:tereact/entities/user.dart';
import 'package:tereact/providers/api_provider.dart';

class TereactProvider extends ChangeNotifier {
  final String listMessagesUrl = "/chat";
  final String listRoomUrl = "/room";
  final String createRoomUrl = "/room/create";
  final String sentToRoomUrl = "/chat";
  late Client socket;

  late FirebaseRemoteConfig _remoteConfig;
  FirebaseRemoteConfig get remoteConfig => _remoteConfig;
  set remoteConfig(FirebaseRemoteConfig remoteConfig) {
    _remoteConfig = remoteConfig;
  }

  Future<List<RoomMessage>> getMessageFromRoom(
    BuildContext context, {
    required Room room,
    required User user,
  }) async {
    try {
      ApiProvider api = Provider.of<ApiProvider>(context, listen: false);
      Response response = await api.dio().get(
            listMessagesUrl,
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

  Future<List<Room>> getRooms(
    BuildContext context, {
    required User user,
    int page = 1,
    String search = "",
  }) async {
    try {
      ApiProvider api = Provider.of<ApiProvider>(context, listen: false);
      Response response = await api.dio().get(
            listRoomUrl,
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
  Future<RoomMessage?> sendMessageToRoom(
    BuildContext context, {
    required User user,
    required int roomId,
    required String strMessage,
  }) async {
    try {
      var payload = {
        "room_id": roomId,
        "type": 1,
        "is_reply": 0,
        "reply_chat_id": 0,
        "value": strMessage
      };

      ApiProvider api = Provider.of<ApiProvider>(context, listen: false);
      Response response = await api.dio().post(
            sentToRoomUrl,
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
