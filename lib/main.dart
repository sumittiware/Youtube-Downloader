import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youTubeDownloader/colors.dart';
import 'package:youTubeDownloader/homepage.dart';
import 'package:youTubeDownloader/provider/songprovider.dart';
import 'package:youTubeDownloader/youtubeDown.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: SongProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Youtube Downloader',
        darkTheme: ThemeData(
          // scaffoldBackgroundColor: AppColors.black,
          primaryColor: AppColors.orange,
        ),
        home: HomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text("Download"),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Steps to Follow : "),
                          content: SizedBox(
                            child: Text(
                                "1) Open youtube video, click on share option\n2) Click on copy to clipboard\n3) Paste the link on click \"Get Details\""),
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Okay"))
                          ],
                        );
                      });
                },
                icon: Icon(Icons.info))
          ],
        ),
        body: YouTubeDowloader());
  }
}
