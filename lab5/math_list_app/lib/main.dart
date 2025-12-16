import 'dart:math';  // Импорт математической библиотеки
import 'package:flutter/material.dart';

void main() {
  runApp(const MathListApp());
}

class MathListApp extends StatelessWidget {
  const MathListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Степени двойки',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MathListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MathListScreen extends StatefulWidget {
  const MathListScreen({super.key});

  @override
  State<MathListScreen> createState() => _MathListScreenState();
}

class _MathListScreenState extends State<MathListScreen> {
  // Список для хранения степеней двойки
  final List<Map<String, dynamic>> _powerItems = [];

  // Текущая максимальная степень
  int _currentMaxPower = 0;

  // Флаг загрузки
  bool _isLoading = false;

  // Метод для вычисления 2^power
  int _calculatePowerOfTwo(int power) {
    return pow(2, power).toInt();
  }

  // Метод для загрузки новых степеней
  Future<void> _loadMorePowers() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Имитируем задержку вычислений
    await Future.delayed(const Duration(milliseconds: 500));

    // Добавляем 5 новых степеней
    final int startPower = _currentMaxPower;
    final int endPower = startPower + 5;

    final List<Map<String, dynamic>> newItems = [];
    for (int power = startPower; power < endPower; power++) {
      final int result = _calculatePowerOfTwo(power);
      newItems.add({
        'power': power,
        'result': result,
        'formula': '2^$power = $result',
        'binary': result.toRadixString(2),  // Двоичное представление
      });
    }

    setState(() {
      _powerItems.addAll(newItems);
      _currentMaxPower = endPower;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Загружаем первые степени при запуске
    _loadMorePowers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Степени числа 2'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('О списке'),
                  content: const Text(
                    'Этот список показывает степени числа 2:\n\n'
                        '2^0 = 1\n'
                        '2^1 = 2\n'
                        '2^2 = 4\n'
                        'и так далее...\n\n'
                        'Листайте вниз для загрузки следующих степеней.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Информационная панель
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.purple[50],
            child: const Row(
              children: [
                Icon(Icons.calculate, color: Colors.purple),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Список степеней числа 2. Листайте вниз для загрузки следующих значений.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          // Список
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                // Если достигли конца - загружаем ещё
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                    !_isLoading) {
                  _loadMorePowers();
                }
                return true;
              },
              child: ListView.builder(
                itemCount: _powerItems.length + 1,
                itemBuilder: (context, index) {
                  // Если это последний элемент - показываем индикатор загрузки
                  if (index == _powerItems.length) {
                    return _isLoading
                        ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                        : const SizedBox.shrink();
                  }

                  // Получаем данные о степени
                  final item = _powerItems[index];
                  final int power = item['power'];
                  final int result = item['result'];
                  final String binary = item['binary'];

                  // Определяем цвет в зависимости от величины степени
                  Color? tileColor;
                  if (result > 1000000) {
                    tileColor = Colors.red[50];
                  } else if (result > 1000) {
                    tileColor = Colors.orange[50];
                  } else {
                    tileColor = Colors.green[50];
                  }

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    color: tileColor,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.purple[100],
                        child: Text(
                          power.toString(),
                          style: const TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        '2^$power = $result',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'Двоичное: $binary',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Десятичное: $result',
                            style: const TextStyle(fontSize: 12),
                          ),
                          if (result < 1000) ...[
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: result / 1024,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.purple,
                              ),
                            ),
                          ],
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '2^$power',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.purple,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Icon(
                            Icons.arrow_upward,
                            color: Colors.purple,
                            size: 16,
                          ),
                        ],
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('2^$power = $result'),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Степень: $power'),
                                  const SizedBox(height: 8),
                                  Text('Результат: $result'),
                                  const SizedBox(height: 8),
                                  Text('Двоичное: $binary'),
                                  const SizedBox(height: 8),
                                  Text('Шестнадцатеричное: 0x${result.toRadixString(16)}'),
                                  const SizedBox(height: 8),
                                  Text('Количество бит: ${binary.length}'),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Закрыть'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadMorePowers,
        tooltip: 'Загрузить ещё 5 степеней',
        child: const Icon(Icons.add),
      ),
    );
  }
}