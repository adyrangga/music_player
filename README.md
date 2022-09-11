# music_player

A Flutter Music Player.

## Getting Started

### Supported devices
- Android min SDK 11

### Supported features
- [x] Search music
- [x] Play and Pause
- [x] Autoplay next music in the list
- [x] Automatically stop playback if click pause with list is new search result

### Libraries/Dependencies
This application uses several libraries, including:
- [provider](https://pub.dev/packages/provider): used for state management.
- [http](https://pub.dev/packages/http): used for make http request.
- [just_audio](https://pub.dev/packages/just_audio): used for play audio from url.
- [mockito](https://pub.dev/packages/mockito) and [build_runner](https://pub.dev/packages/build_runner): used for mock library.

### Instructions to build and deploy the app
You can use VS Code to build and deploy via the VS Code terminal.
1. open this project with VS Code.
2. open VS Code terminal (ctrl + `) or on VS Code menu Click Terminal > New Terminal.
3. in terminal type and run `flutter pub get`.
4. then type and run `flutter build apk --release`.
5. check your build apk in `build\app\outputs\flutter-apk\app-release.apk`.
6. Install it on Android Device or Android Emulator.

Note: You have to do a music search to play it.
