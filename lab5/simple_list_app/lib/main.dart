import 'package:flutter/material.dart';

void main() {
  runApp(const SimpleListApp());
}

class SimpleListApp extends StatelessWidget {
  const SimpleListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Простой список',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SimpleListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SimpleListScreen extends StatelessWidget {
  const SimpleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Простой список'),
      ),
      body: ListView(
        children: const [
          // Элемент 1
          ListTile(
            leading: CircleAvatar(
              child: Text('1'),
            ),
            title: Text('Первый элемент'),
            subtitle: Text('Описание первого элемента'),
            trailing: Icon(Icons.arrow_forward),
          ),
          Divider(),  // Разделитель

          // Элемент 2
          ListTile(
            leading: CircleAvatar(
              child: Text('2'),
            ),
            title: Text('Второй элемент'),
            subtitle: Text('Описание второго элемента'),
            trailing: Icon(Icons.arrow_forward),
          ),
          Divider(),

          // Элемент 3
          ListTile(
            leading: CircleAvatar(
              child: Text('3'),
            ),
            title: Text('Третий элемент'),
            subtitle: Text('Описание третьего элемента'),
            trailing: Icon(Icons.arrow_forward),
          ),
          Divider(),
        ],
      ),
    );
  }
}