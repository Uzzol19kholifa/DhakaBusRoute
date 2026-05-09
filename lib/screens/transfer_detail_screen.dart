import 'package:flutter/material.dart';

import '../services/transfer_service.dart';

/// Full breakdown of a single 1-transfer journey: Bus 1 → mid stop → Bus 2.
class TransferDetailScreen extends StatelessWidget {
  final TransferSuggestion suggestion;
  final String from;
  final String to;
  final bool isBest;

  const TransferDetailScreen({
    super.key,
    required this.suggestion,
    required this.from,
    required this.to,
    this.isBest = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = suggestion;

    return Scaffold(
      appBar: AppBar(title: const Text('Transfer journey')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
                border: isBest
                    ? Border.all(
                        color: theme.colorScheme.primary, width: 1.4)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isBest)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'BEST OPTION',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5),
                        ),
                      ),
                    ),
                  Text(
                    '$from  →  $to',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '1 transfer at  ${s.transferStop}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _Chip(
                          label: 'Total',
                          value: '৳${s.totalFare}',
                          highlight: true),
                      const SizedBox(width: 8),
                      _Chip(
                          label: 'Stops', value: '${s.totalStops}'),
                      const SizedBox(width: 8),
                      _Chip(
                          label: 'Distance',
                          value:
                              '${s.totalKm.toStringAsFixed(1)} km'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _LegBlock(
              index: 1,
              title: 'Take Bus 1',
              busName: s.first.route.name,
              busNameBn: s.first.route.nameBn,
              fromStop: s.first.fromStop,
              toStop: s.first.toStop,
              stops: _segmentStops(s.first.route.stops, s.first.fromIndex,
                  s.first.toIndex),
              fareAmount: s.first.fare.amount,
              fareSource: s.first.fare.isOfficial ? 'Official' : 'Estimated',
              kmText: s.first.fare.distanceKm.toStringAsFixed(1),
            ),
            _TransferDivider(stop: s.transferStop),
            _LegBlock(
              index: 2,
              title: 'Take Bus 2',
              busName: s.second.route.name,
              busNameBn: s.second.route.nameBn,
              fromStop: s.second.fromStop,
              toStop: s.second.toStop,
              stops: _segmentStops(s.second.route.stops,
                  s.second.fromIndex, s.second.toIndex),
              fareAmount: s.second.fare.amount,
              fareSource:
                  s.second.fare.isOfficial ? 'Official' : 'Estimated',
              kmText: s.second.fare.distanceKm.toStringAsFixed(1),
            ),
            const SizedBox(height: 20),
            _BreakdownCard(suggestion: s),
          ],
        ),
      ),
    );
  }

  List<String> _segmentStops(List<String> stops, int from, int to) {
    final lo = from < to ? from : to;
    final hi = from < to ? to : from;
    final segment = stops.sublist(lo, hi + 1);
    return from < to ? segment : segment.reversed.toList();
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  const _Chip({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: highlight
            ? theme.colorScheme.primary
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlight
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: highlight ? Colors.white70 : theme.hintColor,
              )),
          Text(value,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: highlight
                    ? Colors.white
                    : theme.colorScheme.onSurface,
              )),
        ],
      ),
    );
  }
}

class _LegBlock extends StatelessWidget {
  final int index;
  final String title;
  final String busName;
  final String busNameBn;
  final String fromStop;
  final String toStop;
  final List<String> stops;
  final int fareAmount;
  final String fareSource;
  final String kmText;

  const _LegBlock({
    required this.index,
    required this.title,
    required this.busName,
    required this.busNameBn,
    required this.fromStop,
    required this.toStop,
    required this.stops,
    required this.fareAmount,
    required this.fareSource,
    required this.kmText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: theme.colorScheme.primary,
                child: Text('$index',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    )),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                            fontWeight: FontWeight.w600)),
                    Text(busName,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text(busNameBn,
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('৳$fareAmount',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  Text(fareSource,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: fareSource == 'Official'
                            ? theme.colorScheme.primary
                            : theme.hintColor,
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _StopsTimeline(stops: stops),
          const SizedBox(height: 8),
          Text(
            '$fromStop  →  $toStop · ${stops.length} stops · $kmText km',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _StopsTimeline extends StatelessWidget {
  final List<String> stops;
  const _StopsTimeline({required this.stops});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: List.generate(stops.length, (i) {
        final isFirst = i == 0;
        final isLast = i == stops.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: (isFirst || isLast)
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.only(top: 2),
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    stops[i],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: (isFirst || isLast)
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _TransferDivider extends StatelessWidget {
  final String stop;
  const _TransferDivider({required this.stop});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: theme.colorScheme.outlineVariant,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: Colors.amber.shade400, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.swap_horiz, size: 16),
                const SizedBox(width: 4),
                Text('Transfer at $stop',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: theme.colorScheme.outlineVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  final TransferSuggestion suggestion;
  const _BreakdownCard({required this.suggestion});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = suggestion;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Fare breakdown',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _row(theme, 'Bus 1 fare (${s.first.route.name})',
              '৳${s.first.fare.amount}'),
          _row(theme, 'Bus 2 fare (${s.second.route.name})',
              '৳${s.second.fare.amount}'),
          const Divider(height: 18),
          _row(
            theme,
            'Total',
            '৳${s.totalFare}',
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _row(ThemeData theme, String label, String value,
      {bool bold = false}) {
    final style = bold
        ? theme.textTheme.titleMedium
            ?.copyWith(fontWeight: FontWeight.w800)
        : theme.textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(label,
                  style: style, overflow: TextOverflow.ellipsis)),
          Text(value, style: style),
        ],
      ),
    );
  }
}
