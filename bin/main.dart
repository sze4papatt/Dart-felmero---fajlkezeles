import 'dart:io';

/// 1. feladat – fájl létrehozása
Future<void> createFile(String fileName) async {
  final file = File(fileName);

  try {
    final exists = await file.exists();
    if (!exists) {
      await file.create(recursive: true);
      print('A(z) $fileName fájl sikeresen létrehozva.');
    } else {
      print('A(z) $fileName fájl már létezik.');
    }
  } catch (e) {
    print('Hiba a(z) $fileName fájl létrehozásakor: $e');
  }
}

/// 2. feladat – fájl törlése
Future<void> deleteFile(String fileName) async {
  final file = File(fileName);

  try {
    final exists = await file.exists();
    if (exists) {
      await file.delete();
      print('A(z) $fileName fájl törlése sikeres volt.');
    } else {
      print('A(z) $fileName fájl nem létezik, törlés sikertelen.');
    }
  } catch (e) {
    print('Hiba a(z) $fileName fájl törlésekor: $e');
  }
}

/// 3. feladat – fájl beolvasása
Future<List<String>> readFile(String fileName) async {
  final file = File(fileName);
  try {
    final exists = await file.exists();
    if (!exists) {
      print('A(z) $fileName fájl nem létezik.');
      return [];
    }
    final lines = await file.readAsLines();
    return lines;
  } catch (e) {
    print('Hiba a(z) $fileName fájl olvasásakor: $e');
    return [];
  }
}

/// 3. feladat – tartalom kiírása
void printContent(List<String> content) {
  if (content.isEmpty) {
    print('Nincs megjeleníthető adat.');
    return;
  }

  final women = <String>[];
  final men = <String>[];
  final others = <String>[]; 

  for (final line in content) {
    final parts = line.split(';');
    if (parts.length < 3) {
      others.add(line);
      continue;
    }

    final gender = parts[2].trim().toLowerCase();
    if (gender == 'nő' || gender == 'no') {
      women.add(line);
    } else if (gender == 'férfi' || gender == 'ferfi' || gender == 'ffi') {
      men.add(line);
    } else {
      others.add(line);
    }
  }

  print('--- Nők ---');
  for (final w in women) {
    print(w);
  }

  print('--- Férfiak ---');
  for (final m in men) {
    print(m);
  }

  if (others.isNotEmpty) {
    print('--- Egyéb / ismeretlen nem ---');
    for (final o in others) {
      print(o);
    }
  }
}

/// 4. feladat – számok hozzáadása a numbers.txt-hez
Future<void> addNumbers(String fileName, List<int> numbers) async {
  final file = File(fileName);
  try {
    final sink = file.openWrite(mode: FileMode.append);
    sink.writeln(numbers.join(' '));
    await sink.close();
    print('Számok hozzáadva a(z) $fileName fájlhoz.');
  } catch (e) {
    print('Hiba a számok hozzáadásakor ($fileName): $e');
  }
}

/// 4. feladat – számok kiíratása növekvő sorrendben
void printNumbers(List<String> fileContent) {
  final allNumbers = <int>[];

  for (final line in fileContent) {
    if (line.trim().isEmpty) continue;
    final parts = line.trim().split(RegExp(r'\s+'));
    for (final part in parts) {
      final parsed = int.tryParse(part);
      if (parsed != null) {
        allNumbers.add(parsed);
      }
    }
  }

  if (allNumbers.isEmpty) {
    print('A fájl nem tartalmaz számokat.');
    return;
  }

  allNumbers.sort();

  print('Számok növekvő sorrendben:');
  for (final n in allNumbers) {
    print(n);
  }
}

Future<void> main() async {
  // 1. feladat – fájl létrehozása
  await createFile('players.txt');
  await createFile('cars.txt');

  // 2. feladat – fájl törlése
  await deleteFile('players.txt');

  // 3. feladat – employees.txt kezelése
  final employeesContent = await readFile('employees.txt');
  print('\nemployees.txt tartalma (nők, aztán férfiak):');
  printContent(employeesContent);

  // 4. feladat – numbers.txt kezelése
  final newNumbers = [8, 0, 5, 1, 3, 2, 11, 19, 1];
  await addNumbers('numbers.txt', newNumbers);

  final numbersContent = await readFile('numbers.txt');
  print('\nnumbers.txt rendezett tartalma:');
  printNumbers(numbersContent);
}
