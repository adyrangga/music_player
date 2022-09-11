import 'package:flutter/material.dart';
import 'package:music_player/constants.dart' as constants;

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required this.onSubmitSearch,
  }) : super(key: key);

  final void Function(String) onSubmitSearch;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: constants.searchFieldKey,
      textInputAction: TextInputAction.search,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        hintText: constants.searchMusic,
        fillColor: Colors.white,
        filled: true,
        isCollapsed: true,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
        contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      ),
      onSubmitted: onSubmitSearch,
    );
  }
}
