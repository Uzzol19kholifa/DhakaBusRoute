import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// Fetches road-following polylines via the public OSRM demo server.
///
/// OSRM (Open Source Routing Machine) snaps a sequence of waypoints to the
/// underlying OpenStreetMap road network and returns a polyline that follows
/// the actual roads — no API key, no billing. We use this so the bus-route
/// map shows real Dhaka streets rather than straight chords between stops.
///
/// Network failures fall back to the caller's straight-line polyline; the
/// in-memory cache means a route is only fetched once per app session.
class RoadRoutingService {
  static const _base = 'https://router.project-osrm.org/route/v1/driving';

  static final Map<String, List<LatLng>> _cache = {};

  /// Returns a road-following polyline that visits all [waypoints] in order,
  /// or `null` if the request failed (the caller should keep using its
  /// straight-line fallback).
  ///
  /// OSRM caps the public demo at ~25 waypoints per request, so we chunk
  /// long routes and stitch the segments back together.
  static Future<List<LatLng>?> route(List<LatLng> waypoints) async {
    if (waypoints.length < 2) return waypoints;

    final cacheKey = waypoints
        .map((p) =>
            '${p.latitude.toStringAsFixed(5)},${p.longitude.toStringAsFixed(5)}')
        .join(';');
    final cached = _cache[cacheKey];
    if (cached != null) return cached;

    const chunkSize = 24;
    final out = <LatLng>[];
    try {
      for (int start = 0; start < waypoints.length - 1; start += chunkSize - 1) {
        final end = (start + chunkSize).clamp(0, waypoints.length);
        final slice = waypoints.sublist(start, end);
        final coords = slice
            .map((p) => '${p.longitude},${p.latitude}')
            .join(';');
        final url = Uri.parse(
            '$_base/$coords?overview=full&geometries=geojson');
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
        final pts = [
          for (final c in coordsList)
            LatLng((c as List)[1] as double, c[0] as double),
        ];
        // Avoid duplicating the join point between chunks.
        if (out.isNotEmpty && pts.isNotEmpty) {
          out.addAll(pts.skip(1));
        } else {
          out.addAll(pts);
        }
        if (end == waypoints.length) break;
      }
      _cache[cacheKey] = out;
      return out;
    } catch (_) {
      return null;
    }
  }
}
