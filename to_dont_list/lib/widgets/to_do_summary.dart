import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_dont_list/objects/item.dart';

class ToDoSummary extends StatefulWidget {
  const ToDoSummary({
    Key? key,
    required this.items,
    required this.itemSet,
  }) : super(key: key);

  final List<Item> items;
  final Set<Item> itemSet;

  @override
  _ToDoSummaryState createState() => _ToDoSummaryState();
}

class _ToDoSummaryState extends State<ToDoSummary> {
  bool _isSummaryVisible = true;

  @override
  Widget build(BuildContext context) {
    int completedCount = widget.itemSet.length;
    int pendingCount = widget.items.length - completedCount;

    DateTime? nextDueDate;
    for (var item in widget.items) {
      if (item.dueDate != null) {
        if (nextDueDate == null || item.dueDate!.isBefore(nextDueDate)) {
          nextDueDate = item.dueDate;
        }
      }
    }

    String dueDateText = nextDueDate != null
        ? DateFormat('yyyy-MM-dd').format(nextDueDate)
        : "No due dates";
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: TextButton(
            key: const Key("VisibilityButton"),
            onPressed: () {
              setState(() {
                _isSummaryVisible = !_isSummaryVisible;
              });
            },
            child: Text(_isSummaryVisible ? 'Hide Summary' : 'Show Summary'),
          ),
        ),
        Visibility(
          visible: _isSummaryVisible,
          child: Center(
            child: Container(
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
            ),
          ),
        ),
      ],
    );
  }
}