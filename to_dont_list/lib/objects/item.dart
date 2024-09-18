// Data class to keep the string and have an abbreviation function

class Item {
  const Item({required this.name, this.dueDate});

  final String name;
  final DateTime? dueDate;

  String abbrev() {
    return name.substring(0, 1);
  }
}
