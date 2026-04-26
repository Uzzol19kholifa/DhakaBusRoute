/// Per-corridor distance data extracted directly from the official Dhaka
/// Metro Passenger & Goods Transport Committee fare-chart PDF (published
/// 23 April 2026, notification no. ৩৫.০০.০০০০.০২০.২৬.০০৫.১৬-২০৭).
///
/// Every page of the PDF is a single corridor identified by a route code
/// (e.g. `A-362`, `A-365`) with an ordered list of stops and the cumulative
/// kilometres travelled from the corridor's start. The PDF's pre-printed
/// fare cells are exactly `max(10, round(km × 2.53))` so we encode the
/// distance column directly and compute fares on the fly.
///
/// When a (from, to) lookup is satisfied by one of these corridors the
/// resulting fare is shown to the user as **Official Fare**. Otherwise the
/// fare service falls back to the curated adjacent-stop approximation and
/// the fare is labelled **Estimated**.
library;

class PdfStop {
  /// Canonical English stop name (matches `BusRoute.stops`).
  final String name;

  /// Cumulative kilometres from the corridor origin.
  final double km;

  const PdfStop(this.name, this.km);
}

class PdfCorridor {
  /// BRTA-issued corridor code, e.g. `A-362`.
  final String code;

  /// Human-readable corridor label, e.g. `Dhour → Madanpur`.
  final String label;

  /// Published total corridor length (km).
  final double totalKm;

  /// Ordered stops with cumulative km. `stops.first.km == 0` and
  /// `stops.last.km ≈ totalKm`.
  final List<PdfStop> stops;

  const PdfCorridor({
    required this.code,
    required this.label,
    required this.totalKm,
    required this.stops,
  });

  /// Look up a stop on this corridor by name (case-insensitive substring
  /// match). Returns `null` if the corridor does not visit this stop.
  PdfStop? findStop(String name) {
    final q = name.toLowerCase().trim();
    if (q.isEmpty) return null;
    for (final s in stops) {
      final n = s.name.toLowerCase();
      if (n == q) return s;
    }
    for (final s in stops) {
      final n = s.name.toLowerCase();
      if (n.contains(q) || q.contains(n)) return s;
    }
    return null;
  }
}

/// All corridors transcribed from the PDF (one entry per page).
const List<PdfCorridor> pdfCorridors = [
  // A-362 — Dhour → Madanpur (38.5 km), page 1
  PdfCorridor(
    code: 'A-362',
    label: 'Dhour → Madanpur',
    totalKm: 38.5,
    stops: [
      PdfStop('Dhour', 0.0),
      PdfStop('Abdullahpur', 5.1),
      PdfStop('Airport', 8.6),
      PdfStop('Kuril', 12.4),
      PdfStop('Badda', 17.0),
      PdfStop('Rampura Bridge', 19.0),
      PdfStop('Meradia Bazar', 22.0),
      PdfStop('Staff Quarter', 28.5),
      PdfStop('Sultana Kamal Bridge', 30.5),
      PdfStop('Tarabo Bishworoad', 32.5),
      PdfStop('Kanchpur', 35.0),
      PdfStop('Madanpur', 38.5),
    ],
  ),

  // A-365 — Nabinagar → Dhour (45.2 km), page 2
  PdfCorridor(
    code: 'A-365',
    label: 'Nabinagar → Dhour',
    totalKm: 45.2,
    stops: [
      PdfStop('Nabinagar', 0.0),
      PdfStop('Savar', 8.0),
      PdfStop('Gabtoli', 21.5),
      PdfStop('Mirpur 1', 23.5),
      PdfStop('Proshika Moor', 24.8),
      PdfStop('Mirpur 10', 25.8),
      PdfStop('Kalshi', 29.7),
      PdfStop('Jillur Rahman Flyover', 30.1),
      PdfStop('Sheoda Bazar', 32.7),
      PdfStop('Airport', 36.6),
      PdfStop('Abdullahpur', 40.1),
      PdfStop('Kamarpara', 42.2),
      PdfStop('Dhour', 45.2),
    ],
  ),

  // A-366 — Bashila → Dhour (32.8 km), page 3
  PdfCorridor(
    code: 'A-366',
    label: 'Bashila → Dhour',
    totalKm: 32.8,
    stops: [
      PdfStop('Bashila', 0.0),
      PdfStop('Asad Avenue', 3.0),
      PdfStop('Shyamoli', 4.8),
      PdfStop('Kallyanpur', 5.3),
      PdfStop('Technical', 6.5),
      PdfStop('Mirpur 1', 8.5),
      PdfStop('Mirpur 2', 9.8),
      PdfStop('Mirpur 10', 10.3),
      PdfStop('Mirpur 11', 11.3),
      PdfStop('Purobi', 11.8),
      PdfStop('Kalshi', 15.0),
      PdfStop('Sheora Bazar', 19.8),
      PdfStop('Airport', 23.8),
      PdfStop('Uttara', 24.9),
      PdfStop('Abdullahpur', 27.3),
      PdfStop('Dhour', 32.8),
    ],
  ),

  // A-367 — Bhashantek → Nandanpark (44.8 km), page 4
  PdfCorridor(
    code: 'A-367',
    label: 'Bhashantek → Nandanpark',
    totalKm: 44.8,
    stops: [
      PdfStop('Bhashantek', 0.0),
      PdfStop('Mirpur 14', 1.8),
      PdfStop('Mirpur 10', 4.0),
      PdfStop('Mirpur 1', 5.8),
      PdfStop('Technical', 7.7),
      PdfStop('Gabtoli', 8.9),
      PdfStop('Hemayetpur', 16.1),
      PdfStop('Savar', 22.7),
      PdfStop('Nabinagar', 30.7),
      PdfStop('EPZ', 35.8),
      PdfStop('Nandanpark', 44.8),
    ],
  ),

  // A-368 — Sign Board → Fantasy Kingdom (46.3 km), page 5
  PdfCorridor(
    code: 'A-368',
    label: 'Sign Board → Fantasy Kingdom',
    totalKm: 46.3,
    stops: [
      PdfStop('Sign Board', 0.0),
      PdfStop('Jatrabari', 5.0),
      PdfStop('Gulistan', 7.7),
      PdfStop('Paltan', 8.9),
      PdfStop('Bijoy Nagar', 9.5),
      PdfStop('Kakrail', 10.3),
      PdfStop('Mouchak', 11.4),
      PdfStop('Mogbazar', 12.7),
      PdfStop('Satrasta', 13.7),
      PdfStop('Mohakhali', 16.8),
      PdfStop('Banani', 18.8),
      PdfStop('Sheora', 22.1),
      PdfStop('Khilkhet', 23.7),
      PdfStop('Airport', 29.8),
      PdfStop('House Building', 30.5),
      PdfStop('Abdullahpur', 31.6),
      PdfStop('Kamarpara', 33.8),
      PdfStop('Fantasy Kingdom', 46.3),
    ],
  ),

  // A-377 — Demra Bridge → Nabinagar (46.9 km), page 6
  PdfCorridor(
    code: 'A-377',
    label: 'Demra Bridge → Nabinagar',
    totalKm: 46.9,
    stops: [
      PdfStop('Demra Bridge', 0.0),
      PdfStop('Demra Staff Quarter', 2.0),
      PdfStop('Meradia', 8.5),
      PdfStop('Banashree', 11.5),
      PdfStop('Mouchak', 14.0),
      PdfStop('Kakrail', 14.9),
      PdfStop('Shahbag', 17.0),
      PdfStop('Science Lab', 18.2),
      PdfStop('Asad Gate', 22.2),
      PdfStop('Kallyanpur', 24.5),
      PdfStop('Gabtoli', 25.8),
      PdfStop('Savar', 38.9),
      PdfStop('Nabinagar', 46.9),
    ],
  ),

  // A-378 — Demra Staff Quarter → Bashila (23.5 km), page 7
  PdfCorridor(
    code: 'A-378',
    label: 'Demra Staff Quarter → Bashila',
    totalKm: 23.5,
    stops: [
      PdfStop('Demra Staff Quarter', 0.0),
      PdfStop('Meradia Bazar', 8.0),
      PdfStop('Rampura', 10.8),
      PdfStop('Mouchak', 13.3),
      PdfStop('Mogbazar', 14.3),
      PdfStop('Bangla Motor', 15.5),
      PdfStop('Farmgate', 17.5),
      PdfStop('Asad Gate', 19.2),
      PdfStop('Mohammadpur', 20.5),
      PdfStop('Bashila', 23.5),
    ],
  ),

  // A-380 — Shialbari → Kamalapur (Pirjongi Mazar) (21.3 km), page 8
  PdfCorridor(
    code: 'A-380',
    label: 'Shialbari → Kamalapur',
    totalKm: 21.3,
    stops: [
      PdfStop('Shialbari', 0.0),
      PdfStop('Original 10', 2.0),
      PdfStop('Purobi', 3.0),
      PdfStop('Kalshi Moor', 6.3),
      PdfStop('Jillur Rahman Flyover', 9.8),
      PdfStop('Kakli', 11.8),
      PdfStop('Mohakhali', 13.6),
      PdfStop('Satrasta', 15.8),
      PdfStop('Mogbazar', 17.3),
      PdfStop('Malibagh', 18.3),
      PdfStop('Kakrail', 19.3),
      PdfStop('Fakirapool', 20.3),
      PdfStop('Kamalapur', 21.3),
    ],
  ),

  // A-381 — Gulistan → Bhulta Gausia (20.6 km), page 9
  PdfCorridor(
    code: 'A-381',
    label: 'Gulistan → Bhulta Gausia',
    totalKm: 20.6,
    stops: [
      PdfStop('Gulistan', 0.0),
      PdfStop('Demra', 9.5),
      PdfStop('Rupshi', 13.7),
      PdfStop('Bhorpa', 15.1),
      PdfStop('Bhulta Gausia', 20.6),
    ],
  ),

  // A-384 — Sign Board → Nandanpark (56.5 km), page 10
  PdfCorridor(
    code: 'A-384',
    label: 'Sign Board → Nandanpark',
    totalKm: 56.5,
    stops: [
      PdfStop('Sign Board', 0.0),
      PdfStop('Mayor Mohammad Flyover', 4.0),
      PdfStop('Chankharpul', 9.3),
      PdfStop('Azimpur', 11.3),
      PdfStop('New Market', 12.1),
      PdfStop('Gabtoli', 19.7),
      PdfStop('Savar', 34.1),
      PdfStop('Nabinagar', 42.5),
      PdfStop('EPZ', 47.0),
      PdfStop('Jirani', 52.0),
      PdfStop('Nandanpark', 56.5),
    ],
  ),

  // A-386 — Madanpur → Nandanpark (78.6 km), page 11
  PdfCorridor(
    code: 'A-386',
    label: 'Madanpur → Nandanpark',
    totalKm: 78.6,
    stops: [
      PdfStop('Madanpur', 0.0),
      PdfStop('Kanchpur', 4.0),
      PdfStop('Demra', 9.0),
      PdfStop('Meradia Bazar', 15.6),
      PdfStop('Banashree', 17.6),
      PdfStop('Rampura Bridge', 18.6),
      PdfStop('Jamuna Future Park', 23.8),
      PdfStop('Kuril', 24.8),
      PdfStop('ECB Chottor', 28.8),
      PdfStop('Kalshi', 30.3),
      PdfStop('Mirpur 10', 35.2),
      PdfStop('Mirpur 1', 37.0),
      PdfStop('Gabtoli', 40.1),
      PdfStop('Hemayetpur', 48.1),
      PdfStop('Savar', 54.8),
      PdfStop('EPZ', 68.0),
      PdfStop('Nandanpark', 78.6),
    ],
  ),

  // A-387 — Kalampur → Victoria Park (49.5 km), page 12
  PdfCorridor(
    code: 'A-387',
    label: 'Kalampur → Victoria Park',
    totalKm: 49.5,
    stops: [
      PdfStop('Kalampur', 0.0),
      PdfStop('Dhamrai', 3.3),
      PdfStop('Nabinagar', 11.5),
      PdfStop('Savar', 19.5),
      PdfStop('Hemayetpur', 27.5),
      PdfStop('Gabtoli', 33.0),
      PdfStop('Asad Gate', 38.0),
      PdfStop('Farmgate', 40.0),
      PdfStop('Shahbag', 43.0),
      PdfStop('Press Club', 47.0),
      PdfStop('Gulistan', 47.5),
      PdfStop('Victoria Park', 49.5),
    ],
  ),

  // A-393 — Savar → Beraid (37.4 km), page 13
  PdfCorridor(
    code: 'A-393',
    label: 'Savar → Beraid',
    totalKm: 37.4,
    stops: [
      PdfStop('Savar', 0.0),
      PdfStop('Hemayetpur', 6.6),
      PdfStop('Gabtoli', 14.2),
      PdfStop('Technical', 15.0),
      PdfStop('Mirpur 2', 18.2),
      PdfStop('Mirpur 11', 19.8),
      PdfStop('Kalshi', 23.6),
      PdfStop('Jillur Rahman Flyover', 25.8),
      PdfStop('Sheora', 27.8),
      PdfStop('Kuril Flyover', 28.8),
      PdfStop('Norda', 30.1),
      PdfStop('Beraid', 37.4),
    ],
  ),

  // A-406 — Ghatar Char → Sonargaon (39.4 km), page 14
  PdfCorridor(
    code: 'A-406',
    label: 'Ghatar Char → Sonargaon',
    totalKm: 39.4,
    stops: [
      PdfStop('Ghatar Char', 0.0),
      PdfStop('Bashila', 2.8),
      PdfStop('Mohammadpur', 4.3),
      PdfStop('Shankar', 6.3),
      PdfStop('Shyamoli', 6.8),
      PdfStop('Dhanmondi', 7.3),
      PdfStop('Jigatola', 8.3),
      PdfStop('Science Lab', 10.3),
      PdfStop('Shahbag', 11.3),
      PdfStop('Press Club', 12.3),
      PdfStop('Gulistan', 14.3),
      PdfStop('Hanif Flyover', 14.8),
      PdfStop('Shanir Akhra', 19.3),
      PdfStop('Rayerbagh', 20.3),
      PdfStop('Kanchpur', 27.3),
      PdfStop('Madanpur', 30.3),
      PdfStop('Sonargaon', 39.4),
    ],
  ),

  // A-414 — Uttara Diabari → Ghatar Char (32.1 km), page 15
  PdfCorridor(
    code: 'A-414',
    label: 'Uttara Diabari → Ghatar Char',
    totalKm: 32.1,
    stops: [
      PdfStop('Uttara Diabari', 0.0),
      PdfStop('House Building', 3.0),
      PdfStop('Abdullahpur', 4.0),
      PdfStop('Kamarpara', 6.0),
      PdfStop('Dhour', 9.0),
      PdfStop('Diabari Mor', 20.5),
      PdfStop('Mazar Road', 21.3),
      PdfStop('Mirpur 1', 22.5),
      PdfStop('Technical', 24.5),
      PdfStop('Shyamoli', 26.1),
      PdfStop('Asad Gate', 26.3),
      PdfStop('Mohammadpur Bus Stand', 27.8),
      PdfStop('Bashila Bridge', 29.3),
      PdfStop('Ghatar Char', 32.1),
    ],
  ),

  // A-421 — Sign Board → Nabinagar (45.5 km), page 16
  PdfCorridor(
    code: 'A-421',
    label: 'Sign Board → Nabinagar',
    totalKm: 45.5,
    stops: [
      PdfStop('Sign Board', 0.0),
      PdfStop('Jatrabari', 5.5),
      PdfStop('Sayedabad', 6.6),
      PdfStop('Mugda', 8.3),
      PdfStop('Khilgaon Flyover', 9.3),
      PdfStop('Rajarbagh', 11.3),
      PdfStop('Mogbazar', 13.3),
      PdfStop('Bangla Motor', 14.8),
      PdfStop('Farmgate', 15.8),
      PdfStop('Asad Gate', 18.1),
      PdfStop('Kallyanpur', 20.8),
      PdfStop('Gabtoli', 22.2),
      PdfStop('Savar', 36.8),
      PdfStop('Nabinagar', 45.5),
    ],
  ),

  // A-422 — Kamrangirchar (Beribadh) → Konabari (52.0 km), page 17
  PdfCorridor(
    code: 'A-422',
    label: 'Kamrangirchar (Beribadh) → Konabari',
    totalKm: 52.0,
    stops: [
      PdfStop('Kamrangirchar Beribadh', 0.0),
      PdfStop('Mohammadpur', 9.2),
      PdfStop('Asad Gate', 10.6),
      PdfStop('Technical', 14.3),
      PdfStop('Mirpur 1', 16.0),
      PdfStop('Shah Ali Mazar', 16.7),
      PdfStop('Diabari Beribadh', 18.8),
      PdfStop('Dhour Mor', 31.7),
      PdfStop('Zirabo', 37.8),
      PdfStop('Norshingapur', 38.0),
      PdfStop('Kashempur', 48.0),
      PdfStop('Konabari', 52.0),
    ],
  ),

  // A-426 — Kanchpur → Paturia (104.5 km), page 18
  PdfCorridor(
    code: 'A-426',
    label: 'Kanchpur → Paturia',
    totalKm: 104.5,
    stops: [
      PdfStop('Kanchpur', 0.0),
      PdfStop('Hanif Flyover', 14.0),
      PdfStop('Polashi', 17.0),
      PdfStop('Azimpur', 17.5),
      PdfStop('Kalabagan', 20.5),
      PdfStop('Shyamoli', 23.5),
      PdfStop('Gabtoli', 26.2),
      PdfStop('Savar', 30.2),
      PdfStop('Nabinagar', 38.7),
      PdfStop('Islampur', 51.8),
      PdfStop('Kalampur', 59.3),
      PdfStop('Manikganj', 77.2),
      PdfStop('Baniajuri', 84.3),
      PdfStop('Borongail', 90.3),
      PdfStop('Uthuli', 96.9),
      PdfStop('Paturia', 104.5),
    ],
  ),

  // A-429 — Savar → Sign Board (34.0 km), page 19
  PdfCorridor(
    code: 'A-429',
    label: 'Savar → Sign Board',
    totalKm: 34.0,
    stops: [
      PdfStop('Savar', 0.0),
      PdfStop('Hemayetpur', 7.0),
      PdfStop('Gabtoli', 14.2),
      PdfStop('Shyamoli', 16.7),
      PdfStop('Asad Gate', 18.6),
      PdfStop('Farmgate', 20.6),
      PdfStop('Bangla Motor', 21.9),
      PdfStop('Shahbag', 22.7),
      PdfStop('Matshya Bhaban', 23.7),
      PdfStop('Press Club', 24.3),
      PdfStop('Paltan', 24.7),
      PdfStop('Gulistan', 25.8),
      PdfStop('Shanir Akhra', 30.8),
      PdfStop('Sign Board', 34.0),
    ],
  ),

  // A-430 — Bhawer Bhiti (South Keraniganj) → Diabari (35.1 km), page 20
  PdfCorridor(
    code: 'A-430',
    label: 'Bhawer Bhiti (South Keraniganj) → Diabari',
    totalKm: 35.1,
    stops: [
      PdfStop('Bhawer Bhiti South Keraniganj', 0.0),
      PdfStop('Abdullahpur Jail Khana', 3.9),
      PdfStop('Rajendrapur Bazar', 4.6),
      PdfStop('Chunkutia Bazar', 8.8),
      PdfStop('Kadamtoli', 9.5),
      PdfStop('Babu Bazar', 11.2),
      PdfStop('Gulistan Fulbaria', 12.6),
      PdfStop('Paltan', 13.3),
      PdfStop('Kakrail', 14.1),
      PdfStop('Malibagh', 15.0),
      PdfStop('Mouchak Flyover', 15.3),
      PdfStop('Rampura', 16.9),
      PdfStop('Badda', 20.0),
      PdfStop('Notun Bazar', 21.8),
      PdfStop('Kuril Bishworoad', 24.1),
      PdfStop('Khilkhet', 25.9),
      PdfStop('Airport', 28.6),
      PdfStop('House Building', 31.8),
      PdfStop('Diabari', 35.1),
    ],
  ),

  // A-431 — Chiriyakhana → Khaisaikhali Beribadh (53.8 km), page 21
  PdfCorridor(
    code: 'A-431',
    label: 'Chiriyakhana → Khaisaikhali Beribadh',
    totalKm: 53.8,
    stops: [
      PdfStop('Chiriyakhana', 0.0),
      PdfStop('Mirpur 1', 1.8),
      PdfStop('Technical', 3.8),
      PdfStop('Asad Gate', 7.8),
      PdfStop('Science Lab', 9.9),
      PdfStop('Azimpur', 12.5),
      PdfStop('Chankharpul', 16.1),
      PdfStop('Fulbaria', 17.7),
      PdfStop('Nayabazar', 18.9),
      PdfStop('Babu Bazar Bridge', 20.2),
      PdfStop('Kadamtoli', 21.5),
      PdfStop('Konakhola', 26.3),
      PdfStop('Rohitpur', 30.5),
      PdfStop('Tokpur', 38.6),
      PdfStop('Komorganj', 51.2),
      PdfStop('Bandura', 52.2),
      PdfStop('Khaisaikhali Beribadh', 53.2),
      PdfStop('Beribadh', 53.8),
    ],
  ),

  // A-432 — Kuril Bishworoad → Polashi (20.0 km), page 22
  PdfCorridor(
    code: 'A-432',
    label: 'Kuril Bishworoad → Polashi',
    totalKm: 20.0,
    stops: [
      PdfStop('Kuril Bishworoad', 0.0),
      PdfStop('Notun Bazar', 3.4),
      PdfStop('Badda Link Road', 5.5),
      PdfStop('Gulshan 1', 6.5),
      PdfStop('Mohakhali', 8.5),
      PdfStop('Rainbow', 11.3),
      PdfStop('Sonargaon', 12.3),
      PdfStop('Russell Square', 14.0),
      PdfStop('Kalabagan', 15.1),
      PdfStop('New Market', 16.5),
      PdfStop('Polashi', 20.0),
    ],
  ),

  // A-436 — Sadarghat Victoria Park → Bypail (39.8 km), page 23
  PdfCorridor(
    code: 'A-436',
    label: 'Sadarghat Victoria Park → Bypail',
    totalKm: 39.8,
    stops: [
      PdfStop('Sadarghat Victoria Park', 0.0),
      PdfStop('Bangabandhu Avenue', 2.6),
      PdfStop('Kakrail', 8.0),
      PdfStop('Malibagh', 8.7),
      PdfStop('Mouchak', 9.1),
      PdfStop('Rampura', 9.9),
      PdfStop('Kuril Bishworoad', 14.0),
      PdfStop('Airport', 18.6),
      PdfStop('Abdullahpur', 22.1),
      PdfStop('Dhour', 27.7),
      PdfStop('Zirabo', 33.0),
      PdfStop('Ashulia Fantasy Kingdom', 37.3),
      PdfStop('Bypail', 39.8),
    ],
  ),

  // A-439 — Khilgaon Khidma Hospital → Ghatarchar (20.0 km), page 24
  PdfCorridor(
    code: 'A-439',
    label: 'Khilgaon Khidma Hospital → Ghatarchar',
    totalKm: 20.0,
    stops: [
      PdfStop('Khilgaon Khidma Hospital', 0.0),
      PdfStop('Khilgaon Railgate', 2.5),
      PdfStop('Bashabo', 3.0),
      PdfStop('Mugda', 3.5),
      PdfStop('Kamalapur', 5.5),
      PdfStop('Motijheel', 6.5),
      PdfStop('Gulistan', 7.8),
      PdfStop('Shahbag', 10.8),
      PdfStop('Science Lab', 11.9),
      PdfStop('Jigatola', 13.1),
      PdfStop('Dhanmondi 15', 13.7),
      PdfStop('Mohammadpur', 15.7),
      PdfStop('Bashila', 17.2),
      PdfStop('Ghatarchar', 20.0),
    ],
  ),

  // A-441 — Nandanpark → Narayanganj Chashara Hat (65.4 km), page 25
  PdfCorridor(
    code: 'A-441',
    label: 'Nandanpark → Narayanganj Chashara Hat',
    totalKm: 65.4,
    stops: [
      PdfStop('Nandanpark', 0.0),
      PdfStop('Jirani Bazar', 4.5),
      PdfStop('Nabinagar', 14.1),
      PdfStop('Savar', 22.5),
      PdfStop('Gabtoli', 36.9),
      PdfStop('New Market', 44.5),
      PdfStop('Azimpur', 45.3),
      PdfStop('Bakshibazar', 46.7),
      PdfStop('Chankharpul', 47.8),
      PdfStop('Sign Board', 56.7),
      PdfStop('Narayanganj Chashara', 65.4),
    ],
  ),

  // A-453 — Nabinagar → Mawaghat (72.5 km), page 26
  PdfCorridor(
    code: 'A-453',
    label: 'Nabinagar → Mawaghat',
    totalKm: 72.5,
    stops: [
      PdfStop('Nabinagar', 0.0),
      PdfStop('Savar', 8.2),
      PdfStop('Hemayetpur', 14.8),
      PdfStop('Gabtoli', 22.3),
      PdfStop('Asad Gate', 27.3),
      PdfStop('Farmgate', 28.8),
      PdfStop('Shahbag', 31.3),
      PdfStop('Golapshah Mazar', 33.7),
      PdfStop('Babubazar Bridge', 35.7),
      PdfStop('Bezgaon Chourasta', 61.6),
      PdfStop('Mawaghat', 72.5),
    ],
  ),

  // A-458 — Mirpur 12 → Motijheel (15.3 km), page 27
  PdfCorridor(
    code: 'A-458',
    label: 'Mirpur 12 → Motijheel',
    totalKm: 15.3,
    stops: [
      PdfStop('Mirpur 12', 0.0),
      PdfStop('Mirpur 11', 1.1),
      PdfStop('Mirpur 10', 2.5),
      PdfStop('Kazipara', 3.7),
      PdfStop('Sheorapara', 4.5),
      PdfStop('Bijoy Sarani', 8.0),
      PdfStop('Farmgate', 8.7),
      PdfStop('Shahbag', 10.8),
      PdfStop('Press Club', 12.8),
      PdfStop('Gulistan', 13.6),
      PdfStop('Motijheel', 15.3),
    ],
  ),

  // A-459 — Manikdi (ECB Mor) → Azimpur (15.3 km), page 28
  PdfCorridor(
    code: 'A-459',
    label: 'Manikdi (ECB Mor) → Azimpur',
    totalKm: 15.3,
    stops: [
      PdfStop('Manikdi ECB Mor', 0.0),
      PdfStop('Kalshi', 1.1),
      PdfStop('Mirpur 11', 3.1),
      PdfStop('Mirpur 10', 4.2),
      PdfStop('Kazipara', 5.3),
      PdfStop('Sheorapara', 6.2),
      PdfStop('Agargaon', 7.8),
      PdfStop('Shishumela', 9.3),
      PdfStop('College Gate', 9.8),
      PdfStop('Shukrabad', 11.9),
      PdfStop('New Market', 14.1),
      PdfStop('Azimpur', 15.3),
    ],
  ),

  // A-285 — Chiriyakhana → Keraniganj (Notun Jail Khana) (21.0 km), page 29
  PdfCorridor(
    code: 'A-285',
    label: 'Chiriyakhana → Keraniganj (Notun Jail Khana)',
    totalKm: 21.0,
    stops: [
      PdfStop('Chiriyakhana', 0.0),
      PdfStop('Mirpur 1', 1.8),
      PdfStop('Technical', 2.7),
      PdfStop('Shyamoli', 5.8),
      PdfStop('Asad Gate', 7.2),
      PdfStop('Farmgate', 9.0),
      PdfStop('Press Club', 12.6),
      PdfStop('Fulbaria', 14.2),
      PdfStop('Tati Bazar', 15.7),
      PdfStop('Babu Bazar Bridge', 16.9),
      PdfStop('Chunkutia', 18.0),
      PdfStop('Keraniganj Notun Jail Khana', 21.0),
    ],
  ),

  // A-288 — Mirpur 12 → Narayanganj (35.0 km), page 30
  PdfCorridor(
    code: 'A-288',
    label: 'Mirpur 12 → Narayanganj',
    totalKm: 35.0,
    stops: [
      PdfStop('Mirpur 12', 0.0),
      PdfStop('Mirpur 11', 1.5),
      PdfStop('Mirpur 10', 2.5),
      PdfStop('Kazipara', 3.5),
      PdfStop('Sheorapara', 5.0),
      PdfStop('Farmgate', 9.0),
      PdfStop('Shahbag', 11.3),
      PdfStop('GPO', 14.5),
      PdfStop('Mayor Hanif Flyover', 16.0),
      PdfStop('Shanir Akhra', 22.0),
      PdfStop('Sign Board', 25.3),
      PdfStop('Chashara Bus Stand', 33.2),
      PdfStop('Narayanganj', 35.0),
    ],
  ),
];
