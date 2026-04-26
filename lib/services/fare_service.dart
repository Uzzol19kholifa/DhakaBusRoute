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
/// 1. **Route-specific PDF distance**. If the requested route's name appears
///    in [routeCumulativeKm] *and* its cumulative-km list is parallel to
///    `route.stops`, we use the route's own PDF page directly — this is
///    the most accurate path, because two operators traveling between the
///    same two endpoints can take physically different roads with different
///    distances.
/// 2. **Cross-corridor PDF lookup**. Search every transcribed PDF corridor
///    for one that visits both stops and pick the median distance.
/// 3. **Adjacent-leg estimate**. Fall back to the curated `adjacentStopKm`
///    table and label the result **Estimated Fare**.
class FareService {
  /// Compute the fare for travelling between `route.stops[fromIdx]` and
  /// `route.stops[toIdx]`.
  static FareResult compute(BusRoute route, int fromIdx, int toIdx) {
    final fromStop = route.stops[fromIdx];
    final toStop = route.stops[toIdx];

    // (1) Route-specific PDF distance if available. The list in
    // `routeCumulativeKm` is parallel to `BusRoute.stops` for that route, so
    // we can read the cumulative km at each end and subtract.
    final cumKm = routeCumulativeKm[route.name];
    if (cumKm != null && cumKm.length == route.stops.length) {
      final lo = fromIdx < toIdx ? fromIdx : toIdx;
      final hi = fromIdx < toIdx ? toIdx : fromIdx;
      final km = (cumKm[hi] - cumKm[lo]).abs();
      if (km > 0) {
        return FareResult(
          amount: fareFromKm(km),
          distanceKm: km,
          source: FareSource.official,
          corridorLabel: '${route.name} (PDF)',
        );
      }
    }

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
  /// [toStop] and pick a representative distance.
  ///
  /// Different bus operators traverse different physical paths between the
  /// same pair of points so multiple corridors can qualify. We collect every
  /// candidate distance and pick the **median** rather than the minimum:
  /// using the minimum would let a single transcription error in any one
  /// corridor (e.g. A-426's anomalous 4 km Gabtoli↔Savar leg) override the
  /// correct values from all the other corridors. The median is robust to a
  /// single such outlier.
  static FareResult? lookupOfficial(String fromStop, String toStop) {
    final candidates = <_OfficialCandidate>[];
    for (final corridor in pdfCorridors) {
      final f = corridor.findStop(fromStop);
      final t = corridor.findStop(toStop);
      if (f == null || t == null || identical(f, t)) continue;
      final km = (f.km - t.km).abs();
      if (km <= 0) continue;
      candidates.add(_OfficialCandidate(corridor: corridor, km: km));
    }
    if (candidates.isEmpty) return null;

    candidates.sort((a, b) => a.km.compareTo(b.km));
    final pick = candidates[candidates.length ~/ 2];
    return FareResult(
      amount: fareFromKm(pick.km),
      distanceKm: pick.km,
      source: FareSource.official,
      corridorCode: pick.corridor.code,
      corridorLabel: pick.corridor.label,
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

class _OfficialCandidate {
  final PdfCorridor corridor;
  final double km;
  _OfficialCandidate({required this.corridor, required this.km});
}
