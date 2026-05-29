import 'dart:io';
void main() {
  final file = File('coverage/lcov.info');
  if (!file.existsSync()) return print('No lcov.info');
  final lines = file.readAsLinesSync();
  bool skip = false;
  String currentFile = '';
  int fileHit = 0, fileTotal = 0;
  List<int> uncoveredLines = [];
  for (var line in lines) {
    if (line.startsWith('SF:')) {
      if (fileTotal > 0 && !skip && fileHit / fileTotal < 0.85) {
        final pct = (fileHit / fileTotal * 100).toStringAsFixed(1);
        print('');
        print('FILE: $currentFile');
        print('  Coverage: $pct% ($fileHit/$fileTotal)');
        print('  Uncovered: ${uncoveredLines.take(40).join(", ")}${uncoveredLines.length > 40 ? " ..." : ""}');
      }
      currentFile = line.substring(3);
      fileHit = 0; fileTotal = 0; uncoveredLines = [];
      skip = currentFile.contains('.g.dart') || currentFile.contains('firebase_options.dart') || currentFile.contains('main.dart') || currentFile.contains('l10n');
    }
    if (!skip && line.startsWith('DA:')) {
      final parts = line.substring(3).split(',');
      final lineNum = int.parse(parts[0]);
      final hitCount = int.parse(parts[1]);
      fileTotal++;
      if (hitCount > 0) { fileHit++; } else { uncoveredLines.add(lineNum); }
    }
  }
  if (fileTotal > 0 && !skip && fileHit / fileTotal < 0.85) {
    final pct = (fileHit / fileTotal * 100).toStringAsFixed(1);
    print('');
    print('FILE: $currentFile');
    print('  Coverage: $pct% ($fileHit/$fileTotal)');
    print('  Uncovered: ${uncoveredLines.take(40).join(", ")}${uncoveredLines.length > 40 ? " ..." : ""}');
  }
}
