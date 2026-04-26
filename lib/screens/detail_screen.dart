import 'package:flutter/material.dart';

import '../services/bus_service.dart';
import 'map_screen.dart';

/// Detail screen for a single bus, highlighting the user's selected
/// from/to stops and the segment between them.
class DetailScreen extends StatelessWidget {
  final BusMatch match;

  const DetailScreen({super.key, required this.match});

  int get fare => match.fare.amount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final route = match.route;
    final stops = route.stops;

    final lo = match.fromIndex < match.toIndex
        ? match.fromIndex
        : match.toIndex;
    final hi = match.fromIndex < match.toIndex
        ? match.toIndex
        : match.fromIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(route.name),
        actions: [
          IconButton(
            tooltip: 'View Map',
            icon: const Icon(Icons.map_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MapScreen(match: match),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Card(
                elevation: 0,
                color: theme.colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        route.name,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        route.nameBn,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: [
                          _Pill(
                            icon: Icons.access_time,
                            label:
                                '${route.startTime} – ${route.endTime}',
                          ),
                          _Pill(
                            icon: Icons.event_seat,
                            label: route.serviceType,
                          ),
                          _Pill(
                            icon: match.fare.isOfficial
                                ? Icons.verified_rounded
                                : Icons.calculate_outlined,
                            label:
                                '${match.fare.isOfficial ? "Official" : "Estimated"} ৳$fare',
                          ),
                          _Pill(
                            icon: Icons.alt_route,
                            label: '${match.stopsBetween} stops',
                          ),
                          _Pill(
                            icon: Icons.straighten,
                            label:
                                '${match.fare.distanceKm.toStringAsFixed(1)} km',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Row(
                children: [
                  Icon(Icons.route, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Stops on this bus',
                    style: theme.textTheme.titleMedium,
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MapScreen(match: match),
                        ),
                      );
                    },
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: const Text('View Map'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: stops.length,
                itemBuilder: (context, i) {
                  final isFrom = i == match.fromIndex;
                  final isTo = i == match.toIndex;
                  final isHighlighted = isFrom || isTo;
                  final isInBetween = i > lo && i < hi;
                  return _StopTile(
                    name: stops[i],
                    isFirst: i == 0,
                    isLast: i == stops.length - 1,
                    isFrom: isFrom,
                    isTo: isTo,
                    isHighlighted: isHighlighted,
                    isInBetween: isInBetween,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StopTile extends StatelessWidget {
  final String name;
  final bool isFirst;
  final bool isLast;
  final bool isFrom;
  final bool isTo;
  final bool isHighlighted;
  final bool isInBetween;

  const _StopTile({
    required this.name,
    required this.isFirst,
    required this.isLast,
    required this.isFrom,
    required this.isTo,
    required this.isHighlighted,
    required this.isInBetween,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlightColor = theme.colorScheme.primary;
    final inBetweenColor = Colors.amber.shade700;

    Color dotColor;
    if (isHighlighted) {
      dotColor = highlightColor;
    } else if (isInBetween) {
      dotColor = inBetweenColor;
    } else {
      dotColor = theme.colorScheme.outlineVariant;
    }

    final lineColor = isInBetween || isHighlighted
        ? highlightColor.withValues(alpha: 0.6)
        : theme.colorScheme.outlineVariant;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 36,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 2,
                    color: isFirst ? Colors.transparent : lineColor,
                  ),
                ),
                Container(
                  width: isHighlighted ? 18 : 12,
                  height: isHighlighted ? 18 : 12,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : lineColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? highlightColor.withValues(alpha: 0.12)
                      : isInBetween
                          ? inBetweenColor.withValues(alpha: 0.12)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: isHighlighted
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isHighlighted
                              ? highlightColor
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (isFrom)
                      const _Tag(text: 'FROM', color: Colors.green),
                    if (isTo)
                      const _Tag(text: 'TO', color: Colors.green),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  const _Tag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Pill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodySmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
