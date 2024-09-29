import 'dart:io';
import 'package:nfd2nfc/nfd2nfc.dart';

void rename(File file, { bool verbose = false }) {
  file.exists().then((exists) {
    if (exists) {
      String fileName = file.uri.pathSegments.last;

      String newFileName = NFD2NFC.normalize(fileName);
      String newFilePath = file.parent.path + Platform.pathSeparator + newFileName;

      file.rename(newFilePath).then((renamedFile) {
        if (verbose) {
          print('File renamed to: ${renamedFile.path}');
        }
      }).catchError((error) {
        print('Error: Cannot rename file: $error');
      });
    } else {
      print('Error: File not found.');
    }
  }).catchError((error) {
    print('Error: Error checking file existence: $error');
  });
}

void fileCommandHandler(String path, { bool verbose = false }) async {
  rename(File(path));
}

void dirCommandHandler(String path, { bool verbose = false }) {
  Directory dir = Directory(path);
  dir.exists().then((exists) {
    if (exists) {
      dir.list(recursive: true, followLinks: false).listen((entity) {
        if (entity is File) {
          rename(entity, verbose: verbose);
        }
      });
    } else {
      if (verbose) {
        print('Error: Directory not found.');
      }
    }
  }).catchError((error) {
    print('Error: Error checking directory existence: $error');
  });
}
