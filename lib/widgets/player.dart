import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youTubeDownloader/colors.dart';
import 'package:youTubeDownloader/provider/songprovider.dart';

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  SongProvider? songProvider;
  Timer? songTimer;
  var position = new Duration();
  bool? setLoop = false;

  Widget slider() {
    return Slider.adaptive(
        activeColor: AppColors.orange,
        inactiveColor: AppColors.grey.withOpacity(0.4),
        value: position.inSeconds.toDouble(),
        max: songProvider!.songDuration.inSeconds.toDouble(),
        onChanged: (value) {
          songProvider!.player.seek(Duration(seconds: value.toInt()));
        });
  }

  listenStream() {
    songProvider!.player.positionStream.listen((duration) {
      if (duration == songProvider!.songDuration) {
        int value = (setLoop!) ? 0 : 1;
        songProvider!.changeSong(songProvider!.currentIndex + value);
      }
      setState(() {
        position = duration;
      });
    });
  }

  @override
  void dispose() {
    songProvider!.disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    songProvider = Provider.of<SongProvider>(context);
    listenStream();
    return Card(
      color: Colors.amber.shade200,
      elevation: 8,
      margin: EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              songProvider!.getCurrentSongName(),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${position.inMinutes.toString().padLeft(2, '0')}:${position.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Expanded(child: slider()),
                Text(
                  "${songProvider!.songDuration.inMinutes.toString().padLeft(2, '0')}:${songProvider!.songDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        setLoop = !(setLoop!);
                      });
                    },
                    icon: Icon(
                      Icons.loop_rounded,
                      color: (setLoop!) ? AppColors.orange : AppColors.grey,
                    )),
                actionButton(
                    icon: Icons.skip_previous,
                    onPresssed: () {
                      songProvider!.changeSong(songProvider!.currentIndex - 1);
                    }),
                actionButton(
                    icon: songProvider!.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    onPresssed: () {
                      songProvider!.toogleSong();
                    },
                    play: true),
                actionButton(
                    icon: Icons.skip_next,
                    onPresssed: () {
                      songProvider!.changeSong(songProvider!.currentIndex + 1);
                    }),
                IconButton(
                    onPressed: () {
                      songProvider!.shuffleList();
                    },
                    icon: Icon(Icons.shuffle_rounded, color: AppColors.grey))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget actionButton(
      {IconData? icon, void Function()? onPresssed, bool? play = false}) {
    return FloatingActionButton(
      backgroundColor: AppColors.orange,
      child: Icon(
        icon,
        size: (play!) ? 50 : 25,
        color: Colors.white,
      ),
      onPressed: onPresssed ?? () {},
    );
  }
}
