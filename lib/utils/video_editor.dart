import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_video_editor/utils/video_effect.dart';
import 'package:flutter_video_editor/models/video_file.dart';

/// VideoEditor is a class to wrap a VideoFile object and List object.
class VideoEditor {
  /// Returns the [VideoFile] instance for applying filters.
  final VideoFile videoFile;

  /// Returns the [List<VideoEffect>] instance.
  final List<VideoEffect> videoEffects;

  /// Creates a VideoEditor object.
  VideoEditor(this.videoFile, this.videoEffects);

  /// Edit the video based on the [tapiocaBalls](list of processing)
  Future make(String destFilePath) {
    final Map<String, Map<String, dynamic>> processing = {
      for (var v in videoEffects) v.toTypeName(): v.toMap()
    };
    return _VideoEditor.writeVideoFile(videoFile.name, destFilePath, processing);
  }
}

class _VideoEditor {
  static const MethodChannel _channel = MethodChannel('flutter_video_editor');

  static Future writeVideoFile(String srcFilePath, String destFilePath,
      Map<String, Map<String, dynamic>> processing) async {
    await _channel.invokeMethod('writeVideoFile', <String, dynamic>{
      'srcFilePath': srcFilePath,
      'destFilePath': destFilePath,
      'processing': processing
    });
  }
}
