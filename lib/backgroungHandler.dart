import 'package:audio_service/audio_service.dart';
import 'package:youTubeDownloader/provider/songprovider.dart';

class PlayerHandler extends BackgroundAudioTask {
  @override
  Future<void> onPlay() {
    return super.onPlay();
  }

  @override
  Future<void> onPause() {
    return super.onPause();
  }

  @override
  Future<void> onClose() {
    return super.onClose();
  }

  @override
  Future<void> onSkipToNext() {
    return super.onSkipToNext();
  }

  @override
  Future<void> onSkipToPrevious() {
    return super.onSkipToPrevious();
  }
}
