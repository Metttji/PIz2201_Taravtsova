import 'package:flutter/material.dart';

void main() {
  runApp(const AreaCalculatorApp());
}

class AreaCalculatorApp extends StatelessWidget {
  const AreaCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор площади',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
      home: const AreaCalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AreaCalculatorScreen extends StatefulWidget {
  const AreaCalculatorScreen({super.key});

  @override
  State<AreaCalculatorScreen> createState() => _AreaCalculatorScreenState();
}

class _AreaCalculatorScreenState extends State<AreaCalculatorScreen> {
  // Ключ для формы
  final _formKey = GlobalKey<FormState>();

  // Контроллеры для текстовых полей
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  // Переменная для результата
  double? _result;

  // Переменная для хранения ошибок
  String? _calculationError;

  // Метод для вычисления площади
  void _calculateArea() {
    // Сбрасываем предыдущие результаты
    setState(() {
      _result = null;
      _calculationError = null;
    });

    // Проверяем форму
    if (_formKey.currentState!.validate()) {
      // Если форма валидна - сохраняем значения
      _formKey.currentState!.save();

      // Получаем значения из контроллеров
      final String widthText = _widthController.text;
      final String heightText = _heightController.text;

      try {
        // Парсим числа
        final double width = double.parse(widthText);
        final double height = double.parse(heightText);

        // Проверяем на положительные значения
        if (width <= 0 || height <= 0) {
          setState(() {
            _calculationError = 'Значения должны быть больше 0';
          });
          return;
        }

        // Проверяем на очень большие значения
        if (width > 1000000 || height > 1000000) {
          setState(() {
            _calculationError = 'Значения слишком большие';
          });
          return;
        }

        // Вычисляем площадь
        final double area = width * height;

        // Обновляем состояние с результатом
        setState(() {
          _result = area;
        });

        // Показываем уведомление об успехе
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Площадь вычислена: ${area.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );

      } catch (e) {
        setState(() {
          _calculationError = 'Ошибка при вычислении: $e';
        });
      }
    } else {
      // Если форма невалидна - показываем общую ошибку
      setState(() {
        _calculationError = 'Пожалуйста, исправьте ошибки в полях';
      });
    }
  }

  // Метод для сброса формы
  void _resetForm() {
    _formKey.currentState?.reset();
    _widthController.clear();
    _heightController.clear();

    setState(() {
      _result = null;
      _calculationError = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Форма очищена'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    // Очищаем контроллеры при уничтожении виджета
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор площади'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('О калькуляторе'),
                  content: const Text(
                    'Этот калькулятор вычисляет площадь прямоугольника.\n\n'
                        'Формула: S = ширина × высота\n\n'
                        'Введите значения в поля, нажмите "Вычислить" и получите результат.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Понятно'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Заголовок
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.calculate,
                        size: 50,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Калькулятор площади',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Введите ширину и высоту для вычисления площади прямоугольника',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Поле ввода ширины
              Text(
                'Ширина:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _widthController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Введите ширину (например: 10.5)',
                  prefixIcon: const Icon(Icons.width_wide, color: Colors.blue),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () => _widthController.clear(),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите ширину';
                  }

                  // Проверяем, что это число
                  final double? number = double.tryParse(value);
                  if (number == null) {
                    return 'Введите корректное число';
                  }

                  // Проверяем, что число положительное
                  if (number <= 0) {
                    return 'Ширина должна быть больше 0';
                  }

                  return null; // Если ошибок нет
                },
                onChanged: (_) {
                  // Сбрасываем результат при изменении текста
                  if (_result != null) {
                    setState(() {
                      _result = null;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              // Поле ввода высоты
              Text(
                'Высота:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Введите высоту (например: 5.2)',
                  prefixIcon: const Icon(Icons.height, color: Colors.blue),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () => _heightController.clear(),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите высоту';
                  }

                  // Проверяем, что это число
                  final double? number = double.tryParse(value);
                  if (number == null) {
                    return 'Введите корректное число';
                  }

                  // Проверяем, что число положительное
                  if (number <= 0) {
                    return 'Высота должна быть больше 0';
                  }

                  return null; // Если ошибок нет
                },
                onChanged: (_) {
                  // Сбрасываем результат при изменении текста
                  if (_result != null) {
                    setState(() {
                      _result = null;
                    });
                  }
                },
              ),

              const SizedBox(height: 30),

              // Кнопки действий
              Row(
                children: [
                  // Кнопка сброса
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _resetForm,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Сбросить'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Кнопка вычисления
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _calculateArea,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Вычислить'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Показ ошибок
              if (_calculationError != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _calculationError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Показ результата
              if (_result != null) ...[
                Card(
                  color: Colors.green[50],
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 10),
                            Text(
                              'Результат вычисления:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Формула
                        Text(
                          'S = ${_widthController.text} × ${_heightController.text} =',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 10),

                        // Результат
                        Text(
                          _result!.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 5),

                        Text(
                          'квадратных единиц',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Дополнительная информация
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Дополнительная информация:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text('Ширина: '),
                                  Text(
                                    _widthController.text,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Высота: '),
                                  Text(
                                    _heightController.text,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Точность: '),
                                  const Text('2 знака после запятой'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else if (_widthController.text.isNotEmpty || _heightController.text.isNotEmpty) ...[
                // Подсказка, если поля заполнены, но результат не вычислен
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Заполните оба поля и нажмите "Вычислить" для расчёта площади',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 30),

              // Примеры значений
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Примеры значений:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildExampleButton('5 × 3 = 15', 5.0, 3.0),
                          _buildExampleButton('10 × 7 = 70', 10.0, 7.0),
                          _buildExampleButton('12.5 × 4.2 = 52.5', 12.5, 4.2),
                          _buildExampleButton('8.75 × 6.3 = 55.13', 8.75, 6.3),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Информация внизу
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.grey[100] ?? Colors.grey, // Исправлено: добавлено значение по умолчанию
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lightbulb, size: 16, color: Colors.grey),
            SizedBox(width: 8),
            Text(
              'Формула площади прямоугольника: S = a × b',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Виджет для кнопки с примером
  Widget _buildExampleButton(String label, double width, double height) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        _widthController.text = width.toString();
        _heightController.text = height.toString();
        _calculateArea();
      },
      backgroundColor: Colors.blue[100] ?? Colors.blue.shade100, // Исправлено: добавлено значение по умолчанию
      labelStyle: const TextStyle(color: Colors.blue),
    );
  }
}