import 'package:flutter/material.dart';
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

  test('BusService.fareFor falls back to per-km estimate above the minimum',
      () {
    final matches = BusService.findBuses('Gabtoli', 'Airport');
    expect(matches, isNotEmpty);
    final fare = BusService.fareFor(matches.first);
    expect(fare, greaterThanOrEqualTo(10));
  });

  test('BusService.allStops returns a sorted, deduplicated list', () {
    final stops = BusService.allStops();
    expect(stops, isNotEmpty);
    final sorted = [...stops]..sort();
    expect(stops, equals(sorted));
    expect(stops.toSet().length, equals(stops.length));
  });
}
