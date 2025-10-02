import 'package:flutter/services.dart';

class RingtoneService {
  static const platform = MethodChannel('com.example.tonehub/ringtone');

  Future<bool> setRingtone(String filePath, String fileName) async {
    try {
      await platform.invokeMethod('setRingtone', {
        'filePath': filePath,
        'fileName': fileName,
      });
      return true;
    } on PlatformException catch (e) {
      print("Failed to set ringtone: '${e.message}'.");
      return false;
    }
  }
}
