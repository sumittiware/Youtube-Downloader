import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:date_format/date_format.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
var yt = YoutubeExplode();
double statistics = 0.0;
String filename1 = '';

void logCallback(int level, double message) {
  statistics = message;
}

Future<void> showValue(var audio, var audioStream) async {
  double len = audio.size.totalBytes.toDouble();
  double count = 0;
  await for (var data in audioStream) {
    // Keep track of the current downloaded data.
    count += data.length.toDouble();

    // Calculate the current progress.

    double progress = ((count / len) / 1);
    // Update the progressbar.
    logCallback(100, progress);

    // Write to file.
    // output.add(data);
  }
}

Future<void> download(var audioStream, var output) async {
  await audioStream.pipe(output);
  await output.flush();
  await output.close();
}

Future<Directory> _getDownloadDirectory(bool isAudio) async {
  if (Platform.isAndroid) {
    Directory? directory = await getExternalStorageDirectory();
    String newPath = "";
    print(directory);
    List<String> paths = directory!.path.split("/");
    for (int x = 1; x < paths.length; x++) {
      String folder = paths[x];
      if (folder != "Android") {
        newPath += "/" + folder;
      } else {
        break;
      }
    }
    String enddir = "/YoutubeDownloader/" + (isAudio ? "Audio/" : "Video/");
    newPath = newPath + enddir;
    var dir = Directory(newPath);
    bool direxists = await dir.exists();
    if (!direxists) {
      await dir.create(recursive: true);
    }
    return dir;
  }
  throw "Platform not supported";
}

Future<bool> _requestPermissions() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
    status = await Permission.storage.status;
  }
  return status.isGranted;
}

Future<List<dynamic>> getDetails(String url) async {
  var video = await yt.videos.get(url.trim());

  var title = video.title;
  var author = video.author;
  var duration = video.duration;
  var thumbmnail = video.thumbnails.highResUrl;
  var uploadDate = video.publishDate;

  return [
    title,
    author,
    "${duration?.inHours}:${duration?.inMinutes.remainder(60)}:${(duration?.inSeconds.remainder(60))}",
    thumbmnail,
    formatDate(uploadDate ?? DateTime.now(), [dd, '/', mm, '/', yyyy])
        .toString()
  ];
}

Future<void> extract(url, {bool downloadaudio = false}) async {
  url.trim();
  // Save the video to the download directory.
  // final FlutterFFmpegConfig _flutterFFmpegConfig = new FlutterFFmpegConfig();
  // var storageperm = Permission.storage;
  var permissions = await _requestPermissions();
  var dir = await _getDownloadDirectory(downloadaudio);
  print(dir);
  if (permissions) {
    Directory(dir.path).createSync();

    var video = await yt.videos.get(url);

    // Get the video manifest.
    var manifest = await yt.videos.streamsClient.getManifest(url);
    var streams = (downloadaudio) ? manifest.audioOnly : manifest.muxed;

    // Get the audio track with the highest bitrate.
    var audio = streams.withHighestBitrate();
    var audioStream = yt.videos.streamsClient.get(audio);

    // Compose the file name removing the unallowed characters in windows.
    var fileName = '${video.title}.${audio.container.name.toString()}'
        .replaceAll(r'\', '')
        .replaceAll('/', '')
        .replaceAll('*', '')
        .replaceAll('?', '')
        .replaceAll('"', '')
        .replaceAll('<', '')
        .replaceAll('>', '')
        .replaceAll('|', '');
    final path = dir.path + fileName + ((downloadaudio) ? ".mp3" : "");
    var file = File(path);

    // Open the file in writeAppend.
    var output = file.openWrite();
    print("File opened");
    download(audioStream, output);
    // await Future.wait(
    //     [download(audioStream, output), showValue(audio, audioStream)]);

    // Track the file download status.

    // filename1 = 'Downloading ${video.title}.${audio.container.name}';
    // Listen for data received.

  } else {
    throw "Storage permission denied";
  }
}
