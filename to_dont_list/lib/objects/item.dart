// Data class to keep the string and have an abbreviation function

import 'dart:ui';

class Item {
  const Item({required this.name, this.dueDate, required this.color});

  final String name;
  final DateTime? dueDate;
  final Color color;

  String abbrev() {
    return name.substring(0, 1);
  }
}
