/// Approximate latitude / longitude for major Dhaka bus-stop landmarks.
///
/// Used by `MapScreen` (flutter_map + OSM tiles) to plot the route polyline
/// and stop markers. Stops not present here are interpolated linearly from
/// their neighbouring known coordinates at render time.
library;

import 'package:latlong2/latlong.dart';

const Map<String, LatLng> stopCoordinates = {
  // --- Mirpur / North-west ---
  'Gabtoli': LatLng(23.78105, 90.34398),
  'Technical': LatLng(23.78186, 90.35138),
  'Kallyanpur': LatLng(23.78068, 90.36133),
  'Shyamoli': LatLng(23.77497, 90.36571),
  'Shishu Mela': LatLng(23.77300, 90.36749),
  'College Gate': LatLng(23.76942, 90.36889),
  'Asad Gate': LatLng(23.76053, 90.37263),
  'Asad Avenue': LatLng(23.7608, 90.3718),
  'Manik Mia Avenue': LatLng(23.7654, 90.3760),
  'Khamar Bari': LatLng(23.75913, 90.38388),
  'Farmgate': LatLng(23.75902, 90.38712),
  'Bijoy Sarani': LatLng(23.7669, 90.3873),
  // Jahangir Gate (south entrance to Dhaka Cantonment). Verified vs Wikimapia / WorldPlaces.
  'Jahangir Gate': LatLng(23.7751, 90.3905),
  'Mohakhali': LatLng(23.7793, 90.4051),
  'Wireless': LatLng(23.78079, 90.40543),
  'Banani': LatLng(23.79432, 90.40145),
  'Kakali': LatLng(23.7972, 90.4055),
  'Kakli': LatLng(23.7972, 90.4055),
  'Chairman Bari': LatLng(23.78815, 90.40100),
  'Sainik Club': LatLng(23.7900, 90.4051),
  'Staff Road': LatLng(23.81170, 90.40369),
  'MES': LatLng(23.81615, 90.40495),
  'Kurmitola': LatLng(23.82519, 90.40579),
  'Shewra': LatLng(23.81904, 90.41552),
  'Sheora': LatLng(23.8164, 90.4189),
  'Sheora Bazar': LatLng(23.8200, 90.4140),
  'Sheoda Bazar': LatLng(23.8200, 90.4140),
  'Kuril Bishwa Road': LatLng(23.82024, 90.42038),
  'Kuril': LatLng(23.81973, 90.42364),
  'Khilkhet': LatLng(23.83167, 90.42483),
  'Airport': LatLng(23.8478, 90.4029),
  'Jashimuddin': LatLng(23.86086, 90.40005),
  'Rajlakshmi': LatLng(23.86448, 90.40021),
  'Azampur': LatLng(23.86799, 90.40018),
  'House Building': LatLng(23.87483, 90.40069),
  'Uttara': LatLng(23.86933, 90.39269),
  'Abdullahpur': LatLng(23.87964, 90.40119),
  'Tongi': LatLng(23.89379, 90.40349),
  'Station Road': LatLng(23.89306, 90.40203),
  'Mill Gate': LatLng(23.89601, 90.39938),
  'Board Bazar': LatLng(23.94528, 90.38274),
  'Gazipur Bypass': LatLng(23.9795, 90.3712),
  'Gazipur Chourasta': LatLng(23.9978, 90.4222),
  'Konabari': LatLng(24.01083, 90.32094),
  'Chandra': LatLng(24.04703, 90.23915),
  'Kamarpara': LatLng(23.89116, 90.38858),
  'Asulia Bazar': LatLng(23.8970, 90.3290),
  'Ashulia': LatLng(23.8970, 90.3290),
  'Zirabo': LatLng(23.91317, 90.31878),
  'Jamgora': LatLng(23.9373, 90.2857),
  'Fantasy Kingdom': LatLng(23.9335, 90.2393),
  'Fantasy': LatLng(23.9335, 90.2393),
  'Nandan Park': LatLng(23.9550, 90.2110),
  'Nandanpark': LatLng(23.9550, 90.2110),
  'Baipayl': LatLng(23.93800, 90.27006),
  'Nobinagar': LatLng(23.91235, 90.25988),
  'Nabinagar': LatLng(23.8835, 90.2521),
  'Savar': LatLng(23.85885, 90.26261),
  'Hemayetpur': LatLng(23.79306, 90.27194),
  'Amin Bazar': LatLng(23.78504, 90.33144),
  'Dhour': LatLng(23.89062, 90.36857),
  'Dhamrai': LatLng(23.9183, 90.2142),
  'EPZ': LatLng(23.95020, 90.27400),
  'Jirani': LatLng(23.9420, 90.2280),
  // Bashila / Bosila (Mohammadpur, near the Bosila Bridge over Buriganga). Verified vs distancesfrom.com.
  'Bashila': LatLng(23.7547, 90.3589),

  // --- Mirpur grid ---
  'Ansar Camp': LatLng(23.79110, 90.35392),
  'Mirpur 1': LatLng(23.79817, 90.35312),
  'Sony Cinema Hall': LatLng(23.8053, 90.3576),
  'Mirpur 2': LatLng(23.80539, 90.36313),
  'Mirpur 10': LatLng(23.80837, 90.36828),
  'Original 10': LatLng(23.81029, 90.36753),
  'Mirpur 11': LatLng(23.81910, 90.36531),
  'Mirpur 14': LatLng(23.79871, 90.38677),
  'Vashantek': LatLng(23.8329, 90.3924),
  'Bhashantek': LatLng(23.8329, 90.3924),
  'Purobi': LatLng(23.81906, 90.36523),
  'Kalshi': LatLng(23.8215, 90.3772),
  'Kalshi Moor': LatLng(23.8215, 90.3772),
  'Jillur Rahman Flyover': LatLng(23.8222, 90.3940),
  'ECB Square': LatLng(23.8226, 90.3934),
  'ECB Chottor': LatLng(23.82258, 90.39362),
  'Kazipara': LatLng(23.79925, 90.37202),
  'Shewrapara': LatLng(23.79049, 90.37555),
  'Taltola': LatLng(23.78330, 90.37853),
  'Agargaon': LatLng(23.77843, 90.38010),
  'Zia Uddyan': LatLng(23.7691, 90.3819),
  'Bangla College': LatLng(23.7975, 90.3567),
  'Darussalam': LatLng(23.78005, 90.35421),
  'Mazar Road': LatLng(23.79503, 90.34861),
  'Shia Masjid': LatLng(23.7647, 90.3578),
  'Mohammadpur Shia Masjid': LatLng(23.7647, 90.3578),
  'Adabor': LatLng(23.77375, 90.36174),
  'Ring Road': LatLng(23.7737, 90.3621),
  'Shyamoli Ring Road': LatLng(23.7737, 90.3621),
  'Japan Garden City': LatLng(23.7654, 90.3585),
  'Mohammadpur': LatLng(23.75770, 90.36232),
  'Shankar': LatLng(23.7497, 90.3674),
  'Star Kabab': LatLng(23.74745, 90.37071),
  'Dhanmondi 15': LatLng(23.74436, 90.37289),
  'Dhanmondi 27': LatLng(23.75603, 90.37572),
  'Dhanmondi 32': LatLng(23.75173, 90.37787),
  'Shukrabad': LatLng(23.75371, 90.37978),
  'Kalabagan': LatLng(23.74897, 90.37952),
  'City College': LatLng(23.73910, 90.38332),
  'Science Lab': LatLng(23.73843, 90.38367),
  'New Market': LatLng(23.73422, 90.38447),
  'Nilkhet': LatLng(23.73190, 90.38509),
  'Azimpur': LatLng(23.72746, 90.38641),
  'Bakshi Bazar': LatLng(23.72256, 90.39556),
  'Chankharpul': LatLng(23.7231, 90.3999),
  'Bata Signal': LatLng(23.73899, 90.38826),
  'Katabon': LatLng(23.73864, 90.39142),
  'Jigatola': LatLng(23.73901, 90.37100),
  'Bosila': LatLng(23.7547, 90.3589),

  // --- Central / South ---
  'Shahbag': LatLng(23.73831, 90.39541),
  'Bangla Motor': LatLng(23.74535, 90.39501),
  'Kawran Bazar': LatLng(23.7503, 90.3927),
  'Matsya Bhaban': LatLng(23.7344, 90.4017),
  'High Court': LatLng(23.73168, 90.40489),
  'Press Club': LatLng(23.73014, 90.40735),
  'Paltan': LatLng(23.73131, 90.41209),
  'Bijoy Nagar': LatLng(23.7351, 90.4087),
  'Kakrail': LatLng(23.73765, 90.40831),
  'Shantinagar': LatLng(23.74157, 90.41206),
  'Malibagh': LatLng(23.74645, 90.41594),
  'Mouchak': LatLng(23.74587, 90.41218),
  'Mogbazar': LatLng(23.75197, 90.40797),
  'Sat rasta': LatLng(23.7641, 90.3919),
  'Satrasta': LatLng(23.7641, 90.3919),
  'Nabisco': LatLng(23.7741, 90.3996),
  'GPO': LatLng(23.7237, 90.4128),
  'Gulistan': LatLng(23.7256, 90.4131),
  'Motijheel': LatLng(23.72808, 90.41907),
  'Arambagh': LatLng(23.73084, 90.42120),
  'Kamalapur': LatLng(23.73172, 90.42547),
  'Fakirapool': LatLng(23.7340, 90.4180),
  'Fulbaria': LatLng(23.72279, 90.41034),
  'Mayor Mohammad Flyover': LatLng(23.7164, 90.4290),
  'Golap Shah Mazar': LatLng(23.7253, 90.4108),
  'Sadarghat': LatLng(23.7106, 90.4115),
  'Ray Saheb Bazar': LatLng(23.7140, 90.4083),
  'Naya Bazar': LatLng(23.71461, 90.40854),
  'Babubazar': LatLng(23.71077, 90.40274),
  'Keraniganj': LatLng(23.70141, 90.39762),
  'Kadamtali': LatLng(23.7024, 90.4137),
  'Dainik Bangla Moor': LatLng(23.7280, 90.4170),
  'Arambagh Notre Dame College': LatLng(23.7302, 90.4208),
  'Malibaag Moor': LatLng(23.7461, 90.4170),
  'Sayapabad': LatLng(23.7222, 90.4254),
  'Manik Nagar': LatLng(23.72249, 90.42894),
  'TT Para': LatLng(23.7290, 90.4266),

  // --- East / Badda corridor ---
  'Gulshan 1': LatLng(23.7798, 90.4147),
  'Badda Link Road': LatLng(23.7704, 90.4229),
  'Bashtola': LatLng(23.79438, 90.42408),
  'Shahjadpur': LatLng(23.79209, 90.42450),
  'Notun Bazar': LatLng(23.79691, 90.42375),
  'Nadda': LatLng(23.8089, 90.4239),
  'Bashundhara': LatLng(23.8167, 90.4294),
  'Jamuna Future Park': LatLng(23.8175, 90.4250),
  'Uttar Badda': LatLng(23.78570, 90.42561),
  'Badda': LatLng(23.77786, 90.42569),
  // Madhya Badda (Middle Badda) bazar. Verified vs near-place.com.
  'Madhya Badda': LatLng(23.7793, 90.4254),
  'Merul Badda': LatLng(23.77166, 90.42539),
  'Rampura Bridge': LatLng(23.76792, 90.42317),
  'Rampura': LatLng(23.76261, 90.42057),
  'Rampura Bazar': LatLng(23.7613, 90.4229),
  'Banashree': LatLng(23.7621, 90.4317),
  'Hazipara': LatLng(23.7576, 90.4152),
  'Malibagh Railgate': LatLng(23.74970, 90.41263),
  'Khilgaon': LatLng(23.74700, 90.42420),
  // OSM Khilgaon Flyover (south end, Mugda side).
  'Khilgaon Flyover': LatLng(23.74340, 90.42429),
  'Khilgaon Bus Stand': LatLng(23.74700, 90.42420),
  'Sipahibagh': LatLng(23.7513, 90.4309),
  'Bashabo': LatLng(23.74055, 90.43335),
  'Mugdapara': LatLng(23.73118, 90.42866),
  'Jatrabari': LatLng(23.71051, 90.43388),
  'Shonir Akhra': LatLng(23.7037, 90.4509),
  // Sign Board (Shiddhirganj, Narayanganj) — junction of Dhaka–Chattogram
  // Hwy and the road to Demra. Verified vs distancesfrom.com / OSM.
  // OSM Sign Board Bus Stop station node (near Shiddhirganj / Shimrail).
  'Sign Board': LatLng(23.69358, 90.48044),
  // Demra (suburb centroid). Verified vs OSM.
  'Demra': LatLng(23.72849, 90.49740),
  'Demra Bridge': LatLng(23.72180, 90.50040),
  'Demra Staff Quarter': LatLng(23.7286, 90.4694),
  'Staff Quarter': LatLng(23.72001, 90.49034),
  'Meradia': LatLng(23.75493, 90.43625),
  'Meradia Bazar': LatLng(23.7460, 90.4404),
  // Tarabo municipality centre, Rupganj. Verified vs db-city / OSM.
  // Tarabo (town centroid). Verified vs OSM.
  'Tarabo': LatLng(23.72553, 90.51541),
  'Tarabo Bishroad': LatLng(23.7235, 90.5042),
  'Tarabo Bishworoad': LatLng(23.7235, 90.5042),
  // Kanchpur Bridge over Shitalakkhya. Verified vs Wikipedia GeoHack.
  // Kanchpur Bridge / bus stop. Verified vs OSM bus_station node.
  'Kanchpur': LatLng(23.70584, 90.52174),
  'Kachpur': LatLng(23.7036, 90.5176),
  // Madanpur (suburb centroid). Verified vs OSM.
  'Madanpur': LatLng(23.70769, 90.55724),
  // Sultana Kamal Bridge (Demra Bridge over Shitalakkhya). Verified vs Wikipedia GeoHack.
  'Sultana Kamal Bridge': LatLng(23.7218, 90.5004),
  'Bhulta Gausia': LatLng(23.7837, 90.5673),
  'Bhulta': LatLng(23.78459, 90.56528),
  'Bhorpa': LatLng(23.7700, 90.5400),
  'Rupshi': LatLng(23.74030, 90.52544),
  'Proshika Moor': LatLng(23.8096, 90.3610),
  'Shialbari': LatLng(23.8101, 90.3571),
};

/// Convenience: case-insensitive lookup that tries exact, then substring
/// matches against `stopCoordinates`. Returns `null` if no candidate found.
LatLng? coordinateForStop(String name) {
  final q = name.trim();
  if (q.isEmpty) return null;
  // Exact case-sensitive first
  final exact = stopCoordinates[q];
  if (exact != null) return exact;
  // Case-insensitive
  final qLower = q.toLowerCase();
  for (final entry in stopCoordinates.entries) {
    if (entry.key.toLowerCase() == qLower) return entry.value;
  }
  // Substring fallback (longest match wins). Digit-aware so "Mirpur 12"
  // doesn't get the coordinates for "Mirpur 1".
  String? bestKey;
  for (final entry in stopCoordinates.entries) {
    final k = entry.key.toLowerCase();
    if (_digitAwareContains(k, qLower) ||
        _digitAwareContains(qLower, k)) {
      if (bestKey == null || entry.key.length > bestKey.length) {
        bestKey = entry.key;
      }
    }
  }
  return bestKey == null ? null : stopCoordinates[bestKey];
}

bool _digitAwareContains(String haystack, String needle) {
  if (needle.isEmpty || haystack.isEmpty) return false;
  final idx = haystack.indexOf(needle);
  if (idx < 0) return false;
  final before = idx == 0 ? null : haystack.codeUnitAt(idx - 1);
  final afterIdx = idx + needle.length;
  final after =
      afterIdx >= haystack.length ? null : haystack.codeUnitAt(afterIdx);
  if (before != null && before >= 0x30 && before <= 0x39) return false;
  if (after != null && after >= 0x30 && after <= 0x39) return false;
  return true;
}
