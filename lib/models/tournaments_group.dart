import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:toast/toast.dart';

import 'package:winner_casino_test/common/mobile_api.dart';
import 'package:winner_casino_test/models/tournament.dart';

Logger _log = Logger('tournaments_group.dart');

class TournamentGroupModel {
  int id;
  String name;
  int priority;
  String url;
  bool? blockEnroll;
  List<TournamentModel> tournaments;

  TournamentGroupModel({
    required this.id,
    required this.name,
    required this.priority,
    required this.url,
    this.blockEnroll,
    required this.tournaments,
  });

  static List<TournamentGroupModel> listFromJson(String str) =>
      List<TournamentGroupModel>.from(json.decode(str).map((x) =>
          TournamentGroupModel.fromJson(x)));

  factory TournamentGroupModel.fromJson(Map<String, dynamic> json) {
    return TournamentGroupModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      priority: json['priority'] ?? 0,
      url: json['url'] ?? '',
      blockEnroll: json['block_enroll'],
      tournaments: TournamentModel.listFromJson(json['tournaments']),
    );
  }
}

Future<List<TournamentGroupModel>?> fetchTournamentGroupData({
  required int tenantId,
}) async {
  List<TournamentGroupModel>? result;
  try {
    final response = await MobileApi.instance.get(
        queryParameters: {
          'tenant_id': tenantId.toString(),
        },
    );
    if (response.statusCode == 200) {
      result = TournamentGroupModel.listFromJson(response.body);
    } else {
      Toast.show("Data not found",
        duration: 2,
        backgroundColor: Colors.redAccent,
      );
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return result;
}

class TournamentGroupProvider with ChangeNotifier {
  List<TournamentGroupModel>? models;
  bool loading = false;

  getData(context, {required int tenantId}) async {
    loading = true;
    models = await fetchTournamentGroupData(tenantId: tenantId);
    loading = false;

    notifyListeners();
  }
}