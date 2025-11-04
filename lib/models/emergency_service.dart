import 'dart:math' as math;

/// Модель данных для экстренной службы
class EmergencyService {
  final String id;
  final String name;
  final String type; // hospital, police, fire
  final double latitude;
  final double longitude;
  final String address;
  final String? phone;
  final bool isOpen;
  final double? rating;
  final String? photoReference;

  const EmergencyService({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.phone,
    this.isOpen = true,
    this.rating,
    this.photoReference,
  });

  /// Создание из JSON (Google Places API)
  factory EmergencyService.fromPlacesJson(Map<String, dynamic> json) {
    final geometry = json['geometry'] as Map<String, dynamic>;
    final location = geometry['location'] as Map<String, dynamic>;
    
    return EmergencyService(
      id: json['place_id'] as String,
      name: json['name'] as String,
      type: _determineType(json['types'] as List<dynamic>?),
      latitude: location['lat'] as double,
      longitude: location['lng'] as double,
      address: json['vicinity'] as String? ?? json['formatted_address'] as String? ?? '',
      phone: json['formatted_phone_number'] as String?,
      isOpen: json['opening_hours']?['open_now'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble(),
      photoReference: (json['photos'] as List<dynamic>?)?.isNotEmpty == true
          ? json['photos'][0]['photo_reference'] as String?
          : null,
    );
  }

  /// Создание из JSON (MongoDB)
  factory EmergencyService.fromMongoJson(Map<String, dynamic> json) {
    return EmergencyService(
      id: json['_id'] as String? ?? json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      phone: json['phone'] as String?,
      isOpen: json['isOpen'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble(),
      photoReference: json['photoReference'] as String?,
    );
  }

  /// Конвертация в JSON для MongoDB
  Map<String, dynamic> toMongoJson() {
    return {
      '_id': id,
      'name': name,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'phone': phone,
      'isOpen': isOpen,
      'rating': rating,
      'photoReference': photoReference,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Определение типа службы по типам из Google Places
  static String _determineType(List<dynamic>? types) {
    if (types == null) return 'other';
    
    final typeStrings = types.cast<String>();
    
    if (typeStrings.contains('hospital') || 
        typeStrings.contains('health') ||
        typeStrings.contains('doctor')) {
      return 'hospital';
    }
    
    if (typeStrings.contains('police')) {
      return 'police';
    }
    
    if (typeStrings.contains('fire_station')) {
      return 'fire';
    }
    
    return 'other';
  }

  /// Получить эмодзи для типа службы
  String get emoji {
    switch (type) {
      case 'hospital':
        return '🏥';
      case 'police':
        return '👮';
      case 'fire':
        return '🚒';
      default:
        return '📍';
    }
  }

  /// Получить название типа на русском
  String get typeName {
    switch (type) {
      case 'hospital':
        return 'Больница';
      case 'police':
        return 'Полиция';
      case 'fire':
        return 'Пожарная';
      default:
        return 'Служба';
    }
  }

  /// Вычислить расстояние до точки (в км) используя формулу Haversine
  double distanceTo(double lat, double lng) {
    const double earthRadius = 6371; // км
    
    final dLat = _degreesToRadians(lat - latitude);
    final dLng = _degreesToRadians(lng - longitude);
    
    final a = 
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(_degreesToRadians(latitude)) *
        math.cos(_degreesToRadians(lat)) *
        math.pow(math.sin(dLng / 2), 2);
    
    final c = 2 * math.asin(math.sqrt(a));
    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  @override
  String toString() {
    return 'EmergencyService(id: $id, name: $name, type: $type, address: $address)';
  }
}
