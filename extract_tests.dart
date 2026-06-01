import 'dart:io';

void main() {
  final testDir = Directory('test');
  final integrationDir = Directory('integration_test');
  
  final out = StringBuffer();
  out.writeln('# Testing Campaign Report');
  out.writeln();

  out.writeln('## 1. Alberatura delle Cartelle');
  out.writeln('```text');
  _printTree(testDir, out, '');
  if (integrationDir.existsSync()) {
    _printTree(integrationDir, out, '');
  }
  out.writeln('```');
  out.writeln();

  out.writeln('## 2. Unit Test (inclusi Backend & Integration Services)');
  final unitDir = Directory('test/unit');
  if (unitDir.existsSync()) {
    final files = unitDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart')).toList();
    for (final file in files) {
      final name = file.path.split(Platform.pathSeparator).last;
      out.writeln('### $name');
      final lines = file.readAsLinesSync();
      String? currentGroup;
      for (final line in lines) {
        if (line.contains("group('") || line.contains('group("')) {
          final start = line.indexOf(RegExp(r"group\(['" '"' r"]")) + 7;
          final end = line.indexOf(RegExp(r"['" '"' r"]"), start);
          if (start > 6 && end > start) {
            currentGroup = line.substring(start, end);
          }
        }
        if (line.contains("test('") || line.contains('test("')) {
          final start = line.indexOf(RegExp(r"test\(['" '"' r"]")) + 6;
          final end = line.indexOf(RegExp(r"['" '"' r"]"), start);
          if (start > 5 && end > start) {
            final desc = line.substring(start, end);
            if (currentGroup != null) {
              out.writeln('- **$currentGroup**: $desc');
            } else {
              out.writeln('- $desc');
            }
          }
        }
      }
      out.writeln();
    }
  }

  out.writeln('## 3. Widget Test');
  final widgetDir = Directory('test/widget');
  if (widgetDir.existsSync()) {
    final files = widgetDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart')).toList();
    for (final file in files) {
      final name = file.path.split(Platform.pathSeparator).last;
      out.writeln('### $name');
      final lines = file.readAsLinesSync();
      String? currentGroup;
      for (final line in lines) {
        if (line.contains("group('") || line.contains('group("')) {
          final start = line.indexOf(RegExp(r"group\(['" '"' r"]")) + 7;
          final end = line.indexOf(RegExp(r"['" '"' r"]"), start);
          if (start > 6 && end > start) {
            currentGroup = line.substring(start, end);
          }
        }
        if (line.contains("testWidgets('") || line.contains('testWidgets("')) {
          final start = line.indexOf(RegExp(r"testWidgets\(['" '"' r"]")) + 13;
          final end = line.indexOf(RegExp(r"['" '"' r"]"), start);
          if (start > 12 && end > start) {
            final desc = line.substring(start, end);
            if (currentGroup != null) {
              out.writeln('- **$currentGroup**: $desc');
            } else {
              out.writeln('- $desc');
            }
          }
        }
      }
      out.writeln();
    }
  }

  out.writeln('## 4. Integration Test (UI E2E on Simulator)');
  if (integrationDir.existsSync()) {
    final files = integrationDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart')).toList();
    for (final file in files) {
      final name = file.path.split(Platform.pathSeparator).last;
      out.writeln('### $name');
      final lines = file.readAsLinesSync();
      String? currentGroup;
      for (final line in lines) {
        if (line.contains("group('") || line.contains('group("')) {
          final start = line.indexOf(RegExp(r"group\(['" '"' r"]")) + 7;
          final end = line.indexOf(RegExp(r"['" '"' r"]"), start);
          if (start > 6 && end > start) {
            currentGroup = line.substring(start, end);
          }
        }
        if (line.contains("testWidgets('") || line.contains('testWidgets("')) {
          final start = line.indexOf(RegExp(r"testWidgets\(['" '"' r"]")) + 13;
          final end = line.indexOf(RegExp(r"['" '"' r"]"), start);
          if (start > 12 && end > start) {
             final desc = line.substring(start, end);
             out.writeln('- **$currentGroup**: $desc');
          }
        }
      }
      out.writeln();
    }
  }

  File('test_report_temp.md').writeAsStringSync(out.toString());
}

void _printTree(Directory dir, StringBuffer out, String prefix) {
  out.writeln('$prefix${dir.path.split(Platform.pathSeparator).last}/');
  final children = dir.listSync();
  for (int i = 0; i < children.length; i++) {
    final isLast = i == children.length - 1;
    final child = children[i];
    final childPrefix = isLast ? '└── ' : '├── ';
    if (child is Directory) {
      _printTree(child, out, '$prefix${isLast ? "    " : "│   "}');
    } else {
      out.writeln('$prefix$childPrefix${child.path.split(Platform.pathSeparator).last}');
    }
  }
}
