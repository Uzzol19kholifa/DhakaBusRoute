import 'package:flutter/material.dart';

import '../data/fare_data.dart' show fareFromKm;
import '../data/pdf_corridors.dart';

/// Browse the official PDF fare chart corridor by corridor.
///
/// Top of the screen has a search box that filters the corridor list by
/// corridor code, label, or any stop name on the corridor. Tapping a corridor
/// opens [_CorridorDetailScreen] which shows the full stop-to-stop fare matrix
/// (every cell from the PDF page).
class FareChartScreen extends StatefulWidget {
  const FareChartScreen({super.key});

  @override
  State<FareChartScreen> createState() => _FareChartScreenState();
}

class _FareChartScreenState extends State<FareChartScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<PdfCorridor> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return pdfCorridors;
    return pdfCorridors.where((c) {
      if (c.code.toLowerCase().contains(q)) return true;
      if (c.label.toLowerCase().contains(q)) return true;
      for (final s in c.stops) {
        if (s.name.toLowerCase().contains(q)) return true;
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Fare Chart'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search by stop or route…',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchCtrl.clear();
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
                  '${filtered.length} of ${pdfCorridors.length} corridors',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No matching corridors.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : ListView.separated(
                      padding:
                          const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final c = filtered[i];
                        return _CorridorTile(corridor: c);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CorridorTile extends StatelessWidget {
  final PdfCorridor corridor;
  const _CorridorTile({required this.corridor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
          child: Text(
            corridor.code.replaceAll('A-', ''),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        title: Text(
          corridor.label,
          style: theme.textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${corridor.code} · ${corridor.stops.length} stops · '
          '${corridor.totalKm.toStringAsFixed(1)} km',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => _CorridorDetailScreen(corridor: corridor),
          ),
        ),
      ),
    );
  }
}

class _CorridorDetailScreen extends StatefulWidget {
  final PdfCorridor corridor;
  const _CorridorDetailScreen({required this.corridor});

  @override
  State<_CorridorDetailScreen> createState() =>
      _CorridorDetailScreenState();
}

class _CorridorDetailScreenState extends State<_CorridorDetailScreen> {
  PdfStop? _from;
  PdfStop? _to;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = widget.corridor;

    final fromTo = (_from != null && _to != null && _from != _to)
        ? _ComputedFare(
            from: _from!,
            to: _to!,
            km: (_from!.km - _to!.km).abs(),
          )
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(c.code),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Text(c.label,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(
              'Total ${c.totalKm.toStringAsFixed(1)} km · '
              '${c.stops.length} stops · 2.53 BDT/km · min ৳10',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            // Stop-to-stop picker.
            _StopPicker(
              label: 'From',
              icon: Icons.my_location,
              stops: c.stops,
              value: _from,
              onChanged: (v) => setState(() => _from = v),
            ),
            const SizedBox(height: 8),
            _StopPicker(
              label: 'To',
              icon: Icons.location_on,
              stops: c.stops,
              value: _to,
              onChanged: (v) => setState(() => _to = v),
            ),
            const SizedBox(height: 12),
            if (fromTo != null) _FareResultCard(result: fromTo),
            const SizedBox(height: 24),
            Text('All stops',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...List.generate(c.stops.length, (i) {
              final s = c.stops[i];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                visualDensity:
                    const VisualDensity(vertical: -3, horizontal: -2),
                leading: CircleAvatar(
                  radius: 14,
                  backgroundColor:
                      theme.colorScheme.primary.withValues(alpha: 0.12),
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary),
                  ),
                ),
                title: Text(s.name),
                trailing: Text(
                  '${s.km.toStringAsFixed(1)} km',
                  style: theme.textTheme.bodySmall,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ComputedFare {
  final PdfStop from;
  final PdfStop to;
  final double km;
  const _ComputedFare({
    required this.from,
    required this.to,
    required this.km,
  });
  int get fare => fareFromKm(km);
}

class _FareResultCard extends StatelessWidget {
  final _ComputedFare result;
  const _FareResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'OFFICIAL FARE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '৳${result.fare}',
            style: theme.textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            '${result.from.name}  →  ${result.to.name}',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            '${result.km.toStringAsFixed(1)} km × 2.53 BDT/km '
            '(rounded, min ৳10)',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _StopPicker extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<PdfStop> stops;
  final PdfStop? value;
  final ValueChanged<PdfStop?> onChanged;

  const _StopPicker({
    required this.label,
    required this.icon,
    required this.stops,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<PdfStop>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: stops
          .map(
            (s) => DropdownMenuItem(
              value: s,
              child: Text(
                '${s.name}  (${s.km.toStringAsFixed(1)} km)',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
