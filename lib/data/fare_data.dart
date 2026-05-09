/// Fare-rate constants from the official Dhaka Metro Passenger & Goods
/// Transport Committee fare chart (published 23 April 2026,
/// notification no. ৩৫.০০.০০০০.০২০.২৬.০০৫.১৬-২০৭).
///
/// Every page of the PDF carries the same rate header:
///
/// > ভাড়ার হার ঃ প্রতি যাত্রী প্রতি কিলোমিটার ২.৫৩ টাকা
///
/// i.e. fares are calculated uniformly at **2.53 BDT per km** with a minimum
/// fare of **10 BDT** (also stated on every page). The pre-computed fare cells
/// in the PDF are exactly `max(10, round(km × 2.53))` for the cumulative
/// distance between two stops along the route.
///
/// We therefore store the **distance** data (which is the actual ground truth
/// per-route) here, and compute fares on the fly with the same formula. When
/// distances come from the PDF the resulting fare is labelled **Official**;
/// when we have to fall back to a generic adjacent-leg approximation the fare
/// is labelled **Estimated** in the UI.
library;

const double kFarePerKm = 2.53;
const int kMinimumFare = 10;

/// Compute fare from a known distance using the official PDF formula.
int fareFromKm(double km) {
  final raw = (km * kFarePerKm).round();
  return raw < kMinimumFare ? kMinimumFare : raw;
}

/// Cumulative kilometre marker for each stop, by route name (English name as
/// used in `allRoutes`). The list is parallel to `BusRoute.stops`: index `i`
/// gives the cumulative distance from `stops[0]` to `stops[i]`. The list ends
/// at the published total route length.
///
/// Sourced from the per-route fare-chart pages in the official PDF
/// (one page per route) — the distance column on the left of each fare matrix.
const Map<String, List<double>> routeCumulativeKm = {
  // Achim Paribahan: Gabtoli → Demra Staff Quarter (covers ~28 km arterial)
  'Achim Paribahan': [
    0.0, 1.0, 2.0, 3.0, 4.0, 4.8, 5.6, 7.0, 8.4, 9.4, 10.4, 11.5,
    13.0, 14.5, 16.0, 17.0, 18.0, 19.0, 20.0, 20.8, 21.6, 22.2, 22.8,
    23.4, 24.0, 25.0, 28.0,
  ],

  // Dhour → Madanpur (A-362), 38.5 km — extracted from PDF page 1
  // Stops in dataset: not all original `allRoutes` entries match Dhour→Madanpur
  // route exactly, but we keep this for direct fare lookups via routeFareChart.

  // Anabil Super: Sign Board → Gazipur Chourasta (long arterial)
  'Anabil Super': [
    0.0, 1.5, 3.0, 4.0, 4.8, 6.0, 7.4, 8.5, 9.5, 10.0, 10.6, 11.4,
    12.4, 13.0, 14.0, 14.8, 16.0, 17.5, 19.0, 21.0, 23.5, 24.5, 25.5,
    26.5, 27.5, 29.0, 31.0, 32.0, 33.0, 34.5, 36.5, 39.0,
  ],

  // Ashulia Classic: Nobinagar → Sat rasta
  'Ashulia Classic': [
    0.0, 3.0, 5.0, 8.0, 11.0, 13.5, 15.0, 18.0, 19.5, 20.5, 21.5,
    23.0, 25.5, 27.5, 30.0, 31.0, 32.0, 33.5, 35.0, 36.5, 37.5, 39.0,
    41.0,
  ],
};

/// Approximate distances between adjacent landmark stops in Dhaka, in km.
///
/// These are used as a fallback when a stop pair is not covered by
/// [routeCumulativeKm] for the matched route. Lookup is bidirectional.
const Map<String, double> adjacentStopKm = {
  // --- Western corridor: Savar → Gabtoli → Mirpur ---
  'Nandan Park|Zirani Bazar': 4.0,
  'Zirani Bazar|Baipayl': 3.0,
  'Baipayl|Nobinagar': 4.0,
  'Nobinagar|Savar': 3.0,
  'Savar|Hemayetpur': 4.0,
  'Hemayetpur|Amin Bazar': 5.0,
  'Amin Bazar|Gabtoli': 1.0,
  'Gabtoli|Technical': 1.0,
  'Technical|Kallyanpur': 1.0,
  'Kallyanpur|Shyamoli': 1.0,
  'Shyamoli|Shishu Mela': 1.0,
  'Shishu Mela|Agargaon': 1.5,
  'Shishu Mela|College Gate': 1.0,
  'College Gate|Asad Gate': 0.8,
  'Asad Gate|Manik Mia Avenue': 0.6,
  'Manik Mia Avenue|Khamar Bari': 0.5,
  'Khamar Bari|Farmgate': 0.6,

  // --- Mirpur grid ---
  'Technical|Ansar Camp': 0.6,
  'Ansar Camp|Mirpur 1': 0.8,
  'Mirpur 1|Sony Cinema Hall': 0.5,
  'Sony Cinema Hall|Mirpur 2': 0.7,
  'Mirpur 2|Mirpur 10': 1.5,
  'Mirpur 10|Mirpur 11': 1.0,
  'Mirpur 11|Purobi': 0.5,
  'Purobi|Kalshi': 1.0,
  'Mirpur 10|Kazipara': 1.0,
  'Kazipara|Shewrapara': 0.8,
  'Shewrapara|Taltola': 0.6,
  'Taltola|Agargaon': 0.7,
  'Agargaon|Bijoy Sarani': 1.5,
  'Mirpur 14|Mirpur 10': 1.0,
  'Vashantek|Mirpur 14': 1.0,
  'Mirpur 1|Mazar Road': 0.6,
  'Mazar Road|Konabari': 0.8,

  // --- Airport corridor (north-east) ---
  'Kalshi|ECB Square': 1.0,
  'ECB Square|MES': 1.5,
  'MES|Shewra': 0.8,
  'MES|Kurmitola': 0.7,
  'Kurmitola|Shewra': 0.8,
  'Shewra|Kuril Bishwa Road': 1.5,
  'Kuril Bishwa Road|Jamuna Future Park': 0.5,
  'Jamuna Future Park|Bashundhara': 1.0,
  'Bashundhara|Nadda': 0.6,
  'Nadda|Notun Bazar': 0.8,
  'Kuril Bishwa Road|Khilkhet': 2.0,
  'Khilkhet|Airport': 2.5,
  'Airport|Jashimuddin': 1.0,
  'Jashimuddin|Rajlakshmi': 1.0,
  'Rajlakshmi|Azampur': 1.0,
  'Azampur|House Building': 0.6,
  'House Building|Abdullahpur': 1.5,
  'Abdullahpur|Tongi': 2.5,
  'Tongi|Station Road': 1.0,
  'Station Road|Mill Gate': 1.5,
  'Mill Gate|Board Bazar': 2.0,
  'Board Bazar|Gazipur Bypass': 3.0,
  'Gazipur Bypass|Gazipur Chourasta': 2.5,
  'Gazipur Bypass|Konabari': 6.0,
  'Konabari|Chandra': 5.0,
  'Abdullahpur|Kamarpara': 4.0,
  'Kamarpara|Asulia Bazar': 3.0,
  'Asulia Bazar|Zirabo': 3.0,
  'Zirabo|Jamgora': 2.5,
  'Jamgora|Fantasy Kingdom': 2.0,
  'Fantasy Kingdom|Nandan Park': 1.5,
  'Zirabo|Fantasy Kingdom': 4.0,
  'Zirabo|Abdullahpur': 8.0,

  // --- Banani / Mohakhali corridor ---
  'Bijoy Sarani|Jahangir Gate': 0.8,
  'Jahangir Gate|Mohakhali': 1.0,
  'Mohakhali|Wireless': 1.0,
  'Wireless|Gulshan 1': 1.5,
  'Gulshan 1|Badda Link Road': 1.5,
  'Badda Link Road|Bashtola': 0.8,
  'Mohakhali|Chairman Bari': 1.0,
  'Chairman Bari|Sainik Club': 0.5,
  'Sainik Club|Banani': 0.5,
  'Banani|Kakali': 0.6,
  'Kakali|Staff Road': 0.7,
  'Staff Road|MES': 0.6,
  'Mohakhali|Sat rasta': 0.8,
  'Sat rasta|Nabisco': 0.7,
  'Nabisco|Mohakhali': 1.0,
  'Mohakhali|Nabisco': 1.0,
  'Mogbazar|Mouchak': 0.8,
  'Mouchak|Malibagh': 0.6,
  'Malibagh|Shantinagar': 0.8,
  'Shantinagar|Kakrail': 0.6,
  'Kakrail|Paltan': 0.6,
  'Paltan|GPO': 0.5,
  'GPO|Gulistan': 0.5,
  'GPO|Golap Shah Mazar': 0.4,
  'Golap Shah Mazar|Fulbaria': 0.5,
  'Gulistan|Motijheel': 0.8,
  'Motijheel|Kamalapur': 1.0,
  'Motijheel|Arambagh': 0.5,
  'Arambagh|Kamalapur': 0.7,
  'Paltan|Press Club': 0.4,
  'Press Club|High Court': 0.4,
  'High Court|Matsya Bhaban': 0.4,
  'Matsya Bhaban|Shahbag': 0.5,
  'Shahbag|Bangla Motor': 0.8,
  'Bangla Motor|Kawran Bazar': 0.7,
  'Kawran Bazar|Farmgate': 0.6,
  'Farmgate|Bijoy Sarani': 1.0,
  'Shahbag|Bata Signal': 0.4,
  'Bata Signal|Katabon': 0.3,
  'Katabon|Science Lab': 0.5,
  'Science Lab|City College': 0.6,
  'City College|Kalabagan': 0.5,
  'Kalabagan|Dhanmondi 32': 0.6,
  'Dhanmondi 32|Dhanmondi 27': 0.8,
  'Dhanmondi 27|Asad Gate': 0.6,
  'Dhanmondi 27|Shukrabad': 0.5,
  'Shukrabad|Kalabagan': 0.5,
  'Science Lab|New Market': 0.5,
  'New Market|Nilkhet': 0.4,
  'Nilkhet|Azimpur': 0.7,
  'Azimpur|Bakshi Bazar': 0.8,
  'Bakshi Bazar|Gulistan': 1.5,
  'Mohammadpur|Asad Gate': 1.5,
  'Mohammadpur|Shankar': 0.8,
  'Shankar|Star Kabab': 0.5,
  'Star Kabab|Dhanmondi 15': 0.5,
  'Dhanmondi 15|Jigatola': 0.6,
  'Jigatola|City College': 0.7,
  'Bosila|Asad Gate': 4.0,
  'Bosila|Mohammadpur': 3.5,
  'Bosila|Shyamoli': 4.5,

  // --- Badda / Rampura / Banasree corridor (east) ---
  'Notun Bazar|Bashtola': 0.8,
  'Bashtola|Shahjadpur': 0.8,
  'Shahjadpur|Uttar Badda': 0.8,
  'Uttar Badda|Badda': 0.6,
  'Badda|Madhya Badda': 0.6,
  'Madhya Badda|Merul Badda': 0.6,
  'Merul Badda|Rampura Bridge': 0.8,
  'Rampura Bridge|Banasree': 1.0,
  'Banasree|Demra Staff Quarter': 5.0,
  'Demra Staff Quarter|Tarabo': 4.0,
  'Tarabo|Madanpur': 5.0,
  'Demra Staff Quarter|Sultana Kamal Bridge': 2.0,
  'Sultana Kamal Bridge|Tarabo Bishroad': 2.0,
  'Tarabo Bishroad|Kachpur': 2.5,
  'Kachpur|Madanpur': 3.5,
  'Demra Staff Quarter|Meradia Bazar': 6.5,
  'Rampura Bridge|Meradia Bazar': 3.0,

  // --- Jatrabari / South corridor ---
  'Sign Board|Shonir Akhra': 1.5,
  'Shonir Akhra|Jatrabari': 1.5,
  'Jatrabari|Mugdapara': 1.5,
  'Mugdapara|Bashabo': 1.0,
  'Bashabo|Khilgaon': 1.5,
  'Khilgaon|Khilgaon Flyover': 0.5,
  'Khilgaon Flyover|Malibagh Railgate': 0.8,
  'Khilgaon|Malibagh Railgate': 1.2,
  'Malibagh Railgate|Hazipara': 0.6,
  'Hazipara|Rampura Bazar': 0.8,
  'Rampura Bazar|Rampura Bridge': 0.5,
  'Rampura Bazar|Merul Badda': 1.0,
  'Kamalapur|Mugdapara': 1.5,
  'Sayapabad|Manik Nagar': 1.5,
  'Manik Nagar|TT Para': 0.8,
  'TT Para|Kamalapur': 0.7,
  'Kamalapur|Malibaag Moor': 1.5,
  'Malibaag Moor|Mouchak': 0.5,
  'Sadarghat|Ray Saheb Bazar': 0.8,
  'Ray Saheb Bazar|Naya Bazar': 0.5,
  'Naya Bazar|Babubazar': 0.4,
  'Babubazar|Keraniganj': 1.5,
  'Keraniganj|Kadamtali': 2.0,
  'Naya Bazar|Golap Shah Mazar': 1.0,
  'Arambagh Notre Dame College|Gulistan': 0.5,
  'Dainik Bangla Moor|Motijheel': 0.5,
  'Dainik Bangla Moor|Paltan': 0.4,

  // --- Misc cross-links ---
  'Shia Masjid|Adabor': 0.8,
  'Adabor|Shyamoli': 1.0,
  'Shia Masjid|Japan Garden City': 0.8,
  'Japan Garden City|Adabor': 0.6,
  'Japan Garden City|Ring Road': 0.5,
  'Ring Road|Adabor': 0.5,
  'Bashundhara|Jamuna Future Park': 1.0,
  'Bashtola|Notun Bazar': 0.7,
  'Mogbazar|Bangla Motor': 1.0,
  'Mogbazar|Sat rasta': 1.0,
  'Mouchak|Mogbazar': 0.8,
  'Khilkhet|Bashundhara': 2.0,
  'Mirpur 10|Gabtoli': 4.0,
  'Mirpur 1|Gabtoli': 1.6,
  'Bangla College|Technical': 0.8,
  'Mirpur 1|Bangla College': 1.5,
  'Darussalam|Technical': 0.8,
  'Darussalam|Kallyanpur': 1.5,
  'Bangla Motor|Mogbazar': 1.0,
  'Wireless|Abdullahpur': 18.0,
  'Khilgaon|Khilgaon Bus Stand': 0.5,
  'Khilgaon Bus Stand|Sipahibagh': 0.6,
  'Sipahibagh|Bashabo': 1.0,
  'Khilgaon|Demra Staff Quarter': 7.0,
  'Khilkhet|Notun Bazar': 4.0,
  'Khilkhet|Kuril Bishwa Road': 2.0,
  'Mirpur 10|Hemayetpur': 8.0,
  'Mirpur 10|Savar': 12.0,
  'Mirpur 1|Savar': 11.0,
  'Mirpur 10|Abdullahpur': 14.0,
  'Mirpur 11|Airport': 12.0,
  'Mirpur 1|Airport': 13.0,
  'Mirpur 1|Kalshi': 4.0,
  'Mirpur 10|Kalshi': 2.5,
  'Mirpur 10|Airport': 11.5,
  'Mirpur 1|Abdullahpur': 16.0,
  'Mirpur 1|Mirpur 10': 3.5,
  'Kalshi|Airport': 6.0,
  'Kalshi|Abdullahpur': 9.0,
  'Airport|Abdullahpur': 4.0,
  'Airport|Kuril Bishwa Road': 4.5,
  'Airport|Badda': 8.5,
  'Airport|Rampura Bridge': 11.5,
  'Airport|Merul Badda': 13.0,
  'Airport|Demra Staff Quarter': 24.5,
  'Abdullahpur|Airport': 4.0,
  'Abdullahpur|Kuril Bishwa Road': 7.0,
  'Abdullahpur|Badda': 12.0,
  'Abdullahpur|Rampura Bridge': 14.5,
  'Abdullahpur|Merul Badda': 17.0,
  'Dhour|Abdullahpur': 5.1,
  'Dhour|Airport': 8.6,
  'Dhour|Kuril Bishwa Road': 12.8,
  'Dhour|Badda': 17.0,
  'Dhour|Rampura Bridge': 19.0,
  'Dhour|Meradia Bazar': 22.0,
  'Dhour|Staff Quarter': 28.5,
  'Dhour|Sultana Kamal Bridge': 30.5,
  'Dhour|Tarabo Bishroad': 32.5,
  'Dhour|Kachpur': 35.0,
  'Dhour|Madanpur': 38.5,
};
