import '../data/fare_data.dart';
import '../models/bus_route.dart';

/// Provenance of a computed fare. Drives the "Official Fare" / "Estimated"
/// labels in the UI.
enum FareSource {
  /// Fare was computed from PDF-published cumulative distances using the
  /// official `2.53 BDT/km` formula. Treat this as ground truth.
  official,

  /// Fare was computed from the curated adjacent-stop distance fallback.
  /// Still uses the official per-km rate but the underlying distance is an
  /// approximation.
  estimated,
}

class FareResult {
  /// Fare amount in BDT, already floored at the official `kMinimumFare`.
  final int amount;

  /// Distance (km) used to compute the fare.
  final double distanceKm;

  /// Whether the underlying distance came from the PDF (`official`) or from
  /// the fallback approximation (`estimated`).
  final FareSource source;

  const FareResult({
    required this.amount,
    required this.distanceKm,
    required this.source,
  });

  bool get isOfficial => source == FareSource.official;
}

/// Computes fares for a (route, fromIndex, toIndex) triple.
class FareService {
  /// Compute the fare for travelling between `route.stops[fromIdx]` and
  /// `route.stops[toIdx]`.
  static FareResult compute(BusRoute route, int fromIdx, int toIdx) {
    final cumKm = routeCumulativeKm[route.name];

    if (cumKm != null && cumKm.length == route.stops.length) {
      final distance = (cumKm[toIdx] - cumKm[fromIdx]).abs();
      return FareResult(
        amount: fareFromKm(distance),
        distanceKm: distance,
        source: FareSource.official,
      );
    }

    final distance = _sumAdjacentLegs(route, fromIdx, toIdx);
    return FareResult(
      amount: fareFromKm(distance),
      distanceKm: distance,
      source: FareSource.estimated,
    );
  }

  /// Sum approximate per-leg distances between stops `fromIdx` and `toIdx`,
  /// using [adjacentStopKm] (bidirectional) and falling back to a generic
  /// 1 km default for legs we don't have data for.
  static double _sumAdjacentLegs(BusRoute route, int fromIdx, int toIdx) {
    final lo = fromIdx < toIdx ? fromIdx : toIdx;
    final hi = fromIdx < toIdx ? toIdx : fromIdx;
    double total = 0;
    for (int i = lo; i < hi; i++) {
      total += _legDistance(route.stops[i], route.stops[i + 1]);
    }
    return total;
  }

  static double _legDistance(String a, String b) {
    return adjacentStopKm['$a|$b'] ??
        adjacentStopKm['$b|$a'] ??
        // Generic Dhaka neighbourhood-stop spacing fallback
        1.0;
  }
}
