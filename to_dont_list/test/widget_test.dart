// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:to_dont_list/main.dart';
import 'package:to_dont_list/objects/item.dart';
import 'package:to_dont_list/widgets/to_do_items.dart';
import 'package:to_dont_list/widgets/to_do_summary.dart';

void main() {
  test('Item abbreviation should be first letter', () {
    const item = Item(name: "add more todos", color: Colors.black);
    expect(item.abbrev(), "a");
  });

  // Yes, you really need the MaterialApp and Scaffold
  testWidgets('ToDoListItem has a text', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                item: const Item(name: "test", color: Colors.black),
                completed: true,
                onListChanged: (Item item, bool completed) {},
                onDeleteItem: (Item item) {}, tileSize: 70.0,))));
    final textFinder = find.text('test');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(textFinder, findsOneWidget);
  });

  testWidgets('ToDoListItem has a Circle Avatar with abbreviation', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                item: const Item(name: "test", color: Colors.black),
                completed: true,
                onListChanged: (Item item, bool completed) {},
                onDeleteItem: (Item item) {}, tileSize: 70.0,))));
    final abbvFinder = find.text('t');
    final avatarFinder = find.byType(CircleAvatar);

    CircleAvatar circ = tester.firstWidget(avatarFinder);
    Text ctext = circ.child as Text;

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(abbvFinder, findsOneWidget);
    expect(circ.backgroundColor, Colors.black54);
    expect(ctext.data, "t");
  });

  testWidgets('Default ToDoList has one item', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsOneWidget);
  });

  testWidgets('Clicking and Typing adds item to ToDoList', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    expect(find.byKey(const Key("ItemName")), findsNothing);

    await tester.tap(find.byKey(const Key("AddItem")));
    await tester.pump(); // Pump after every action to rebuild the widgets
    expect(find.text("hi"), findsNothing);

    await tester.enterText(find.byKey(const Key("ItemName")), 'hi');
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsNWidgets(2));
  });

  testWidgets('Toggle summary visibility', (WidgetTester tester) async {
    List<Item> items = [
      const Item(name: 'Task 1', color: Colors.black),
      const Item(name: 'Task 2', color: Colors.black),
    ];
    Set<Item> itemSet = {};

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ToDoSummary(items: items, itemSet: itemSet),
      ),
    ));
                
    expect(find.text('Pending items: 2'), findsOneWidget);

    await tester.tap(find.byKey(const Key("VisibilityButton")));
    await tester.pump();

    expect(find.text('Pending items: 0'), findsNothing);

    await tester.tap(find.byKey(const Key("VisibilityButton")));
    await tester.pump();

    expect(find.text('Pending items: 2'), findsOneWidget);
  });

  testWidgets('Item has a due date displayed', (WidgetTester tester) async {
    DateTime dueDate1 = DateTime.parse("2024-09-18");
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                item: Item(name: "test", color: Colors.black, dueDate: dueDate1),
                completed: true,
                onListChanged: (Item item, bool completed) {},
                onDeleteItem: (Item item) {}, tileSize: 70.0,))));
                
    expect(find.text("2024-09-18"), findsOneWidget);

  });

  testWidgets('Check if completing items updates summary', (WidgetTester tester) async {
    List<Item> items = [
      const Item(name: 'Task 1', color: Colors.black),
      const Item(name: 'Task 2', color: Colors.black),
    ];
    Set<Item> itemSet = {};

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ToDoSummary(items: items, itemSet: itemSet),
      ),
    ));
                
    expect(find.text('Pending items: 2'), findsOneWidget);
    expect(find.text('Completed items: 0'), findsOneWidget);

    itemSet.add(items[0]);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ToDoSummary(items: items, itemSet: itemSet),
      ),
    ));

    expect(find.text('Pending items: 1'), findsOneWidget);
    expect(find.text('Completed items: 1'), findsOneWidget);

  });

  testWidgets('Check if summary knows closest due date', (WidgetTester tester) async {
    DateTime dueDate1 = DateTime.parse("2024-09-18");
    DateTime dueDate2 = DateTime.parse("2024-09-24");

    List<Item> items = [
      const Item(name: 'Task 1', color: Colors.black),
      Item(name: 'Task 2', color: Colors.black, dueDate: dueDate1),
      Item(name: 'Task 1', color: Colors.black, dueDate: dueDate2),
    ];
    Set<Item> itemSet = {};

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ToDoSummary(items: items, itemSet: itemSet),
      ),
    ));
                
    expect(find.text('Next due date: 2024-09-18'), findsOneWidget);
  });

  testWidgets('Check if closest due date is first in list', (WidgetTester tester) async {

    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    await tester.tap(find.byKey(const Key("AddItem")));
    await tester.pump();

    await tester.enterText(find.byKey(const Key("ItemName")), 'Task 1');
    await tester.pump();

    await tester.enterText(find.byKey(const Key("ItemDate")), '2024-09-18');
    await tester.pump();

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();

    await tester.tap(find.byKey(const Key("AddItem")));
    await tester.pump();

    await tester.enterText(find.byKey(const Key("ItemName")), 'Task 2');
    await tester.pump();

    await tester.enterText(find.byKey(const Key("ItemDate")), '2024-09-14');
    await tester.pump();

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();
                
    final listItems = tester.widgetList<ToDoListItem>(find.byType(ToDoListItem)).toList();

    expect(listItems[0].item.name, 'Task 2');


  });



  




}

  // One to test the tap and press actions on the items
