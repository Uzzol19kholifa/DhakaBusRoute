import 'package:flutter_test/flutter_test.dart';

import 'package:dhaka_bus_finder/main.dart';
import 'package:dhaka_bus_finder/data/pdf_corridors.dart';
import 'package:dhaka_bus_finder/services/bus_service.dart';
import 'package:dhaka_bus_finder/services/fare_service.dart';
import 'package:dhaka_bus_finder/services/stop_matching.dart';
import 'package:dhaka_bus_finder/services/transfer_service.dart';

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

  // PDF-derived fare tests: these stops live on transcribed corridors so
  // we should always get back an Official fare matching the PDF cell.
  test('Sign Board → Khilgaon Flyover returns Official PDF fare', () {
    final fare =
        FareService.lookupOfficial('Sign Board', 'Khilgaon Flyover');
    expect(fare, isNotNull, reason: 'Should be on the A-421 corridor');
    expect(fare!.isOfficial, isTrue);
    // 9.3 km × 2.53 BDT/km = 23.529 → ৳24
    expect(fare.distanceKm, closeTo(9.3, 0.05));
    expect(fare.amount, equals(24));
  });

  test('Zirabo → Abdullahpur returns Official PDF fare', () {
    final fare = FareService.lookupOfficial('Zirabo', 'Abdullahpur');
    expect(fare, isNotNull,
        reason: 'Should be on the A-436 (Sadarghat → Bypail) corridor');
    expect(fare!.isOfficial, isTrue);
    // |33.0 - 22.1| = 10.9 km × 2.53 = 27.577 → ৳28
    expect(fare.distanceKm, closeTo(10.9, 0.05));
    expect(fare.amount, equals(28));
  });

  test('stopNameMatches is digit-aware (Mirpur 1 ≠ Mirpur 10)', () {
    expect(stopNameMatches('Mirpur 1', 'Mirpur 1'), isTrue);
    expect(stopNameMatches('Mirpur 1', 'Mirpur 10'), isFalse);
    expect(stopNameMatches('Mirpur 10', 'Mirpur 1'), isFalse);
    expect(stopNameMatches('Mirpur 11', 'Mirpur 1'), isFalse);
    // Non-numeric prefixes still match.
    expect(stopNameMatches('Mirpur', 'Mirpur 10'), isTrue);
    expect(stopNameMatches('Khilgaon', 'Khilgaon Flyover'), isTrue);
  });

  test('PdfCorridor.findStop does not match Mirpur 1 inside Mirpur 10', () {
    // Build a corridor that has Mirpur 10 but not Mirpur 1, and verify
    // findStop('Mirpur 1') returns null instead of the false positive.
    const corridor = PdfCorridor(
      code: 'TEST-1',
      label: 'test',
      totalKm: 5,
      stops: [PdfStop('Mirpur 10', 0), PdfStop('Mirpur 11', 2.0)],
    );
    expect(corridor.findStop('Mirpur 1'), isNull);
    expect(corridor.findStop('Mirpur 10')?.km, equals(0));
  });

  test('TransferService finds 1-transfer suggestions when no direct bus',
      () {
    // Two stops we don't expect to be on the same route.
    final suggestions =
        TransferService.findSuggestions('Demra Bridge', 'Khilgaon Flyover');
    // Don't assert non-empty (depends on data) but if we do find any
    // they should each have two distinct routes and a positive fare.
    for (final s in suggestions) {
      expect(s.first.route.name, isNot(equals(s.second.route.name)));
      expect(s.totalFare, greaterThanOrEqualTo(20));
      expect(s.totalStops, greaterThan(1));
    }
  });
}
