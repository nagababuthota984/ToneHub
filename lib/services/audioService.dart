import 'package:audioplayers/audioplayers.dart';

class AudioService {
  bool isPlaying = false;
  String currentPlayingFilePath = '';
  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> playAudio(String filePath) async {
    if (!isPlaying) {
      if (audioPlayer.source != null) {
        await audioPlayer.release();
      }
      isPlaying = true;
      currentPlayingFilePath = filePath;
      await audioPlayer.play(DeviceFileSource(filePath));
    }
  }

  Future<void> pauseAudio() async {
    if (isPlaying) {
      await audioPlayer.pause();
      isPlaying = false;
    }
  }

  Future<void> stopAudio() async {
    if (isPlaying) {
      await audioPlayer.stop();
      currentPlayingFilePath = '';
      isPlaying = false;
    }
  }
}
