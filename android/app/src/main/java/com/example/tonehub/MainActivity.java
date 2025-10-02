package com.example.tonehub;

import android.content.ContentValues;
import android.content.Intent;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.provider.MediaStore;
import android.provider.Settings;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import java.io.File;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.tonehub/ringtone";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("setRingtone")) {
                        String filePath = call.argument("filePath");
                        String fileName = call.argument("fileName");
                        
                        if (filePath != null && fileName != null) {
                            boolean success = setRingtone(filePath, fileName);
                            if (success) {
                                result.success("Ringtone set successfully");
                            } else {
                                result.error("ERROR", "Failed to set ringtone", null);
                            }
                        } else {
                            result.error("INVALID_ARGUMENT", "File path or name is null", null);
                        }
                    } else {
                        result.notImplemented();
                    }
                }
            );
    }

    private boolean setRingtone(String filePath, String fileName) {
        try {
            // Check if we have permission to write settings
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (!Settings.System.canWrite(this)) {
                    // Request permission
                    Intent intent = new Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS);
                    intent.setData(Uri.parse("package:" + getPackageName()));
                    startActivity(intent);
                    return false;
                }
            }

            File audioFile = new File(filePath);
            if (!audioFile.exists()) {
                return false;
            }

            ContentValues values = new ContentValues();
            values.put(MediaStore.MediaColumns.DATA, audioFile.getAbsolutePath());
            values.put(MediaStore.MediaColumns.TITLE, fileName);
            values.put(MediaStore.MediaColumns.MIME_TYPE, "audio/*");
            values.put(MediaStore.Audio.Media.IS_RINGTONE, true);
            values.put(MediaStore.Audio.Media.IS_NOTIFICATION, false);
            values.put(MediaStore.Audio.Media.IS_ALARM, false);
            values.put(MediaStore.Audio.Media.IS_MUSIC, false);

            Uri uri = MediaStore.Audio.Media.getContentUriForPath(audioFile.getAbsolutePath());
            Uri newUri = getContentResolver().insert(uri, values);

            if (newUri != null) {
                RingtoneManager.setActualDefaultRingtoneUri(
                    this,
                    RingtoneManager.TYPE_RINGTONE,
                    newUri
                );
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
