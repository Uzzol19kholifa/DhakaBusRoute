import 'package:flutter/material.dart';

import '../services/bus_service.dart';
import '../services/fare_disclaimer.dart';
import '../services/transfer_service.dart';
import 'detail_screen.dart';
import 'map_screen.dart';
import 'transfer_detail_screen.dart';

class ResultsScreen extends StatefulWidget {
  final String from;
  final String to;

  const ResultsScreen({super.key, required this.from, required this.to});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late final List<BusMatch> matches;
  late final FareResult? headlineFare;
  bool _showSuggestions = false;
  List<TransferSuggestion>? _suggestions;

  @override
  void initState() {
    super.initState();
    matches = BusService.findBuses(widget.from, widget.to);
    headlineFare = BusService.headlineFare(matches);
  }

  void _loadSuggestions() {
    setState(() {
      _showSuggestions = true;
      _suggestions ??= TransferService.findSuggestions(widget.from, widget.to);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cheapest = matches.isNotEmpty ? matches.first.fare.amount : null;
    // Only show the "Cheapest" tag if there are multiple buses *and* there's
    // an actual price differential.
    final hasMultiplePrices = matches.length > 1 &&
        matches.any((m) => m.fare.amount != cheapest);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buses & Fare'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _RouteHeader(from: widget.from, to: widget.to),
            _FareCard(fare: headlineFare, hasResults: matches.isNotEmpty),
            const SizedBox(height: 4),
            if (matches.isEmpty)
              _NoDirectBusBlock(
                onShow: _loadSuggestions,
                showing: _showSuggestions,
              ),
            if (matches.isNotEmpty)
              ...List.generate(matches.length, (i) {
                final m = matches[i];
                final isCheapest =
                    hasMultiplePrices && m.fare.amount == cheapest;
                final diff = (cheapest == null) ? 0 : m.fare.amount - cheapest;
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                      16, i == 0 ? 8 : 0, 16, 10),
                  child: _BusCard(
                    match: m,
                    isCheapest: isCheapest,
                    diffFromCheapest: diff,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(match: m),
                      ),
                    ),
                    onMap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MapScreen(match: m),
                      ),
                    ),
                    theme: theme,
                  ),
                );
              }),
            if (matches.isEmpty && _showSuggestions)
              _SuggestionsList(
                suggestions: _suggestions ?? const [],
                from: widget.from,
                to: widget.to,
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _NoDirectBusBlock extends StatelessWidget {
  final VoidCallback onShow;
  final bool showing;
  const _NoDirectBusBlock({required this.onShow, required this.showing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        children: [
          Icon(Icons.directions_bus_filled_outlined,
              size: 56, color: theme.colorScheme.outline),
          const SizedBox(height: 12),
          Text(
            'No direct bus found',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'No single bus connects these stops. Tap below to see '
            'options with one transfer.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (!showing)
            FilledButton.icon(
              onPressed: onShow,
              icon: const Icon(Icons.alt_route_rounded),
              label: const Text('Show Suggestions'),
            ),
        ],
      ),
    );
  }
}

class _SuggestionsList extends StatelessWidget {
  final List<TransferSuggestion> suggestions;
  final String from;
  final String to;
  const _SuggestionsList({
    required this.suggestions,
    required this.from,
    required this.to,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (suggestions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Card(
          elevation: 0,
          color: theme.colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: theme.colorScheme.outline),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No 1-transfer route found between these stops in our '
                    'data either. Try a nearby landmark or a different '
                    'spelling.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    final cheapest = suggestions
        .map((s) => s.totalFare)
        .reduce((a, b) => a < b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(Icons.alt_route_rounded,
                  color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Suggested 1-transfer routes',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        for (final s in suggestions)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: _SuggestionCard(
              suggestion: s,
              isBest: s.totalFare == cheapest,
              from: from,
              to: to,
            ),
          ),
      ],
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final TransferSuggestion suggestion;
  final bool isBest;
  final String from;
  final String to;
  const _SuggestionCard({
    required this.suggestion,
    required this.isBest,
    required this.from,
    required this.to,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = suggestion;
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isBest
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TransferDetailScreen(
              suggestion: s,
              from: from,
              to: to,
              isBest: isBest,
            ),
          ),
        ),
        child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isBest)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Best option',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            _LegRow(
              order: 1,
              busName: s.first.route.name,
              busNameBn: s.first.route.nameBn,
              from: s.first.fromStop,
              to: s.first.toStop,
              fare: s.first.fare,
              stops: s.first.stopsBetween,
              theme: theme,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.swap_calls_rounded,
                      size: 16, color: theme.colorScheme.outline),
                  const SizedBox(width: 6),
                  Text(
                    'Transfer at ${s.transferStop}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            _LegRow(
              order: 2,
              busName: s.second.route.name,
              busNameBn: s.second.route.nameBn,
              from: s.second.fromStop,
              to: s.second.toStop,
              fare: s.second.fare,
              stops: s.second.stopsBetween,
              theme: theme,
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total · ${s.totalStops} stops · '
                    '${s.totalKm.toStringAsFixed(1)} km',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Text(
                  '৳${s.totalFare}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            if (s.hasEstimated)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Includes one or more estimated leg',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.amber.shade900,
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Spacer(),
                Text('View details',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    )),
                Icon(Icons.chevron_right,
                    size: 16, color: theme.colorScheme.primary),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _LegRow extends StatelessWidget {
  final int order;
  final String busName;
  final String busNameBn;
  final String from;
  final String to;
  final FareResult fare;
  final int stops;
  final ThemeData theme;
  const _LegRow({
    required this.order,
    required this.busName,
    required this.busNameBn,
    required this.from,
    required this.to,
    required this.fare,
    required this.stops,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$order',
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                busName,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (busNameBn.isNotEmpty)
                Text(
                  busNameBn,
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant),
                ),
              const SizedBox(height: 2),
              Text(
                '$from  →  $to',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.alt_route,
                      size: 13, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 3),
                  Text('$stops stops',
                      style: theme.textTheme.bodySmall),
                  const SizedBox(width: 12),
                  Text('৳${fare.amount}',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: fare.isOfficial
                          ? theme.colorScheme.primary.withValues(alpha: 0.18)
                          : Colors.amber.shade700.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      fare.isOfficial ? 'Official' : 'Estimated',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: fare.isOfficial
                            ? theme.colorScheme.primary
                            : Colors.amber.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BusCard extends StatelessWidget {
  final BusMatch match;
  final bool isCheapest;
  final int diffFromCheapest;
  final VoidCallback onTap;
  final VoidCallback onMap;
  final ThemeData theme;

  const _BusCard({
    required this.match,
    required this.isCheapest,
    required this.diffFromCheapest,
    required this.onTap,
    required this.onMap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          match.route.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          match.route.nameBn,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _ServiceBadge(serviceType: match.route.serviceType),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 6,
                children: [
                  _MetaItem(
                    icon: Icons.access_time,
                    label:
                        '${match.route.startTime} – ${match.route.endTime}',
                  ),
                  _MetaItem(
                    icon: Icons.alt_route,
                    label: '${match.stopsBetween} stops',
                  ),
                  _MetaItem(
                    icon: Icons.payments_outlined,
                    label: '৳${match.fare.amount}',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _FareSourcePill(source: match.fare.source),
                  const SizedBox(width: 8),
                  if (isCheapest)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded,
                              size: 14, color: Colors.white),
                          SizedBox(width: 3),
                          Text(
                            'Cheapest',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (diffFromCheapest > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade700.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '+৳$diffFromCheapest vs cheapest',
                        style: TextStyle(
                          color: Colors.amber.shade900,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${match.fromStop}  →  ${match.toStop}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: onMap,
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: const Text('View Map'),
                  ),
                  TextButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.list_alt, size: 18),
                    label: const Text('Stops'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouteHeader extends StatelessWidget {
  final String from;
  final String to;
  const _RouteHeader({required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      color: theme.colorScheme.primaryContainer,
      child: Row(
        children: [
          const Icon(Icons.trip_origin),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              from,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.arrow_forward_rounded),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              to,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.location_on),
        ],
      ),
    );
  }
}

class _FareCard extends StatelessWidget {
  final FareResult? fare;
  final bool hasResults;
  const _FareCard({required this.fare, required this.hasResults});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final f = fare;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              f?.isOfficial == true
                  ? Icons.verified_rounded
                  : Icons.confirmation_number_outlined,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        !hasResults
                            ? 'Fare unavailable'
                            : f?.isOfficial == true
                                ? 'Official Fare'
                                : 'Estimated Fare',
                        style: theme.textTheme.labelLarge,
                      ),
                      const SizedBox(width: 4),
                      const FareInfoIcon(size: 14),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    f != null
                        ? '৳${f.amount}'
                        : 'No buses connect these stops',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  if (f != null)
                    Text(
                      '${f.distanceKm.toStringAsFixed(1)} km · 2.53 BDT/km · min ৳10',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            if (f != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: f.isOfficial
                      ? theme.colorScheme.primary
                      : Colors.amber.shade700,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  f.isOfficial ? 'PDF' : 'Approx',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FareSourcePill extends StatelessWidget {
  final FareSource source;
  const _FareSourcePill({required this.source});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOfficial = source == FareSource.official;
    final color = isOfficial ? theme.colorScheme.primary : Colors.amber.shade700;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOfficial ? Icons.verified_rounded : Icons.calculate_outlined,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            isOfficial ? 'Official Fare' : 'Estimated',
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceBadge extends StatelessWidget {
  final String serviceType;
  const _ServiceBadge({required this.serviceType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSeating = serviceType.toLowerCase() == 'seating';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSeating
            ? theme.colorScheme.primary
            : theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        serviceType,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
