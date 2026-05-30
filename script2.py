import sys

def parse_lcov_per_file(filepath):
    files = {}
    current_file = None
    skip = False
    
    with open(filepath, 'r') as f:
        for line in f:
            if line.startswith('SF:'):
                current_file = line.split(':',1)[1].strip().replace('\\', '/')
                if 'lib/l10n/' in current_file or current_file.endswith('main.dart') or current_file.endswith('firebase_options.dart') or '.freezed.' in current_file or '.g.' in current_file:
                    skip = True
                else:
                    skip = False
                    files[current_file] = {'lf': 0, 'lh': 0}
            
            if not skip and current_file:
                if line.startswith('LF:'):
                    files[current_file]['lf'] = int(line.split(':')[1])
                elif line.startswith('LH:'):
                    files[current_file]['lh'] = int(line.split(':')[1])

    # Sort by uncovered lines (lf - lh) descending
    sorted_files = sorted(files.items(), key=lambda x: x[1]['lf'] - x[1]['lh'], reverse=True)
    
    print(f"{'File':<70} {'Total':>6} {'Covered':>8} {'Missing':>8} {'Cov%':>6}")
    print('-' * 100)
    for fname, data in sorted_files[:20]:
        missing = data['lf'] - data['lh']
        pct = (data['lh'] / data['lf'] * 100) if data['lf'] > 0 else 0
        short = fname.replace('lib/', '')
        print(f"{short:<70} {data['lf']:>6} {data['lh']:>8} {missing:>8} {pct:>5.1f}%")

parse_lcov_per_file("coverage/lcov.info")
