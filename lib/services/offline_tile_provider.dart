import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;

/// `TileProvider` that prefers tiles bundled in the APK assets and falls
/// back to the public OSM tile server only for tiles outside the bundled
/// range.
///
/// Bundled coverage is roughly a 30 km box around central Dhaka at zooms
/// 10–14 (see `pubspec.yaml` and `assets/tiles/`). For any tile inside
/// that box the map renders fully offline; for zooms outside 10–14 (or
/// pans beyond Dhaka) we transparently fetch from `tile.openstreetmap.org`.
class OfflineTileProvider extends TileProvider {
  static const _userAgent = 'dhaka_bus_finder/1.0';
  static const _networkTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    return _OfflineTileImage(
      coords: coordinates,
      assetPath:
          'assets/tiles/${coordinates.z}/${coordinates.x}/${coordinates.y}.png',
      networkUrl: _networkTemplate
          .replaceAll('{z}', '${coordinates.z}')
          .replaceAll('{x}', '${coordinates.x}')
          .replaceAll('{y}', '${coordinates.y}'),
      userAgent: _userAgent,
    );
  }
}

@immutable
class _OfflineTileImage extends ImageProvider<_OfflineTileImage> {
  final TileCoordinates coords;
  final String assetPath;
  final String networkUrl;
  final String userAgent;

  const _OfflineTileImage({
    required this.coords,
    required this.assetPath,
    required this.networkUrl,
    required this.userAgent,
  });

  @override
  Future<_OfflineTileImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<_OfflineTileImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(
      _OfflineTileImage key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(decode),
      scale: 1.0,
      debugLabel: 'OfflineTile(${coords.z}/${coords.x}/${coords.y})',
    );
  }

  Future<ui.Codec> _loadAsync(ImageDecoderCallback decode) async {
    Uint8List? bytes = await _loadAsset();
    bytes ??= await _loadNetwork();
    if (bytes == null) {
      throw StateError(
          'Tile ${coords.z}/${coords.x}/${coords.y} not in assets and '
          'network fetch failed');
    }
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    return decode(buffer);
  }

  Future<Uint8List?> _loadAsset() async {
    try {
      final data = await rootBundle.load(assetPath);
      return data.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  Future<Uint8List?> _loadNetwork() async {
    try {
      final res = await http.get(Uri.parse(networkUrl), headers: {
        'User-Agent': userAgent,
      }).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return null;
      return res.bodyBytes;
    } catch (_) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      other is _OfflineTileImage && other.assetPath == assetPath;

  @override
  int get hashCode => assetPath.hashCode;
}
