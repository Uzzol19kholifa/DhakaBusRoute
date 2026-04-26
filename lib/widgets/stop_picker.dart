import 'package:flutter/material.dart';

/// Tappable field that opens a full-screen searchable list of stop names.
class StopPicker extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? value;
  final List<String> stops;
  final ValueChanged<String> onSelected;

  const StopPicker({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.stops,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = value != null && value!.isNotEmpty;
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          final picked = await showSearch<String?>(
            context: context,
            delegate: _StopSearchDelegate(stops: stops),
          );
          if (picked != null && picked.isNotEmpty) {
            onSelected(picked);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasValue ? value! : 'Tap to search a stop',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: hasValue
                            ? theme.colorScheme.onSurface
                            : theme.hintColor,
                        fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _StopSearchDelegate extends SearchDelegate<String?> {
  final List<String> stops;
  _StopSearchDelegate({required this.stops})
      : super(searchFieldLabel: 'Search stops…');

  List<String> _filtered() {
    if (query.isEmpty) return stops;
    final q = query.toLowerCase();
    return stops.where((s) => s.toLowerCase().contains(q)).toList();
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => query = '',
          ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final results = _filtered();
    if (results.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('No matching stops.'),
        ),
      );
    }
    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final stop = results[i];
        return ListTile(
          leading: const Icon(Icons.location_on_outlined),
          title: Text(stop),
          onTap: () => close(context, stop),
        );
      },
    );
  }
}
