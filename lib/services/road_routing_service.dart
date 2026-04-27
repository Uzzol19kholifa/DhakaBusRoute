import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// Fetches road-following polylines for a bus route.
///
/// Resolution order:
/// 1. **Bundled** — at first call we load `assets/route_polylines.json` which
///    contains pre-computed OSRM polylines for every route in `bus_data.dart`.
///    These were generated against the *full* route (origin → terminus) so we
///    look up by route name and clip to the requested segment via
///    nearest-point matching against the segment's first/last waypoint.
/// 2. **Live OSRM** — if no bundled polyline is available (route name
///    missing or asset failed to load) we fall back to the public OSRM demo.
///    Cached in-memory for the session.
/// 3. **Straight-line** — caller's own fallback if both fail.
class RoadRoutingService {
  static const _base = 'https://router.project-osrm.org/route/v1/driving';
  static const _bundleAsset = 'assets/route_polylines.json';

  static Map<String, List<LatLng>>? _bundle;
  static Future<void>? _bundleLoad;
  static final Map<String, List<LatLng>> _liveCache = {};

  /// Lazily load the bundled polylines once per app session.
  static Future<void> _ensureBundle() {
    return _bundleLoad ??= () async {
      try {
        final raw = await rootBundle.loadString(_bundleAsset);
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        final out = <String, List<LatLng>>{};
        for (final entry in decoded.entries) {
          final list = entry.value as List<dynamic>;
          out[entry.key] = [
            for (final p in list)
              LatLng(
                ((p as List)[0] as num).toDouble(),
                (p[1] as num).toDouble(),
              ),
          ];
        }
        _bundle = out;
      } catch (_) {
        _bundle = const {};
      }
    }();
  }

  /// Returns a road-following polyline for the segment of [routeName]
  /// between [waypoints.first] and [waypoints.last]. If [routeName] is null
  /// or not in the bundle, falls back to live OSRM on [waypoints].
  ///
  /// Returns `null` only if everything failed; the caller should keep its
  /// straight-line fallback in that case.
  static Future<List<LatLng>?> route(
    List<LatLng> waypoints, {
    String? routeName,
  }) async {
    if (waypoints.length < 2) return waypoints;

    if (routeName != null) {
      await _ensureBundle();
      final full = _bundle?[routeName];
      if (full != null && full.length >= 2) {
        final clipped = _clipBundled(full, waypoints.first, waypoints.last);
        if (clipped.length >= 2) return clipped;
      }
    }

    return _liveOsrm(waypoints);
  }

  /// Clip a bundled full-route polyline to the segment between the points
  /// closest to [from] and [to]. Preserves order from full polyline.
  static List<LatLng> _clipBundled(
    List<LatLng> full,
    LatLng from,
    LatLng to,
  ) {
    final iFrom = _nearestIndex(full, from);
    final iTo = _nearestIndex(full, to);
    final lo = iFrom < iTo ? iFrom : iTo;
    final hi = iFrom < iTo ? iTo : iFrom;
    return full.sublist(lo, hi + 1);
  }

  static int _nearestIndex(List<LatLng> pts, LatLng target) {
    int best = 0;
    double bestD = double.infinity;
    for (int i = 0; i < pts.length; i++) {
      final p = pts[i];
      final dy = p.latitude - target.latitude;
      final dx = p.longitude - target.longitude;
      final d2 = dy * dy + dx * dx;
      if (d2 < bestD) {
        bestD = d2;
        best = i;
      }
    }
    return best;
  }

  static Future<List<LatLng>?> _liveOsrm(List<LatLng> waypoints) async {
    final cacheKey = waypoints
        .map((p) =>
            '${p.latitude.toStringAsFixed(5)},${p.longitude.toStringAsFixed(5)}')
        .join(';');
    final cached = _liveCache[cacheKey];
    if (cached != null) return cached;

    const chunkSize = 24;
    final out = <LatLng>[];
    try {
      for (int start = 0;
          start < waypoints.length - 1;
          start += chunkSize - 1) {
        final end = (start + chunkSize).clamp(0, waypoints.length);
        final slice = waypoints.sublist(start, end);
        final coords = slice.map((p) => '${p.longitude},${p.latitude}').join(';');
        final url =
            Uri.parse('$_base/$coords?overview=full&geometries=geojson');
        final res = await http
            .get(url, headers: {'User-Agent': 'dhaka_bus_finder/1.0'})
            .timeout(const Duration(seconds: 8));
        if (res.statusCode != 200) return null;
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final routes = body['routes'] as List<dynamic>?;
        if (routes == null || routes.isEmpty) return null;
        final geom = (routes.first as Map<String, dynamic>)['geometry']
            as Map<String, dynamic>;
        final coordsList = geom['coordinates'] as List<dynamic>;
        // OSRM GeoJSON coordinates can be int or double; cast via num.
        final pts = [
          for (final c in coordsList)
            LatLng(
              ((c as List)[1] as num).toDouble(),
              (c[0] as num).toDouble(),
            ),
        ];
        if (out.isNotEmpty && pts.isNotEmpty) {
          out.addAll(pts.skip(1));
        } else {
          out.addAll(pts);
        }
        if (end == waypoints.length) break;
      }
      _liveCache[cacheKey] = out;
      return out;
    } catch (_) {
      return null;
    }
  }
}
