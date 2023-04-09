import '../widgets/toneitem.dart';

class ToneData {
  static final List<ToneItem> toneItems = List<ToneItem>.generate(
      50,
      (index) => ToneItem(
          filePath: 'Ringtone $index path', fileName: 'Ringtone $index',id:'$index'));
}
