import '../data/bus_data.dart';
import '../models/bus_route.dart';
import 'fare_service.dart';
import 'stop_matching.dart';

/// One leg of a transfer suggestion: ride [route] from [fromStop] to [toStop].
class TransferLeg {
  final BusRoute route;
  final int fromIndex;
  final int toIndex;
  final String fromStop;
  final String toStop;
  final FareResult fare;

  const TransferLeg({
    required this.route,
    required this.fromIndex,
    required this.toIndex,
    required this.fromStop,
    required this.toStop,
    required this.fare,
  });

  int get stopsBetween => (toIndex - fromIndex).abs() + 1;
}

/// A suggested 1-transfer journey: ride [first], transfer at [transferStop],
/// ride [second].
class TransferSuggestion {
  final TransferLeg first;
  final TransferLeg second;
  final String transferStop;

  const TransferSuggestion({
    required this.first,
    required this.second,
    required this.transferStop,
  });

  /// Total estimated fare for both legs.
  int get totalFare => first.fare.amount + second.fare.amount;

  /// Total stops travelled across both legs (counting the transfer stop once).
  int get totalStops => first.stopsBetween + second.stopsBetween - 1;

  /// Total distance (km) across both legs.
  double get totalKm => first.fare.distanceKm + second.fare.distanceKm;

  /// Whether either leg fell back to an estimated fare.
  bool get hasEstimated =>
      !first.fare.isOfficial || !second.fare.isOfficial;
}

/// Find one-transfer journeys from [from] to [to].
class TransferService {
  /// Find up to [limit] best 1-transfer suggestions from [from] to [to],
  /// sorted by total fare (cheapest first), then by total stops, then by
  /// total km. Returns an empty list if no viable transfers exist.
  ///
  /// We only build suggestions for transfer stops that **don't** already
  /// have a direct bus (otherwise we'd just recommend the direct route).
  static List<TransferSuggestion> findSuggestions(
    String from,
    String to, {
    int limit = 5,
  }) {
    // Buses that visit `from` (without visiting `to` on the same route).
    final firstLegs = <TransferLeg>[];
    // Buses that visit `to` (without visiting `from` on the same route).
    final secondLegs = <TransferLeg>[];

    for (final route in allRoutes) {
      final fIdx = _findStopIndex(route.stops, from);
      final tIdx = _findStopIndex(route.stops, to);

      if (fIdx != -1 && tIdx == -1) {
        // Candidate first leg: ride this from `from` to each downstream stop.
        for (int i = 0; i < route.stops.length; i++) {
          if (i == fIdx) continue;
          // Skip if this candidate transfer stop matches `to` exactly
          // (shouldn't happen because tIdx == -1, but defensive).
          if (_equivalent(route.stops[i], to)) continue;
          final fare = FareService.compute(route, fIdx, i);
          firstLegs.add(TransferLeg(
            route: route,
            fromIndex: fIdx,
            toIndex: i,
            fromStop: route.stops[fIdx],
            toStop: route.stops[i],
            fare: fare,
          ));
        }
      }

      if (tIdx != -1 && fIdx == -1) {
        // Candidate second leg: ride this from each upstream stop to `to`.
        for (int i = 0; i < route.stops.length; i++) {
          if (i == tIdx) continue;
          if (_equivalent(route.stops[i], from)) continue;
          final fare = FareService.compute(route, i, tIdx);
          secondLegs.add(TransferLeg(
            route: route,
            fromIndex: i,
            toIndex: tIdx,
            fromStop: route.stops[i],
            toStop: route.stops[tIdx],
            fare: fare,
          ));
        }
      }
    }

    // Pair first/second legs by transfer stop (canonical match).
    final suggestions = <TransferSuggestion>[];
    final seen = <String>{};
    for (final a in firstLegs) {
      for (final b in secondLegs) {
        if (a.route.name == b.route.name) continue;
        if (!_equivalent(a.toStop, b.fromStop)) continue;
        // De-dupe on (routeA, routeB, transferStop).
        final key = '${a.route.name}|${b.route.name}|${a.toStop.toLowerCase()}';
        if (!seen.add(key)) continue;
        suggestions.add(TransferSuggestion(
          first: a,
          second: b,
          transferStop: a.toStop,
        ));
      }
    }

    suggestions.sort((x, y) {
      final fare = x.totalFare.compareTo(y.totalFare);
      if (fare != 0) return fare;
      final stops = x.totalStops.compareTo(y.totalStops);
      if (stops != 0) return stops;
      return x.totalKm.compareTo(y.totalKm);
    });

    return suggestions.take(limit).toList();
  }

  static bool _equivalent(String a, String b) => stopNameMatches(a, b);

  static int _findStopIndex(List<String> stops, String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return -1;
    for (int i = 0; i < stops.length; i++) {
      if (stops[i].toLowerCase() == q) return i;
    }
    for (int i = 0; i < stops.length; i++) {
      if (stopNameMatches(stops[i], query)) return i;
    }
    return -1;
  }
}
