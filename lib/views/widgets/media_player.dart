import 'package:flutter/material.dart';
import 'package:music_player/constants.dart' as constants;

class MediaPlayer extends StatefulWidget {
  const MediaPlayer({
    Key? key,
    required this.showMediaPlayer,
    required this.isPlaying,
    required this.progress,
    required this.onResume,
    required this.onPause,
  }) : super(key: key);

  final bool showMediaPlayer;
  final bool isPlaying;
  final double progress;
  final void Function() onResume;
  final void Function() onPause;

  @override
  State<MediaPlayer> createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer>
    with TickerProviderStateMixin {
  late AnimationController _animSizeController;
  late Animation<double> _animationSize;
  late AnimationController _animIconController;

  @override
  void initState() {
    _animSizeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationSize = _animationSize = CurvedAnimation(
      parent: _animSizeController,
      curve: Curves.easeInOut,
    );
    _animIconController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    super.initState();
  }

  @override
  void didUpdateWidget(covariant MediaPlayer oldWidget) {
    if (widget.isPlaying) {
      _animIconController.forward();
    } else {
      _animIconController.reverse();
    }

    if (widget.showMediaPlayer) {
      _animSizeController.forward();
    } else {
      _animSizeController.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animSizeController.dispose();
    _animIconController.dispose();
    super.dispose();
  }

  void _onTapPlayPause() {
    if (_animIconController.value == 0.0) {
      widget.onResume();
      _animIconController.forward();
    } else {
      widget.onPause();
      _animIconController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animationSize,
      axisAlignment: 1,
      child: Card(
        color: Theme.of(context).primaryColor,
        child: Container(
          height: 100,
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                key: constants.playPauseButtonKey,
                borderRadius: BorderRadius.circular(40),
                onTap: _onTapPlayPause,
                child: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  progress: _animIconController,
                  size: 44,
                  color: Colors.white,
                ),
              ),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: Colors.red,
                  inactiveTrackColor: Theme.of(context).dividerColor,
                  thumbColor: Colors.white,
                ),
                child: Slider(value: widget.progress, onChanged: (_) {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
