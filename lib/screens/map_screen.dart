import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/stop_coords.dart';
import '../services/bus_service.dart';

/// Fully offline route map. Renders the bus route as a polyline over a
/// stylised Dhaka backdrop using stop coordinates bundled in
/// `lib/data/stop_coords.dart`. No network calls, no map tiles required.
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

    // Build (stop, point) list, interpolating coordinates for stops we don't
    // have explicit lat/lng for.
    final positioned = _resolvePoints(stops);

    return Scaffold(
      appBar: AppBar(
        title: Text(match.route.name),
        actions: [
          IconButton(
            tooltip: 'About this map',
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (_) => const AlertDialog(
                  title: Text('Offline route map'),
                  content: Text(
                    'This map is fully offline — stop locations are bundled '
                    'with the app. Coordinates are approximate landmarks; '
                    'use it as a visual schematic of the route, not for '
                    'turn-by-turn navigation.',
                  ),
                ),
              );
            },
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
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: LayoutBuilder(builder: (context, c) {
                      return InteractiveViewer(
                        minScale: 0.6,
                        maxScale: 4.0,
                        child: SizedBox(
                          width: c.maxWidth,
                          height: c.maxHeight,
                          child: CustomPaint(
                            painter: _RoutePainter(
                              stops: stops,
                              positioned: positioned,
                              fromIdx: match.fromIndex,
                              toIdx: match.toIndex,
                              lo: lo,
                              hi: hi,
                              primary: theme.colorScheme.primary,
                              accent: Colors.amber.shade700,
                              foreground: theme.colorScheme.onSurface,
                              muted: theme.colorScheme.outline,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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

  /// Resolve a `LatLng` for every stop in [stops], interpolating linearly
  /// between known neighbours when a stop is not in [stopCoordinates].
  static List<LatLng> _resolvePoints(List<String> stops) {
    final raw = stops.map((s) => stopCoordinates[s]).toList();

    // Linear interpolation between known neighbours for any null entries.
    for (int i = 0; i < raw.length; i++) {
      if (raw[i] != null) continue;
      int prev = i - 1;
      while (prev >= 0 && raw[prev] == null) {
        prev--;
      }
      int next = i + 1;
      while (next < raw.length && raw[next] == null) {
        next++;
      }
      if (prev >= 0 && next < raw.length) {
        final p = raw[prev]!;
        final n = raw[next]!;
        final t = (i - prev) / (next - prev);
        raw[i] = LatLng(
          p.lat + (n.lat - p.lat) * t,
          p.lng + (n.lng - p.lng) * t,
        );
      } else if (prev >= 0) {
        raw[i] = raw[prev];
      } else if (next < raw.length) {
        raw[i] = raw[next];
      } else {
        // Fallback to Dhaka centre.
        raw[i] = const LatLng(23.7806, 90.4067);
      }
    }
    return raw.cast<LatLng>();
  }
}

class _RoutePainter extends CustomPainter {
  final List<String> stops;
  final List<LatLng> positioned;
  final int fromIdx;
  final int toIdx;
  final int lo;
  final int hi;
  final Color primary;
  final Color accent;
  final Color foreground;
  final Color muted;

  _RoutePainter({
    required this.stops,
    required this.positioned,
    required this.fromIdx,
    required this.toIdx,
    required this.lo,
    required this.hi,
    required this.primary,
    required this.accent,
    required this.foreground,
    required this.muted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (positioned.isEmpty) return;

    // Draw a stylised "Dhaka" background watermark.
    _drawBackdrop(canvas, size);

    // Compute screen-space points by mapping lat/lng → pixel via bounding box.
    final lats = positioned.map((p) => p.lat).toList();
    final lngs = positioned.map((p) => p.lng).toList();
    var minLat = lats.reduce(math.min);
    var maxLat = lats.reduce(math.max);
    var minLng = lngs.reduce(math.min);
    var maxLng = lngs.reduce(math.max);

    // Pad the bbox so points aren't pasted on the edges.
    final padLat = math.max((maxLat - minLat) * 0.12, 0.005);
    final padLng = math.max((maxLng - minLng) * 0.12, 0.005);
    minLat -= padLat;
    maxLat += padLat;
    minLng -= padLng;
    maxLng += padLng;

    // Maintain aspect ratio; longitude span at Dhaka is roughly 1° lng ≈
    // 0.918° lat in actual ground distance.
    final latSpan = maxLat - minLat;
    final lngSpan = (maxLng - minLng) * 0.918;
    final scale = math.min(size.width / lngSpan, size.height / latSpan);
    final offsetX = (size.width - lngSpan * scale) / 2;
    final offsetY = (size.height - latSpan * scale) / 2;

    Offset toPx(LatLng p) {
      final x = offsetX + ((p.lng - minLng) * 0.918) * scale;
      final y = offsetY + (maxLat - p.lat) * scale;
      return Offset(x, y);
    }

    final pts = positioned.map(toPx).toList();

    // 1. Polyline for the entire route in muted colour.
    final fullLine = Paint()
      ..color = muted.withValues(alpha: 0.45)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final fullPath = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length; i++) {
      fullPath.lineTo(pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(fullPath, fullLine);

    // 2. Highlight segment between user's From and To in primary colour.
    if (lo != hi) {
      final segLine = Paint()
        ..color = primary
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      final segPath = Path()..moveTo(pts[lo].dx, pts[lo].dy);
      for (int i = lo + 1; i <= hi; i++) {
        segPath.lineTo(pts[i].dx, pts[i].dy);
      }
      canvas.drawPath(segPath, segLine);
    }

    // 3. Stop markers.
    for (int i = 0; i < pts.length; i++) {
      final isFrom = i == fromIdx;
      final isTo = i == toIdx;
      final isInBetween = i > lo && i < hi;
      final isHighlighted = isFrom || isTo;

      final radius = isHighlighted ? 8.0 : (isInBetween ? 5.0 : 4.0);
      final fill = Paint()
        ..color = isHighlighted
            ? primary
            : (isInBetween ? accent : muted)
        ..style = PaintingStyle.fill;
      final ring = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(pts[i], radius + 1.5, ring);
      canvas.drawCircle(pts[i], radius, fill);
    }

    // 4. Labels for the From/To stops only (avoid clutter).
    void drawLabel(int i, String text, Color color) {
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 160);
      final p = pts[i];
      final dx = (p.dx + tp.width + 12 < size.width) ? p.dx + 12 : p.dx - tp.width - 12;
      final dy = math.max(0.0, p.dy - tp.height - 6);
      final bg = Paint()..color = Colors.white.withValues(alpha: 0.92);
      final r = Rect.fromLTWH(dx - 4, dy - 2, tp.width + 8, tp.height + 4);
      canvas.drawRRect(
        RRect.fromRectAndRadius(r, const Radius.circular(6)),
        bg,
      );
      tp.paint(canvas, Offset(dx, dy));
    }

    drawLabel(fromIdx, stops[fromIdx], primary);
    if (fromIdx != toIdx) drawLabel(toIdx, stops[toIdx], primary);
  }

  void _drawBackdrop(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFF1F5F1);
    canvas.drawRect(Offset.zero & size, bg);

    // Subtle diagonal grid.
    final gridPaint = Paint()
      ..color = const Color(0xFFD8E1D8)
      ..strokeWidth = 0.5;
    const step = 32.0;
    for (double x = -size.height; x < size.width + size.height; x += step) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        gridPaint,
      );
    }

    // Soft 'Dhaka' watermark in the corner.
    final tp = TextPainter(
      text: TextSpan(
        text: 'DHAKA',
        style: TextStyle(
          color: const Color(0xFFC8DAC8).withValues(alpha: 0.7),
          fontSize: 56,
          fontWeight: FontWeight.w900,
          letterSpacing: 4,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(size.width - tp.width - 16, 12));
  }

  @override
  bool shouldRepaint(covariant _RoutePainter oldDelegate) {
    return oldDelegate.stops != stops ||
        oldDelegate.fromIdx != fromIdx ||
        oldDelegate.toIdx != toIdx ||
        oldDelegate.primary != primary;
  }
}

class _Legend extends StatelessWidget {
  final ThemeData theme;
  const _Legend({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 6,
      children: [
        _Dot(
          color: theme.colorScheme.primary,
          label: 'From / To',
        ),
        _Dot(color: Colors.amber.shade700, label: 'Stops on segment'),
        _Dot(color: theme.colorScheme.outline, label: 'Other stops'),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final String label;
  const _Dot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
