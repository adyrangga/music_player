import 'dart:convert';

SongModel musicTrackModelFromJson(String str) =>
    SongModel.fromJson(json.decode(str));

String musicTrackModelToJson(SongModel data) => json.encode(data.toJson());

class SongModel {
  SongModel({
    this.trackId,
    this.artistName = '',
    this.collectionName = '',
    this.trackName = '',
    this.previewUrl = '',
    this.artworkUrl100 = '',
  });

  int? trackId;
  String artistName;
  String collectionName;
  String trackName;
  String previewUrl;
  String artworkUrl100;

  factory SongModel.fromJson(Map<String, dynamic> json) => SongModel(
        trackId: json["trackId"],
        artistName: json["artistName"],
        collectionName: json["collectionName"],
        trackName: json["trackName"],
        previewUrl: json["previewUrl"],
        artworkUrl100: json["artworkUrl100"],
      );

  Map<String, dynamic> toJson() => {
        "trackId": trackId,
        "artistName": artistName,
        "collectionName": collectionName,
        "trackName": trackName,
        "previewUrl": previewUrl,
        "artworkUrl100": artworkUrl100,
      };
}
