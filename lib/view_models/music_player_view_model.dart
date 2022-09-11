import 'package:flutter/foundation.dart';
import 'package:music_player/api_services/api_service.dart';
import 'package:music_player/models/song_model.dart';

class MusicPlayerViewModel extends ChangeNotifier {
  final apiService = ApiService();
  bool _isLoading = false;
  List<SongModel> _songList = List.empty(growable: true);

  bool isLoading() => _isLoading;
  List<SongModel> get getSongList => _songList;
  SongModel? get getFirstSong => _songList.isNotEmpty ? _songList[0] : null;

  /// handle song search via api.
  void searchSong(String searchTerm) async {
    _isLoading = true;
    notifyListeners();
    _songList = await apiService.fetchSong(searchTerm);
    _isLoading = false;
    notifyListeners();
  }

  /// determines whether the song can be played to the next or stopped if the playlist is different.
  SongModel? next(SongModel currentSong) {
    int indexCurrent =
        getSongList.indexWhere((e) => e.trackId == currentSong.trackId);
    int length = _songList.length;
    bool validNext =
        indexCurrent != -1 && (length - 1) != -1 && (indexCurrent + 1) < length;
    SongModel? result =
        validNext ? _songList.elementAt(indexCurrent + 1) : null;
    return result;
  }

  /// determines if the playing song can be paused or not.
  bool canResumed(SongModel currentSong) {
    return getSongList.indexWhere((e) => e.trackId == currentSong.trackId) !=
        -1;
  }
}
