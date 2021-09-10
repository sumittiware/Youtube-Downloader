import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youTubeDownloader/main.dart';
import 'package:youTubeDownloader/provider/songprovider.dart';
import 'package:youTubeDownloader/widgets/player.dart';
import 'package:youTubeDownloader/widgets/songs.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context, listen: false);
    songProvider.readSongsFile();
    return Scaffold(
      appBar: AppBar(
        title: Text("Youtube Play Music"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return MyHomePage();
                }));
              },
              icon: Icon(Icons.download_rounded))
        ],
      ),
      body: Column(
        children: [SongsList(), MusicPlayer()],
      ),
    );
  }
}
