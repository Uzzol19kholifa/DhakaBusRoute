import 'package:flutter_test/flutter_test.dart';

import 'package:dhaka_bus_finder/main.dart';
import 'package:dhaka_bus_finder/services/bus_service.dart';

void main() {
  testWidgets('Home screen renders the From / To pickers and search button',
      (WidgetTester tester) async {
    await tester.pumpWidget(const DhakaBusFinderApp());
    await tester.pumpAndSettle();

    expect(find.text('Dhaka Bus Finder 🚌'), findsOneWidget);
    expect(find.text('From'), findsOneWidget);
    expect(find.text('To'), findsOneWidget);
    expect(find.text('Find Buses'), findsOneWidget);
  });

  test('BusService.findBuses returns matching routes between two stops', () {
    final matches = BusService.findBuses('Mirpur 10', 'Airport');
    expect(matches, isNotEmpty);
    for (final m in matches) {
      expect(m.fromIndex, isNonNegative);
      expect(m.toIndex, isNonNegative);
      expect(m.fromIndex == m.toIndex, isFalse);
    }
  });

  test('BusMatch carries a fare result with source label', () {
    final matches = BusService.findBuses('Gabtoli', 'Airport');
    expect(matches, isNotEmpty);
    final fare = matches.first.fare;
    expect(fare.amount, greaterThanOrEqualTo(10));
    expect(
      [FareSource.official, FareSource.estimated].contains(fare.source),
      isTrue,
    );
    expect(fare.distanceKm, greaterThan(0));
  });

  test('BusService.headlineFare picks the cheapest fare', () {
    final matches = BusService.findBuses('Mirpur 10', 'Motijheel');
    if (matches.isEmpty) return;
    final headline = BusService.headlineFare(matches);
    expect(headline, isNotNull);
    final cheapest =
        matches.map((m) => m.fare.amount).reduce((a, b) => a < b ? a : b);
    expect(headline!.amount, equals(cheapest));
  });

  test('BusService.allStops returns a sorted, deduplicated list', () {
    final stops = BusService.allStops();
    expect(stops, isNotEmpty);
    final sorted = [...stops]..sort();
    expect(stops, equals(sorted));
    expect(stops.toSet().length, equals(stops.length));
  });
}
