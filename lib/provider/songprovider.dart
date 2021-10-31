import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class SongProvider with ChangeNotifier {
  bool? _isPlaying = false;
  int? _currentIndex = 0;
  AudioPlayer? _player = AudioPlayer();
  Duration? _songDuration = Duration();
  List<FileSystemEntity>? _files = [];

  List<FileSystemEntity> get files => [..._files!];
  int get currentIndex => _currentIndex!;
  bool get isPlaying => _isPlaying!;
  Duration get songDuration => _songDuration!;
  AudioPlayer get player => _player!;

  SongProvider() {
    readSongsFile();
  }

  void readSongsFile() {
    _files!.clear();
    const directory = "/storage/emulated/0/YoutubeDownloader/Audio/";
    _files = Directory(directory).listSync();
  }

  String getSongName(int index) {
    return _files![index].path.split("/").last.split(".").first;
  }

  String getCurrentSongName() {
    return _files![_currentIndex!].path.split("/").last.split(".").first;
  }

  void toogleSong() {
    (_isPlaying!) ? _player?.pause() : _player!.play();
    _isPlaying = !_isPlaying!;
    notifyListeners();
  }

  Future<void> changeSong(int value) async {
    _songDuration = await _player!.setFilePath(_files![value].path);
    _currentIndex = value;
    // _player!.play();
    notifyListeners();
  }

  void disposePlayer() {
    _player!.dispose();
  }

  void shuffleList() {
    _files!.shuffle();
    _player!.pause();
    changeSong(currentIndex);
    notifyListeners();
  }

  void deleteSong(int index) {
    _files!.remove(_files![index]);
    notifyListeners();
  }
}
