import 'dart:convert';

import 'song_model.dart';

MusicSearchModel musicSearchModelFromJson(String str) =>
    MusicSearchModel.fromJson(json.decode(str));

String musicSearchModelToJson(MusicSearchModel data) =>
    json.encode(data.toJson());

class MusicSearchModel {
  MusicSearchModel({
    this.resultCount = 0,
    this.results = const [],
  });

  int resultCount;
  List<SongModel> results;

  factory MusicSearchModel.fromJson(Map<String, dynamic> json) =>
      MusicSearchModel(
        resultCount: json["resultCount"],
        results: List<SongModel>.from(
            json["results"].map((x) => SongModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resultCount": resultCount,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
