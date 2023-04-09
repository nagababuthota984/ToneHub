import 'package:file_picker/file_picker.dart';
import 'package:tonehub/widgets/toneitem.dart';

Future<ToneItem> pickFile() async {
  var result = await FilePicker.platform.pickFiles(
      dialogTitle: "Pick an mp3 file",
      type: FileType.audio,
      allowMultiple: false);
  if (result == null) {
    return Future.error("No file selected.");
  } 
  else {
    if (result.paths.isNotEmpty && result.names.isNotEmpty) {
      String fileName = result.names.first ?? "";
      String filePath = result.paths.first ?? "";
      String fileId = result.files[0].identifier ?? "";
      if (fileName != "" && filePath != "" && fileId != "") {
        return ToneItem(fileName: fileName, filePath: filePath, id: fileId);
      }
    }
    return Future.error("Please select a valid mp3 file.");
  }
}


