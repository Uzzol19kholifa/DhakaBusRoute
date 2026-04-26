import '../data/bus_data.dart';
import '../models/bus_route.dart';
import 'fare_service.dart';
import 'stop_matching.dart';

export 'fare_service.dart' show FareResult, FareSource;

/// Result of a route lookup for a single bus.
class BusMatch {
  final BusRoute route;

  /// Index of the matched "from" stop within `route.stops` (after fuzzy match).
  final int fromIndex;

  /// Index of the matched "to" stop within `route.stops`.
  final int toIndex;

  /// Resolved canonical "from" stop name (the actual entry in `route.stops`).
  final String fromStop;

  /// Resolved canonical "to" stop name.
  final String toStop;

  /// Computed fare for this match (Official or Estimated).
  final FareResult fare;

  const BusMatch({
    required this.route,
    required this.fromIndex,
    required this.toIndex,
    required this.fromStop,
    required this.toStop,
    required this.fare,
  });

  /// Number of stops travelled (inclusive of from & to).
  int get stopsBetween => (toIndex - fromIndex).abs() + 1;

  /// Whether the bus is travelling in its natural (forward) direction.
  bool get forward => toIndex >= fromIndex;
}

/// Pure-Dart service that exposes search & fare lookups over the bundled data.
class BusService {
  /// Return the alphabetically sorted, de-duplicated list of every stop name
  /// that appears in any route in [allRoutes].
  static List<String> allStops() {
    final set = <String>{};
    for (final route in allRoutes) {
      set.addAll(route.stops);
    }
    final list = set.toList()..sort();
    return list;
  }

  static bool _stopMatches(String stop, String query) =>
      stopNameMatches(stop, query);

  /// Two-pass lookup: prefer an exact (case-insensitive) match before falling
  /// back to fuzzy matching. Required so picking "Badda" on a route that
  /// contains both "Uttar Badda" and "Badda" returns the literal "Badda"
  /// stop, not the substring-matching "Uttar Badda".
  static int _findStopIndex(List<String> stops, String query) {
    final qLower = query.trim().toLowerCase();
    for (int i = 0; i < stops.length; i++) {
      if (stops[i].toLowerCase() == qLower) return i;
    }
    for (int i = 0; i < stops.length; i++) {
      if (_stopMatches(stops[i], query)) return i;
    }
    return -1;
  }

  /// Find every route that connects [from] and [to] (bidirectional). Each
  /// match carries its computed fare and matched canonical stop names.
  static List<BusMatch> findBuses(String from, String to) {
    final matches = <BusMatch>[];
    for (final route in allRoutes) {
      final fromIdx = _findStopIndex(route.stops, from);
      final toIdx = _findStopIndex(route.stops, to);
      if (fromIdx == -1 || toIdx == -1 || fromIdx == toIdx) continue;
      final fare = FareService.compute(route, fromIdx, toIdx);
      matches.add(
        BusMatch(
          route: route,
          fromIndex: fromIdx,
          toIndex: toIdx,
          fromStop: route.stops[fromIdx],
          toStop: route.stops[toIdx],
          fare: fare,
        ),
      );
    }
    matches.sort((a, b) => a.fare.amount.compareTo(b.fare.amount));
    return matches;
  }

  /// Headline fare across all matching buses (the cheapest available fare).
  static FareResult? headlineFare(List<BusMatch> matches) {
    if (matches.isEmpty) return null;
    return matches
        .map((m) => m.fare)
        .reduce((a, b) => a.amount <= b.amount ? a : b);
  }
}
