import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/emergency_service.dart';
import '../config/api_config.dart';

/// Сервис для работы с Google Places API
class PlacesService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';
  
  /// Поиск ближайших экстренных служб
  /// 
  /// [latitude] и [longitude] - координаты текущего местоположения
  /// [type] - тип службы: 'hospital', 'police', 'fire' или null для всех
  /// [radius] - радиус поиска в метрах (по умолчанию 5000м = 5км)
  Future<List<EmergencyService>> findNearbyServices({
    required double latitude,
    required double longitude,
    String? type,
    int radius = 5000,
  }) async {
    if (!ApiConfig.hasGooglePlacesKey) {
      throw Exception('Google Places API key not configured');
    }

    final placeType = _getGooglePlaceType(type);
    
    final url = Uri.parse(
      '$_baseUrl/nearbysearch/json'
      '?location=$latitude,$longitude'
      '&radius=$radius'
      '&type=$placeType'
      '&key=${ApiConfig.googlePlacesApiKey}',
    );

    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        
        if (data['status'] == 'OK') {
          final results = data['results'] as List<dynamic>;
          return results
              .map((json) => EmergencyService.fromPlacesJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Places API error: ${data['status']}');
        }
      } else {
        throw Exception('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch places: $e');
    }
  }

  /// Поиск всех типов экстренных служб поблизости
  Future<List<EmergencyService>> findAllEmergencyServices({
    required double latitude,
    required double longitude,
    int radius = 5000,
  }) async {
    final results = <EmergencyService>[];
    
    // Поиск больниц
    try {
      final hospitals = await findNearbyServices(
        latitude: latitude,
        longitude: longitude,
        type: 'hospital',
        radius: radius,
      );
      results.addAll(hospitals);
    } catch (e) {
      print('Error fetching hospitals: $e');
    }

    // Поиск полиции
    try {
      final police = await findNearbyServices(
        latitude: latitude,
        longitude: longitude,
        type: 'police',
        radius: radius,
      );
      results.addAll(police);
    } catch (e) {
      print('Error fetching police: $e');
    }

    // Поиск пожарных станций
    try {
      final fire = await findNearbyServices(
        latitude: latitude,
        longitude: longitude,
        type: 'fire',
        radius: radius,
      );
      results.addAll(fire);
    } catch (e) {
      print('Error fetching fire stations: $e');
    }

    // Сортировка по расстоянию
    results.sort((a, b) {
      final distA = a.distanceTo(latitude, longitude);
      final distB = b.distanceTo(latitude, longitude);
      return distA.compareTo(distB);
    });

    return results;
  }

  /// Получить детали места по Place ID
  Future<EmergencyService?> getPlaceDetails(String placeId) async {
    if (!ApiConfig.hasGooglePlacesKey) {
      throw Exception('Google Places API key not configured');
    }

    final url = Uri.parse(
      '$_baseUrl/details/json'
      '?place_id=$placeId'
      '&fields=name,formatted_address,formatted_phone_number,geometry,opening_hours,rating,photos,types'
      '&key=${ApiConfig.googlePlacesApiKey}',
    );

    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        
        if (data['status'] == 'OK') {
          final result = data['result'] as Map<String, dynamic>;
          return EmergencyService.fromPlacesJson(result);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching place details: $e');
      return null;
    }
  }

  /// Конвертация типа службы в тип Google Places
  String _getGooglePlaceType(String? type) {
    switch (type) {
      case 'hospital':
        return 'hospital';
      case 'police':
        return 'police';
      case 'fire':
        return 'fire_station';
      default:
        return 'hospital'; // По умолчанию ищем больницы
    }
  }

  /// Получить URL фотографии места
  String? getPhotoUrl(String? photoReference, {int maxWidth = 400}) {
    if (photoReference == null || !ApiConfig.hasGooglePlacesKey) {
      return null;
    }

    return '$_baseUrl/photo'
        '?maxwidth=$maxWidth'
        '&photo_reference=$photoReference'
        '&key=${ApiConfig.googlePlacesApiKey}';
  }
}
