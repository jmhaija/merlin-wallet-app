import 'dart:convert';

import 'package:client_app/utils/globals.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class Suggestion {

  Suggestion(this.placeId, this.description);
  final String placeId;
  final String description;

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {

  PlaceApiProvider(this.sessionToken);
  final client = Client();
  final sessionToken;

  static final String apiKey = dotenv.get('GOOGLE_API_KEY', fallback: 'google api key not found');

  Future<List<dynamic>> fetchSuggestions(String input, String lang) async {
    final Uri request = Uri(
			scheme: globalSettings['google_api']['scheme'],
			host: globalSettings['google_api']['host'],
			path: globalSettings['google_api']['search_address']['path'],
			queryParameters: {
				'input': input,
				'types': globalSettings['google_api']['search_address']['address'],
				'language': lang,
				'components': 'country:${globalSettings['country']}',
				'key': apiKey,
				'sessiontoken': sessionToken 
			}
		);
		
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        return result['predictions']
          .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
          .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return ['Address not found. Enter address manually.'];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

	Future<Place> getPlaceDetailFromId(String placeId) async {
    final request = Uri(
			scheme: globalSettings['google_api']['scheme'],
			host: globalSettings['google_api']['host'],
			path: globalSettings['google_api']['place_details']['path'],
			queryParameters: {
				'place_id': placeId,
				'fields': globalSettings['google_api']['place_details']['address_component'],
				'key': apiKey,
				'sessionToken': sessionToken
			} 
		);
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components =
            result['result']['address_components'] as List<dynamic>;
        // build result
        final place = Place();
        for (var c in components) {
          final List type = c['types'];
          if (type.contains('street_number')) {
            place.streetNumber = c['long_name'];
          }
          if (type.contains('route')) {
            place.street = c['long_name'];
          }
          if (type.contains('locality')) {
            place.city = c['long_name'];
          }
					if (type.contains('administrative_area_level_1')) {
						place.state = c['short_name'];
					}
          if (type.contains('postal_code')) {
            place.zipCode = c['long_name'];
          }
					if (type.contains('country')) {
						place.country = c['long_name'];
					}
        }
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}

class Place {

  Place({
    this.streetNumber = '',
    this.street = '',
    this.city = '',
		this.state = '',
    this.zipCode = '',
		this.country = '',
  });
  String streetNumber;
  String street;
  String city;
	String state;
  String zipCode;
	String country;

  @override
  String toString() {
    return 'Place(streetNumber: $streetNumber, street: $street, city: $city, state: $state, zipCode: $zipCode, country: $country)';
  }
}