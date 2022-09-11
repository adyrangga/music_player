import 'package:flutter/material.dart';
import 'package:music_player/models/song_model.dart';
import 'package:music_player/view_models/music_player_view_model.dart';
import 'package:music_player/views/widgets/media_player.dart';
import 'package:music_player/views/widgets/search_bar.dart';
import 'package:music_player/views/widgets/song_tile.dart';
import 'package:music_player/views/widgets/spinner_loading.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({Key? key}) : super(key: key);

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final _audioPlayer = AudioPlayer();
  SongModel _selectedSong = SongModel();
  bool _showMediaPlayer = false;
  double _progress = 0;

  @override
  void initState() {
    _audioPlayer
      ..playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          SongModel? nextSong =
              Provider.of<MusicPlayerViewModel>(context, listen: false)
                  .next(_selectedSong);

          /// if the currently playing song has finished, check for the next song.
          if (nextSong != null) {
            _onTapTile(nextSong);
          } else {
            _onStop(showMediaPlayer: true);
          }
        }
      })
      ..positionStream.listen((position) {
        if (_audioPlayer.duration != null) {
          var progress = position.inSeconds.toDouble() /
              _audioPlayer.duration!.inSeconds.toDouble();
          setState(() {
            _progress = progress;
          });
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onTapTile(SongModel song) {
    _audioPlayer.stop();
    _audioPlayer.setUrl(song.previewUrl).then((_) {
      setState(() {
        _progress = 0;
        _selectedSong = song;
        _showMediaPlayer = true;
        _audioPlayer.play();
      });
    });
  }

  void _onResume() {
    SongModel? checkFirstSong =
        Provider.of<MusicPlayerViewModel>(context, listen: false).getFirstSong;

    /// check if audio idle, play first song in the list if not null.
    if (_audioPlayer.processingState == ProcessingState.idle &&
        checkFirstSong != null) {
      _onTapTile(checkFirstSong);
    } else {
      /// resume playing the song.
      setState(() {
        _audioPlayer.play();
      });
    }
  }

  void _onPause() {
    bool canResumed = Provider.of<MusicPlayerViewModel>(context, listen: false)
        .canResumed(_selectedSong);

    /// determines whether the song can be paused,
    /// or should stop and hide the media player.
    if (canResumed) {
      setState(() {
        _audioPlayer.pause();
      });
    } else {
      _onStop();
    }
  }

  void _onStop({bool showMediaPlayer = false}) {
    _audioPlayer.stop();
    setState(() {
      _progress = 0;
      _selectedSong = SongModel();
      _showMediaPlayer = showMediaPlayer;
    });
  }

  void _onSubmitSearch(String searchTerm) {
    if (!_audioPlayer.playing) {
      setState(() {
        _selectedSong = SongModel();
        _audioPlayer.stop();
        _progress = 0;
        _showMediaPlayer = false;
      });
    }
    context.read<MusicPlayerViewModel>().searchSong(searchTerm);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: SearchBar(onSubmitSearch: _onSubmitSearch)),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: context
                        .watch<MusicPlayerViewModel>()
                        .getSongList
                        .map((song) => SongTile(
                              data: song,
                              selected:
                                  song.previewUrl == _selectedSong.previewUrl,
                              isPlaying: _audioPlayer.playing,
                              onTap: () => _onTapTile(song),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child: SpinnerLoading(),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: MediaPlayer(
                  showMediaPlayer: _showMediaPlayer,
                  isPlaying: _audioPlayer.playing,
                  progress: _progress,
                  onResume: _onResume,
                  onPause: _onPause,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
