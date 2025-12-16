import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingApi {

static Future<String?> getPlaceName(double lat, double lng) async {
  final apiKey = const String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey'
  );

  final response = await http.get(url);

  print("full response: ${response.body}");

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    if (data['results'] != null && data['results'].isNotEmpty) {
      // ✅ Use the correct key: 'address_components'
      final components = data['results'][0]['address_components'] as List<dynamic>?;

      if (components == null) return 'Unknown location';

      String? street;
      String? neighborhood;

      for (var component in components) {
        final types = List<String>.from(component['types']);
        if (types.contains('route')) {
          street = component['long_name'];
        } else if (types.contains('administrative_area_level_3')) {
          neighborhood = component['long_name'];
        }
      }

      if (street != null && neighborhood != null) {
        return '$street, $neighborhood';
      } else if (street != null) {
        return street;
      } else if (neighborhood != null) {
        return neighborhood;
      }
    }
  }

  return 'Unknown location';
}
}