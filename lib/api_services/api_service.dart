import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;
import 'package:music_player/constants.dart' as constants;
import 'package:music_player/models/music_search_model.dart';
import 'package:music_player/models/song_model.dart';

class ApiService {
  Client client = Client();

  /// fetch songs from iTunes API based on search terms.
  Future<List<SongModel>> fetchSong(String searchTerm) async {
    List<SongModel> songList = List.empty(growable: true);
    try {
      var response = await client.get(Uri(
          scheme: 'https',
          host: constants.baseApi,
          path: constants.searchApi,
          queryParameters: {
            'term': Uri.encodeQueryComponent(searchTerm),
            'country': 'id',
            'entity': 'musicTrack',
            'attribute': 'artistTerm',
          }));
      if (response.statusCode == 200) {
        MusicSearchModel musicSearchData =
            musicSearchModelFromJson(response.body);
        songList = musicSearchData.results;
      }
    } catch (e) {
      songList = List.empty(growable: true);
    }
    return songList;
  }
}
