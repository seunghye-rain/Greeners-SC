import 'dart:async';
import 'dart:html' as html;

Future<String?> pickWebImage() async {
  final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
  uploadInput.click();

  final completer = Completer<String?>();

  uploadInput.onChange.listen((event) {
    final file = uploadInput.files!.first;
    final reader = html.FileReader();

    reader.readAsDataUrl(file);
    reader.onLoadEnd.listen((event) {
      completer.complete(reader.result as String?);
    });
  });

  return completer.future;
}
