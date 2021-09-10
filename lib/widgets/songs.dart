import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:youTubeDownloader/colors.dart';
import 'package:youTubeDownloader/provider/songprovider.dart';

class SongsList extends StatefulWidget {
  const SongsList({Key? key}) : super(key: key);

  @override
  _SongsListState createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final songProvider = Provider.of<SongProvider>(context);
    return Expanded(
      child: (songProvider.files.length == 0)
          ? Center(
              child: Text("No Songs present in the given directory"),
            )
          : Container(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      onTap: () {
                        songProvider.changeSong(index);
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: deviceSize.width * 0.7,
                                child: Text(
                                  songProvider.getSongName(index),
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          (songProvider.currentIndex == index)
                                              ? AppColors.orange
                                              : AppColors.grey),
                                ),
                              ),
                              Spacer(),
                              if (songProvider.currentIndex == index &&
                                  songProvider.isPlaying)
                                SpinKitWave(
                                  color: AppColors.orange,
                                  size: 20,
                                  duration: Duration(milliseconds: 400),
                                ),
                              PopupMenuButton(
                                  padding: EdgeInsets.only(left: 8),
                                  onSelected: (value) {
                                    if (value == 1) {
                                      songProvider.deleteSong(index);
                                    }
                                  },
                                  icon: Icon(Icons.more_vert_rounded),
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: Text("Remove"),
                                          value: 1,
                                        ),
                                      ])
                            ],
                          )),
                    ),
                  );
                },
                itemCount: songProvider.files.length,
              ),
            ),
    );
  }
}
