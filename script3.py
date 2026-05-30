import sys

def get_uncovered_lines(filepath, target_file):
    current_file = None
    uncovered = []
    
    with open(filepath, 'r') as f:
        for line in f:
            if line.startswith('SF:'):
                current_file = line.split(':',1)[1].strip().replace('\\', '/')
            
            if current_file and target_file in current_file:
                if line.startswith('DA:'):
                    parts = line[3:].strip().split(',')
                    line_num = int(parts[0])
                    hit_count = int(parts[1])
                    if hit_count == 0:
                        uncovered.append(line_num)

    print(f'Uncovered lines in {target_file}:')
    for ln in sorted(uncovered):
        print(f'  {ln}')
    print(f'Total: {len(uncovered)}')

for f in ['pre_assessment_screen.dart', 'login_screen.dart', 'settings_screen.dart', 'facility_selection_screen.dart']:
    get_uncovered_lines('coverage/lcov.info', f)
    print()
