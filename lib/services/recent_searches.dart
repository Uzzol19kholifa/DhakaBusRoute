import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's most recent From→To searches in SharedPreferences.
class RecentSearches {
  static const _key = 'recent_searches_v1';
  static const int _maxEntries = 5;
  static const _separator = '||';

  /// Load the most recent searches, newest first.
  static Future<List<RecentSearch>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? const [];
    return list
        .map((s) {
          final parts = s.split(_separator);
          if (parts.length != 2) return null;
          return RecentSearch(from: parts[0], to: parts[1]);
        })
        .whereType<RecentSearch>()
        .toList(growable: false);
  }

  /// Insert (or move-to-front) a search; oldest entries are evicted.
  static Future<void> add(String from, String to) async {
    if (from.isEmpty || to.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? <String>[];
    final encoded = '$from$_separator$to';
    existing
      ..removeWhere((e) => e == encoded)
      ..insert(0, encoded);
    if (existing.length > _maxEntries) {
      existing.removeRange(_maxEntries, existing.length);
    }
    await prefs.setStringList(_key, existing);
  }

  /// Clear all stored searches.
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

class RecentSearch {
  final String from;
  final String to;
  const RecentSearch({required this.from, required this.to});
}
