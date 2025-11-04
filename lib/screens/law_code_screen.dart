import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class LawCodeScreen extends StatefulWidget {
  const LawCodeScreen({super.key});

  @override
  State<LawCodeScreen> createState() => _LawCodeScreenState();
}

class _LawCodeScreenState extends State<LawCodeScreen> {
  final _controller = TextEditingController();
  final List<_LawCategory> _categories = const [
    _LawCategory(
      icon: Icons.shield_outlined,
      title: 'Экстренные права',
      description: 'Ваши права в экстренных ситуациях',
      content: 'В экстренных ситуациях вы имеете право на:\n\n\u2022 Немедленную медицинскую помощь\n\u2022 Обращение в экстренные службы по тел. 112\n\u2022 Находиться в безопасном месте\n\u2022 Отказаться от опасной работы\n\u2022 Получить информацию о ситуации',
    ),
    _LawCategory(
      icon: Icons.local_police_outlined,
      title: 'Взаимодействие с полицией',
      description: 'Ваши права при остановке полицией',
      content: 'При остановке полицией:\n\n\u2022 Сохраняйте спокойствие\n\u2022 Вы имеете право знать причину остановки\n\u2022 Можете не отвечать на вопросы без адвоката\n\u2022 Ведите видеозапись (legal in public spaces)\n\u2022 Просите предъявить удостоверение\n\u2022 Запомните имена и номера жетонов',
    ),
    _LawCategory(
      icon: Icons.health_and_safety_outlined,
      title: 'Самооборона',
      description: 'Права на самооборону',
      content: 'Законная самооборона:\n\n\u2022 Используйте разумную силу для защиты\n\u2022 Сила должна соответствовать угрозе\n\u2022 Прекратите, когда угроза устранена\n\u2022 Сообщите в полицию немедленно\n\u2022 Сохраните доказательства инцидента',
    ),
    _LawCategory(
      icon: Icons.medical_services_outlined,
      title: 'Медицинское согласие',
      description: 'Права на медицинскую помощь',
      content: 'Медицинские права:\n\n\u2022 Право на бесплатную экстренную помощь\n\u2022 Право на информированное согласие\n\u2022 Право отказаться от лечения\n\u2022 Конфиденциальность медицинских данных\n\u2022 Второе мнение врача',
    ),
    _LawCategory(
      icon: Icons.warning_amber_outlined,
      title: 'Эвакуация и бедствия',
      description: 'Что делать при стихийных бедствиях',
      content: 'При стихийных бедствиях:\n\n\u2022 Следуйте указаниям властей\n\u2022 Эвакуируйтесь при необходимости\n\u2022 Знайте пути эвакуации\n\u2022 Имейте тревожную сумку\n\u2022 Оставайтесь на связи с родными',
    ),
    _LawCategory(
      icon: Icons.description_outlined,
      title: 'Подача заявления',
      description: 'Как подать заявление в полицию',
      content: 'Подача заявления:\n\n\u2022 Обратитесь в ближайшее отделение\n\u2022 Принесите удостоверение личности\n\u2022 Опишите инцидент подробно\n\u2022 Предоставьте доказательства\n\u2022 Получите копию заявления\n\u2022 Сохраните номер дела',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredCategories = _categories
        .where((c) =>
            c.title.toLowerCase().contains(_controller.text.toLowerCase()) ||
            c.description.toLowerCase().contains(_controller.text.toLowerCase()))
        .toList();

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Юридическая информация',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF030213),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Узнайте свои права и обязанности',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF717182),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _controller,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Поиск законов, прав, рекомендаций...',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF717182),
                      ),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF717182)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => _showLawDetail(context, category),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F3F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              category.icon,
                              color: const Color(0xFF030213),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF030213),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  category.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF717182),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Color(0xFF717182),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
    );
  }

  void _showLawDetail(BuildContext context, _LawCategory category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F3F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      category.icon,
                      color: const Color(0xFF030213),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      category.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF030213),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  category.content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Color(0xFF030213),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LawCategory {
  final IconData icon;
  final String title;
  final String description;
  final String content;

  const _LawCategory({
    required this.icon,
    required this.title,
    required this.description,
    required this.content,
  });
}
