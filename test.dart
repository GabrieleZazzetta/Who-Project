import 'dart:io';
void main() {
  final file = File('coverage/lcov.info');
  if (!file.existsSync()) return print('No lcov.info');
  final lines = file.readAsLinesSync();
  int hit = 0, total = 0;
  bool skip = false;
  String currentFile = '';
  int fileHit = 0, fileTotal = 0;
  for (var line in lines) {
    if (line.startsWith('SF:')) {
      if (fileTotal > 0 && fileHit / fileTotal < 0.85) {
        print(currentFile + ' : ' + (fileHit/fileTotal*100).toStringAsFixed(2) + '%');
      }
      currentFile = line.substring(3);
      fileHit = 0; fileTotal = 0;
      skip = currentFile.contains('.g.dart') || currentFile.contains('firebase_options.dart') || currentFile.contains('main.dart') || currentFile.contains('l10n');
    }
    if (!skip && line.startsWith('DA:')) {
      total++; fileTotal++;
      if (int.parse(line.split(',')[1]) > 0) { hit++; fileHit++; }
    }
  }
  if (fileTotal > 0 && fileHit / fileTotal < 0.85) {
    print(currentFile + ' : ' + (fileHit/fileTotal*100).toStringAsFixed(2) + '%');
  }
  print('Overall Coverage: ' + (hit/total*100).toStringAsFixed(2) + '% (' + hit.toString() + ' / ' + total.toString() + ')');
}
