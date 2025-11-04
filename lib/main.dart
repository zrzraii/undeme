import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/law_code_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const UndemeApp());
}

class UndemeApp extends StatelessWidget {
  const UndemeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Undeme',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      routes: {
        '/': (_) => const HomeScreen(),
        '/map': (_) => const MapScreen(),
        '/chat': (_) => const ChatScreen(),
        '/laws': (_) => const LawCodeScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }
}

Future<void> openExternalMaps(String query) async {
  final encoded = Uri.encodeComponent(query);
  final google = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encoded');
  if (await canLaunchUrl(google)) {
    await launchUrl(google, mode: LaunchMode.externalApplication);
  }
}
