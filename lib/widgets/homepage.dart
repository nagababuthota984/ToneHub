import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tonehub/data/tonedata.dart';
import 'package:tonehub/widgets/toneitem.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  List<ToneItem> _displayableToneItems = List<ToneItem>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    prepareToneItems();
    setState(() {
      _displayableToneItems;
    });
  }

  void prepareToneItems() {
    _displayableToneItems.add(ToneData.toneItems.first);
    _displayableToneItems.add(ToneData.toneItems.last);
  }

  void updateToneItemsState(List<ToneItem> items) {
    setState(() {
      items;
    });
  }

  void pickFile() async {
    var result = await FilePicker.platform.pickFiles(
        dialogTitle: "Pick an mp3 file",
        type: FileType.audio,
        allowMultiple: false);
    if (result == null)
      return;
    else {
      if (result.paths.isNotEmpty && result.names.isNotEmpty) {
        String fileName = result.names.first ?? "";
        String filePath = result.paths.first ?? "";
        if (fileName != "" && filePath != "") {
          _displayableToneItems
              .add(ToneItem(fileName: fileName, filePath: filePath));
          setState(() {
            _displayableToneItems;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ReorderableListView.builder(
        itemCount: _displayableToneItems.length,
        prototypeItem: ListTile(title: _displayableToneItems.first),
        itemBuilder: (context, index) {
          final toneItem = _displayableToneItems[index];
          return ListTile(
            title: toneItem,
            key: Key(toneItem.filePath),
          );
        },
        onReorder: (int oldIndex, int newIndex) {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickFile,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
