import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_dont_list/objects/item.dart';

typedef ToDoListChangedCallback = Function(Item item, bool completed);
typedef ToDoListRemovedCallback = Function(Item item);

class ToDoListItem extends StatelessWidget {
  ToDoListItem(
      {required this.item,
      required this.completed,
      required this.onListChanged,
      required this.onDeleteItem})
      : super(key: ObjectKey(item));

  final Item item;
  final bool completed;

  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;

  Color? _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return completed //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!completed) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          onListChanged(item, completed);
        },
        onLongPress: completed
            ? () {
                onDeleteItem(item);
              }
            : null,
        leading: CircleAvatar(
          backgroundColor: _getColor(context),
          child: Text(item.abbrev()),
        ),
        title: Text(
          item.name,
          style: _getTextStyle(context),
        ),
        subtitle: item.dueDate != null
          ? Text(DateFormat('yyyy-MM-dd').format(item.dueDate!))
          : null,
      ),
    );
  }
}
