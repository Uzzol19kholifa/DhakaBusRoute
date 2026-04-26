import 'package:flutter/material.dart';

import '../services/bus_service.dart';
import '../services/fare_disclaimer.dart';
import '../services/recent_searches.dart';
import '../widgets/stop_picker.dart';
import 'bus_search_screen.dart';
import 'fare_chart_screen.dart';
import 'results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _from;
  String? _to;
  late final List<String> _stops;
  List<RecentSearch> _recents = const [];

  @override
  void initState() {
    super.initState();
    _stops = BusService.allStops();
    _loadRecents();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      FareDisclaimer.showOnFirstLaunchIfNeeded(context);
    });
  }

  Future<void> _loadRecents() async {
    final r = await RecentSearches.load();
    if (!mounted) return;
    setState(() => _recents = r);
  }

  void _swap() {
    setState(() {
      final tmp = _from;
      _from = _to;
      _to = tmp;
    });
  }

  Future<void> _search() async {
    final from = _from;
    final to = _to;
    if (from == null || to == null || from == to) return;
    await RecentSearches.add(from, to);
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResultsScreen(from: from, to: to),
      ),
    );
    _loadRecents();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canSearch =
        _from != null && _to != null && _from!.isNotEmpty && _to!.isNotEmpty && _from != _to;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dhaka Bus Finder 🚌'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroBanner(),
              const SizedBox(height: 20),
              StopPicker(
                label: 'From',
                icon: Icons.my_location,
                value: _from,
                stops: _stops,
                onSelected: (v) => setState(() => _from = v),
              ),
              const SizedBox(height: 8),
              Center(
                child: IconButton.filledTonal(
                  onPressed: _swap,
                  icon: const Icon(Icons.swap_vert_rounded),
                  tooltip: 'Swap stops',
                ),
              ),
              const SizedBox(height: 8),
              StopPicker(
                label: 'To',
                icon: Icons.location_on,
                value: _to,
                stops: _stops,
                onSelected: (v) => setState(() => _to = v),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: canSearch ? _search : null,
                icon: const Icon(Icons.search),
                label: const Text('Find Buses'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 16),
              _DisclaimerBanner(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _MenuTile(
                      icon: Icons.list_alt_rounded,
                      label: 'Full Fare Chart',
                      sublabel: 'Browse all PDF corridors',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const FareChartScreen(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MenuTile(
                      icon: Icons.directions_bus_rounded,
                      label: 'Search by Bus',
                      sublabel: 'Find a bus by name',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const BusSearchScreen(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_recents.isNotEmpty) ...[
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent searches',
                      style: theme.textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: () async {
                        await RecentSearches.clear();
                        _loadRecents();
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ..._recents.map(
                  (r) => Card(
                    elevation: 0,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: ListTile(
                      leading: const Icon(Icons.history),
                      title: Text('${r.from}  →  ${r.to}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        setState(() {
                          _from = r.from;
                          _to = r.to;
                        });
                        _search();
                      },
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(label,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(sublabel,
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

class _DisclaimerBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.amber.shade50,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => FareDisclaimer.showDisclaimer(context),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: Colors.amber.shade800, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'ভাড়া কিলোমিটার অনুযায়ী হিসাব — BRTA ভাড়ার সঙ্গে '
                  'কিছু পার্থক্য থাকতে পারে। বিস্তারিত দেখতে ট্যাপ করুন।',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.amber.shade900, height: 1.3),
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded,
                  color: Colors.amber.shade800, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.directions_bus_rounded,
              color: Colors.white, size: 40),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find your bus',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pick your start and destination — we\'ll show every bus and the official fare.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white.withValues(alpha: 0.92)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
