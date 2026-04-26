import '../data/bus_data.dart';
import '../data/fare_data.dart';
import '../models/bus_route.dart';

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

  const BusMatch({
    required this.route,
    required this.fromIndex,
    required this.toIndex,
    required this.fromStop,
    required this.toStop,
  });

  /// Number of stops travelled (inclusive of from & to).
  int get stopsBetween => (toIndex - fromIndex).abs() + 1;

  /// Whether the bus is travelling in its natural (forward) direction.
  bool get forward => toIndex >= fromIndex;
}

/// Pure-Dart service that exposes search & fare lookups over the bundled data.
///
/// Holds no state; all methods are static so screens can call them directly.
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

  /// Fuzzy match on stop names — case-insensitive substring match in either
  /// direction so `Jashimuddin` matches `Jashimuddin (Uttara)` and vice versa.
  static bool _stopMatches(String stop, String query) {
    final s = stop.toLowerCase();
    final q = query.toLowerCase();
    return s.contains(q) || q.contains(s);
  }

  /// Find the first index in `stops` whose name fuzzy-matches `query`. Returns
  /// `-1` when no match is found.
  static int _findStopIndex(List<String> stops, String query) {
    for (int i = 0; i < stops.length; i++) {
      if (_stopMatches(stops[i], query)) return i;
    }
    return -1;
  }

  /// Return every route that connects [from] and [to], regardless of
  /// direction. Each [BusMatch] also exposes the matched canonical stop names
  /// and traversal direction.
  static List<BusMatch> findBuses(String from, String to) {
    final matches = <BusMatch>[];
    for (final route in allRoutes) {
      final fromIdx = _findStopIndex(route.stops, from);
      final toIdx = _findStopIndex(route.stops, to);
      if (fromIdx == -1 || toIdx == -1 || fromIdx == toIdx) continue;
      matches.add(
        BusMatch(
          route: route,
          fromIndex: fromIdx,
          toIndex: toIdx,
          fromStop: route.stops[fromIdx],
          toStop: route.stops[toIdx],
        ),
      );
    }
    return matches;
  }

  /// Try to look up an explicit fare from the official chart.
  static int? lookupFare(String from, String to) {
    return fareChart['$from|$to'] ?? fareChart['$to|$from'];
  }

  /// Estimate the distance between two adjacent stops along a route using
  /// [stopDistanceKm]. Falls back to a default of 1.0 km for unknown legs.
  static double _legDistance(String a, String b) {
    return stopDistanceKm['$a|$b'] ?? stopDistanceKm['$b|$a'] ?? 1.0;
  }

  /// Estimate the total distance between two stops along a specific route by
  /// summing per-leg distances along the route's stop list.
  static double estimateDistanceAlongRoute(
    BusRoute route,
    int fromIdx,
    int toIdx,
  ) {
    final lo = fromIdx < toIdx ? fromIdx : toIdx;
    final hi = fromIdx < toIdx ? toIdx : fromIdx;
    double total = 0;
    for (int i = lo; i < hi; i++) {
      total += _legDistance(route.stops[i], route.stops[i + 1]);
    }
    return total;
  }

  /// Compute the fare for a (from, to) pair on a specific route.
  ///
  /// Resolution order:
  /// 1. Exact stop-pair entry in [fareChart].
  /// 2. Per-km estimate from accumulated [stopDistanceKm] legs.
  /// 3. The minimum fare floor.
  static int fareFor(BusMatch match) {
    final explicit = lookupFare(match.fromStop, match.toStop);
    if (explicit != null) return explicit;
    final dist = estimateDistanceAlongRoute(
      match.route,
      match.fromIndex,
      match.toIndex,
    );
    final calc = (dist * kFarePerKm).round();
    return calc < kMinimumFare ? kMinimumFare : calc;
  }

  /// Headline fare across all matching buses — the minimum fare available is
  /// shown to the user as the estimated fare for the trip.
  static int? headlineFare(List<BusMatch> matches) {
    if (matches.isEmpty) return null;
    return matches.map(fareFor).reduce((a, b) => a < b ? a : b);
  }
}
