/// Approximate latitude / longitude for major Dhaka bus-stop landmarks.
///
/// Used by `MapScreen` (flutter_map + OSM tiles) to plot the route polyline
/// and stop markers. Stops not present here are interpolated linearly from
/// their neighbouring known coordinates at render time.
library;

import 'package:latlong2/latlong.dart';

const Map<String, LatLng> stopCoordinates = {
  // --- Mirpur / North-west ---
  'Gabtoli': LatLng(23.7806, 90.3531),
  'Technical': LatLng(23.7861, 90.3543),
  'Kallyanpur': LatLng(23.7873, 90.3617),
  'Shyamoli': LatLng(23.7732, 90.3651),
  'Shishu Mela': LatLng(23.7717, 90.3705),
  'College Gate': LatLng(23.7700, 90.3650),
  'Asad Gate': LatLng(23.7639, 90.3681),
  'Asad Avenue': LatLng(23.7651, 90.3674),
  'Manik Mia Avenue': LatLng(23.7654, 90.3760),
  'Khamar Bari': LatLng(23.7670, 90.3815),
  'Farmgate': LatLng(23.7585, 90.3895),
  'Bijoy Sarani': LatLng(23.7669, 90.3873),
  'Jahangir Gate': LatLng(23.7714, 90.3935),
  'Mohakhali': LatLng(23.7793, 90.4051),
  'Wireless': LatLng(23.7843, 90.4106),
  'Banani': LatLng(23.7937, 90.4047),
  'Kakali': LatLng(23.7972, 90.4055),
  'Kakli': LatLng(23.7972, 90.4055),
  'Chairman Bari': LatLng(23.7846, 90.4044),
  'Sainik Club': LatLng(23.7900, 90.4051),
  'Staff Road': LatLng(23.8009, 90.4068),
  'MES': LatLng(23.8071, 90.4090),
  'Kurmitola': LatLng(23.8127, 90.4108),
  'Shewra': LatLng(23.8164, 90.4189),
  'Sheora': LatLng(23.8164, 90.4189),
  'Sheora Bazar': LatLng(23.8200, 90.4140),
  'Sheoda Bazar': LatLng(23.8200, 90.4140),
  'Kuril Bishwa Road': LatLng(23.8255, 90.4252),
  'Kuril': LatLng(23.8255, 90.4252),
  'Khilkhet': LatLng(23.8348, 90.4239),
  'Airport': LatLng(23.8478, 90.4029),
  'Jashimuddin': LatLng(23.8541, 90.4011),
  'Rajlakshmi': LatLng(23.8650, 90.4001),
  'Azampur': LatLng(23.8697, 90.3999),
  'House Building': LatLng(23.8724, 90.3993),
  'Uttara': LatLng(23.8724, 90.3950),
  'Abdullahpur': LatLng(23.8836, 90.3998),
  'Tongi': LatLng(23.8918, 90.3996),
  'Station Road': LatLng(23.8949, 90.4014),
  'Mill Gate': LatLng(23.9092, 90.4070),
  'Board Bazar': LatLng(23.9416, 90.4170),
  'Gazipur Bypass': LatLng(23.9763, 90.4116),
  'Gazipur Chourasta': LatLng(23.9978, 90.4222),
  'Konabari': LatLng(23.9923, 90.3373),
  'Chandra': LatLng(24.0410, 90.2680),
  'Kamarpara': LatLng(23.8835, 90.3683),
  'Asulia Bazar': LatLng(23.8881, 90.3331),
  'Ashulia': LatLng(23.8881, 90.3331),
  'Zirabo': LatLng(23.9065, 90.2812),
  'Jamgora': LatLng(23.9203, 90.2588),
  'Fantasy Kingdom': LatLng(23.9335, 90.2393),
  'Fantasy': LatLng(23.9335, 90.2393),
  'Nandan Park': LatLng(23.9550, 90.2110),
  'Nandanpark': LatLng(23.9550, 90.2110),
  'Baipayl': LatLng(23.9425, 90.2110),
  'Nobinagar': LatLng(23.8835, 90.2521),
  'Nabinagar': LatLng(23.8835, 90.2521),
  'Savar': LatLng(23.8580, 90.2666),
  'Hemayetpur': LatLng(23.7926, 90.3083),
  'Amin Bazar': LatLng(23.7884, 90.3380),
  'Dhour': LatLng(23.9000, 90.3815),
  'Dhamrai': LatLng(23.9089, 90.2128),
  'EPZ': LatLng(23.9050, 90.2370),
  'Jirani': LatLng(23.9420, 90.2280),
  'Bashila': LatLng(23.7670, 90.3450),

  // --- Mirpur grid ---
  'Ansar Camp': LatLng(23.7958, 90.3543),
  'Mirpur 1': LatLng(23.7976, 90.3525),
  'Sony Cinema Hall': LatLng(23.8053, 90.3576),
  'Mirpur 2': LatLng(23.8067, 90.3650),
  'Mirpur 10': LatLng(23.8074, 90.3691),
  'Original 10': LatLng(23.8074, 90.3691),
  'Mirpur 11': LatLng(23.8190, 90.3666),
  'Mirpur 14': LatLng(23.8240, 90.3879),
  'Vashantek': LatLng(23.8329, 90.3924),
  'Bhashantek': LatLng(23.8329, 90.3924),
  'Purobi': LatLng(23.8224, 90.3727),
  'Kalshi': LatLng(23.8191, 90.3920),
  'Kalshi Moor': LatLng(23.8191, 90.3920),
  'Jillur Rahman Flyover': LatLng(23.8222, 90.3940),
  'ECB Square': LatLng(23.8244, 90.4059),
  'ECB Chottor': LatLng(23.8244, 90.4059),
  'Kazipara': LatLng(23.7975, 90.3739),
  'Shewrapara': LatLng(23.7900, 90.3781),
  'Taltola': LatLng(23.7825, 90.3789),
  'Agargaon': LatLng(23.7763, 90.3801),
  'Zia Uddyan': LatLng(23.7691, 90.3819),
  'Bangla College': LatLng(23.7975, 90.3567),
  'Darussalam': LatLng(23.7867, 90.3504),
  'Mazar Road': LatLng(23.7913, 90.3508),
  'Shia Masjid': LatLng(23.7647, 90.3578),
  'Mohammadpur Shia Masjid': LatLng(23.7647, 90.3578),
  'Adabor': LatLng(23.7665, 90.3599),
  'Ring Road': LatLng(23.7679, 90.3615),
  'Shyamoli Ring Road': LatLng(23.7679, 90.3615),
  'Japan Garden City': LatLng(23.7654, 90.3585),
  'Mohammadpur': LatLng(23.7548, 90.3589),
  'Shankar': LatLng(23.7497, 90.3674),
  'Star Kabab': LatLng(23.7475, 90.3713),
  'Dhanmondi 15': LatLng(23.7472, 90.3768),
  'Dhanmondi 27': LatLng(23.7575, 90.3727),
  'Dhanmondi 32': LatLng(23.7531, 90.3760),
  'Shukrabad': LatLng(23.7569, 90.3777),
  'Kalabagan': LatLng(23.7508, 90.3803),
  'City College': LatLng(23.7459, 90.3807),
  'Science Lab': LatLng(23.7384, 90.3836),
  'New Market': LatLng(23.7341, 90.3853),
  'Nilkhet': LatLng(23.7314, 90.3869),
  'Azimpur': LatLng(23.7281, 90.3865),
  'Bakshi Bazar': LatLng(23.7211, 90.3960),
  'Chankharpul': LatLng(23.7180, 90.4040),
  'Bata Signal': LatLng(23.7395, 90.3866),
  'Katabon': LatLng(23.7422, 90.3899),
  'Jigatola': LatLng(23.7437, 90.3729),
  'Bosila': LatLng(23.7587, 90.3413),

  // --- Central / South ---
  'Shahbag': LatLng(23.7390, 90.3957),
  'Bangla Motor': LatLng(23.7421, 90.3951),
  'Kawran Bazar': LatLng(23.7503, 90.3927),
  'Matsya Bhaban': LatLng(23.7344, 90.4017),
  'High Court': LatLng(23.7311, 90.4040),
  'Press Club': LatLng(23.7286, 90.4063),
  'Paltan': LatLng(23.7295, 90.4150),
  'Bijoy Nagar': LatLng(23.7351, 90.4087),
  'Kakrail': LatLng(23.7392, 90.4082),
  'Shantinagar': LatLng(23.7419, 90.4143),
  'Malibagh': LatLng(23.7457, 90.4198),
  'Mouchak': LatLng(23.7494, 90.4126),
  'Mogbazar': LatLng(23.7470, 90.4023),
  'Sat rasta': LatLng(23.7641, 90.3919),
  'Satrasta': LatLng(23.7641, 90.3919),
  'Nabisco': LatLng(23.7741, 90.3996),
  'GPO': LatLng(23.7237, 90.4128),
  'Gulistan': LatLng(23.7256, 90.4131),
  'Motijheel': LatLng(23.7284, 90.4189),
  'Arambagh': LatLng(23.7232, 90.4172),
  'Kamalapur': LatLng(23.7320, 90.4262),
  'Fakirapool': LatLng(23.7295, 90.4220),
  'Fulbaria': LatLng(23.7235, 90.4112),
  'Mayor Mohammad Flyover': LatLng(23.7195, 90.4180),
  'Golap Shah Mazar': LatLng(23.7253, 90.4108),
  'Sadarghat': LatLng(23.7106, 90.4115),
  'Ray Saheb Bazar': LatLng(23.7140, 90.4083),
  'Naya Bazar': LatLng(23.7137, 90.4055),
  'Babubazar': LatLng(23.7151, 90.4022),
  'Keraniganj': LatLng(23.7020, 90.3984),
  'Kadamtali': LatLng(23.7024, 90.4137),
  'Dainik Bangla Moor': LatLng(23.7280, 90.4170),
  'Arambagh Notre Dame College': LatLng(23.7256, 90.4140),
  'Malibaag Moor': LatLng(23.7461, 90.4170),
  'Sayapabad': LatLng(23.7222, 90.4254),
  'Manik Nagar': LatLng(23.7252, 90.4286),
  'TT Para': LatLng(23.7290, 90.4266),

  // --- East / Badda corridor ---
  'Gulshan 1': LatLng(23.7798, 90.4147),
  'Badda Link Road': LatLng(23.7833, 90.4244),
  'Bashtola': LatLng(23.7889, 90.4305),
  'Shahjadpur': LatLng(23.7919, 90.4263),
  'Notun Bazar': LatLng(23.7977, 90.4254),
  'Nadda': LatLng(23.8089, 90.4239),
  'Bashundhara': LatLng(23.8136, 90.4214),
  'Jamuna Future Park': LatLng(23.8175, 90.4250),
  'Uttar Badda': LatLng(23.7842, 90.4290),
  'Badda': LatLng(23.7805, 90.4264),
  'Madhya Badda': LatLng(23.7773, 90.4250),
  'Merul Badda': LatLng(23.7723, 90.4210),
  'Rampura Bridge': LatLng(23.7644, 90.4233),
  'Rampura': LatLng(23.7644, 90.4233),
  'Rampura Bazar': LatLng(23.7613, 90.4229),
  'Banashree': LatLng(23.7621, 90.4317),
  'Hazipara': LatLng(23.7551, 90.4224),
  'Malibagh Railgate': LatLng(23.7491, 90.4221),
  'Khilgaon': LatLng(23.7458, 90.4283),
  'Khilgaon Flyover': LatLng(23.7474, 90.4300),
  'Khilgaon Bus Stand': LatLng(23.7445, 90.4310),
  'Sipahibagh': LatLng(23.7431, 90.4281),
  'Bashabo': LatLng(23.7384, 90.4314),
  'Mugdapara': LatLng(23.7365, 90.4357),
  'Jatrabari': LatLng(23.7113, 90.4337),
  'Shonir Akhra': LatLng(23.6943, 90.4441),
  // Sign Board (Shiddhirganj, Narayanganj) — junction of Dhaka–Chattogram
  // Hwy and the road to Demra. Verified vs distancesfrom.com / OSM.
  'Sign Board': LatLng(23.6919, 90.4815),
  'Demra': LatLng(23.7209, 90.4833),
  'Demra Bridge': LatLng(23.7218, 90.4823),
  'Demra Staff Quarter': LatLng(23.7286, 90.4694),
  'Staff Quarter': LatLng(23.7286, 90.4694),
  'Meradia': LatLng(23.7460, 90.4404),
  'Meradia Bazar': LatLng(23.7460, 90.4404),
  // Tarabo municipality centre, Rupganj. Verified vs db-city / OSM.
  'Tarabo': LatLng(23.7225, 90.5085),
  'Tarabo Bishroad': LatLng(23.7235, 90.5042),
  'Tarabo Bishworoad': LatLng(23.7235, 90.5042),
  // Kanchpur Bridge over Shitalakkhya. Verified vs Wikipedia GeoHack.
  'Kanchpur': LatLng(23.7036, 90.5176),
  'Kachpur': LatLng(23.7036, 90.5176),
  'Madanpur': LatLng(23.6976, 90.5610),
  'Sultana Kamal Bridge': LatLng(23.7340, 90.4854),
  'Bhulta Gausia': LatLng(23.7770, 90.5512),
  'Bhulta': LatLng(23.7770, 90.5512),
  'Bhorpa': LatLng(23.7700, 90.5400),
  'Rupshi': LatLng(23.7575, 90.5170),
  'Proshika Moor': LatLng(23.7920, 90.3500),
  'Shialbari': LatLng(23.8020, 90.3565),
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
