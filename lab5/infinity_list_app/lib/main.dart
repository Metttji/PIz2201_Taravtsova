import 'package:flutter/material.dart';

void main() {
  runApp(const InfinityListApp());
}

class InfinityListApp extends StatelessWidget {
  const InfinityListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Бесконечный список',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const InfinityListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InfinityListScreen extends StatefulWidget {
  const InfinityListScreen({super.key});

  @override
  State<InfinityListScreen> createState() => _InfinityListScreenState();
}

class _InfinityListScreenState extends State<InfinityListScreen> {
  // Список для хранения элементов
  final List<String> _items = [];

  // Флаг загрузки
  bool _isLoading = false;

  // Метод для загрузки новых элементов
  Future<void> _loadMoreItems() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Имитируем задержку загрузки
    await Future.delayed(const Duration(seconds: 1));

    // Добавляем 10 новых элементов
    final int startIndex = _items.length;
    final int endIndex = startIndex + 10;

    final List<String> newItems = [];
    for (int i = startIndex; i < endIndex; i++) {
      newItems.add('Элемент №$i');
    }

    setState(() {
      _items.addAll(newItems);
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Загружаем первую порцию элементов при запуске
    _loadMoreItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Бесконечный список'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          // Если достигли конца списка - загружаем ещё
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !_isLoading) {
            _loadMoreItems();
          }
          return true;
        },
        child: ListView.builder(
          itemCount: _items.length + 1, // +1 для индикатора загрузки
          itemBuilder: (context, index) {
            // Если это последний элемент - показываем индикатор загрузки
            if (index == _items.length) {
              return _isLoading
                  ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  : Container(); // Пустой контейнер в конце
            }

            // Обычный элемент списка
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green[100],
                child: Text(
                  index.toString(),
                  style: const TextStyle(color: Colors.green),
                ),
              ),
              title: Text(
                _items[index],
                style: const TextStyle(fontSize: 16),
              ),
              subtitle: Text(
                'Это элемент с индексом $index',
                style: const TextStyle(fontSize: 14),
              ),
              trailing: const Icon(Icons.more_vert),
              onTap: () {
                // Действие при нажатии на элемент
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Нажат элемент: ${_items[index]}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Кнопка для ручной загрузки элементов
          _loadMoreItems();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}