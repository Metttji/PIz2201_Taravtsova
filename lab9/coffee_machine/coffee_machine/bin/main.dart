import 'dart:io';
import 'package:coffee_machine/coffee_machine.dart';

/// Главная функция программы
void main() {
  print('\n' * 2);
  print('╔══════════════════════════════════════════════════╗');
  print('║           ДОБРО ПОЖАЛОВАТЬ В КОФЕМАШИНУ!         ║');
  print('╚══════════════════════════════════════════════════╝');

  // Создаем кофемашину с начальными ресурсами
  CoffeeMachine machine = CoffeeMachine(
    coffeeBeans: 500,
    milk: 1000,
    water: 2000,
    cash: 0,
  );

  // Главный цикл программы
  bool isRunning = true;

  while (isRunning) {
    _showMainMenu();

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        _showCoffeeMenu(machine);
        break;
      case '2':
        _addResourcesMenu(machine);
        break;
      case '3':
        machine.showStatus();
        break;
      case '4':
        _withdrawMoney(machine);
        break;
      case '5':
        isRunning = false;
        _showExitMessage(machine);
        break;
      default:
        print('\n⚠️  Неверный выбор. Попробуйте снова.');
    }
  }
}

/// Показать главное меню
void _showMainMenu() {
  print('\n' * 2);
  print('════════════════════ ГЛАВНОЕ МЕНЮ ════════════════════');
  print('1. 🍵 Приготовить кофе');
  print('2. 📦 Добавить ресурсы');
  print('3. 📊 Показать статус');
  print('4. 💰 Изъять деньги');
  print('5. 🚪 Выход');
  print('═══════════════════════════════════════════════════');
  print('Выберите действие (1-5): ');
}

/// Показать меню выбора кофе
void _showCoffeeMenu(CoffeeMachine machine) {
  print('\n' * 2);
  print('══════════════════ ВЫБЕРИТЕ КОФЕ ══════════════════');
  print('1. Эспрессо ☕');
  print('   - Крепкий черный кофе');
  print('   - Цена: 100 руб');
  print('   - Ресурсы: 50г кофе, 100мл воды');
  print('');
  print('2. Капучино 🧋');
  print('   - Кофе с молочной пенкой');
  print('   - Цена: 150 руб');
  print('   - Ресурсы: 40г кофе, 150мл молока, 50мл воды');
  print('');
  print('3. Латте 🥛');
  print('   - Кофе с большим количеством молока');
  print('   - Цена: 170 руб');
  print('   - Ресурсы: 35г кофе, 200мл молока, 50мл воды');
  print('');
  print('0. ↩️  Назад в главное меню');
  print('═══════════════════════════════════════════════════');
  print('Выберите кофе (1-3) или 0 для возврата: ');

  String? choice = stdin.readLineSync();

  if (choice == '0') return;

  int coffeeType;
  try {
    coffeeType = int.parse(choice!);
    if (coffeeType < 1 || coffeeType > 3) {
      print('\n⚠️  Неверный выбор кофе.');
      return;
    }
  } catch (e) {
    print('\n⚠️  Пожалуйста, введите число.');
    return;
  }

  // Получаем цену кофе
  double price;
  switch (coffeeType) {
    case 1:
      price = 100;
      break;
    case 2:
      price = 150;
      break;
    case 3:
      price = 170;
      break;
    default:
      return;
  }

  print('\n💵 Цена кофе: $price руб');
  print('Внесите деньги: ');

  try {
    String? moneyInput = stdin.readLineSync();
    double money = double.parse(moneyInput!);

    if (money <= 0) {
      print('\n⚠️  Сумма должна быть положительной.');
      return;
    }

    // Пытаемся приготовить кофе
    bool success = machine.makeCoffee(coffeeType, money);

    if (success) {
      // Показываем остаток ресурсов
      print('\n' * 2);
      print('══════════════ ОСТАТОК РЕСУРСОВ ══════════════');
      print('☕ Кофе: ${machine.coffeeBeans.toStringAsFixed(1)}г');
      print('🥛 Молоко: ${machine.milk.toStringAsFixed(1)}мл');
      print('💧 Вода: ${machine.water.toStringAsFixed(1)}мл');
      print('═══════════════════════════════════════════════════');
    }

  } catch (e) {
    print('\n⚠️  Ошибка: Введите корректную сумму.');
  }

  // Ждем нажатия Enter для продолжения
  print('\nНажмите Enter для продолжения...');
  stdin.readLineSync();
}

/// Меню добавления ресурсов
void _addResourcesMenu(CoffeeMachine machine) {
  print('\n' * 2);
  print('════════════════ ДОБАВИТЬ РЕСУРСЫ ════════════════');

  try {
    print('Введите количество кофейных зерен (г): ');
    String? coffeeInput = stdin.readLineSync();
    double coffee = double.parse(coffeeInput!);

    print('Введите количество молока (мл): ');
    String? milkInput = stdin.readLineSync();
    double milk = double.parse(milkInput!);

    print('Введите количество воды (мл): ');
    String? waterInput = stdin.readLineSync();
    double water = double.parse(waterInput!);

    print('Внесите деньги в кассу (руб): ');
    String? cashInput = stdin.readLineSync();
    double cash = double.parse(cashInput!);

    // Проверяем на отрицательные значения
    if (coffee < 0 || milk < 0 || water < 0 || cash < 0) {
      print('\n⚠️  Значения не могут быть отрицательными.');
      return;
    }

    // Добавляем ресурсы
    machine.addResources(
      coffee: coffee,
      milk: milk,
      water: water,
      money: cash,
    );

  } catch (e) {
    print('\n⚠️  Ошибка: Введите корректные числа.');
  }

  print('\nНажмите Enter для продолжения...');
  stdin.readLineSync();
}

/// Изъятие денег из кофемашины
void _withdrawMoney(CoffeeMachine machine) {
  print('\n' * 2);
  print('══════════════════ ИЗЪЯТИЕ ДЕНЕГ ════════════════');

  if (machine.cash == 0) {
    print('💰 Касса пуста. Нет денег для изъятия.');
  } else {
    print('💰 В кассе: ${machine.cash.toStringAsFixed(2)} руб');
    print('Вы уверены, что хотите изъять все деньги? (да/нет): ');

    String? confirm = stdin.readLineSync();

    if (confirm?.toLowerCase() == 'да') {
      double withdrawn = machine.resetCash();
      print('✅ Изъято: ${withdrawn.toStringAsFixed(2)} руб');
    } else {
      print('❌ Изъятие отменено.');
    }
  }

  print('\nНажмите Enter для продолжения...');
  stdin.readLineSync();
}

/// Показать сообщение при выходе
void _showExitMessage(CoffeeMachine machine) {
  print('\n' * 3);
  print('══════════════════════════════════════════════════');
  print('                ИТОГОВЫЙ СТАТУС');
  print('══════════════════════════════════════════════════');
  print('☕ Кофейные зерна: ${machine.coffeeBeans.toStringAsFixed(1)} г');
  print('🥛 Молоко: ${machine.milk.toStringAsFixed(1)} мл');
  print('💧 Вода: ${machine.water.toStringAsFixed(1)} мл');
  print('💰 Деньги в кассе: ${machine.cash.toStringAsFixed(2)} руб');
  print('══════════════════════════════════════════════════');
  print('\nСпасибо за использование кофемашины! До свидания! 👋');
  print('\n' * 2);
}