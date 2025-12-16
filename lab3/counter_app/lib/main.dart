import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Инкремент',  // 1. Заменили название приложения
      theme: ThemeData(
        primarySwatch: Colors.green,  // 2. Заменили тему на зелёную
      ),
      home: const MyHomePage(title: 'Инкремент'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Значение инкремента:',  // 4. Заменили надпись
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 30),  // Отступ

            // 6-8. Две кнопки + и - горизонтально
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Кнопка "-"
                ElevatedButton(
                  onPressed: _decrementCounter,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 80),
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.remove, size: 30),
                ),

                const SizedBox(width: 20),  // Расстояние между кнопками

                // Кнопка "+"
                ElevatedButton(
                  onPressed: _incrementCounter,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 80),
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.add, size: 30),
                ),
              ],
            ),

            const SizedBox(height: 20),  // Отступ

            // 9-10. Кнопка "Сбросить" (прозрачная с серым текстом)
            TextButton(
              onPressed: _resetCounter,
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
              child: const Text(
                'Сбросить',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      // 5. Убрали кнопку с нижнего правого угла
      // floatingActionButton: FloatingActionButton(...) - УДАЛЕНО
    );
  }
}