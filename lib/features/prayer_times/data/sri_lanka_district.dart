// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Sri Lanka's 25 administrative districts with their capital/main
// town coordinates — public geographic reference points, not GPS
// readings, so prayer times work with no location permission at all.
// A district naturally spans a range where true prayer times differ
// by well under a minute from its town centre.

class SriLankaDistrict {
  const SriLankaDistrict({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final double latitude;
  final double longitude;
}

const List<SriLankaDistrict> sriLankaDistricts = [
  SriLankaDistrict(name: 'Colombo', latitude: 6.9271, longitude: 79.8612),
  SriLankaDistrict(name: 'Gampaha', latitude: 7.0917, longitude: 79.9995),
  SriLankaDistrict(name: 'Kalutara', latitude: 6.5854, longitude: 79.9607),
  SriLankaDistrict(name: 'Kandy', latitude: 7.2906, longitude: 80.6337),
  SriLankaDistrict(name: 'Matale', latitude: 7.4675, longitude: 80.6234),
  SriLankaDistrict(
    name: 'Nuwara Eliya',
    latitude: 6.9497,
    longitude: 80.7891,
  ),
  SriLankaDistrict(name: 'Galle', latitude: 6.0535, longitude: 80.2210),
  SriLankaDistrict(name: 'Matara', latitude: 5.9549, longitude: 80.5550),
  SriLankaDistrict(name: 'Hambantota', latitude: 6.1241, longitude: 81.1185),
  SriLankaDistrict(name: 'Jaffna', latitude: 9.6615, longitude: 80.0255),
  SriLankaDistrict(name: 'Kilinochchi', latitude: 9.3803, longitude: 80.3770),
  SriLankaDistrict(name: 'Mannar', latitude: 8.9810, longitude: 79.9044),
  SriLankaDistrict(name: 'Vavuniya', latitude: 8.7514, longitude: 80.4971),
  SriLankaDistrict(name: 'Mullaitivu', latitude: 9.2671, longitude: 80.8142),
  SriLankaDistrict(name: 'Batticaloa', latitude: 7.7310, longitude: 81.6747),
  SriLankaDistrict(name: 'Ampara', latitude: 7.2975, longitude: 81.6747),
  SriLankaDistrict(
    name: 'Trincomalee',
    latitude: 8.5874,
    longitude: 81.2152,
  ),
  SriLankaDistrict(name: 'Kurunegala', latitude: 7.4863, longitude: 80.3623),
  SriLankaDistrict(name: 'Puttalam', latitude: 8.0362, longitude: 79.8283),
  SriLankaDistrict(
    name: 'Anuradhapura',
    latitude: 8.3114,
    longitude: 80.4037,
  ),
  SriLankaDistrict(
    name: 'Polonnaruwa',
    latitude: 7.9403,
    longitude: 81.0188,
  ),
  SriLankaDistrict(name: 'Badulla', latitude: 6.9934, longitude: 81.0550),
  SriLankaDistrict(name: 'Moneragala', latitude: 6.8714, longitude: 81.3507),
  SriLankaDistrict(name: 'Ratnapura', latitude: 6.6828, longitude: 80.4012),
  SriLankaDistrict(name: 'Kegalle', latitude: 7.2513, longitude: 80.3464),
];
