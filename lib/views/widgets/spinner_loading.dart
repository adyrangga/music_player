import 'package:flutter/material.dart';
import 'package:music_player/constants.dart' as constants;
import 'package:music_player/view_models/music_player_view_model.dart';
import 'package:provider/provider.dart';

class SpinnerLoading extends StatelessWidget {
  const SpinnerLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return context.watch<MusicPlayerViewModel>().isLoading()
        ? Container(
            key: constants.spinnerKey,
            color: Colors.grey,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          )
        : const SizedBox(key: constants.noSpinnerKey);
  }
}
