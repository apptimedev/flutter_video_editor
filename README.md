# Flutter Plugin Video Editor
## foruscommunity/flutter_video_editor

[![Forus App](https://forus.app/icons/icon-128x128.png)](https://forus.app)

---

Flutter plugin `foruscommunity/flutter_video_editor` allows you to edit videos on Android and iOS.

Thanks to [anharu2394/tapioca](https://github.com/anharu2394/tapioca) plugin that inspired this project.

---

## Summary

* ### [Getting Started](#getting-started)
* ### [Installation](#installation)
* ### [Usage](#usage)
* ### [Used packages](#used-packages)
* ### [License](#license)

---

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## Installation

First, add `flutter_video_editor` as a [dependency in your pubspec.yaml file.](https://flutter.dev/docs/development/packages-and-plugins/using-packages)

### Android

Step 1. Ensure the following permission is present in your Android Manifest file, located in `<project root>/android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

Step 2. Add the JitPack repository to your Android build file, located in `<project root>/android/build.gradle`:

```
allprojects {
	repositories {
		...
		maven { url 'https://jitpack.io' }
	}
}
```

### iOS

Add the following entry to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

- NSPhotoLibraryUsageDescription - Specifies the reason for your app to access the user’s photo library. This is called `Privacy - Photo Library Usage Description` in the visual editor.
- NSPhotoLibraryAddUsageDescription - Specifies the reason for your app to get write-only access to the user’s photo library. This is called `Privacy - Photo Library Additions Usage Description` in the visual editor.

```
<key>NSPhotoLibraryUsageDescription</key>
<string>Used to demonstrate image picker plugin</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>needs permission to write videos</string>
```

## Usage

```dart
import 'package:flutter_video_editor/flutter_video_editor.dart';
import 'package:path_provider/path_provider.dart';

final videoEffects = [
    VideoEffect.filter(Filters.pink),
    VideoEffect.imageOverlay(imageBitmap, 300, 300),
    VideoEffect.textOverlay("text",100,10,100,Color(0xffffc0cb)),
];
var tempDir = await getTemporaryDirectory();
final path = '${tempDir.path}/result.mp4';
final videoEditor = VideoEditor(VideoFile(videoPath), videoEffects);
videoEditor.make(path).then((_) {
  print("finish processing");
});
```

### VideoEffect

VideoEffect is an effect to apply to the video.

| VideoEffect                                                               |       Effect       |
| :------------------------------------------------------------------------ | :----------------: |
| VideoEffect.filter(Filters filter)                                        | Apply color filter |
| VideoEffect.textOverlay(String text, int x, int y, int size, Color color) |    Overlay text    |
| VideoEffect.imageOverlay(Uint8List bitmap, int x, int y)                  |   Overlay images   |

### VideoFile

VideoFile is a class to wrap a video file.

### VideoEditor

VideoEditor is a class to wrap a `VideoFile` object and `List<VideoEffect>` object.

You can edit the video by executing `.make()`.


## Used packages

* [AVFoundation](https://developer.apple.com/documentation/avfoundation): Official video editor for iOS.
* [Mp4Composer-android](https://github.com/MasayukiSuda/Mp4Composer-android): MasayukiSuda's video editor for Android.

---

## License

BSD licensed. See the LICENSE file for details.