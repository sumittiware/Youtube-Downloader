import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youTubeDownloader/main.dart';
import './downloadservice.dart';
import 'package:youTubeDownloader/provider/songprovider.dart';
import 'package:youTubeDownloader/widgets/player.dart';
import 'package:youTubeDownloader/widgets/songs.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    getPermission();
    super.initState();
  }

  getPermission() async {
    await requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Youtube Play Music"),
        backgroundColor: Colors.orange,
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
