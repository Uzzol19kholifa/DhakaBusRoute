import 'package:flutter/material.dart';

import '../services/bus_service.dart';
import 'detail_screen.dart';
import 'map_screen.dart';

class ResultsScreen extends StatelessWidget {
  final String from;
  final String to;

  const ResultsScreen({super.key, required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final matches = BusService.findBuses(from, to);
    final headlineFare = BusService.headlineFare(matches);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _RouteHeader(from: from, to: to),
            _FareCard(fare: headlineFare, hasResults: matches.isNotEmpty),
            const SizedBox(height: 4),
            Expanded(
              child: matches.isEmpty
                  ? const _EmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: matches.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final m = matches[i];
                        final isCheapest =
                            hasMultiplePrices && m.fare.amount == cheapest;
                        final diff = (cheapest == null)
                            ? 0
                            : m.fare.amount - cheapest;
                        return _BusCard(
                          match: m,
                          isCheapest: isCheapest,
                          diffFromCheapest: diff,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(match: m),
                              ),
                            );
                          },
                          onMap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MapScreen(match: m),
                              ),
                            );
                          },
                          theme: theme,
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
                  Text(
                    !hasResults
                        ? 'Fare unavailable'
                        : f?.isOfficial == true
                            ? 'Official Fare'
                            : 'Estimated Fare',
                    style: theme.textTheme.labelLarge,
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_bus_filled_outlined,
              size: 56, color: theme.colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            'No direct buses found',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Try a nearby landmark or check the spelling of the stop name.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
