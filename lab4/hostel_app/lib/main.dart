import 'package:flutter/material.dart';

void main() {
  runApp(const HostelApp());
}

class HostelApp extends StatelessWidget {
  const HostelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Общежитие КубГАУ',
      theme: ThemeData(
        primarySwatch: Colors.green,  // Зелёная тема
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HostelScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HostelScreen extends StatefulWidget {
  const HostelScreen({super.key});

  @override
  State<HostelScreen> createState() => _HostelScreenState();
}

class _HostelScreenState extends State<HostelScreen> {
  bool _isLiked = false;  // Состояние сердечка

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _callAction() {
    // Действие для кнопки "Позвонить"
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Набираем номер: +7 (861) 221-58-00'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _routeAction() {
    // Действие для кнопки "Маршрут"
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Строим маршрут до ул. Калинина, 13'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareAction() {
    // Действие для кнопки "Поделиться"
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Поделиться информацией об общежитии'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Общежитие КубГАУ'),
        backgroundColor: Colors.green,  // Зелёный цвет
        centerTitle: true,
      ),
      body: SingleChildScrollView(  // Делаем экран прокручиваемым
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Карточка с информацией
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Заголовок и сердечко
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Общежитие №20',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                          // Сердечко (красное при нажатии)
                          IconButton(
                            onPressed: _toggleLike,
                            icon: Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _isLiked ? Colors.red : Colors.grey,
                              size: 30,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Адрес
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Краснодар, ул. Калинина, 13',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Изображение общежития
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/hostel.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Если изображение не загрузилось
                              return const Center(
                                child: Icon(
                                  Icons.home_work,
                                  size: 80,
                                  color: Colors.green,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Кнопки действий
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Кнопка "Позвонить"
                          ElevatedButton.icon(
                            onPressed: _callAction,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.call, size: 20),
                            label: const Text('ПОЗВОНИТЬ'),
                          ),

                          // Кнопка "Маршрут"
                          ElevatedButton.icon(
                            onPressed: _routeAction,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.directions, size: 20),
                            label: const Text('МАРШРУТ'),
                          ),

                          // Кнопка "Поделиться"
                          ElevatedButton.icon(
                            onPressed: _shareAction,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.share, size: 20),
                            label: const Text('ПОДЕЛИТЬСЯ'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Длинный текст про общежития
              Text(
                'Студенческий городок или так называемый кампус Кубанского ГАУ состоит из двадцати общежитий, в которых проживает более 8000 студентов, что составляет 96% от всех нуждающихся. Студенты первого курса обеспечены местами в общежитии полностью. В соответствии с Положением о студенческих общежитиях университета, при поселении между администрацией и студентами заключается договор найма жилого помещения. Воспитательная работа в общежитиях направлена на улучшение быта, соблюдение правил внутреннего распорядка, отсутствия асоциальных явлений в молодежной среде. Условия проживания в общежитиях университетского кампуса полностью отвечают санитарным нормам и требованиям: наличие оборудованных кухонь, душевых комнат, прачечных, читальных залов, комнат самоподготовки, помещений для заседаний студенческих советов и наглядной агитации. С целью улучшения условий быта студентов активно работает система студенческого самоуправления – студенческие советы организуют всю работу по самообслуживанию.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 30),

              // Дополнительная информация
              Card(
                color: Colors.green[50],
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Контакты для связи:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        leading: Icon(Icons.phone, color: Colors.green),
                        title: Text('+7 (861) 221-58-00'),
                        subtitle: Text('Телефон коменданта'),
                      ),
                      ListTile(
                        leading: Icon(Icons.email, color: Colors.green),
                        title: Text('hostel@kubsau.ru'),
                        subtitle: Text('Электронная почта'),
                      ),
                      ListTile(
                        leading: Icon(Icons.access_time, color: Colors.green),
                        title: Text('Круглосуточно'),
                        subtitle: Text('Режим работы'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}