import '../data/fare_data.dart';
import '../data/pdf_corridors.dart';
import '../models/bus_route.dart';

/// Provenance of a computed fare. Drives the "Official Fare" / "Estimated"
/// labels in the UI.
enum FareSource {
  /// Fare was looked up directly from a corridor in the official PDF
  /// (`pdf_corridors.dart`). Treat this as ground truth.
  official,

  /// Fare was computed from the curated adjacent-stop distance fallback.
  /// Still uses the official `2.53 BDT/km` rate but the underlying distance
  /// is an approximation, not from the PDF.
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

  /// PDF corridor code used (e.g. `A-362`). Only set for `official` fares.
  final String? corridorCode;

  /// Human-readable corridor label (e.g. `Dhour → Madanpur`). Only set for
  /// `official` fares.
  final String? corridorLabel;

  const FareResult({
    required this.amount,
    required this.distanceKm,
    required this.source,
    this.corridorCode,
    this.corridorLabel,
  });

  bool get isOfficial => source == FareSource.official;
}

/// Computes fares for a (route, fromIndex, toIndex) triple.
///
/// Resolution order:
/// 1. Look up the (fromStop, toStop) pair across **every PDF corridor**.
///    If any corridor visits both stops we read the cumulative km from the
///    PDF directly and label the result **Official Fare**.
/// 2. Fall back to the curated adjacent-leg distances in `fare_data.dart`
///    and label the result **Estimated Fare**.
class FareService {
  /// Compute the fare for travelling between `route.stops[fromIdx]` and
  /// `route.stops[toIdx]`.
  static FareResult compute(BusRoute route, int fromIdx, int toIdx) {
    final fromStop = route.stops[fromIdx];
    final toStop = route.stops[toIdx];

    final official = lookupOfficial(fromStop, toStop);
    if (official != null) return official;

    final distance = _sumAdjacentLegs(route, fromIdx, toIdx);
    return FareResult(
      amount: fareFromKm(distance),
      distanceKm: distance,
      source: FareSource.estimated,
    );
  }

  /// Search every PDF corridor for one that visits both [fromStop] and
  /// [toStop]. Returns the official fare from the corridor with the
  /// **shortest** distance between them (in case multiple corridors qualify
  /// — different bus operators traverse different physical paths between
  /// the same pair of points).
  static FareResult? lookupOfficial(String fromStop, String toStop) {
    FareResult? best;
    for (final corridor in pdfCorridors) {
      final f = corridor.findStop(fromStop);
      final t = corridor.findStop(toStop);
      if (f == null || t == null || identical(f, t)) continue;
      final km = (f.km - t.km).abs();
      if (km <= 0) continue;
      if (best == null || km < best.distanceKm) {
        best = FareResult(
          amount: fareFromKm(km),
          distanceKm: km,
          source: FareSource.official,
          corridorCode: corridor.code,
          corridorLabel: corridor.label,
        );
      }
    }
    return best;
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
