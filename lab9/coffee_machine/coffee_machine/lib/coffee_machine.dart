/// Класс Кофемашина
/// Реализует функционал кофемашины с ресурсами и приготовлением кофе
class CoffeeMachine {
  // Приватные поля (инкапсуляция)
  double _coffeeBeans;    // Кофейные зерна в граммах
  double _milk;           // Молоко в миллилитрах
  double _water;          // Вода в миллилитрах
  double _cash;           // Деньги в рублях

  // Константы для расхода ресурсов
  static const double _ESPRESSO_COFFEE = 50.0;
  static const double _ESPRESSO_WATER = 100.0;
  static const double _ESPRESSO_PRICE = 100.0;

  static const double _CAPPUCCINO_COFFEE = 40.0;
  static const double _CAPPUCCINO_MILK = 150.0;
  static const double _CAPPUCCINO_WATER = 50.0;
  static const double _CAPPUCCINO_PRICE = 150.0;

  static const double _LATTE_COFFEE = 35.0;
  static const double _LATTE_MILK = 200.0;
  static const double _LATTE_WATER = 50.0;
  static const double _LATTE_PRICE = 170.0;

  /// Конструктор класса
  /// [coffeeBeans] - начальное количество кофейных зерен (г)
  /// [milk] - начальное количество молока (мл)
  /// [water] - начальное количество воды (мл)
  /// [cash] - начальная сумма денег
  CoffeeMachine({
    double coffeeBeans = 0,
    double milk = 0,
    double water = 0,
    double cash = 0,
  })  : _coffeeBeans = coffeeBeans,
        _milk = milk,
        _water = water,
        _cash = cash;

  // ============ ГЕТТЕРЫ (доступ к состоянию) ============

  /// Получить количество кофейных зерен
  double get coffeeBeans => _coffeeBeans;

  /// Получить количество молока
  double get milk => _milk;

  /// Получить количество воды
  double get water => _water;

  /// Получить количество денег
  double get cash => _cash;

  // ============ СЕТТЕРЫ (изменение состояния) ============

  /// Установить количество кофейных зерен
  set coffeeBeans(double value) {
    if (value < 0) {
      throw ArgumentError('Количество кофе не может быть отрицательным');
    }
    _coffeeBeans = value;
  }

  /// Установить количество молока
  set milk(double value) {
    if (value < 0) {
      throw ArgumentError('Количество молока не может быть отрицательным');
    }
    _milk = value;
  }

  /// Установить количество воды
  set water(double value) {
    if (value < 0) {
      throw ArgumentError('Количество воды не может быть отрицательным');
    }
    _water = value;
  }

  /// Установить количество денег
  set cash(double value) {
    if (value < 0) {
      throw ArgumentError('Количество денег не может быть отрицательным');
    }
    _cash = value;
  }

  // ============ ПУБЛИЧНЫЕ МЕТОДЫ ============

  /// Добавить ресурсы в машину
  /// [coffee] - кофе для добавления (г)
  /// [milk] - молоко для добавления (мл)
  /// [water] - вода для добавления (мл)
  /// [money] - деньги для добавления (руб)
  void addResources({
    double coffee = 0,
    double milk = 0,
    double water = 0,
    double money = 0,
  }) {
    if (coffee < 0 || milk < 0 || water < 0 || money < 0) {
      throw ArgumentError('Значения не могут быть отрицательными');
    }

    _coffeeBeans += coffee;
    _milk += milk;
    _water += water;
    _cash += money;

    print('✅ Ресурсы добавлены успешно!');
    print('   Кофе: +${coffee.toStringAsFixed(1)}г');
    print('   Молоко: +${milk.toStringAsFixed(1)}мл');
    print('   Вода: +${water.toStringAsFixed(1)}мл');
    print('   Деньги: +${money.toStringAsFixed(2)} руб');
  }

  /// Проверить доступность ресурсов для конкретного кофе
  /// [coffeeType] - тип кофе (1-эспрессо, 2-капучино, 3-латте)
  /// Возвращает true, если ресурсов достаточно
  bool checkResources(int coffeeType) {
    switch (coffeeType) {
      case 1: // Эспрессо
        return _coffeeBeans >= _ESPRESSO_COFFEE && _water >= _ESPRESSO_WATER;
      case 2: // Капучино
        return _coffeeBeans >= _CAPPUCCINO_COFFEE &&
            _milk >= _CAPPUCCINO_MILK &&
            _water >= _CAPPUCCINO_WATER;
      case 3: // Латте
        return _coffeeBeans >= _LATTE_COFFEE &&
            _milk >= _LATTE_MILK &&
            _water >= _LATTE_WATER;
      default:
        return false;
    }
  }

  /// Приготовить кофе
  /// [coffeeType] - тип кофе (1-эспрессо, 2-капучино, 3-латте)
  /// [money] - внесенная сумма денег
  /// Возвращает true, если кофе приготовлен успешно
  bool makeCoffee(int coffeeType, double money) {
    // Проверяем, хватает ли денег
    double price = _getPrice(coffeeType);
    if (money < price) {
      print('❌ Недостаточно денег. Нужно: $price руб, внесено: $money руб');
      return false;
    }

    // Проверяем ресурсы
    if (!checkResources(coffeeType)) {
      print('❌ Недостаточно ресурсов для приготовления кофе');
      _printMissingResources(coffeeType);
      return false;
    }

    // Используем ресурсы
    _useResources(coffeeType);

    // Принимаем деньги и даем сдачу
    _cash += price;
    double change = money - price;

    if (change > 0) {
      print('💵 Сдача: ${change.toStringAsFixed(2)} руб');
    }

    // Показываем результат
    _showCoffeeResult(coffeeType);
    return true;
  }

  /// Показать статус кофемашины
  void showStatus() {
    print('\n══════════════════════════════════════════════════');
    print('             СТАТУС КОФЕМАШИНЫ');
    print('══════════════════════════════════════════════════');
    print('☕ Кофейные зерна: ${_coffeeBeans.toStringAsFixed(1)} г');
    print('🥛 Молоко: ${_milk.toStringAsFixed(1)} мл');
    print('💧 Вода: ${_water.toStringAsFixed(1)} мл');
    print('💰 Деньги: ${_cash.toStringAsFixed(2)} руб');
    print('══════════════════════════════════════════════════\n');
  }

  /// Сбросить деньги (обнулить кассу)
  double resetCash() {
    double cashBack = _cash;
    _cash = 0;
    print('💸 Касса обнулена. Возвращено: ${cashBack.toStringAsFixed(2)} руб');
    return cashBack;
  }

  // ============ ПРИВАТНЫЕ МЕТОДЫ ============

  /// Получить цену кофе по типу
  double _getPrice(int coffeeType) {
    switch (coffeeType) {
      case 1: return _ESPRESSO_PRICE;
      case 2: return _CAPPUCCINO_PRICE;
      case 3: return _LATTE_PRICE;
      default: return 0;
    }
  }

  /// Использовать ресурсы для приготовления кофе
  void _useResources(int coffeeType) {
    switch (coffeeType) {
      case 1: // Эспрессо
        _coffeeBeans -= _ESPRESSO_COFFEE;
        _water -= _ESPRESSO_WATER;
        break;
      case 2: // Капучино
        _coffeeBeans -= _CAPPUCCINO_COFFEE;
        _milk -= _CAPPUCCINO_MILK;
        _water -= _CAPPUCCINO_WATER;
        break;
      case 3: // Латте
        _coffeeBeans -= _LATTE_COFFEE;
        _milk -= _LATTE_MILK;
        _water -= _LATTE_WATER;
        break;
    }
  }

  /// Показать недостающие ресурсы
  void _printMissingResources(int coffeeType) {
    print('   Требуется:');

    switch (coffeeType) {
      case 1: // Эспрессо
        if (_coffeeBeans < _ESPRESSO_COFFEE) {
          print('   - Кофе: ${_ESPRESSO_COFFEE - _coffeeBeans}г');
        }
        if (_water < _ESPRESSO_WATER) {
          print('   - Вода: ${_ESPRESSO_WATER - _water}мл');
        }
        break;
      case 2: // Капучино
        if (_coffeeBeans < _CAPPUCCINO_COFFEE) {
          print('   - Кофе: ${_CAPPUCCINO_COFFEE - _coffeeBeans}г');
        }
        if (_milk < _CAPPUCCINO_MILK) {
          print('   - Молоко: ${_CAPPUCCINO_MILK - _milk}мл');
        }
        if (_water < _CAPPUCCINO_WATER) {
          print('   - Вода: ${_CAPPUCCINO_WATER - _water}мл');
        }
        break;
      case 3: // Латте
        if (_coffeeBeans < _LATTE_COFFEE) {
          print('   - Кофе: ${_LATTE_COFFEE - _coffeeBeans}г');
        }
        if (_milk < _LATTE_MILK) {
          print('   - Молоко: ${_LATTE_MILK - _milk}мл');
        }
        if (_water < _LATTE_WATER) {
          print('   - Вода: ${_LATTE_WATER - _water}мл');
        }
        break;
    }
  }

  /// Показать результат приготовления кофе
  void _showCoffeeResult(int coffeeType) {
    String coffeeName = '';
    String emoji = '';

    switch (coffeeType) {
      case 1:
        coffeeName = 'Эспрессо';
        emoji = '☕';
        break;
      case 2:
        coffeeName = 'Капучино';
        emoji = '🧋';
        break;
      case 3:
        coffeeName = 'Латте';
        emoji = '🥛';
        break;
    }

    print('\n$emoji  ===================================  $emoji');
    print('      🎉 КОФЕ ГОТОВ! 🎉');
    print('      $coffeeName приготовлен!');
    print('$emoji  ===================================  $emoji\n');
  }
}