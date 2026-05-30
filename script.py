import sys

def parse_filtered_lcov(filepath):
    total_lines = 0
    covered_lines = 0
    skip_file = False
    
    with open(filepath, 'r') as f:
        for line in f:
            if line.startswith('SF:'):
                current_file = line.split(':')[1].strip().replace('\\', '/')
                if 'lib/l10n/' in current_file or current_file.endswith('main.dart') or current_file.endswith('firebase_options.dart') or '.freezed.' in current_file or '.g.' in current_file:
                    skip_file = True
                else:
                    skip_file = False
            
            if not skip_file:
                if line.startswith('LF:'):
                    total_lines += int(line.split(':')[1])
                elif line.startswith('LH:'):
                    covered_lines += int(line.split(':')[1])
                    
    print(f'Total: {total_lines}, Covered: {covered_lines}')
    return (covered_lines / total_lines) * 100 if total_lines > 0 else 0

print(f'Real Coverage: {parse_filtered_lcov("coverage/lcov.info"):.2f}%')
