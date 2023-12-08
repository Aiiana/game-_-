import 'dart:io';
import 'dart:math';

void main() {
  bool exit = false;

  while (!exit) {
    print("Выберите:\n1-Игра на одного.\n2-Соревнование\n3-Выйти из программы ");
    ModeNumberOfPeople people = ModeNumberOfPeople(int.tryParse(stdin.readLineSync() ?? "") ?? 0);
    people.modeNumberOfPeople1();

    if (people.modeNumberOfPeople == 1) {
      // Если выбран режим "Игра на одного", запрашиваем параметры один раз перед циклом раундов
      print("Введите количество раундов:");
      int rounds = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
       print("Выберите режим игры:\n1-Пользователь загадывает число, а компьютер угадывает.\n2-Компьютер загадывает число, а пользователь отгадывает.");
        GameMode game = GameMode(int.tryParse(stdin.readLineSync() ?? "") ?? 0);
        game.gameMode1();

        print("Выберите уровень сложности:\n1-Легкий\n2-Средний\n3-Сложный");
        DifficultyLevel level = DifficultyLevel(int.tryParse(stdin.readLineSync() ?? "") ?? 0);
        level.difficultyLevel1();
      // Затем выполняем указанное количество раундов
      for (int i = 1; i <= rounds; i++) {
        print("\nРаунд $i:");

        print("Игра началась!");

        if (game.gameMode == 1 && level.difficultyLevel == 1) {
          User user = User(first: 1, last: 100);
          user.play();
        } else if (game.gameMode == 2 && level.difficultyLevel == 1) {
          Computer computerHard = Computer(first: 1, last: 100);
          computerHard.play();
        }
      }
    } else if (people.modeNumberOfPeople == 2) {
      // Если выбран режим "Соревнование", запускаем соревнование
      print("Соревнование началось!");

      User user1 = User(first: 1, last: 100);
      Computer computerHard = Computer(first: 1, last: 100);

      for (int i = 1; i <= 3; i++) {
        print("Раунд $i:");

        print("Игрок №1");
        user1.play();

        print("Игрок №2");
        computerHard.play();

        if (user1.steps < computerHard.steps) {
          print("Игрок №1 выиграл раунд $i с меньшим количеством шагов!");
        } else if (user1.steps > computerHard.steps) {
          print("Игрок №2 выиграл раунд $i с меньшим количеством шагов!");
        } else {
          print("Раунд $i: Ничья! Оба игрока угадали число за одинаковое количество шагов.");
        }

        // После каждого раунда обновляем диапазон для следующего раунда
        user1.reset();
        computerHard.reset();
      }

      // Финальный результат после трех раундов
      if (user1.steps < computerHard.steps) {
        print("ВЫИГРАЛ ИГРОК №1!");
      } else if (user1.steps > computerHard.steps) {
        print("ВЫИГРАЛ ИГРОК №2!");
      } else {
        print(" НИЧЬЯ!");
      }
    } else if (people.modeNumberOfPeople == 3) {
      // Если выбрано "Выйти из программы", устанавливаем флаг выхода из цикла
      exit = true;
    }

    // После завершения игры, спрашиваем пользователя, хочет ли он продолжить
    if (!exit) {
      print("\nВыход в главное меню:введите(да/нет");
      String continuePlaying = stdin.readLineSync()?.toLowerCase() ?? '';
      if (continuePlaying != 'y') {
        exit = true;
      }
    }
  }
}
class ModeNumberOfPeople {
  int modeNumberOfPeople;

  ModeNumberOfPeople(this.modeNumberOfPeople);

  void modeNumberOfPeople1() {
    if (modeNumberOfPeople == 1) {
      print("Вы выбрали: Игра на одного");
    } else if (modeNumberOfPeople == 2) {
      print("Вы выбрали: Соревнование.");
    } else {
      print("Досвидание!");
    }
  }
}
class GameMode {
  int gameMode;

  GameMode(this.gameMode);

  void gameMode1() {
    if (gameMode == 1) {
      print("Вы выбрали режим: Пользователь загадывает число, а компьютер угадывает");
    } else if (gameMode == 2) {
      print("Вы выбрали режим: Компьютер загадывает число, а пользователь отгадывает");
    } else {
      print("Ошибка");
    }
  }
}
class DifficultyLevel {
  int difficultyLevel;

  DifficultyLevel(this.difficultyLevel);

  void difficultyLevel1() {
    if (difficultyLevel == 1) {
      print("Вы выбрали: Легкий");
    } else if (difficultyLevel == 2) {
      print("Вы выбрали: Средний");
    } else if (difficultyLevel == 3) {
      print("Вы выбрали: Сложный");
    } else {
      print("Ошибка");
    }
  }
}
class User {
  int first;
  int last;
  int steps = 0;

  User({required this.first, required this.last});

  int guess() {
    return (first + last) ~/ 2;
  }

  void play() {
    print('Загадайте число от $first до $last.');
    String user;
    int guess1;

    do {
      if (steps > 7) {
        print('Вы исчерпали максимальное количество попыток. Игра завершена.');
        return;
      }
      guess1 = guess();
      print('Это число $guess1? (б(больше)/м(меньше)/п(правильно))');
      user = stdin.readLineSync() ?? '';

      if (user.toLowerCase() == 'б') {
        first = guess1 + 1;
      } else if (user.toLowerCase() == 'м') {
        last = guess1 - 1;
      }
      steps++;
    } while (user.toLowerCase() != 'п');

    print('Я угадал ваше число: $guess1 за $steps шага/шагов.');
  }

  void reset() {
    steps = 0;
  }
}

class Computer {
  int first;
  int last;
  int steps = 0;

  Computer({required this.first, required this.last});

  void play() {
    print("Компьютер загадал число от $first до $last. Попробуйте угадать.");
    int computerNumber = generateRandomNumber();
    int userGuess;

    do {
      if (steps > 7) {
        print("Количество попыток исчерпано. Загаданное число: $computerNumber");
        return;
      }
      print("Какое число вы думаете, что загадал компьютер? ");
      userGuess = int.tryParse(stdin.readLineSync() ?? "") ?? 0;

      if (userGuess > computerNumber) {
        print("Меньше.");
      } else if (userGuess < computerNumber) {
        print("Больше.");
      } else {
        print("Поздравляем, вы угадали число $userGuess за $steps шага!");
      }
      steps++;
    } while (userGuess != computerNumber);
  }

  int generateRandomNumber() {
    Random random = Random();
    return first + random.nextInt(last - first + 1);
  }

  void reset() {
    steps = 0;
  }
}
