import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/bottom_nav.dart';
import '../services/places_service.dart';
import '../services/database_service.dart';
import '../models/emergency_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _selectedFilter = 'All';
  List<EmergencyService> _services = [];
  bool _isLoading = true;
  String? _errorMessage;
  Position? _currentPosition;
  final _placesService = PlacesService();

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Получаем текущее местоположение
      final position = await _getCurrentLocation();
      if (position == null) {
        setState(() {
          _errorMessage = 'Не удалось получить местоположение';
          _isLoading = false;
        });
        return;
      }

      _currentPosition = position;

      // Загружаем службы из Places API
      final services = await _placesService.findAllEmergencyServices(
        latitude: position.latitude,
        longitude: position.longitude,
        radius: 5000,
      );

      // Сохраняем в MongoDB для кэширования
      try {
        await DatabaseService.saveServices(services);
      } catch (e) {
        print('Failed to cache services in MongoDB: $e');
      }

      setState(() {
        _services = services;
        _isLoading = false;
      });
    } catch (e) {
      // Пытаемся загрузить из MongoDB если Places API не работает
      try {
        final cachedServices = await DatabaseService.getAllServices();
        setState(() {
          _services = cachedServices;
          _errorMessage = 'Показаны кэшированные данные';
          _isLoading = false;
        });
      } catch (dbError) {
        setState(() {
          _errorMessage = 'Ошибка загрузки данных: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      // Проверяем разрешения
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Получаем текущую позицию
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  List<EmergencyService> get _filteredServices {
    if (_selectedFilter == 'All') {
      return _services;
    }
    
    final typeMap = {
      'Hospitals': 'hospital',
      'Police': 'police',
      'Fire': 'fire',
    };
    
    final filterType = typeMap[_selectedFilter];
    return _services.where((s) => s.type == filterType).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.warning, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
            const Text(
              'Undeme',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF030213),
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Экстренная помощь',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF717182),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Ближайшие экстренные службы',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF030213),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Найдите ближайшие экстренные службы в вашем районе',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF717182),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _FilterChip(
                label: 'Все',
                isSelected: _selectedFilter == 'All',
                onTap: () => setState(() => _selectedFilter = 'All'),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: '🏥 Больницы',
                isSelected: _selectedFilter == 'Hospitals',
                onTap: () => setState(() => _selectedFilter = 'Hospitals'),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: '👮 Полиция',
                isSelected: _selectedFilter == 'Police',
                onTap: () => setState(() => _selectedFilter = 'Police'),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: '🚒 Пожарные',
                isSelected: _selectedFilter == 'Fire',
                onTap: () => setState(() => _selectedFilter = 'Fire'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                border: Border.all(color: Colors.orange.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(fontSize: 12, color: Colors.orange.shade700),
                    ),
                  ),
                ],
              ),
            ),
          Container(
            height: 192,
            decoration: BoxDecoration(
              color: const Color(0xFFECECF0),
              border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isLoading ? Icons.hourglass_empty : Icons.map_outlined,
                    size: 32,
                    color: const Color(0xFF717182),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isLoading ? 'Загрузка...' : 'Интерактивная карта',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF717182),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Показано ${_filteredServices.length} служб',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (_filteredServices.isEmpty)
            Center(
              child: Column(
                children: [
                  const Icon(Icons.search_off, size: 48, color: Color(0xFF717182)),
                  const SizedBox(height: 16),
                  const Text(
                    'Службы не найдены',
                    style: TextStyle(fontSize: 16, color: Color(0xFF717182)),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _loadServices,
                    child: const Text('Обновить'),
                  ),
                ],
              ),
            )
          else
            ..._filteredServices.take(10).map((service) {
              final distance = _currentPosition != null
                  ? service.distanceTo(_currentPosition!.latitude, _currentPosition!.longitude)
                  : 0.0;
              final timeMinutes = (distance / 5 * 60).round(); // Примерно 5 км/ч - скорость движения
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _ServiceCard(
                  emoji: service.emoji,
                  name: service.name,
                  status: service.isOpen ? 'Открыто' : 'Закрыто',
                  distance: '${distance.toStringAsFixed(1)} км',
                  time: '$timeMinutes мин',
                  address: service.address,
                  query: service.name,
                  phone: service.phone,
                ),
              );
            }).toList(),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF030213) : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.black.withValues(alpha: 0.1),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF030213),
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String emoji;
  final String name;
  final String status;
  final String distance;
  final String time;
  final String address;
  final String query;
  final String? phone;

  const _ServiceCard({
    required this.emoji,
    required this.name,
    required this.status,
    required this.distance,
    required this.time,
    required this.address,
    required this.query,
    this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final isOpen = status == 'Open';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF030213),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isOpen
                                ? const Color(0xFF030213)
                                : const Color(0xFFECEEF2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isOpen ? Colors.white : const Color(0xFF030213),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          distance,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF717182),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 12,
                    color: Color(0xFF717182),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF717182),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 12,
                color: Color(0xFF717182),
              ),
              const SizedBox(width: 8),
              Text(
                address,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF717182),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final url = Uri.parse(
                      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}',
                    );
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF030213),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.navigation, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Маршрут',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: phone != null ? () async {
                  final url = Uri.parse('tel:$phone');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                } : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF030213),
                  side: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.phone, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Звонок',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
