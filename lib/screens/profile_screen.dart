import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _name = TextEditingController(text: 'John Smith');
  final _email = TextEditingController(text: 'john.smith@email.com');
  final _phone = TextEditingController(text: '+1 (555) 123-4567');
  
  bool _sosVibration = true;
  bool _autoLocationSharing = true;
  bool _emergencyNotifications = true;
  bool _soundAlerts = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Профиль и настройки',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF030213),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Управляйте своей информацией и экстренными контактами',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF717182),
              ),
            ),
            const SizedBox(height: 24),
            _buildCard(
              icon: Icons.person_outline,
              title: 'Личная информация',
              children: [
                _buildTextField('Полное имя', _name),
                const SizedBox(height: 16),
                _buildTextField('Email', _email),
                const SizedBox(height: 16),
                _buildTextField('Номер телефона', _phone),
              ],
            ),
            const SizedBox(height: 24),
            _buildCard(
              icon: Icons.contacts_outlined,
              title: 'Экстренные контакты',
              children: [
                const Text(
                  'Add up to 3 trusted contacts who will be notified when you activate SOS',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF717182),
                  ),
                ),
                const SizedBox(height: 16),
                _buildContactCard(
                  name: 'John Doe',
                  phone: '+1 (555) 123-4567',
                  relationship: 'Brother',
                ),
                const SizedBox(height: 16),
                _buildContactCard(
                  name: 'Sarah Smith',
                  phone: '+1 (555) 987-6543',
                  relationship: 'Friend',
                ),
                const SizedBox(height: 16),
                _buildContactCard(
                  name: 'Mom',
                  phone: '+1 (555) 456-7890',
                  relationship: 'Mother',
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildCard(
              icon: Icons.settings_outlined,
              title: 'Настройки приложения',
              children: [
                _buildSwitchTile(
                  title: 'SOS Button Vibration',
                  subtitle: 'Vibrate when SOS is activated',
                  value: _sosVibration,
                  onChanged: (val) => setState(() => _sosVibration = val),
                ),
                Divider(color: Colors.black.withValues(alpha: 0.1), height: 1),
                _buildSwitchTile(
                  title: 'Auto Location Sharing',
                  subtitle: 'Automatically share location in SOS',
                  value: _autoLocationSharing,
                  onChanged: (val) => setState(() => _autoLocationSharing = val),
                ),
                Divider(color: Colors.black.withValues(alpha: 0.1), height: 1),
                _buildSwitchTile(
                  title: 'Emergency Notifications',
                  subtitle: 'Get alerts about nearby emergencies',
                  value: _emergencyNotifications,
                  onChanged: (val) => setState(() => _emergencyNotifications = val),
                ),
                Divider(color: Colors.black.withValues(alpha: 0.1), height: 1),
                _buildSwitchTile(
                  title: 'Sound Alerts',
                  subtitle: 'Play sound when SOS is activated',
                  value: _soundAlerts,
                  onChanged: (val) => setState(() => _soundAlerts = val),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildCard(
              icon: Icons.security_outlined,
              title: 'Конфиденциальность и безопасность',
              children: [
                _buildPrivacyItem('🔒 Your location is only shared when you activate SOS'),
                const SizedBox(height: 12),
                _buildPrivacyItem('📱 Emergency contacts are stored securely on your device'),
                const SizedBox(height: 12),
                _buildPrivacyItem('🚫 We never share your personal information with third parties'),
                const SizedBox(height: 12),
                _buildPrivacyItem('🗑️ You can delete your data at any time'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 4),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF030213)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF030213),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF030213),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF030213),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required String name,
    required String phone,
    required String relationship,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF030213),
                ),
              ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Edit contact (prototype)')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF030213),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Remove contact (prototype)')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                    ),
                    child: const Text(
                      'Remove',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF030213),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone, size: 12, color: Color(0xFF717182)),
              const SizedBox(width: 8),
              Text(
                phone,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF717182),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.person, size: 12, color: Color(0xFF717182)),
              const SizedBox(width: 8),
              Text(
                relationship,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF717182),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF030213),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF717182),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFF030213),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyItem(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF030213),
      ),
    );
  }
}
