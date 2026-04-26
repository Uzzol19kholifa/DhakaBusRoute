import '../models/bus_route.dart';

// All bus routes for Dhaka city.
//
// Source: dhakabusservice.com (Dhaka Bus Service / DBS).
// Each route's `stops` are listed in the natural traversal order, but routes
// are treated as bidirectional in the search logic.

const List<BusRoute> allRoutes = [

  BusRoute(
    name: 'Achim Paribahan', nameBn: 'আছিম পরিবহন',
    stops: ['Gabtoli','Technical','Ansar Camp','Mirpur 1','Sony Cinema Hall','Mirpur 2','Mirpur 10','Mirpur 11','Purobi','Kalshi','ECB Square','MES','Shewra','Kuril Bishwa Road','Jamuna Future Park','Bashundhara','Nadda','Notun Bazar','Bashtola','Shahjadpur','Uttar Badda','Badda','Madhya Badda','Merul Badda','Rampura Bridge','Banasree','Demra Staff Quarter'],
    startTime: '06:00 AM', endTime: '11:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Active Paribahan', nameBn: 'এক্টিভ পরিবহন',
    stops: ['Shia Masjid','Adabor','Shyamoli','Technical','Ansar Camp','Mirpur 1','Sony Cinema Hall','Mirpur 2','Mirpur 10','Mirpur 11','Purobi','Kalshi','ECB Square','MES','Shewrapara','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur'],
    startTime: '06:00 AM', endTime: '10:30 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Agradut', nameBn: 'অগ্রদূত',
    stops: ['Savar','Hemayetpur','Amin Bazar','Gabtoli','Technical','Kallyanpur','Shyamoli','Shishu Mela','Agargaon','Zia Uddyan','Bijoy Sarani','Jahangir Gate','Mohakhali','Wireless','Gulshan 1','Badda Link Road','Bashtola','Shahjadpur','Uttar Badda','Notun Bazar'],
    startTime: '05:30 AM', endTime: '10:30 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Airport Bangabandhu Avenue', nameBn: 'এয়ারপোর্ট বঙ্গবন্ধু এভিনিউ পরিবহন',
    stops: ['Fulbaria','Golap Shah Mazar','GPO','Paltan','Press Club','High Court','Matsya Bhaban','Shahbag','Bangla Motor','Kawran Bazar','Farmgate','Bijoy Sarani','Jahangir Gate','Mohakhali','Chairman Bari','Sainik Club','Banani','Kakali','Staff Road','MES','Kurmitola','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','House Building','Abdullahpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Azmeri Glory Limited', nameBn: 'আজমেরী গ্লোরী লিমিটেড',
    stops: ['Sadarghat','Ray Saheb Bazar','Naya Bazar','Golap Shah Mazar','GPO','Paltan','Kakrail','Shantinagar','Malibagh','Mouchak','Nabisco','Mohakhali','Sainik Club','Banani','Kakali','Staff Road','MES','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Tongi','Station Road','Mill Gate','Board Bazar','Gazipur Bypass','Konabari','Chandra'],
    startTime: '06:00 AM', endTime: '12:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Ajmi', nameBn: 'আজমী',
    stops: ['Dhamrai','Savar','Hemayetpur','Amin Bazar','Gabtoli','Technical','Kallyanpur','Shyamoli','Shishu Mela','College Gate','Asad Gate','Dhanmondi 27','Dhanmondi 32','Kalabagan','City College','New Market','Nilkhet','Azimpur','Bakshi Bazar','Gulistan','Chittagong Road'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Akash', nameBn: 'আকাশ',
    stops: ['Kadamtali','Keraniganj','Babubazar','Naya Bazar','Golap Shah Mazar','GPO','Paltan','Kakrail','Shantinagar','Malibagh','Mouchak','Malibagh Railgate','Hazipara','Rampura Bazar','Merul Badda','Badda','Shahjadpur','Bashtola','Notun Bazar','Nadda','Bashundhara','Jamuna Future Park','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Tongi'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Akik', nameBn: 'আকিক',
    stops: ['Ansar Camp','Mirpur 1','Sony Cinema Hall','Mirpur 2','Mirpur 10','Mirpur 11','Purobi','Kalshi','ECB Square','MES','Shewra','Kuril Bishwa Road','Jamuna Future Park','Bashundhara','Nadda','Notun Bazar','Bashtola','Shahjadpur','Uttar Badda'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Al Makka', nameBn: 'আল মক্কা',
    stops: ['Motijheel','Gulistan','GPO','Paltan','Kakrail','Shantinagar','Malibagh','Mouchak','Mogbazar','Nabisco','Mohakhali','Chairman Bari','Kakali','Banani','ECB Square','Kalshi','Purobi','Mirpur 10','Mirpur 2','Mirpur 1'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Al Madina Plus One', nameBn: 'আল মদিনা প্লাস ওয়ান',
    stops: ['Nandan Park','Zirani Bazar','Baipayl','Nobinagar','Savar','Hemayetpur','Amin Bazar','Gabtoli','Technical','Kallyanpur','Shyamoli','Shishu Mela','College Gate','Asad Gate','Khamar Bari','Farmgate','Kawran Bazar','Bangla Motor','Shahbag','High Court','Press Club','Paltan','GPO','Gulistan','Motijheel','Kamalapur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Alif', nameBn: 'আলিফ',
    stops: ['Mirpur 14','Mirpur 10','Mirpur 2','Sony Cinema Hall','Mirpur 1','Mazar Road','Konabari','Rupnagar','Beribadh','Birulia','Ashulia','Zirabo','Fantasy Kingdom','Nandan Park'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Alif 2', nameBn: 'আলিফ',
    stops: ['Shia Masjid','Japan Garden City','Adabor','Shyamoli','Shishu Mela','Agargaon','Zia Uddyan','Bijoy Sarani','Jahangir Gate','Mohakhali','Wireless','Gulshan 1','Badda Link Road','Madhya Badda','Merul Badda','Rampura Bridge','Banasree'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Alif 3', nameBn: 'আলিফ',
    stops: ['Mirpur 1','Mirpur 2','Mirpur 10','Kazipara','Shewrapara','Agargaon','Bijoy Sarani','Jahangir Gate','Mohakhali','Wireless','Gulshan 1','Badda Link Road','Madhya Badda','Merul Badda','Rampura Bridge','Banasree'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Alif 4', nameBn: 'আলিফ',
    stops: ['Japan Garden City','Ring Road','Adabor','Shyamoli','Shishu Mela','Agargaon','Zia Uddyan','Bijoy Sarani','Jahangir Gate','Mohakhali','Chairman Bari','Sainik Club','Kakali','Banani','Staff Road','MES','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Anabil Super', nameBn: 'অনাবিল সুপার',
    stops: ['Sign Board','Shonir Akhra','Jatrabari','Mugdapara','Bashabo','Khilgaon','Malibagh Railgate','Hazipara','Rampura Bazar','Rampura Bridge','Merul Badda','Uttar Badda','Shahjadpur','Nadda','Bashtola','Notun Bazar','Khilkhet','Bashundhara','Jamuna Future Park','Kuril Bishwa Road','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Tongi','Station Road','Mill Gate','Board Bazar','Gazipur Bypass','Gazipur Chourasta'],
    startTime: '06:00 AM', endTime: '12:00 AM', serviceType: 'Seating',
  ),

  BusRoute(
    name: 'Arnob', nameBn: 'অরনব',
    stops: ['Hemayetpur','Amin Bazar','Gabtoli','Technical','Kallyanpur','Shyamoli','Shishu Mela','Agargaon','Zia Uddyan','Bijoy Sarani','Jahangir Gate','Mohakhali','Wireless','Abdullahpur','Badda Link Road','Madhya Badda','Merul Badda','Rampura Bridge','Banasree','Demra Staff Quarter'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Ashirbad Paribahan', nameBn: 'আশীর্বাদ পরিবহন',
    stops: ['Duairipara','Rupnagar Abashik','Shiyal Bari','Proshika Moor','Mirpur 2','Mirpur 1','Ansar Camp','Technical','Kallyanpur','Shyamoli','Shishu Mela','College Gate','Asad Gate','Dhanmondi 27','Shukrabad','Dhanmondi 32','Kalabagan','City College','New Market','Nilkhet','Azimpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Ashulia Classic', nameBn: 'আশুলিয়া ক্লাসিক',
    stops: ['Nobinagar','Baipayl','Jamgora','Fantasy Kingdom','Zirabo','Asulia Bazar','Kamarpara','Abdullahpur','House Building','Azampur','Rajlakshmi','Jashimuddin','Airport','Khilkhet','Kuril Bishwa Road','Shewra','MES','Kakali','Banani','Chairman Bari','Mohakhali','Nabisco','Sat rasta'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Asmani', nameBn: 'আসমানী',
    stops: ['Dhour','Abdullahpur','House Building','Azampur','Rajlakshmi','Jashimuddin','Airport','Khilkhet','Kuril Bishwa Road','Jamuna Future Park','Bashundhara','Nadda','Notun Bazar','Bashtola','Shahjadpur','Uttar Badda','Badda','Madhya Badda','Merul Badda','Rampura Bridge','Banasree','Demra Staff Quarter','Tarabo','Madanpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'ATCL', nameBn: 'এটিসিএল',
    stops: ['Mohammadpur','Asad Gate','Shukrabad','Kalabagan','City College','Science Lab','Katabon','Bata Signal','Shahbag','Matsya Bhaban','High Court','Press Club','Paltan','GPO','Gulistan','Arambagh Notre Dame College'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Ayat', nameBn: 'আয়াত',
    stops: ['Chiriyakhana','Sony Cinema Hall','Mirpur 2','Mirpur 10','Kazipara','Shewrapara','Taltola','Agargaon','Khamar Bari','Farmgate','Kawran Bazar','Bangla Motor','Mogbazar','Mouchak','Malibaag Moor','Rajarbag','Kamalapur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Bahon', nameBn: 'বাহন',
    stops: ['Mirpur 14','Mirpur 10','Mirpur 2','Mirpur 1','Ansar Camp','Bangla College','Technical','Darussalam','Kallyanpur','Shyamoli','Asad Gate','Dhanmondi 27','Dhanmondi 32','Kalabagan','Science Lab','Katabon','Shahbag','High Court','Press Club','Paltan','Dainik Bangla Moor','Motijheel','Arambagh','Kamalapur','Mugdapara','Bashabo','Khilgaon'],
    startTime: '06:00 AM', endTime: '11:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Baishakhi', nameBn: 'বৈশাখী',
    stops: ['Savar','Hemayetpur','Amin Bazar','Gabtoli','Technical','Kallyanpur','Shyamoli','Shishu Mela','Agargaon','Bijoy Sarani','Jahangir Gate','Mohakhali','Gulshan 1','Badda Link Road','Bashtola','Uttar Badda','Notun Bazar'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Balaka', nameBn: 'বলাকা',
    stops: ['Sayapabad','Manik Nagar','TT Para','Kamalapur','Malibaag Moor','Mouchak','Mogbazar','Sat rasta','Nabisco','Mohakhali','Chairman Bari','Banani','Kakali','Staff Road','MES','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Tongi','Station Road','Mill Gate','Board Bazar','Gazipur Bypass','Gazipur Chourasta'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Seating',
  ),

  BusRoute(
    name: 'Basumati', nameBn: 'বাসুমতি',
    stops: ['Gabtoli','Technical','Kallyanpur','Shyamoli','Shishu Mela','College Gate','Asad Gate','Manik Mia Avenue','Khamar Bari','Farmgate','Kawran Bazar','Bangla Motor','Shahbag','Matsya Bhaban','High Court','Press Club','Paltan','GPO','Golap Shah Mazar','Naya Bazar','Babubazar','Keraniganj','Maowa'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Basumati Transport', nameBn: 'বাসুমতি ট্রান্সপোর্ট',
    stops: ['Gabtoli','Mirpur 1','Sony Cinema Hall','Mirpur 2','Mirpur 10','Mirpur 11','Purobi','Kalshi','ECB Square','MES','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Tongi','Station Road','Mill Gate','Board Bazar','Gazipur Chourasta'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Best Satabdi', nameBn: 'বেষ্ট শতাব্দী',
    stops: ['Azimpur','Nilkhet','New Market','City College','Kalabagan','Dhanmondi 32','Dhanmondi 27','Khamar Bari','Farmgate','Jahangir Gate','Mohakhali','Chairman Bari','Sainik Club','Banani','Kakali','Staff Road','MES','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Dia Bari'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Best Transport', nameBn: 'বেষ্ট ট্রান্সপোর্ট',
    stops: ['Mirpur 10','Kazipara','Shewrapara','Taltola','Agargaon','Khamar Bari','Farmgate','Kawran Bazar','Bangla Motor','Shahbag','Matsya Bhaban','High Court','Press Club','Paltan','GPO','Gulistan','Motijheel','Sayapabad','Jatrabari'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Bhuiyan Paribahan', nameBn: 'ভূঁইয়া পরিবহন',
    stops: ['Japan Garden City','Ring Road','Adabor','Shyamoli','Shishu Mela','Agargaon','Zia Uddyan','Bijoy Sarani','Old Airport','Jahangir Gate','Mohakhali','Chairman Bari','Sainik Club','Kakali','Banani','Staff Road','MES','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Bihanga', nameBn: 'বিহঙ্গ',
    stops: ['Mirpur 12','Mirpur 11','Mirpur 10','Kazipara','Shewrapara','Agargaon','Bijoy Sarani','Jahangir Gate','Mohakhali','Wireless','Gulshan Bridge','Gulshan 1','Badda','Notun Bazar'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Bikalpa Auto', nameBn: 'বিকল্প অটো সুপার সার্ভিস',
    stops: ['Mirpur 12','Pallabi','Purobi','Mirpur 11','Mirpur 1','Kazipara','Shewrapara','Taltola','Agargaon','Bijoy Sarani','Farmgate','Kawran Bazar','Bangla Motor','Shahbag','Matsya Bhaban','High Court','Press Club','Paltan','GPO','Gulistan','Motijheel'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Bikalpa Super', nameBn: 'বিকল্প সুপার সার্ভিস',
    stops: ['Mirpur 12','Pallabi','Purobi','Mirpur 11','Mirpur 10','Kazipara','Shewrapara','Taltola','Agargaon','Shyamoli','Shishu Mela','College Gate','Asad Gate','Dhanmondi 27','Dhanmondi 32','Kalabagan','City College','New Market','Nilkhet','Azimpur','Dhakeshwari'],
    startTime: '06:00 AM', endTime: '11:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Bikash', nameBn: 'বিকাশ',
    stops: ['Azimpur','Nilkhet','New Market','City College','Kalabagan','Dhanmondi 27','Dhanmondi 32','Khamar Bari','Farmgate','Jahangir Gate','Mohakhali','Sainik Club','Banani','Kakali','Kuril Bishwa Road','Khilkhet','Airport','Abdullahpur','Kamarpara'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Bikash Paribahan', nameBn: 'বিকাশ পরিবহন',
    stops: ['Sign Board','Matuail','Rayerbag','Shonir Akhra','Jatrabari','Sayapabad','Gulistan','Chankhar Pul','Bakshi Bazar','Azimpur','Nilkhet','New Market','City College','Kalabagan','Dhanmondi 27','Dhanmondi 32','Khamar Bari','Farmgate','Jahangir Gate','Mohakhali','Chairman Bari','Sainik Club','Banani','Kakali','Staff Road','MES','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Kamarpara','Dhour'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Bondhu Paribahan', nameBn: 'বন্ধু পরিবহন',
    stops: ['Gulistan','GPO','Paltan','Kakrail','Shantinagar','Malibaag Moor','Mouchak','Malibagh Railgate','Hazipara','Rampura Bazar','Rampura Bridge','Merul Badda','Shahjadpur','Bashtola','Notun Bazar'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Borak', nameBn: 'বোরাক',
    stops: ['Palashi','Chittagong Road','Sonargao','Chasara','Meghna Ghat'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Bashumoti', nameBn: 'বসুমতি',
    stops: ['Gazipur Chourasta','Tongi','Airport','Khilkhet','Kalshi','Pallabi','Mirpur 11','Mirpur 10','Mirpur 1','Gabtoli'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'BRTC 1', nameBn: 'বি আর টিসি',
    stops: ['Madanpur','Kanchpur','Chittagong Road','Sign Board','Matuail','Rayerbag','Shonir Akhra','Jatrabari','Sayapabad','Gulistan','GPO','Paltan','Press Club','High Court','Matsya Bhaban','Shahbag','Bangla Motor','Kawran Bazar','Farmgate','Khamar Bari','Asad Gate','College Gate','Shishu Mela','Shyamoli','Kallyanpur','Technical','Gabtoli','Amin Bazar','Hemayetpur','Savar'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'BRTC 2', nameBn: 'বি আর টিসি',
    stops: ['Motijheel','Gulistan','GPO','Paltan','Press Club','High Court','Matsya Bhaban','Shahbag','Bangla Motor','Kawran Bazar','Farmgate','Jahangir Gate','Mohakhali','Chairman Bari','Kakali','Banani','Staff Road','MES','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Tongi'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'BRTC 3', nameBn: 'বি আর টিসি',
    stops: ['Mohammadpur','Asad Gate','Khamar Bari','Farmgate','Jahangir Gate','Mohakhali','Wireless','Gulshan 1','Badda Link Road','Uttar Badda','Shahjadpur','Bashtola','Notun Bazar','Nadda','Bashundhara','Jamuna Future Park','Kuril Bishwa Road'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'BRTC 4', nameBn: 'বি আর টিসি',
    stops: ['Kamalapur','Motijheel','Gulistan','GPO','Paltan','Press Club','High Court','Matsya Bhaban','Shahbag','Bangla Motor','Kawran Bazar','Farmgate','Jahangir Gate','Mohakhali','Wireless','Gulshan 1','Badda Link Road','Uttar Badda','Shahjadpur','Bashtola','Notun Bazar','Nadda','Bashundhara','Jamuna Future Park','Kuril Bishwa Road'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'BRTC 5', nameBn: 'বি আর টিসি',
    stops: ['Motijheel','Gulistan','GPO','Paltan','Kakrail','Shantinagar','Malibaag Moor','Mouchak','Malibagh Railgate','Hazipara','Rampura Bazar','Rampura Bridge','Merul Badda','Shahjadpur','Bashtola','Notun Bazar','Nadda','Bashundhara','Jamuna Future Park','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'BRTC Mohammadpur', nameBn: 'বি আর টিসি',
    stops: ['Mohammadpur','Star Kabab','Dhanmondi','Jigatola','City College','Science Lab','Shahbag','Matsya Bhaban','High Court','Press Club','Paltan','GPO','Gulistan','Motijheel'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'BRTC Gabtoli', nameBn: 'বি আর টিসি',
    stops: ['Gabtoli','Mirpur 1','Sony Cinema Hall','Mirpur 2','Mirpur 10','Mirpur 11','Purobi','Kalshi','ECB Square','MES','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Tongi','Mill Gate','Board Bazar','Gazipur Bypass','Gazipur Chourasta'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'BRTC Elevated Expressway', nameBn: 'বিআরটিসি এলিভেটেড',
    stops: ['Rajlakshmi','Airport','Kawlar','Farmgate','Bijoy Sarani'],
    startTime: '07:00 AM', endTime: '06:00 PM', serviceType: 'Seating',
  ),

  BusRoute(
    name: 'City Link', nameBn: 'সিটি লিংক',
    stops: ['Chittagong Road','Sign Board','Matuail','Rayerbag','Shonir Akhra','Jatrabari','Sayapabad','Gulistan','GPO','Paltan','Press Club','High Court','Matsya Bhaban','Shahbag','Bata Signal','Science Lab','City College','Jigatola','Dhanmondi 15','Star Kabab','Mohammadpur','Bosila','Ghatar Char'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'D Link', nameBn: 'ডি লিংক',
    stops: ['Fulbaria','Chankhar Pul','Bakshi Bazar','Azimpur','Nilkhet','New Market','City College','Kalabagan','Dhanmondi 32','Dhanmondi 27','Asad Gate','College Gate','Shishu Mela','Shyamoli','Kallyanpur','Darussalam','Technical','Gabtoli','Amin Bazar','Hemayetpur','Savar','Dhamrai'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'D One Transport', nameBn: 'ডি ওয়ান',
    stops: ['Motijheel','Dainik Bangla Moor','Paltan','Press Club','Matsya Bhaban','High Court','Shahbag','Bangla Motor','Kawran Bazar','Farmgate','Asad Gate','College Gate','Shishu Mela','Shyamoli','Kallyanpur','Technical','Gabtoli','Amin Bazar','Nobinagar','Dhamrai'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Desh Bangla', nameBn: 'দেশ বাংলা',
    stops: ['Postogola','Dholairpar','Jatrabari','Sayapabad','Mugdapara','Malibagh','Rampura Bazar','Rampura Bridge','Merul Badda','Uttar Badda','Bashtola','Notun Bazar','Nadda','Bashundhara','Jamuna Future Park','Kuril Chourasta','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Abdullahpur','Kamarpara'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Dewan', nameBn: 'দেওয়ান',
    stops: ['Azimpur','Eden College','Nilkhet','New Market','Science Lab','City College','Katabon','Shahbag','Bangla Motor','Kawran Bazar','Farmgate','Jahangir Gate','Mohakhali','Wireless','Gulshan 1','Badda','Badda Link Road','Uttar Badda','Shahjadpur','Bashtola','Notun Bazar','Nadda','Bashundhara','Jamuna Future Park','Kuril Bishwa Road'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Dhakar Chaka 1', nameBn: 'ঢাকার চাকা',
    stops: ['Police Plaza','Gulshan 1','Gulshan 2'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Seating',
  ),

  BusRoute(
    name: 'Dhakar Chaka 2', nameBn: 'ঢাকার চাকা',
    stops: ['Banani','Gulshan 2','Notun Bazar'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Seating',
  ),

  BusRoute(
    name: 'Dhaka Metro Service', nameBn: 'ঢাকার মেট্রো সার্ভিস',
    stops: ['Mirpur 1','Kallyanpur','Shyamoli','Asad Gate','Shukrabad','Kalabagan','Science Lab','New Market','Nilkhet','Azimpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Dhaka Paribahan', nameBn: 'ঢাকা পরিবহন',
    stops: ['Gulistan','Shahbag','Farmgate','Banani','Uttara','Shib Bari'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Dipon', nameBn: 'দিপন',
    stops: ['Tajmahal Road','Salimullah Road','Jakir Hossain Road','Star Kabab','Dhanmondi 15','Jigatola','City College','Science Lab','Shahbag','Matsya Bhaban','High Court','Press Club','Paltan','Baitul Mukarram','Gulistan','Motijheel','Arambagh'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Dishari', nameBn: 'দিসারি',
    stops: ['Chiriyakhana','Mirpur 1','Ansar Camp','Technical','Kallyanpur','Shyamoli','Shishu Mela','College Gate','Asad Gate','Khamar Bari','Farmgate','Kawran Bazar','Bangla Motor','Shahbag','Matsya Bhaban','High Court','Press Club','Paltan','GPO','Golap Shah Mazar','Naya Bazar','Babubazar','Keraniganj'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Elite', nameBn: 'এলিট',
    stops: ['Agargaon','Taltola','Shewrapara','Kazipara','Mirpur 10','Mirpur 11','Purobi','Pallabi','Kalshi','Kuril Bishwa Road','Airport','Jashimuddin','Rajlakshmi','House Building','Abdullahpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'ETC', nameBn: 'ইটিসি',
    stops: ['Golap Shah Mazar','Shahbag','Bangla Motor','Farmgate','Agargaon','Shewrapara','Kazipara','Mirpur 10','Pallabi','Mirpur 12'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'ETC Transport', nameBn: 'ইটিসি ট্রান্সপোর্ট',
    stops: ['Golap Shah Mazar','GPO','Paltan','Press Club','High Court','Matsya Bhaban','Shahbag','Bangla Motor','Kawran Bazar','Farmgate','Khamar Bari','Agargaon','Taltola','Shewrapara','Kazipara','Mirpur 10','Mirpur 11','Purobi','Pallabi','Mirpur 12'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Seating',
  ),

  BusRoute(
    name: 'Gazipur Paribahan', nameBn: 'গাজীপুর পরিবহন',
    stops: ['Motijheel','Paltan','Kakrail','Shantinagar','Malibaag Moor','Mouchak','Mogbazar','Nabisco','Mohakhali','Chairman Bari','Sainik Club','Kakali','Banani','Staff Road','MES','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Tongi','Station Road','Mill Gate','Board Bazar','Gazipur Chourasta','Shib Bari'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Green Anabil', nameBn: 'গ্রীন অনাবিল',
    stops: ['Chasara','Shibu Market','Jalkuri','Sign Board','Matuail','Rayerbag','Shonir Akhra','Jatrabari','Sayapabad','Mugdapara','Bashabo','Malibagh Railgate','Hazipara','Rampura Bazar','Rampura Bridge','Merul Badda','Uttar Badda','Shahjadpur','Bashtola','Notun Bazar','Nadda','Bashundhara','Jamuna Future Park','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Tongi','Station Road','Mill Gate','Board Bazar','Gazipur Bypass','Gazipur Chourasta'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Green Dhaka', nameBn: 'গ্রীন ঢাকা',
    stops: ['Motijheel','Gulistan','GPO','Paltan','Kakrail','Shantinagar','Malibaag Moor','Mouchak','Malibagh Railgate','Hazipara','Rampura Bazar','Rampura Bridge','Merul Badda','Uttar Badda','Shahjadpur','Bashtola','Notun Bazar','Nadda','Bashundhara','Jamuna Future Park','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Seating',
  ),

  BusRoute(
    name: 'Hazi Transport', nameBn: 'হাজি ট্রান্সপোর্ট',
    stops: ['Mirpur 12','Pallabi','Purobi','Mirpur 10','Kazipara','Shewrapara','Agargaon','Bijoy Sarani','Farmgate','Kawran Bazar','Bangla Motor','Shahbag','Matsya Bhaban','High Court','Press Club','Paltan','GPO','Gulistan','Motijheel'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Himachal Suveccha', nameBn: 'হিমাচল শুভেচ্ছা',
    stops: ['Metro Hall','Chasara','Shibu Market','Jalkuri','Sign Board','Matuail','Rayerbag','Shonir Akhra','Jatrabari','Janapoth Moor','Gulistan','GPO','Paltan','Press Club','High Court','Matsya Bhaban','Shahbag','Bangla Motor','Kawran Bazar','Farmgate','Bijoy Sarani','Agargaon','Taltola','Shewrapara','Kazipara','Mirpur 10','Mirpur 11','Purobi','Pallabi','Mirpur 12'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Himalay', nameBn: 'হিমালয়',
    stops: ['Madanpur','Jatrabari','Bangladesh Bank','Mogbazar','Mohakhali','Tongi'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'J M Super Paribahan', nameBn: 'জে এম সুপার পরিবহন',
    stops: ['Jatrabari','Sayapabad','Mugdapara','Bashabo','Khilgaon','Malibagh Railgate','Hazipara','Rampura Bazar','Rampura Bridge','Merul Badda','Uttar Badda','Shahjadpur','Bashtola','Notun Bazar','Nadda','Bashundhara','Jamuna Future Park','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Tongi'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Jabale Noor 1', nameBn: 'জাবালে নুর পরিবহন',
    stops: ['Agargaon','Taltola','Shewrapara','Kazipara','Mirpur 10','Mirpur 11','Purobi','Pallabi','Kalshi','Kuril Bishwa Road','Airport','Jashimuddin','Rajlakshmi','House Building','Abdullahpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Jabale Noor 2', nameBn: 'জাবালে নুর পরিবহন',
    stops: ['Gabtoli','Mirpur 1','Mirpur 10','Kalshi','Kuril Flyover','Notun Bazar'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Kamal Plus Paribahan', nameBn: 'কামাল প্লাস পরিবহন',
    stops: ['Chittagong Road','Sign Board','Matuail','Rayerbag','Shonir Akhra','Jatrabari','Sayapabad','Gulistan','Chankhar Pul','Bakshi Bazar','Azimpur','Nilkhet','New Market','Science Lab','City College','Jigatola','Dhanmondi 15','Star Kabab','Shankar','Mohammadpur','Ghatar Char'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Kanak', nameBn: 'কনক',
    stops: ['Mirpur 1','Sony Cinema Hall','Mirpur 2','Mirpur 10','Mirpur 11','Purobi','Kalshi','ECB Square','MES','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Khajababa', nameBn: 'খাজা বাবা',
    stops: ['Jatrabari','Sayapabad','Gulistan','GPO','Paltan','Press Club','High Court','Matsya Bhaban','Shahbag','Bangla Motor','Kawran Bazar','Farmgate','Khamar Bari','Agargaon','Taltola','Shewrapara','Kazipara','Mirpur 10','Mirpur 11','Purobi','Pallabi','Mirpur 12'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Labbayek', nameBn: 'লাব্বাইক',
    stops: ['Savar','Hemayetpur','Amin Bazar','Gabtoli','Technical','Kallyanpur','Shyamoli','Shishu Mela','College Gate','Asad Gate','Khamar Bari','Farmgate','Kawran Bazar','Bangla Motor','Mogbazar','Mouchak','Malibaag Moor','Rajarbag','Khilgaon flyover','Bashabo','Mugdapara','Manik Nagar','Golapbagh Chowrasta','Sayapabad','Janapoth Moor','Jatrabari','Kazla','Shonir Akhra','Rayerbag','Matuail','Sign Board'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Seating',
  ),

  BusRoute(
    name: 'Lal Sabuj', nameBn: 'লাল সবুজ',
    stops: ['Nandan Park','Zirani Bazar','Baipayl','Nobinagar','Savar','Hemayetpur','Amin Bazar','Gabtoli','Technical','Kallyanpur','Shyamoli','Shishu Mela','College Gate','Asad Gate','Khamar Bari','Farmgate','Kawran Bazar','Bangla Motor','Shahbag','High Court','Press Club','Paltan','GPO','Gulistan','Motijheel'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Seating',
  ),

  BusRoute(
    name: 'Lams Paribahan', nameBn: 'লামস পরিবহন',
    stops: ['Mirpur 12','Pallabi','Purobi','Mirpur 11','Mirpur 1','Kazipara','Shewrapara','Taltola','Agargaon','Bijoy Sarani','Farmgate','Kawran Bazar','Bangla Motor','Shahbag','Matsya Bhaban','High Court','Press Club','Paltan','Dainik Bangla Moor','Motijheel'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Malancha', nameBn: 'মালঞ্চ',
    stops: ['Mohammadpur','Shankar','Star Kabab','Dhanmondi 15','Jigatola','City College','Science Lab','Bata Signal','Shahbag','Matsya Bhaban','High Court','Press Club','Paltan','GPO','Gulistan','Dayagonj','Dhupkhola'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Manjil Express', nameBn: 'মাঞ্জিল এক্সপ্রেস',
    stops: ['Chittagong Road','Sign Board','Matuail','Rayerbag','Shonir Akhra','Jatrabari','Sayapabad','Gulistan','GPO','Paltan','Kakrail','Malibaag Moor','Mouchak','Mogbazar'],
    startTime: '05:30 AM', endTime: '10:30 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Meshkat', nameBn: 'মেসকাত',
    stops: ['Mohammadpur','Asad Gate','Khamar Bari','Farmgate','Bangla Motor','Shahbag','Matsya Bhaban','Paltan','Dainik Bangla Moor','Motijheel','Ittefaq Moor','Sayapabad','Jatrabari','Shonir Akhra','Rayerbag','Matuail','Sign Board','Chittagong Road'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Midline', nameBn: 'মিডলাইন',
    stops: ['Mohammadpur','Shankar','Star Kabab','Dhanmondi 15','Jigatola','City College','Science Lab','Bata Signal','Shahbag','Matsya Bhaban','High Court','Press Club','Paltan','Gulistan','Motijheel','Arambagh','Kamalapur','Bashabo','Khilgaon'],
    startTime: '06:00 AM', endTime: '11:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Mirpur Metro Services', nameBn: 'মিরপুর মেট্রো সার্ভিস',
    stops: ['Azimpur','Nilkhet','New Market','Science Lab','City College','Kalabagan','Dhanmondi 32','Dhanmondi 27','Asad Gate','College Gate','Shishu Mela','Shyamoli','Kallyanpur','Darussalam','Technical','Bangla College','Tolarbag','Ansar Camp','Mirpur 1'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Mirpur Link', nameBn: 'মিরপুর লিংক',
    stops: ['ECB Square','Purobi','Mirpur 11','Mirpur 10','Kazipara','Shewrapara','Agargaon','Khamar Bari','Dhanmondi 27','Dhanmondi 32','City College','Nilkhet','New Market','Azimpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Mirpur Transport Service', nameBn: 'মিরপুর ট্রান্সপোর্ট সার্ভিস',
    stops: ['Gulistan','Golap Shah Mazar','GPO','Paltan','Press Club','High Court','Matsya Bhaban','Shahbag','Bangla Motor','Kawran Bazar','Farmgate','Khamar Bari','Agargaon','Taltola','Shewrapara','Kazipara','Mirpur 10','Mirpur 11','Purobi','Pallabi','Mirpur 12'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Mirpur United Service', nameBn: 'মিরপুর ইউনাইটেড সার্ভিস',
    stops: ['Sadarghat','Ray Saheb Bazar','Naya Bazar','Golap Shah Mazar','GPO','Paltan','Press Club','High Court','Matsya Bhaban','Shahbag','Bangla Motor','Kawran Bazar','Farmgate','Khamar Bari','Agargaon','Taltola','Shewrapara','Kazipara','Mirpur 10','Mirpur 11','Purobi','Pallabi','Mirpur 12'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'MM Lovely', nameBn: 'এম এম লাভলী',
    stops: ['Savar','Hemayetpur','Amin Bazar','Gabtoli','Technical','Kallyanpur','Shyamoli','Shishu Mela','College Gate','Asad Gate','Khamar Bari','Farmgate','Kawran Bazar','Bangla Motor','Mogbazar','Mouchak','Malibaag Moor','Rajarbag','Khilgaon flyover','Bashabo','Mugdapara','Manik Nagar','Golapbagh Chowrasta','Sayapabad','Janapoth Moor','Jatrabari','Kazla','Shonir Akhra','Rayerbag','Matuail','Sign Board'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Seating',
  ),

  BusRoute(
    name: 'Modhumita', nameBn: 'মধুমিতা',
    stops: ['Chiriyakhana','Sony Cinema Hall','Mirpur 2','Mirpur 1','Ansar Camp','Technical','Kallyanpur','Shyamoli','Shishu Mela','Agargaon','Bijoy Sarani','Jahangir Gate','Mohakhali','Wireless','Abdullahpur','Badda Link Road','Merul Badda','Rampura Bridge','Banasree'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Moitri', nameBn: 'মৈত্রী',
    stops: ['Mohammadpur','Shankar','Star Kabab','Dhanmondi 15','Jigatola','City College','Science Lab','Bata Signal','Shahbag','Matsya Bhaban','High Court','Press Club','Paltan','GPO','Gulistan','Motijheel','Arambagh'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Moumita', nameBn: 'মৌমিতা',
    stops: ['Chasara','Shibu Market','Jalkuri','Sign Board','Matuail','Rayerbag','Shonir Akhra','Jatrabari','Sayapabad','Gulistan','Chankhar Pul','Bakshi Bazar','Azimpur','Nilkhet','New Market','City College','Kalabagan','Dhanmondi 32','Dhanmondi 27','Asad Gate','College Gate','Shishu Mela','Shyamoli','Kallyanpur','Darussalam','Technical','Gabtoli','Amin Bazar','Hemayetpur','Savar','Baipayl','Zirani Bazar','Nandan Park','Chandra'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Nabakali', nameBn: 'নবকালি',
    stops: ['Chiriyakhana','Mirpur 1','Ansar Camp','Technical','Kallyanpur','Shyamoli','Shishu Mela','College Gate','Asad Gate','Dhanmondi 27','Shukrabad','Dhanmondi 32','Kalabagan','Science Lab','Katabon','Shahbag','High Court','Fulbaria','Naya Bazar','Babubazar','Keraniganj'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'New Vision', nameBn: 'নিউ ভিশন',
    stops: ['Chiriyakhana','Mirpur 1','Ansar Camp','Technical','Kallyanpur','Shyamoli','Shishu Mela','College Gate','Asad Gate','Khamar Bari','Farmgate','Kawran Bazar','Bangla Motor','Shahbag','High Court','Press Club','Paltan','Dainik Bangla Moor','Motijheel'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Nilachol', nameBn: 'নিলাচল',
    stops: ['Chittagong Road','Sign Board','Matuail','Rayerbag','Shonir Akhra','Jatrabari','Sayapabad','Gulistan','Chankhar Pul','Bakshi Bazar','Azimpur','Nilkhet','New Market','City College','Kalabagan','Dhanmondi 32','Dhanmondi 27','Asad Gate','College Gate','Shishu Mela','Shyamoli','Kallyanpur','Darussalam','Technical','Gabtoli','Amin Bazar','Hemayetpur','Savar','Nobinagar','Manikganj','Paturia'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Nishorgo', nameBn: 'নিসর্গ',
    stops: ['Mirpur 14','Mirpur 10','Kazipara','Shewrapara','Taltola','Agargaon','Asad Gate','Shyamoli','Mohammadpur','Shankar','Dhanmondi 15','Jigatola','Science Lab','New Market','Nilkhet','Eden College','Azimpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Omama International', nameBn: 'ওমামা ইন্টারন্যাশনাল বাস',
    stops: ['Motijheel','Dainik Bangla Moor','Paltan','Press Club','Matsya Bhaban','High Court','Shahbag','Bangla Motor','Kawran Bazar','Farmgate','Jahangir Gate','Mohakhali','Chairman Bari','Sainik Club','Banani','Kakali','Staff Road','MES','Shewra','Kuril Bishwa Road','Khilkhet','Airport'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'One Transport', nameBn: 'ওয়ান ট্রান্সপোর্ট',
    stops: ['Nandan Park','Zirani Bazar','Baipayl','Nobinagar','Savar','Hemayetpur','Amin Bazar','Gabtoli','Technical','Kallyanpur','Shyamoli','Shishu Mela','College Gate','Asad Gate','Khamar Bari','Farmgate','Kawran Bazar','Bangla Motor','Shahbag','High Court','Press Club','Paltan','GPO','Gulistan','Motijheel'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Pallabi Local Service', nameBn: 'পল্লবী লোকাল সার্ভিস',
    stops: ['Asad Gate','College Gate','Shishu Mela','Shyamoli','Kallyanpur','Technical','Mirpur 1','Sony Cinema Hall','Mirpur 2','Chalantika Mor','Mirpur 6','Mirpur 11','Mirpur 12'],
    startTime: '05:30 AM', endTime: '10:30 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Pallabi Super', nameBn: 'পল্লবী সুপার',
    stops: ['Gabtoli','Technical','Ansar Camp','Mirpur 1','Sony Cinema Hall','Mirpur 2','Mirpur 10','Mirpur 11','Purobi','Kalshi','ECB Square','MES','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Kamarpara'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Paristhan', nameBn: 'পরিস্থান',
    stops: ['Bosila','Mohammadpur','Asad Gate','College Gate','Shyamoli','Kallyanpur','Darussalam','Technical','Bangla College','Tolarbag','Ansar Camp','Mirpur 1','Mirpur 2','Mirpur 10','Mirpur 11','Purobi','Kalshi','ECB Square','MES','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','House Building','Abdullahpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Prochesta', nameBn: 'প্রচেষ্টা',
    stops: ['Maowa','Keraniganj','Babubazar','Naya Bazar','Golap Shah Mazar','GPO','Paltan','Kakrail','Shantinagar','Malibaag Moor','Mouchak','Malibagh Railgate','Hazipara','Rampura Bazar','Rampura Bridge','Merul Badda','Badda','Uttar Badda','Shahjadpur','Bashtola','Notun Bazar','Nadda','Bashundhara','Jamuna Future Park','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Projapati', nameBn: 'প্রজাপতি',
    stops: ['Bosila','Mohammadpur','Asad Gate','College Gate','Shyamoli','Kallyanpur','Darussalam','Technical','Bangla College','Ansar Camp','Mirpur 1','Mirpur 2','Mirpur 10','Mirpur 11','Purobi','Kalshi','ECB Square','MES','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','House Building','Abdullahpur','Kamarpara'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Provati Banasree', nameBn: 'প্রভাতী বনশ্রী',
    stops: ['Fulbaria','Golap Shah Mazar','GPO','Paltan','Kakrail','Shantinagar','Malibaag Moor','Mogbazar','Sat rasta','Nabisco','Mohakhali','Chairman Bari','Banani','Kakali','Staff Road','MES','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Tongi','Station Road','Mill Gate','Board Bazar','Gazipur Chourasta','Joydebpur','Sreepur','Barmi'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Raida', nameBn: 'রাইদা',
    stops: ['Postogola','Dholairpar','Jatrabari','Janapoth Moor','Sayapabad','Mugdapara','Bashabo','Khilgaon','Malibagh Railgate','Rampura Bazar','Rampura Bridge','Merul Badda','Badda','Uttar Badda','Bashtola','Notun Bazar','Nadda','Bashundhara','Jamuna Future Park','Kuril Chourasta','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Dia Bari'],
    startTime: '06:00 AM', endTime: '11:00 PM', serviceType: 'Seating',
  ),

  BusRoute(
    name: 'Raja City', nameBn: 'রাজা সিটি',
    stops: ['Postogola','Jurain','Dayagonj','Gulistan','GPO','Paltan','Press Club','High Court','Shahbag','Bata Signal','Science Lab','City College','Jigatola','Dhanmondi 15','Star Kabab','Shankar','Mohammadpur','Bosila','Ghatar Char'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Rajanigandha', nameBn: 'রজনীগন্ধা',
    stops: ['Chittagong Road','Sign Board','Matuail','Rayerbag','Shonir Akhra','Jatrabari','Sayapabad','Gulistan','GPO','Paltan','Press Club','High Court','Shahbag','Bata Signal','Science Lab','Jigatola','Dhanmondi','Star Kabab','Shankar','Mohammadpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Rajdhani Super', nameBn: 'রাজধানী',
    stops: ['Hemayetpur','Gabtoli','Technical','Ansar Camp','Mirpur 1','Sony Cinema Hall','Mirpur 2','Mirpur 10','Mirpur 11','Purobi','Kalshi','ECB Square','MES','Shewra','Kuril Bishwa Road','Jamuna Future Park','Bashundhara','Nadda','Notun Bazar','Bashtola','Shahjadpur','Uttar Badda','Badda','Madhya Badda','Merul Badda','Rampura Bridge','Banasree','Demra Staff Quarter'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Ramjan', nameBn: 'রমজান',
    stops: ['Gabtoli','Technical','Kallyanpur','Shyamoli','Shishu Mela','College Gate','Asad Gate','Mohammadpur','Shankar','Star Kabab','Dhanmondi 15','Jigatola','City College','Science Lab','Bata Signal','Shahbag','Matsya Bhaban','Kakrail','Shantinagar','Malibaag Moor','Mouchak','Malibagh Railgate','Hazipara','Rampura Bazar','Rampura Bridge','Banasree','Demra Staff Quarter'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Rois', nameBn: 'রাইস',
    stops: ['Sony Cinema Hall','Mirpur 2','Mirpur 10','Kazipara','Shewrapara','Agargaon','Mohakhali','Abdullahpur','Badda','Rampura Bridge','Banasree'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Rongdhonu Express', nameBn: 'রংধনু এক্সপ্রেস',
    stops: ['Adabor','Mohammadpur','Shia Masjid','Shyamoli','College Gate','Asad Gate','Kalabagan','Science Lab','Katabon','Bata Signal','Shahbag','Kakrail','Fakirapul','Motijheel','Dayagonj','Postogola'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Runway Express', nameBn: 'রানওয়ে এক্সপ্রেস',
    stops: ['Keraniganj','Kadamtali','Babubazar','Naya Bazar','Golap Shah Mazar','GPO','Paltan','Press Club','High Court','Matsya Bhaban','Shahbag','Bangla Motor','Kawran Bazar','Farmgate','Agargaon','Shewrapara','Kazipara','Mirpur 10','Mirpur 11','Mirpur 12','ECB Square'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Rupkotha', nameBn: 'রুপকথা',
    stops: ['Gabtoli','Mirpur 1','Sony Cinema Hall','Mirpur 2','Mirpur 10','Mirpur 11','Purobi','Kalshi','ECB Square','MES','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Safety Druti', nameBn: 'সেফটি দ্রুতি',
    stops: ['Mirpur 12','Pallabi','Purobi','Mirpur 11','Mirpur 10','Kazipara','Shewrapara','Taltola','Agargaon','Khamar Bari','Dhanmondi 27','Dhanmondi 32','Kalabagan','City College','New Market','Nilkhet','Azimpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Sakalpa Transport', nameBn: 'স্বকল্প ট্রান্সপোর্ট',
    stops: ['Chiriyakhana','Mirpur 1','Sony Cinema Hall','Mirpur 2','Mirpur 10','Kazipara','Shewrapara','Agargaon','Bijoy Sarani','Farmgate','Bangla Motor','Mogbazar','Malibaag Moor','Kamalapur'],
    startTime: '05:30 AM', endTime: '10:30 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Salsabil', nameBn: 'ছালছাবিল',
    stops: ['Postogola','Dholairpar','Jatrabari','Sayapabad','Mugdapara','Bashabo','Khilgaon','Malibagh Railgate','Rampura Bazar','Rampura Bridge','Merul Badda','Badda','Uttar Badda','Bashtola','Notun Bazar','Nadda','Bashundhara','Jamuna Future Park','Kuril Chourasta','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Tongi','Station Road','Mill Gate','Board Bazar','Gazipur Bypass','Gazipur Chourasta'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Savar Paribahan', nameBn: 'সাভার পরিবহন',
    stops: ['Sadarghat','Golap Shah Mazar','GPO','Paltan','Press Club','High Court','Matsya Bhaban','Shahbag','Science Lab','Kalabagan','Dhanmondi 32','Dhanmondi 27','Asad Gate','College Gate','Shishu Mela','Shyamoli','Kallyanpur','Darussalam','Technical','Gabtoli','Amin Bazar','Hemayetpur','Savar','Baipayl','Zirani Bazar','Nandan Park'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Shadhin', nameBn: 'স্বাধীন',
    stops: ['Bosila','Mohammadpur','Asad Gate','Khamar Bari','Farmgate','Kawran Bazar','Bangla Motor','Mogbazar','Mouchak','Malibagh Railgate','Hazipara','Rampura Bazar','Rampura Bridge','Banasree','Demra Staff Quarter'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Shadhin Express', nameBn: 'স্বাধীন এক্সপ্রেস',
    stops: ['Mirpur 12','Pallabi','Purobi','Mirpur 11','Mirpur 10','Kazipara','Shewrapara','Taltola','Agargaon','Khamar Bari','Farmgate','Kawran Bazar','Bangla Motor','Shahbag','High Court','Press Club','Paltan','GPO','Golap Shah Mazar','Naya Bazar','Babubazar','Keraniganj','Kadamtali','Rajendrapur','Maowa'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Shahria Enterprise', nameBn: 'শাহরিয়া এন্টারপ্রাইজ',
    stops: ['Gabtoli','Technical','Kallyanpur','Shyamoli','Shishu Mela','College Gate','Asad Gate','Dhanmondi 27','Dhanmondi 32','Shukrabad','Kalabagan','City College','Science Lab','Katabon','Shahbag','Matsya Bhaban','Kakrail','Arambagh','Motijheel','Ittefaq Moor','Tikatuli','Dayagonj','Gandaria','Jurain','Postogola'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Shatabdi', nameBn: 'শতাব্দি',
    stops: ['Motijheel','Paltan','Kakrail','Malibaag Moor','Mouchak','Mogbazar','Sat rasta','Nabisco','Mohakhali','Chairman Bari','Banani','Kakali','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Kamarpara'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Shikhor 1', nameBn: 'শিখর পরিবহন',
    stops: ['Mirpur 12','Pallabi','Purobi','Mirpur 11','Mirpur 10','Kazipara','Shewrapara','Taltola','Agargaon','Bijoy Sarani','Farmgate','Kawran Bazar','Bangla Motor','Shahbag','Matsya Bhaban','High Court','Press Club','Paltan','GPO','Gulistan','Janapoth Moor','Jatrabari'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Shikhor 2', nameBn: 'শিখর পরিবহন',
    stops: ['Jatrabari','Sayapabad','Gulistan','GPO','Paltan','Press Club','High Court','Matsya Bhaban','Shahbag','Bangla Motor','Kawran Bazar','Farmgate','Bijoy Sarani','Agargaon','IDB','Taltola','Shewrapara','Kazipara','Mirpur 10','Mirpur 11','Pallabi','Purobi','Mirpur 12'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Siam Transport', nameBn: 'সিয়াম ট্রান্সপোর্ট',
    stops: ['Banasree','Rampura Bridge','Merul Badda','Badda','Shahjadpur','Bashtola','Notun Bazar','Nadda','Bashundhara','Jamuna Future Park','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Kamarpara','Dhour','Beribadh','Ashulia','Zirabo','Fantasy Kingdom','Jamgora','Shimultola','Baipayl','Palli Bidyut','Savar Cantonment','Nobinagar'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Skyline', nameBn: 'স্কাই লাইন',
    stops: ['Sadarghat','Ray Saheb Bazar','Naya Bazar','Golap Shah Mazar','GPO','Paltan','Kakrail','Shantinagar','Malibaag Moor','Mouchak','Nabisco','Mohakhali','Chairman Bari','Sainik Club','Banani','Kakali','Staff Road','MES','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Tongi','Station Road','Mill Gate','Board Bazar','Gazipur Chourasta'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Somoy', nameBn: 'সময়',
    stops: ['Sign Board','Matuail','Rayerbag','Shonir Akhra','Jatrabari','Sayapabad','Janapoth Moor','Gulistan','GPO','Paltan','Press Club','High Court','Matsya Bhaban','Shahbag','Bangla Motor','Kawran Bazar','Farmgate','Bijoy Sarani','Agargaon','IDB','Taltola','Shewrapara','Kazipara','Mirpur 10','Mirpur 11','Pallabi','Purobi','Mirpur 12'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Somoy Niyantran', nameBn: 'সময় নিয়ন্ত্রণ',
    stops: ['Mirpur 12','Pallabi','Purobi','Mirpur 11','Mirpur 10','Kazipara','Shewrapara','Taltola','Agargaon','Bijoy Sarani','Farmgate','Kawran Bazar','Bangla Motor','Shahbag','Matsya Bhaban','High Court','Press Club','Paltan','GPO','Golap Shah Mazar','Naya Bazar','Babubazar','Keraniganj'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Somota Paribahan', nameBn: 'সমতা পরিবহন',
    stops: ['Chittagong Road','Sign Board','Matuail','Rayerbag','Shonir Akhra','Jatrabari','Sayapabad','Gulistan','Chankhar Pul','Bakshi Bazar','Dhakeshwari','Azimpur','Nilkhet','New Market','City College','Kalabagan','Dhanmondi 32','Dhanmondi 27','Asad Gate','College Gate','Shishu Mela','Shyamoli','Kallyanpur','Darussalam','Technical','Ansar Camp','Mirpur 1','Abdullahpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Supravat', nameBn: 'সুপ্রভাত',
    stops: ['Victoria Park','Sadarghat','Ray Saheb Bazar','Golap Shah Mazar','GPO','Paltan','Kakrail','Shantinagar','Malibaag Moor','Mouchak','Malibagh Railgate','Hazipara','Rampura Bazar','Rampura Bridge','Merul Badda','Badda','Shahjadpur','Bashtola','Notun Bazar','Nadda','Bashundhara','Jamuna Future Park','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Tongi'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Suveccha', nameBn: 'শুভেচ্ছা',
    stops: ['Chittagong Road','Sign Board','Matuail','Rayerbag','Shonir Akhra','Jatrabari','Sayapabad','Gulistan','Chankhar Pul','Bakshi Bazar','Dhakeshwari','Azimpur','Nilkhet','New Market','City College','Kalabagan','Dhanmondi 32','Dhanmondi 27','Asad Gate','College Gate','Shishu Mela','Shyamoli','Kallyanpur','Darussalam','Technical','Gabtoli','Amin Bazar','Hemayetpur','Savar','Nobinagar','Baipayl','Zirani Bazar','Nandan Park','Chandra'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Suvojatri', nameBn: 'শুভযাত্রী',
    stops: ['Fulbaria','Golap Shah Mazar','GPO','Paltan','Press Club','High Court','Matsya Bhaban','Shahbag','Bata Signal','Science Lab','Kalabagan','Dhanmondi 32','Dhanmondi 27','Asad Gate','College Gate','Shishu Mela','Shyamoli','Kallyanpur','Darussalam','Technical','Gabtoli','Amin Bazar','Hemayetpur','Manikganj'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Swajan Paribahan', nameBn: 'স্বজন পরিবহন',
    stops: ['Savar','Hemayetpur','Amin Bazar','Gabtoli','Technical','Kallyanpur','Shyamoli','Shishu Mela','College Gate','Asad Gate','Khamar Bari','Farmgate','Kawran Bazar','Bangla Motor','Shahbag','High Court','Press Club','Paltan','GPO','Golap Shah Mazar','Naya Bazar','Ray Saheb Bazar','Sadarghat'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Talukdar', nameBn: 'তালুকদার',
    stops: ['Chiriyakhana','Mirpur 1','Ansar Camp','Technical','Kallyanpur','Shyamoli','Shishu Mela','College Gate','Asad Gate','Khamar Bari','Farmgate','Kawran Bazar','Bangla Motor','Mogbazar','Mouchak','Malibaag Moor','Rajarbag','Khilgaon flyover','Bashabo','Mugdapara','Manik Nagar','Golapbagh Chowrasta','Sayapabad','Janapoth Moor','Jatrabari','Kazla','Shonir Akhra','Rayerbag','Matuail','Sign Board','Sanarpar','Chittagong Road'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Tanjil Paribahan', nameBn: 'তানজিল পরিবহন',
    stops: ['Chiriyakhana','Mirpur 1','Ansar Camp','Technical','Kallyanpur','Shyamoli','Shishu Mela','College Gate','Asad Gate','Khamar Bari','Farmgate','Kawran Bazar','Bangla Motor','Shahbag','High Court','Press Club','Paltan','GPO','Golap Shah Mazar','Naya Bazar','Ray Saheb Bazar','Sadarghat'],
    startTime: '05:30 AM', endTime: '10:30 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Taranga Plus', nameBn: 'তরঙ্গ প্লাস',
    stops: ['Mohammadpur','Shankar','Star Kabab','Dhanmondi 15','Jigatola','City College','Science Lab','Bata Signal','Shahbag','Matsya Bhaban','Kakrail','Shantinagar','Malibaag Moor','Mouchak','Malibagh Railgate','Hazipara','Rampura Bazar','Rampura Bridge','Banasree','South Banasree'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Tetulia', nameBn: 'তেতুলিয়া',
    stops: ['Shia Masjid','Japan Garden City','Ring Road','Adabor','Shyamoli','Shishu Mela','Agargaon','Taltola','Shewrapara','Kazipara','Mirpur 10','Mirpur 11','Purobi','Pallabi','Kalshi','ECB Square','MES','Shewra','Kuril Bishwa Road','Airport','Jashimuddin','Rajlakshmi','House Building','Abdullahpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Thikana', nameBn: 'ঠিকানা',
    stops: ['Sign Board','Matuail','Rayerbag','Shonir Akhra','Jatrabari','Sayapabad','Gulistan','Chankhar Pul','Bakshi Bazar','Dhakeshwari','Azimpur','Nilkhet','New Market','City College','Kalabagan','Dhanmondi 32','Dhanmondi 27','Asad Gate','College Gate','Shishu Mela','Shyamoli','Kallyanpur','Darussalam','Technical','Gabtoli','Amin Bazar','Hemayetpur','Savar','Baipayl','Zirani Bazar','Nandan Park','Chandra'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Thikana Express', nameBn: 'ঠিকানা এক্সপ্রেস',
    stops: ['Shonbari Sreenagar','Nimtola','Kuchimura','Rajendrapur','Hasnabad','Postogola','Jurain','Dholairpar','Jatrabari','Sayapabad','Gulistan','Chankhar Pul','Bakshi Bazar','Azimpur','Nilkhet','New Market','City College','Kalabagan','Dhanmondi 32','Dhanmondi 27','Asad Gate','College Gate','Shishu Mela','Shyamoli','Kallyanpur','Darussalam','Technical','Gabtoli','Amin Bazar','Hemayetpur','Savar','Baipayl','Zirani Bazar','Nandan Park','Chandra'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Titas', nameBn: 'তিতাস',
    stops: ['Chiriyakhana','Mirpur 1','Gabtoli','Savar','Nobinagar','Chandra'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Transilva', nameBn: 'ট্রান্সিল্ভা',
    stops: ['Mirpur 1','Ansar Camp','Technical','Kallyanpur','Shyamoli','Shishu Mela','College Gate','Asad Gate','Dhanmondi 27','Dhanmondi 32','Kalabagan','Science Lab','Bata Signal','Shahbag','Matsya Bhaban','High Court','Press Club','Paltan','GPO','Gulistan','Motijheel','Sayapabad','Janapoth Moor','Jatrabari'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Turag', nameBn: 'গ্রেট তুরাগ',
    stops: ['Jatrabari','Sayapabad','Mugdapara','Bashabo','Khilgaon','Malibaag Moor','Rampura Bazar','Rampura Bridge','Merul Badda','Badda','Uttar Badda','Bashtola','Notun Bazar','Nadda','Bashundhara','Jamuna Future Park','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Tongi'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Victor Classic', nameBn: 'ভিক্টর ক্লাসিক',
    stops: ['Sadarghat','Ray Saheb Bazar','Naya Bazar','Golap Shah Mazar','GPO','Paltan','Kakrail','Shantinagar','Malibaag Moor','Mouchak','Malibagh Railgate','Hazipara','Rampura Bazar','Rampura Bridge','Merul Badda','Badda','Shahjadpur','Bashtola','Notun Bazar','Nadda','Bashundhara','Jamuna Future Park','Kuril Bishwa Road'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Victor Paribahan', nameBn: 'ভিক্টর পরিবহন',
    stops: ['Sadarghat','Ray Saheb Bazar','Naya Bazar','Golap Shah Mazar','GPO','Paltan','Kakrail','Shantinagar','Malibaag Moor','Mouchak','Malibagh Railgate','Hazipara','Rampura Bazar','Rampura Bridge','Merul Badda','Badda','Shahjadpur','Bashtola','Notun Bazar','Nadda','Bashundhara','Jamuna Future Park','Kuril Bishwa Road'],
    startTime: '06:30 AM', endTime: '10:30 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'VIP 27', nameBn: 'ভিআইপি ২৭',
    stops: ['Azimpur','Nilkhet','New Market','City College','Kalabagan','Banani','Kakali','MES','Shewra','Kuril Bishwa Road','Khilkhet','Airport','Jashimuddin','Rajlakshmi','Azampur','House Building','Abdullahpur','Tongi','Station Road','Mill Gate','Board Bazar','Gazipur Chourasta'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Welcome', nameBn: 'ওয়েলকাম',
    stops: ['Nandan Park','Zirani Bazar','Baipayl','Nobinagar','Savar','Hemayetpur','Amin Bazar','Gabtoli','Technical','Kallyanpur','Shyamoli','Shishu Mela','College Gate','Asad Gate','Khamar Bari','Farmgate','Kawran Bazar','Bangla Motor','Shahbag','High Court','Press Club','Paltan','GPO','Gulistan','Motijheel'],
    startTime: '05:30 AM', endTime: '10:30 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: 'Winner', nameBn: 'উইনার',
    stops: ['Azimpur','Eden College','Nilkhet','New Market','Science Lab','City College','Kalabagan','Panthopoth','Kawran Bazar','Bot tola','Nabisco','Mohakhali','Wireless','Gulshan 1','Badda','Badda Link Road','Uttar Badda','Shahjadpur','Bashtola','Notun Bazar','Nadda','Bashundhara','Jamuna Future Park','Kuril Bishwa Road'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: '6 No.', nameBn: '৬নং',
    stops: ['Kamalapur','Motijheel','Gulistan','GPO','Paltan','Kakrail','Shantinagar','Malibaag Moor','Mouchak','Mogbazar','Kawran Bazar','Farmgate','Jahangir Gate','Bijoy Sarani','Mohakhali','Gulshan 1','Gulshan 2','Notun Bazar'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: '7 No.', nameBn: '৭নং',
    stops: ['Gabtoli','Technical','Kallyanpur','Shyamoli','Shishu Mela','College Gate','Asad Gate','Dhanmondi 27','Dhanmondi 32','Kalabagan','Science Lab','Katabon','Shahbag','High Court','Press Club','Paltan','GPO','Golap Shah Mazar','Gulistan','Naya Bazar','Ray Saheb Bazar','Sadarghat'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: '8 No.', nameBn: '৮নং',
    stops: ['Jatrabari','Janapoth Moor','Sayapabad','Motijheel','Dainik Bangla Moor','Paltan','Press Club','Matsya Bhaban','High Court','Shahbag','Bangla Motor','Kawran Bazar','Farmgate','Khamar Bari','Asad Gate','College Gate','Shishu Mela','Shyamoli','Kallyanpur','Technical','Gabtoli'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: '9 No.', nameBn: '৯নং',
    stops: ['College Gate','Shishu Mela','Shyamoli','Kallyanpur','Darussalam','Technical','Bangla College','Tolarbag','Ansar Camp','Mirpur 1','Sony Cinema Hall','Mirpur 2','Proshika Moor','Pallabi','Mirpur 12'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

  BusRoute(
    name: '13 No.', nameBn: '১৩নং',
    stops: ['Mohammadpur','Shankar','Star Kabab','Dhanmondi 15','Jigatola','City College','Science Lab','New Market','Nilkhet','Azimpur'],
    startTime: '06:00 AM', endTime: '10:00 PM', serviceType: 'Semi-Seating',
  ),

];
