import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' show Response;
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:music_player/api_services/api_service.dart';
import 'package:music_player/constants.dart' as constants;
import 'package:music_player/main.dart';
import 'package:music_player/models/song_model.dart';

import 'package:music_player/view_models/music_player_view_model.dart';
import 'package:provider/provider.dart';

import 'widget_test.mocks.dart';

final mockResponse = {
  "resultCount": 1,
  "results": [
    {
      "trackId": 1,
      "artistName": "artiseName",
      "collectionName": "collectionName",
      "trackName": "trackName",
      "previewUrl": "",
      "artworkUrl100": "",
    }
  ]
};

Widget makeTestableWidget(
        {Widget? child, required MusicPlayerViewModel provider}) =>
    MaterialApp(
      home: ChangeNotifierProvider<MusicPlayerViewModel>(
        create: (_) => provider,
        child: Scaffold(
          body: child,
        ),
      ),
    );

@GenerateMocks([MusicPlayerViewModel])
void main() {
  testWidgets('should render music player', (WidgetTester tester) async {
    String searchTerm = 'test';
    final apiProvider = ApiService();
    final mockProvider = MockMusicPlayerViewModel();
    apiProvider.client = MockClient((request) {
      return Future.value(Response(json.encode(mockResponse), 200));
    });
    apiProvider.fetchSong(searchTerm);
    when(mockProvider.getSongList).thenReturn([]);
    when(mockProvider.apiService).thenReturn(apiProvider);
    when(mockProvider.isLoading()).thenReturn(false);

    await tester.pumpWidget(makeTestableWidget(
      provider: mockProvider,
      child: const MyApp(),
    ));

    final searchField = find.byKey(constants.searchFieldKey);
    await tester.enterText(searchField, searchTerm);
    when(mockProvider.searchSong(searchTerm)).thenAnswer((_) {
      when(mockProvider.getSongList).thenReturn([
        SongModel(
          trackId: 1,
          artistName: 'artistName',
          collectionName: 'collectionName',
          trackName: 'trackName',
          previewUrl: '',
          artworkUrl100: '',
        ),
      ]);
    });

    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('songTileKey1')), findsOneWidget);
    await tester.tap(find.byKey(const Key('songTileKey1')));
    await tester.pumpAndSettle();

    expect(find.byKey(constants.playPauseButtonKey), findsOneWidget);
    InkWell playPause = find
        .byKey(constants.playPauseButtonKey)
        .evaluate()
        .single
        .widget as InkWell;
    playPause.onTap;
    await tester.pumpAndSettle();
  });
}
