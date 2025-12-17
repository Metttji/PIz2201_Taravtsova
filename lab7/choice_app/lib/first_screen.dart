import 'package:flutter/material.dart';
import 'second_screen.dart'; // Импортируем SecondScreen из отдельного файла

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  // Переменная для хранения выбранного ответа
  String? _selectedChoice;

  // Время последнего выбора (для уникальности ключа SnackBar)
  DateTime? _lastChoiceTime;

  // Метод для перехода на второй экран
  void _navigateToChoiceScreen(BuildContext context) async {
    // Используем Navigator.push для перехода
    // Ждём результат с помощью await
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SecondScreen(),
      ),
    );

    // Если пользователь что-то выбрал (не нажал "Назад")
    if (result != null) {
      setState(() {
        _selectedChoice = result;
        _lastChoiceTime = DateTime.now();
      });

      // Показываем SnackBar с выбором
      _showChoiceSnackBar(context, result);
    }
  }

  // Метод для показа SnackBar
  void _showChoiceSnackBar(BuildContext context, String choice) {
    // Используем уникальный ключ, чтобы показывать новый SnackBar каждый раз
    final snackBarKey = ValueKey<String>('snackbar_${_lastChoiceTime?.millisecondsSinceEpoch}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: snackBarKey,
        content: Text(
          'Вы выбрали: $choice',
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: choice == 'Да' ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'ОК',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        onVisible: () {
          print('Показан SnackBar с выбором: $choice');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главный экран'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Заголовок
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Приложение для выбора',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Иконка
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.question_answer,
                  size: 60,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 40),

              // Кнопка перехода
              ElevatedButton.icon(
                onPressed: () => _navigateToChoiceScreen(context),
                icon: const Icon(Icons.arrow_forward, size: 24),
                label: const Text(
                  'Перейти к выбору',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 5,
                  shadowColor: Colors.blue[900],
                ),
              ),

              const SizedBox(height: 30),

              // Показ выбранного ответа
              _selectedChoice != null
                  ? Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Последний выбор:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _selectedChoice!,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: _selectedChoice == 'Да'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Icon(
                      _selectedChoice == 'Да'
                          ? Icons.check_circle
                          : Icons.cancel,
                      size: 40,
                      color: _selectedChoice == 'Да'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ],
                ),
              )
                  : Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Нажмите кнопку выше, чтобы сделать выбор',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              // Информация о работе приложения
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Нажмите "Перейти к выбору", выберите "Да" или "Нет" на следующем экране, '
                      'затем вернитесь назад, чтобы увидеть результат здесь и во всплывающем уведомлении.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),

      // Индикатор внизу
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue[800],
        height: 60,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                _selectedChoice != null
                    ? 'Выбор сохранён: $_selectedChoice'
                    : 'Выбор ещё не сделан',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// УДАЛИТЕ этот класс SecondScreen отсюда!
// Перенесите его в отдельный файл second_screen.dart