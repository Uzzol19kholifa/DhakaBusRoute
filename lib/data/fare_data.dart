/// Fare chart data sourced from the official Dhaka Metro Passenger & Goods
/// Transport Committee fare chart (published 23 April 2026).
///
/// The chart prescribes a uniform rate of **2.53 BDT per km** with a minimum
/// fare of **10 BDT**. The map below stores explicit fare entries from the
/// PDF; for any pair not listed, [estimateFareFromDistance] (or the per-km
/// fallback in `services/fare_service.dart`) is used.
///
/// Keys use the format `"FromStop|ToStop"`. Buses are bidirectional so look
/// up both `A|B` and `B|A`.
library;

/// Per-kilometre fare in BDT, as set by the Transport Committee.
const double kFarePerKm = 2.53;

/// Minimum fare in BDT regardless of distance.
const int kMinimumFare = 10;

/// Explicit fare-chart entries from the official PDF.
///
/// This is a representative subset covering several major routes; for any
/// stop-pair not listed the app falls back to a per-km estimate computed
/// from [stopDistanceKm].
const Map<String, int> fareChart = {
  // --- Route: Dhour ↔ Madanpur (A-362) ---
  'Dhour|Abdullahpur': 13,
  'Dhour|Airport': 22,
  'Dhour|Kuril Bishwa Road': 31,
  'Dhour|Badda': 40,
  'Dhour|Rampura Bridge': 48,
  'Dhour|Merul Badda': 56,
  'Dhour|Demra Staff Quarter': 92,
  'Dhour|Tarabo': 99,
  'Dhour|Madanpur': 109,
  'Abdullahpur|Airport': 10,
  'Abdullahpur|Kuril Bishwa Road': 18,
  'Abdullahpur|Badda': 30,
  'Abdullahpur|Rampura Bridge': 37,
  'Abdullahpur|Merul Badda': 43,
  'Abdullahpur|Demra Staff Quarter': 68,
  'Abdullahpur|Tarabo': 82,
  'Abdullahpur|Madanpur': 98,
  'Airport|Kuril Bishwa Road': 10,
  'Airport|Badda': 22,
  'Airport|Rampura Bridge': 29,
  'Airport|Merul Badda': 34,
  'Airport|Demra Staff Quarter': 62,
  'Airport|Tarabo': 69,
  'Airport|Madanpur': 80,

  // --- Route: Nobinagar ↔ Dhour (A-365N) ---
  'Nobinagar|Savar': 20,
  'Nobinagar|Gabtoli': 48,
  'Nobinagar|Mirpur 1': 59,
  'Nobinagar|Proshika Moor': 60,
  'Nobinagar|Kalshi': 72,
  'Nobinagar|Kuril Bishwa Road': 96,
  'Nobinagar|Airport': 93,
  'Nobinagar|Abdullahpur': 101,
  'Nobinagar|Kamarpara': 107,
  'Nobinagar|Dhour': 118,
  'Savar|Gabtoli': 38,
  'Savar|Mirpur 1': 59,
  'Savar|Abdullahpur': 89,
  'Gabtoli|Mirpur 1': 10,
  'Gabtoli|Airport': 56,
  'Gabtoli|Abdullahpur': 66,
  'Mirpur 1|Kalshi': 16,
  'Mirpur 1|Airport': 37,
  'Mirpur 1|Abdullahpur': 57,
  'Kalshi|Airport': 22,
  'Kalshi|Abdullahpur': 51,
  'Airport|Abdullahpur': 29,
  'Airport|Kamarpara': 34,

  // --- Route: Bosila ↔ Dhour (A-366N) ---
  'Bosila|Asad Gate': 10,
  'Bosila|Shyamoli': 12,
  'Bosila|Kallyanpur': 19,
  'Bosila|Technical': 22,
  'Bosila|Mirpur 1': 29,
  'Bosila|Mirpur 2': 32,
  'Bosila|Mirpur 10': 36,
  'Bosila|Mirpur 11': 41,
  'Bosila|Purobi': 43,
  'Bosila|Kalshi': 48,
  'Bosila|Airport': 63,
  'Bosila|Abdullahpur': 73,
  'Bosila|Dhour': 98,
  'Shyamoli|Technical': 10,
  'Shyamoli|Mirpur 1': 18,
  'Shyamoli|Mirpur 10': 26,
  'Shyamoli|Kalshi': 36,
  'Shyamoli|Airport': 51,
  'Shyamoli|Abdullahpur': 61,
  'Technical|Mirpur 1': 10,
  'Technical|Mirpur 10': 18,
  'Technical|Airport': 43,
  'Mirpur 1|Mirpur 10': 10,
  'Mirpur 10|Kalshi': 22,
  'Mirpur 10|Airport': 38,
  'Mirpur 10|Abdullahpur': 48,
  'Mirpur 11|Airport': 35,

  // --- Route: Vashantek ↔ Nandan Park (A-369N) ---
  'Vashantek|Mirpur 14': 10,
  'Vashantek|Mirpur 10': 10,
  'Vashantek|Mirpur 1': 16,
  'Vashantek|Technical': 19,
  'Vashantek|Gabtoli': 23,
  'Vashantek|Hemayetpur': 37,
  'Vashantek|Savar': 49,
  'Vashantek|Nobinagar': 62,
  'Vashantek|Nandan Park': 99,
  'Mirpur 10|Gabtoli': 14,
  'Mirpur 10|Hemayetpur': 36,
  'Mirpur 10|Savar': 43,
  'Mirpur 1|Gabtoli': 10,
  'Mirpur 1|Savar': 36,
  'Gabtoli|Hemayetpur': 23,
  'Gabtoli|Savar': 30,
  'Gabtoli|Nobinagar': 56,
  'Gabtoli|Nandan Park': 95,
  'Hemayetpur|Savar': 10,
  'Hemayetpur|Nobinagar': 33,
  'Savar|Nobinagar': 23,
  'Savar|Nandan Park': 62,
  'Nobinagar|Nandan Park': 34,
};

/// Approximate distances between adjacent landmark stops in Dhaka, in km.
///
/// Used by the per-km fare estimator when [fareChart] does not contain an
/// exact entry. Values come from the distance column of the official PDF
/// fare-chart pages and are stored bidirectionally via the lookup helper.
const Map<String, double> stopDistanceKm = {
  'Gabtoli|Technical': 1.0,
  'Technical|Kallyanpur': 1.0,
  'Kallyanpur|Shyamoli': 1.0,
  'Shyamoli|Shishu Mela': 1.0,
  'Shishu Mela|Agargaon': 1.5,
  'Agargaon|Bijoy Sarani': 1.5,
  'Bijoy Sarani|Jahangir Gate': 0.8,
  'Jahangir Gate|Mohakhali': 1.0,
  'Mohakhali|Banani': 1.5,
  'Banani|Kakali': 0.6,
  'Kakali|MES': 1.0,
  'MES|Kuril Bishwa Road': 1.5,
  'Kuril Bishwa Road|Khilkhet': 2.0,
  'Khilkhet|Airport': 2.5,
  'Airport|Jashimuddin': 1.0,
  'Jashimuddin|Rajlakshmi': 1.0,
  'Rajlakshmi|Azampur': 1.0,
  'Azampur|House Building': 0.6,
  'House Building|Abdullahpur': 1.5,
  'Abdullahpur|Tongi': 2.5,
  'Mirpur 1|Mirpur 2': 1.0,
  'Mirpur 2|Mirpur 10': 1.5,
  'Mirpur 10|Mirpur 11': 1.0,
  'Mirpur 10|Kazipara': 1.0,
  'Kazipara|Shewrapara': 0.8,
  'Notun Bazar|Bashtola': 0.8,
  'Bashtola|Shahjadpur': 0.8,
  'Shahjadpur|Uttar Badda': 0.8,
  'Uttar Badda|Badda': 0.6,
  'Badda|Madhya Badda': 0.6,
  'Madhya Badda|Merul Badda': 0.6,
  'Merul Badda|Rampura Bridge': 0.8,
  'Rampura Bridge|Banasree': 1.0,
  'GPO|Paltan': 0.5,
  'Paltan|Shahbag': 1.5,
  'Shahbag|Bangla Motor': 1.0,
  'Bangla Motor|Kawran Bazar': 0.8,
  'Kawran Bazar|Farmgate': 0.8,
  'Farmgate|Bijoy Sarani': 1.0,
};
