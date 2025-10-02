import 'package:flutter/material.dart';
import 'package:tonehub/data/tonedata.dart';
import 'package:tonehub/services/audioService.dart';
import 'package:tonehub/services/ringtoneService.dart';
import 'package:tonehub/widgets/toneitem.dart';
import 'filePickBtn.dart';

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
  List<ToneItem> _displayableToneItems = List<ToneItem>.empty(growable: true);
  final AudioService audioService = AudioService();
  final RingtoneService ringtoneService = RingtoneService();
  
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

  Widget buildDialog(
      String title, String content, String okContent, String cancelContent) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: Text(cancelContent),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: Text(cancelContent),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.black;
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
            title: ToneItem(
              filePath: toneItem.filePath,
              fileName: toneItem.fileName,
              id: toneItem.id,
              onSetRingtone: () => onSetRingtone(toneItem),
            ),
            focusColor: Colors.blue,
            key: Key(toneItem.filePath),
            textColor: textColor,
            onTap: () {
              onToneTap(toneItem);
            },
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          var tempToneitem = _displayableToneItems[newIndex];
          _displayableToneItems[newIndex] = _displayableToneItems[oldIndex];
          _displayableToneItems[oldIndex] = tempToneitem;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addToneClicked,
        tooltip: 'Add Ringtone',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void addToneClicked() async {
    var toneItem = await pickFile();
    if (!doesToneAlreadyExist(toneItem.id)) {
      _displayableToneItems.add(toneItem);
      updateToneItemsState(_displayableToneItems);
    }
  }

  bool doesToneAlreadyExist(String fileId) {
    return _displayableToneItems.isNotEmpty &&
        _displayableToneItems.any((element) => element.id == fileId);
  }

  void onToneTap(ToneItem toneItem) async {
    //handles list item tap.
    if (!audioService.isPlaying) {
      await audioService.playAudio(toneItem.filePath);
    } else if (audioService.currentPlayingFilePath == toneItem.filePath) {
      await audioService.pauseAudio();
    } else if (audioService.currentPlayingFilePath != toneItem.filePath &&
        audioService.isPlaying) {
      await audioService.stopAudio();
      await audioService.playAudio(toneItem.filePath);
    }
  }

  void onSetRingtone(ToneItem toneItem) async {
    bool success = await ringtoneService.setRingtone(
      toneItem.filePath,
      toneItem.fileName,
    );
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${toneItem.fileName} set as ringtone'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to set ringtone. Please grant permission.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
