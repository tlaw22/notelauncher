import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notelauncher++',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  void addItem(String item) {
    _items.add(item);
    saveData();
  }

  List<String> _items = [];

  Future<void> readJson() async {
    final String response =
    await rootBundle.loadString("assets/data/mydata.json");
    final data = await jsonDecode(response);
    setState(() {
      _items = data["items"];
      // print(".. number of item: ${_items.length}");   We are going to add this to the top of the list.
    });
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_items[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Item'),
                content: TextField(
                  onChanged: (value) {
                    addItem(value);
                  },
                ),
                actions: [
                  ElevatedButton(
                    child: Text('Save'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void saveData() {
    String data = _items.join(',');
    File('lib/data/mydata.json').writeAsStringSync(data);
  }
}
