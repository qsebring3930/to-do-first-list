// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/item.dart';
import 'package:to_dont_list/widgets/to_do_items.dart';
import 'package:to_dont_list/widgets/to_do_dialog.dart';
import 'package:to_dont_list/widgets/to_do_summary.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final List<Item> items = [const Item(name: "add more todos", color: Colors.purpleAccent)];
  final _itemSet = <Item>{};

  final List<Color> funColors = [
    Colors.pinkAccent,
    Colors.lightBlueAccent,
    Colors.amberAccent,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.tealAccent,
  ];

  Color _getRandomColor() {
    final random = Random();
    return funColors[random.nextInt(funColors.length)];
  }

  void _sortItemsByDueDate() {
    items.sort((a, b) {
      if (_itemSet.contains(a) && !_itemSet.contains(b)) {
        return 1;
      } else if (!_itemSet.contains(a) && _itemSet.contains(b)) {
        return -1;
      } else {
        if (a.dueDate == null && b.dueDate == null) {
          return 0;
        } else if (a.dueDate == null) {
          return 1; // Items with no due date come last
        } else if (b.dueDate == null) {
          return -1; // Items with no due date come last
        } else {
          return a.dueDate!.compareTo(b.dueDate!);
        }
      }
    });
  }

  void _handleListChanged(Item item, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      items.remove(item);
      if (!completed) {
        print("Completing");
        _itemSet.add(item);
        items.add(item);
      } else {
        print("Making Undone");
        _itemSet.remove(item);
        items.insert(0, item);
      }
      _sortItemsByDueDate();
    });
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      print("Deleting item");
      items.remove(item);
      _sortItemsByDueDate();
    });
  }

  void _handleNewItem(String itemText, DateTime? dueDate, TextEditingController textController) {
    setState(() {
      print("Adding new item");
      Item item = Item(name: itemText, dueDate: dueDate, color: _getRandomColor());
      items.insert(0, item);
      textController.clear();
      _sortItemsByDueDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('To Do List'),
        ),
        body: Column(
          children: [
            ToDoSummary(
            items: items,
            itemSet: _itemSet,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ToDoListItem(
                  item: items[index],
                  completed: _itemSet.contains(items[index]),
                  onListChanged: _handleListChanged,
                  onDeleteItem: _handleDeleteItem,
                  tileSize: index == 0 ? 300.0 : 70.0,
                ),
              ),
            ),
          ),
        ]),
        floatingActionButton: FloatingActionButton(
            key: const Key("AddItem"),
            child: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return ToDoDialog(onListAdded: _handleNewItem);
                  });
            }));
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'To Do List',
    home: ToDoList(),
  ));
}
