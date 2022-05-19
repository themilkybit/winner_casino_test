import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'image_resource.dart';
import 'translated_string.dart';

class TournamentModel {
  int id;
  String name;
  int startDate;
  int endDate;
  bool enrolled;
  bool activated;
  String missionGroupId;
  TranslatedStringModel uiPrize1;
  TranslatedStringModel uiPrize2;
  TranslatedStringModel uiRules;
  ImageResourceModel uiCornerImage;
  ImageResourceModel uiCurrentPlaceImage;
  ImageResourceModel uiGamesImage;
  ImageResourceModel uiObjectivesImage;
  ImageResourceModel uiScoresImage;
  ImageResourceModel uiTopImage;
  List<int>? games;
  List<int>? recommended;
  int? levels;

  TournamentModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.enrolled,
    required this.activated,
    required this.missionGroupId,
    required this.uiPrize1,
    required this.uiPrize2,
    required this.uiRules,
    required this.uiCornerImage,
    required this.uiCurrentPlaceImage,
    required this.uiGamesImage,
    required this.uiObjectivesImage,
    required this.uiScoresImage,
    required this.uiTopImage,
    this.games,
    this.recommended,
    this.levels,
  });

  static List<TournamentModel> listFromJson(dynamic json) {
    return List<TournamentModel>.from(json.map((x) =>
        TournamentModel.fromJson(x)));
  }

  factory TournamentModel.fromJson(Map<String, dynamic> json) {
    return TournamentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      startDate: json['start_date'] ?? 0,
      endDate: json['end_date'] ?? 0,
      enrolled: json['enrolled'] ?? false,
      activated: json['activated'] ?? false,
      missionGroupId: json['mission_group_id'] ?? '',
      uiPrize1: TranslatedStringModel.fromJson(json['meta']['ui']['prize_1']),
      uiPrize2: TranslatedStringModel.fromJson(json['meta']['ui']['prize_2']),
      uiRules: TranslatedStringModel.fromJson(json['meta']['ui']['rules']),
      uiCornerImage: ImageResourceModel.fromJson(json['meta']['ui']['corner_image']),
      uiCurrentPlaceImage: ImageResourceModel.fromJson(json['meta']['ui']['current_place_image']),
      uiGamesImage: ImageResourceModel.fromJson(json['meta']['ui']['games_image']),
      uiObjectivesImage: ImageResourceModel.fromJson(json['meta']['ui']['objectives_image']),
      uiScoresImage: ImageResourceModel.fromJson(json['meta']['ui']['scores_image']),
      uiTopImage: ImageResourceModel.fromJson(json['meta']['ui']['top_image']),
      games: (json['meta']['games'] as List).map((e) => e as int).toList(),
      recommended: (json['meta']['recommended'] as List).map((e) => e as int).toList(),
      levels: json['meta']['levels'],
    );
  }
}