import 'dart:io';
import 'package:args/args.dart';
import 'package:nfd2nfc/file.dart';
import 'package:nfd2nfc/nfd2nfc.dart';

void main(List<String> args) {
  final parser = ArgParser()
    ..addOption('file', abbr: 'f', help: 'Rename the file.', valueHelp: 'path')
    ..addOption('dir', abbr: 'd', help: 'Rename files under the directory.', valueHelp: 'path')
    ..addFlag('verbose', abbr: 'v', help: 'Enable verbose mode', defaultsTo: false)
    ..addFlag('help', abbr: 'h', help: 'Display this help information', negatable: false);

  ArgResults argResults;
  try {
    argResults = parser.parse(args);
  } on ArgParserException catch (e) {
    print('Error: ${e.message}');
    print(parser.usage);
    exit(64); // Exit code 64 indicates a command line usage error.
  }

  if (argResults['help'] as bool) {
    print('nfd2nfc: A Dart implementation of Hangul NFD to NFC converter.');
    print('');
    print('Usage:');
    print(parser.usage);
    return;
  }

  final verbose = argResults['verbose'] as bool;

  if (argResults['dir'] != null) {
    final dirPath = argResults['dir'] as String;
    dirCommandHandler(dirPath, verbose: verbose); // Assuming similar handling for dir
    return;
  } else if (argResults['file'] != null) {
    final filePath = argResults['file'] as String;
    fileCommandHandler(filePath, verbose: verbose);
    return;
  }

  // Continue to read input from stdin as before
  List<String> lines = [];
  while (true) {
    String? input = stdin.readLineSync();
    if (input == null) {
      break;
    }
    lines.add(input);
  }

  print(NFD2NFC.normalize(lines.join('\n')));
}
