import "dart:typed_data";
import "dart:ui";

/// Enum that specifies the color filter type.
enum Filters { pink, white, blue }

/// VideoEffect is a effect to apply to the video.
abstract class VideoEffect {
  /// Creates a object to apply color filter from [Filters].
  static VideoEffect filter(Filters filter) {
    return _Filter(filter);
  }

  /// Creates a object to apply color filter from [Color].
  static VideoEffect filterFromColor(Color color) {
    return _Filter.color(color);
  }

  /// Creates a object to overlay text.
  static VideoEffect textOverlay(
      String text, int x, int y, int size, Color color) {
    return _TextOverlay(text, x, y, size, color);
  }

  /// Creates a object to overlay a image.
  static VideoEffect imageOverlay(Uint8List bitmap, int x, int y) {
    return _ImageOverlay(bitmap, x, y);
  }

  /// Returns a [Map<String, dynamic>] representation of this object.
  Map<String, dynamic> toMap();

  /// Returns a VideoEffect type name.
  String toTypeName();
}

class _Filter extends VideoEffect {
  late String color;

  _Filter(Filters type) {
    switch (type) {
      case Filters.pink:
        color = "#ffc0cb";
        break;
      case Filters.white:
        color = "#ffffff";
        break;
      case Filters.blue:
        color = "#1f8eed";
    }
  }

  _Filter.color(Color colorInstance) {
    color = '#${colorInstance.value.toRadixString(16).substring(2)}';
  }

  @override
  Map<String, dynamic> toMap() {
    return {'type': color};
  }

  @override
  String toTypeName() {
    return 'Filter';
  }
}

class _TextOverlay extends VideoEffect {
  final String text;
  final int x;
  final int y;
  final int size;
  final Color color;

  _TextOverlay(this.text, this.x, this.y, this.size, this.color);

  @override
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'x': x,
      'y': y,
      'size': size,
      'color': '#${color.value.toRadixString(16).substring(2)}'
    };
  }

  @override
  String toTypeName() {
    return 'TextOverlay';
  }
}

class _ImageOverlay extends VideoEffect {
  final Uint8List bitmap;
  final int x;
  final int y;

  _ImageOverlay(this.bitmap, this.x, this.y);

  @override
  Map<String, dynamic> toMap() {
    return {'bitmap': bitmap, 'x': x, 'y': y};
  }

  @override
  String toTypeName() {
    return 'ImageOverlay';
  }
}
