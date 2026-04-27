import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../data/stop_coords.dart';
import '../services/bus_service.dart';
import '../services/offline_tile_provider.dart';
import '../services/road_routing_service.dart';

/// Real-world map view of a single bus route, rendered with OpenStreetMap
/// tiles (no API key, free for non-commercial use). The polyline first
/// renders as straight chords between bundled stop coordinates, then is
/// upgraded asynchronously to a road-following polyline via the OSRM demo
/// server (no key required). On network failure we keep the straight line.
class MapScreen extends StatefulWidget {
  final BusMatch match;

  const MapScreen({super.key, required this.match});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<LatLng>? _roadSegment;
  bool _routingFailed = false;
  bool _routingLoading = true;

  late final List<LatLng> _positioned;
  late final List<LatLng> _segmentPoints;
  late final int _lo;
  late final int _hi;

  @override
  void initState() {
    super.initState();
    final m = widget.match;
    _lo = m.fromIndex < m.toIndex ? m.fromIndex : m.toIndex;
    _hi = m.fromIndex < m.toIndex ? m.toIndex : m.fromIndex;
    _positioned = _resolvePoints(m.route.stops);
    _segmentPoints = [
      for (int i = _lo; i <= _hi; i++) _positioned[i],
    ];
    _kickOffRouting();
  }

  Future<void> _kickOffRouting() async {
    final result = await RoadRoutingService.route(
      _segmentPoints,
      routeName: widget.match.route.name,
    );
    if (!mounted) return;
    setState(() {
      _routingLoading = false;
      if (result != null && result.length > 1) {
        _roadSegment = result;
      } else {
        _routingFailed = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final match = widget.match;
    final stops = match.route.stops;
    final positioned = _positioned;
    final segmentPoints = _segmentPoints;
    final lo = _lo;
    final hi = _hi;

    final renderedSegment = _roadSegment ?? segmentPoints;

    // Frame the map around the segment with a little padding.
    final bounds = LatLngBounds.fromPoints(
      renderedSegment.isEmpty ? positioned : renderedSegment,
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
            if (_routingLoading)
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 8),
                    Text('Snapping route to roads…',
                        style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            if (_routingFailed)
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Text(
                  'Offline — showing straight-line route. Connect to the '
                  'internet for road-following polyline.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.amber.shade900),
                ),
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
                        // OfflineTileProvider serves z10-14 tiles around
                        // Dhaka from the bundled APK assets and falls
                        // back to OSM network only for tiles outside the
                        // bundled box (other cities, deeper zooms, etc.).
                        tileProvider: OfflineTileProvider(),
                        urlTemplate:
                            'assets/tiles/{z}/{x}/{y}.png',
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
                          // Highlighted travelled segment (road-following
                          // when OSRM responds, otherwise straight chords).
                          Polyline(
                            points: renderedSegment,
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
