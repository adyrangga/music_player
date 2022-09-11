import 'package:flutter/material.dart';
import 'package:music_player/constants.dart' as constants;
import 'package:music_player/view_models/music_player_view_model.dart';
import 'package:music_player/views/music_player_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MusicPlayerViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: constants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MusicPlayerScreen(),
    );
  }
}
