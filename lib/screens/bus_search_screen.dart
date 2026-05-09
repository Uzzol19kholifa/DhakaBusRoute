import 'package:flutter/material.dart';

import '../data/bus_data.dart';
import '../models/bus_route.dart';
import '../services/fare_service.dart';

/// Search by bus / operator name and view that bus's full route.
///
/// Tapping a result opens [_BusRouteScreen] which shows the ordered list
/// of stops with the start and end highlighted, plus per-stop cumulative
/// fare from the origin (Official when the corresponding pair is on a PDF
/// corridor, Estimated otherwise).
class BusSearchScreen extends StatefulWidget {
  const BusSearchScreen({super.key});

  @override
  State<BusSearchScreen> createState() => _BusSearchScreenState();
}

class _BusSearchScreenState extends State<BusSearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List<BusRoute> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return allRoutes;
    return allRoutes.where((r) {
      return r.name.toLowerCase().contains(q) ||
          r.nameBn.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filtered;
    return Scaffold(
      appBar: AppBar(title: const Text('Search by Bus Name')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _ctrl,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Type a bus or operator name…',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _ctrl.clear();
                            setState(() => _query = '');
                          },
                        ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${filtered.length} of ${allRoutes.length} buses',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No buses match "$_query".',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : ListView.separated(
                      padding:
                          const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 8),
                      itemBuilder: (_, i) =>
                          _BusTile(route: filtered[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BusTile extends StatelessWidget {
  final BusRoute route;
  const _BusTile({required this.route});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              theme.colorScheme.primary.withValues(alpha: 0.15),
          child: Icon(Icons.directions_bus,
              color: theme.colorScheme.primary, size: 18),
        ),
        title: Text(
          route.name,
          style: theme.textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '${route.nameBn} · ${route.stops.length} stops',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => _BusRouteScreen(route: route),
          ),
        ),
      ),
    );
  }
}

class _BusRouteScreen extends StatelessWidget {
  final BusRoute route;
  const _BusRouteScreen({required this.route});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(route.name)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(route.nameBn,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(
                    '${route.stops.first}  →  ${route.stops.last}',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${route.stops.length} stops · '
                    '${route.startTime} – ${route.endTime} · '
                    '${route.serviceType}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Stops & fare from origin',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...List.generate(route.stops.length, (i) {
              final stop = route.stops[i];
              final isFirst = i == 0;
              final isLast = i == route.stops.length - 1;
              FareResult? fare;
              if (!isFirst) {
                fare = FareService.compute(route, 0, i);
              }
              return _StopRow(
                index: i,
                stop: stop,
                isFirst: isFirst,
                isLast: isLast,
                fare: fare,
              );
            }),
          ],
        ),
      ),
    );
  }

}

class _StopRow extends StatelessWidget {
  final int index;
  final String stop;
  final bool isFirst;
  final bool isLast;
  final FareResult? fare;

  const _StopRow({
    required this.index,
    required this.stop,
    required this.isFirst,
    required this.isLast,
    required this.fare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color dotColor;
    if (isFirst || isLast) {
      dotColor = theme.colorScheme.primary;
    } else {
      dotColor = theme.colorScheme.outline;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: (isFirst || isLast)
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
                if (isFirst)
                  Text('Start',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      )),
                if (isLast)
                  Text('End',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      )),
              ],
            ),
          ),
          if (fare != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('৳${fare!.amount}',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
                Text(
                  fare!.isOfficial ? 'Official' : 'Estimated',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: fare!.isOfficial
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
