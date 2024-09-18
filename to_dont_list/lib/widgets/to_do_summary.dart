import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_dont_list/objects/item.dart';

class ToDoSummary extends StatelessWidget {
  const ToDoSummary({
    Key? key,
    required this.items,
    required this.itemSet,
  }) : super(key: key);

  final List<Item> items;
  final Set<Item> itemSet;

  @override
  Widget build(BuildContext context) {
    int completedCount = itemSet.length;
    int pendingCount = items.length - completedCount;

    DateTime? nextDueDate;
    for (var item in items) {
      if (item.dueDate != null) {
        if (nextDueDate == null || item.dueDate!.isBefore(nextDueDate)) {
          nextDueDate = item.dueDate;
        }
      }
    }

    String dueDateText = nextDueDate != null
        ? DateFormat('yyyy-MM-dd').format(nextDueDate)
        : "No due dates";

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'To-Do List Summary',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8.0),
          Text('Pending items: $pendingCount'),
          Text('Completed items: $completedCount'),
          Text('Next due date: $dueDateText'),
        ],
      ),
    );
  }
}