/// Models describing a Dhaka city bus route and a single fare entry.
///
/// All instances are intentionally `const`-constructible so that the bundled
/// route/fare datasets in `lib/data/` can live as compile-time constants.
class BusRoute {
  /// English name of the operator (e.g. "Achim Paribahan").
  final String name;

  /// Bangla name of the operator (e.g. "আছিম পরিবহন").
  final String nameBn;

  /// Ordered list of stop names along the route. Order matters — index `0`
  /// is the origin terminus and the last element is the destination terminus.
  /// Buses are treated as bidirectional in the search logic.
  final List<String> stops;

  /// Operating start time in `hh:mm AM/PM` format.
  final String startTime;

  /// Operating end time in `hh:mm AM/PM` format.
  final String endTime;

  /// Either `Seating` or `Semi-Seating`.
  final String serviceType;

  const BusRoute({
    required this.name,
    required this.nameBn,
    required this.stops,
    required this.startTime,
    required this.endTime,
    required this.serviceType,
  });
}

/// A single fare-chart entry for a route.
class FareEntry {
  final String routeName;
  final String fromStop;
  final String toStop;

  /// Fare in Bangladeshi Taka (BDT).
  final int fareAmount;

  /// Distance between the two stops along the route (km).
  final double distanceKm;

  const FareEntry({
    required this.routeName,
    required this.fromStop,
    required this.toStop,
    required this.fareAmount,
    required this.distanceKm,
  });
}
