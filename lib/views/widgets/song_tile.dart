import 'package:flutter/material.dart';
import 'package:music_player/models/song_model.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    Key? key,
    required this.data,
    required this.selected,
    required this.isPlaying,
    required this.onTap,
  }) : super(key: key);

  final SongModel data;
  final bool selected;
  final bool isPlaying;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key('songTileKey${data.trackId}'),
      contentPadding: EdgeInsets.zero,
      selected: selected,
      leading: data.artworkUrl100.isNotEmpty
          ? ImageContainer(image: NetworkImage(data.artworkUrl100))
          : null,
      title: Text(data.trackName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.artistName),
          Text(data.collectionName),
        ],
      ),
      trailing: selected && isPlaying
          ? const ImageContainer(image: AssetImage('assets/playing-on.gif'))
          : null,
      shape: Border(
        bottom: BorderSide(
          color: Theme.of(context).dividerColor,
        ),
      ),
      onTap: onTap,
    );
  }
}

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    Key? key,
    required this.image,
  }) : super(key: key);

  final ImageProvider<Object> image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
