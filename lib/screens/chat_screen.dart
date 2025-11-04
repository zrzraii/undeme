import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../widgets/bottom_nav.dart';
import '../config/api_config.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final List<_Message> _messages = [
    const _Message(sender: 'AI', text: "Привет! Я ваш AI-помощник по безопасности. Могу помочь с юридическими вопросами, советами по безопасности и экстренными инструкциями. Чем могу помочь?"),
  ];
  bool _isLoading = false;
  GenerativeModel? _model;

  @override
  void initState() {
    super.initState();
    // Initialize Gemini API with ApiConfig
    if (ApiConfig.hasGeminiKey) {
      _model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: ApiConfig.geminiApiKey,
      );
    }
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    setState(() {
      _messages.add(_Message(sender: 'You', text: text));
      _controller.clear();
      _isLoading = true;
    });

    try {
      if (_model != null) {
        final prompt = '''You are an emergency safety assistant. Provide helpful, concise advice about:
- Legal rights and procedures
- Safety tips and emergency protocols
- What to do in emergency situations

User question: $text

Provide a clear, actionable response.''';
        
        final content = [Content.text(prompt)];
        final response = await _model!.generateContent(content);
        
        setState(() {
          _messages.add(_Message(
            sender: 'AI',
            text: response.text ?? 'Sorry, I could not generate a response.',
          ));
        });
      } else {
        // Fallback response if no API key
        await Future.delayed(const Duration(milliseconds: 600));
        setState(() {
          _messages.add(const _Message(
            sender: 'AI',
            text: 'Пожалуйста, настройте Gemini API ключ для включения AI-ответов. Для экстренной помощи звоните 112.',
          ));
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(_Message(
          sender: 'AI',
          text: 'Извините, произошла ошибка при обработке запроса. Для экстренной помощи звоните 112.',
        ));
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _sendSuggestedQuestion(String question) {
    _controller.text = question;
    _send();
  }

  @override
  Widget build(BuildContext context) {
    final hasMessages = _messages.length > 1;
    
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
                  'AI Помощник безопасности',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF030213),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Получите юридическую консультацию, советы по безопасности и экстренную помощь',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF717182),
                  ),
                ),
                if (!hasMessages) ...
                [
                  const SizedBox(height: 24),
                  const Text(
                    'Попробуйте спросить о:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF717182),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _SuggestedQuestion(
                    text: 'Какие у меня права при остановке полицией?',
                    onTap: () => _sendSuggestedQuestion('Какие у меня права при остановке полицией?'),
                  ),
                  const SizedBox(height: 8),
                  _SuggestedQuestion(
                    text: 'Дайте советы по безопасности при прогулке в одиночку',
                    onTap: () => _sendSuggestedQuestion('Дайте советы по безопасности при прогулке в одиночку'),
                  ),
                  const SizedBox(height: 8),
                  _SuggestedQuestion(
                    text: 'Что делать при ДТП?',
                    onTap: () => _sendSuggestedQuestion('Что делать при ДТП?'),
                  ),
                  const SizedBox(height: 8),
                  _SuggestedQuestion(
                    text: 'Как подать заявление в полицию?',
                    onTap: () => _sendSuggestedQuestion('Как подать заявление в полицию?'),
                  ),
                ],
              ],
            ),
          ),
          if (hasMessages)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final m = _messages[index];
                  final isMe = m.sender == 'You';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        if (!isMe) ...
                        [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Color(0xFF030213),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.psychology,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe ? const Color(0xFFECECF0) : Colors.white,
                              border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m.text,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF030213),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '10:42',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'AI думает...',
                    style: TextStyle(color: Color(0xFF717182)),
                  ),
                ],
              ),
            ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _controller,
                        enabled: !_isLoading,
                        decoration: const InputDecoration(
                          hintText: 'Спросите о юридической помощи, безопасности или экстренных процедурах...',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF717182),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _isLoading ? const Color(0xFF030213).withValues(alpha: 0.5) : const Color(0xFF030213),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, size: 16, color: Colors.white),
                      onPressed: _isLoading ? null : _send,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }
}

class _SuggestedQuestion extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _SuggestedQuestion({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF030213),
          ),
        ),
      ),
    );
  }
}

class _Message {
  final String sender;
  final String text;
  const _Message({required this.sender, required this.text});
}
