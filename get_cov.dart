import 'dart:io';
void main() {
  var lines = File('coverage/lcov.info').readAsLinesSync();
  var total = 0;
  var hits = 0;
  var fileTotal = 0;
  var fileHits = 0;
  var currentFile = '';
  
  var fileStats = <String, Map<String, int>>{};

  for (var l in lines) {
    if (l.startsWith('SF:')) {
      currentFile = l.substring(3);
      fileTotal = 0;
      fileHits = 0;
    } else if (l.startsWith('DA:')) {
      var parts = l.split(',');
      total++;
      fileTotal++;
      if (int.parse(parts[1]) > 0) {
        hits++;
        fileHits++;
      }
    } else if (l == 'end_of_record') {
      if (fileTotal > 0) {
        fileStats[currentFile] = {'hits': fileHits, 'total': fileTotal};
      }
    }
  }

  var sortedKeys = fileStats.keys.toList()..sort((a, b) {
    var pctA = fileStats[a]!['hits']! / fileStats[a]!['total']!;
    var pctB = fileStats[b]!['hits']! / fileStats[b]!['total']!;
    return pctA.compareTo(pctB);
  });

  for (var file in sortedKeys) {
    var stats = fileStats[file]!;
    var hitsVal = stats['hits']!;
    var totVal = stats['total']!;
    var pct = (hitsVal / totVal * 100).toStringAsFixed(1);
    print(pct + '% (' + hitsVal.toString() + '/' + totVal.toString() + ') - ' + file);
  }

  var totalPct = (hits/total*100).toStringAsFixed(1);
  print('\nTOTAL COVERAGE: ' + totalPct + '% (' + hits.toString() + '/' + total.toString() + ')');
}
