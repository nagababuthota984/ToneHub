import 'package:flutter/material.dart';

class ToneItem extends StatefulWidget {
  const ToneItem({
    super.key, 
    required this.filePath, 
    required this.fileName, 
    required this.id,
    this.onSetRingtone,
  });
  final String filePath;
  final String fileName;
  final String id;
  final VoidCallback? onSetRingtone;
  
  @override
  State<ToneItem> createState() => _ToneItemState();
}

class _ToneItemState extends State<ToneItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.fileName),
      key: Key(widget.id),
      textColor: Colors.black,
      tileColor: Colors.white70,
      trailing: IconButton(
        icon: const Icon(Icons.ring_volume),
        tooltip: 'Set as Ringtone',
        onPressed: widget.onSetRingtone,
      ),
    );
  }
}
