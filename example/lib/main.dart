import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_video_editor/flutter_video_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late XFile _video;
  late XFile _asset;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    child: const Text("Pick a video and Edit it"),
                    onPressed: () async {
                      debugPrint("clicked!");
                      await _pickVideo();
                      var tempDir = await getTemporaryDirectory();
                      final path =
                          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}result.mp4';
                      debugPrint("$tempDir");
                      await _pickAsset();
                      final imageBitmap =
                          (await _asset.readAsBytes()).buffer.asUint8List();
                      try {
                        final videoEffects = [
                          VideoEffect.filter(Filters.pink),
                          VideoEffect.imageOverlay(imageBitmap, 300, 300),
                          VideoEffect.textOverlay(
                              "text", 100, 10, 100, const Color(0xffffc0cb)),
                        ];
                        final videoEditor =
                            VideoEditor(VideoFile(_video.path), videoEffects);
                        videoEditor.make(path).then((_) async {
                          debugPrint("finished");
                          debugPrint(path);
                          GallerySaver.saveVideo(path).then((bool? success) {
                            debugPrint(success.toString());
                          });
                          final currentState = _navigatorKey.currentState;
                          if (currentState != null) {
                            currentState.push(
                              MaterialPageRoute(
                                  builder: (context) => VideoPage(path: path)),
                            );
                          }

                          setState(() {
                            _isLoading = false;
                          });
                        });
                      } on PlatformException {
                        debugPrint("error!!!!");
                      }
                    },
                  )),
      ),
    );
  }

  Future<void> _pickVideo() async {
    try {
      final ImagePicker _picker = ImagePicker();
      XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _video = video;
          _isLoading = true;
        });
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future<void> _pickAsset() async {
    try {
      final ImagePicker _picker = ImagePicker();
      XFile? asset = await _picker.pickImage(source: ImageSource.gallery);
      if (asset != null) {
        setState(() {
          _asset = asset;
          _isLoading = true;
        });
      }
    } catch (e) {
      debugPrint("$e");
    }
  }
}

class VideoPage extends StatefulWidget {
  final String path;

  const VideoPage({Key? key, required this.path}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
