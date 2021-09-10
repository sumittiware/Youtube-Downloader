import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youTubeDownloader/colors.dart';
import 'package:youTubeDownloader/downloadservice.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YouTubeDowloader extends StatefulWidget {
  @override
  _YouTubeDowloaderState createState() => _YouTubeDowloaderState();
}

class _YouTubeDowloaderState extends State<YouTubeDowloader> {
  bool _detailsFetched = false;
  bool _detailsLoading = false;
  bool _detailserror = false;
  bool _gettingVideo = false;
  bool _gettingAudio = false;

  String? title;
  String? author;
  String? duration;
  String? thumbnailUrl;
  String? date;
  String? error;

  var youtubeInstance;
  var _controller = TextEditingController();
  String filename = "";
  double stats = 0.0;
  String url = '';

  void settingstate() {
    Timer.periodic(
        const Duration(seconds: 1),
        (Timer t) => setState(() {
              stats = statistics;
            }));
  }

  @override
  void initState() {
    youtubeInstance = YoutubeExplode();
    super.initState();
  }

  @override
  void dispose() {
    youtubeInstance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Paste link here",
                  prefixIcon: Icon(Icons.content_paste),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              width: 140,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _detailsLoading = true;
                  });
                  getDetails(_controller.text).then((value) {
                    _detailsLoading = false;
                    _detailsFetched = true;
                    title = value[0];
                    author = value[1];
                    duration = value[2];
                    thumbnailUrl = value[3];
                    date = value[4];
                    setState(() {});
                  }).catchError((error) {
                    _detailsLoading = false;
                    _detailserror = true;
                    error = error;
                    setState(() {});
                    print(error.toString());
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.toString())));
                  });
                },
                child: (!_detailsLoading)
                    ? Text(
                        "Get Details",
                        style: TextStyle(color: Colors.white),
                      )
                    : _progressIndicator(),
                style: ElevatedButton.styleFrom(primary: AppColors.orange),
              ),
            ),
            if (_detailsFetched && !_detailsLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          height: 220,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(thumbnailUrl ?? ""),
                                fit: BoxFit.cover),
                          ),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              duration ?? "",
                              style: TextStyle(
                                  color: Colors.white,
                                  backgroundColor: Colors.black),
                            ),
                          ),
                        ),
                        Text(
                          title ?? "",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text(author ?? ""), Text(date ?? "")],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            if (_detailsFetched && !_detailsLoading)
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: AppColors.orange),
                          onPressed: () async {
                            setState(() {
                              _gettingVideo = true;
                            });
                            url = _controller.text;
                            settingstate();
                            try {
                              await extract(url);
                            } catch (e) {
                              print("Do nothing");
                            }
                            setState(() {
                              _gettingVideo = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Video downloaded and saved at /storage/emulated/0/YoutubeDownloader/Video/")));
                          },
                          child: (!_gettingVideo)
                              ? Text("Download Video")
                              : _progressIndicator()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: AppColors.orange),
                          onPressed: () async {
                            setState(() {
                              _gettingAudio = true;
                            });
                            url = _controller.text;
                            settingstate();
                            try {
                              await extract(url, downloadaudio: true);
                              setState(() {
                                _gettingAudio = false;
                              });
                            } catch (e) {
                              setState(() {
                                _gettingAudio = false;
                              });
                              print("Do nothing");
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "mp3 downloaded and saved at /storage/emulated/0/YoutubeDownloader/Audio/")));
                          },
                          child: (!_gettingAudio)
                              ? Text("Download Audio")
                              : _progressIndicator()),
                    ),
                  ]),
          ]),
    );
  }

  Widget _progressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.white),
        child: new CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}
