import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../data/stop_coords.dart';
import '../services/bus_service.dart';

/// Real-world map view of a single bus route, rendered with OpenStreetMap
/// tiles (no API key, free for non-commercial use). The polyline traces the
/// bus's path between [match.fromStop] and [match.toStop]; large green
/// markers mark the From/To stops; smaller amber markers mark intermediate
/// stops on the segment; tiny grey markers mark all other stops on the
/// route for context.
class MapScreen extends StatelessWidget {
  final BusMatch match;

  const MapScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stops = match.route.stops;

    final lo = match.fromIndex < match.toIndex
        ? match.fromIndex
        : match.toIndex;
    final hi = match.fromIndex < match.toIndex
        ? match.toIndex
        : match.fromIndex;

    // Resolve a coordinate for every stop. Stops without explicit coords are
    // interpolated between their nearest known neighbours.
    final positioned = _resolvePoints(stops);

    final segmentPoints = <LatLng>[
      for (int i = lo; i <= hi; i++) positioned[i],
    ];

    // Frame the map around the segment with a little padding.
    final bounds = LatLngBounds.fromPoints(
      segmentPoints.isEmpty ? positioned : segmentPoints,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(match.route.name),
        actions: [
          IconButton(
            tooltip: 'About this map',
            icon: const Icon(Icons.info_outline),
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => const AlertDialog(
                title: Text('Route map'),
                content: Text(
                  'Map data © OpenStreetMap contributors. The route polyline '
                  'connects bus stops in published order; for stops without '
                  'precise coordinates the path is interpolated. Use it as a '
                  'visual aid, not for turn-by-turn navigation.',
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: _Legend(theme: theme),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FlutterMap(
                    options: MapOptions(
                      initialCameraFit: CameraFit.bounds(
                        bounds: bounds,
                        padding: const EdgeInsets.all(40),
                      ),
                      minZoom: 8,
                      maxZoom: 18,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.dhaka.bus_finder',
                        maxZoom: 19,
                      ),
                      PolylineLayer(
                        polylines: [
                          // Faint full-route polyline behind the main segment
                          Polyline(
                            points: positioned,
                            strokeWidth: 3,
                            color: theme.colorScheme.outline.withValues(
                                alpha: 0.45),
                            pattern: StrokePattern.dashed(
                                segments: const [8, 6]),
                          ),
                          // Highlighted travelled segment
                          Polyline(
                            points: segmentPoints,
                            strokeWidth: 6,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          for (int i = 0; i < positioned.length; i++)
                            _markerFor(
                              point: positioned[i],
                              label: stops[i],
                              isFrom: i == match.fromIndex,
                              isTo: i == match.toIndex,
                              isOnSegment: i >= lo && i <= hi,
                              theme: theme,
                            ),
                        ],
                      ),
                      const RichAttributionWidget(
                        attributions: [
                          TextSourceAttribution(
                            'OpenStreetMap contributors',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Card(
                elevation: 0,
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Icon(Icons.directions_bus_rounded,
                          color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${match.fromStop}  →  ${match.toStop}',
                                style: theme.textTheme.titleMedium),
                            Text(
                              '${match.stopsBetween} stops · '
                              '${match.fare.distanceKm.toStringAsFixed(1)} km · '
                              '৳${match.fare.amount}',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Marker _markerFor({
    required LatLng point,
    required String label,
    required bool isFrom,
    required bool isTo,
    required bool isOnSegment,
    required ThemeData theme,
  }) {
    final color = isFrom || isTo
        ? theme.colorScheme.primary
        : isOnSegment
            ? Colors.amber.shade700
            : theme.colorScheme.outline;
    final size = isFrom || isTo ? 36.0 : (isOnSegment ? 22.0 : 14.0);

    return Marker(
      point: point,
      width: size + 4,
      height: size + 4,
      child: Tooltip(
        message: label,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: isFrom || isTo
              ? Icon(
                  isFrom ? Icons.trip_origin : Icons.location_on,
                  color: Colors.white,
                  size: size * 0.6,
                )
              : null,
        ),
      ),
    );
  }

  /// Resolve a [LatLng] for every stop in [stops]. Known stops use their
  /// exact bundled coordinates; unknown stops are linearly interpolated
  /// between their nearest known neighbours so the polyline still draws a
  /// sensible path through them.
  List<LatLng> _resolvePoints(List<String> stops) {
    final n = stops.length;
    final known = List<LatLng?>.generate(n, (i) => coordinateForStop(stops[i]));

    // Find nearest known neighbour to each end so we can extrapolate.
    int firstKnown = known.indexWhere((p) => p != null);
    int lastKnown = -1;
    for (int i = n - 1; i >= 0; i--) {
      if (known[i] != null) {
        lastKnown = i;
        break;
      }
    }
    if (firstKnown == -1) {
      // No known coordinates at all. Use Dhaka centre and spread along a
      // small line to avoid a degenerate map.
      const dhakaCentre = LatLng(23.7806, 90.4074);
      return [
        for (int i = 0; i < n; i++)
          LatLng(
            dhakaCentre.latitude + (i - n / 2) * 0.005,
            dhakaCentre.longitude + (i - n / 2) * 0.003,
          ),
      ];
    }

    // Pad endpoints with the nearest known coordinate.
    for (int i = 0; i < firstKnown; i++) {
      known[i] = known[firstKnown];
    }
    for (int i = lastKnown + 1; i < n; i++) {
      known[i] = known[lastKnown];
    }

    // Interpolate the gaps between known points.
    final result = List<LatLng>.filled(n, known[firstKnown]!);
    int i = 0;
    while (i < n) {
      if (known[i] != null) {
        result[i] = known[i]!;
        i++;
        continue;
      }
      // Find the start (last known before i) and end (next known >= i).
      int start = i - 1;
      int end = i;
      while (end < n && known[end] == null) {
        end++;
      }
      final startLatLng = result[start];
      final endLatLng = known[end]!;
      final span = end - start;
      for (int j = i; j < end; j++) {
        final t = (j - start) / span;
        result[j] = LatLng(
          startLatLng.latitude +
              (endLatLng.latitude - startLatLng.latitude) * t,
          startLatLng.longitude +
              (endLatLng.longitude - startLatLng.longitude) * t,
        );
      }
      i = end;
    }
    return result;
  }
}

class _Legend extends StatelessWidget {
  final ThemeData theme;
  const _Legend({required this.theme});

  @override
  Widget build(BuildContext context) {
    Widget chip(Color color, IconData? icon, String text) => Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: icon == null
                    ? null
                    : Icon(icon, color: Colors.white, size: 8),
              ),
              const SizedBox(width: 6),
              Text(text, style: theme.textTheme.labelMedium),
            ],
          ),
        );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          chip(theme.colorScheme.primary, Icons.trip_origin, 'From / To'),
          chip(Colors.amber.shade700, null, 'Stops on segment'),
          chip(theme.colorScheme.outline, null, 'Other stops'),
        ],
      ),
    );
  }
}
