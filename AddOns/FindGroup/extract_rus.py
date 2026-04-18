import os
import re

d = 'c:/CircleL/Interface/AddOns/FindGroup/'
files = [f for f in os.listdir(d) if f.endswith(('.lua','.xml'))]

with open(os.path.join(d, 'extract_rus.txt'), 'w', encoding='utf-8') as out:
    for f in files:
        with open(os.path.join(d, f), 'r', encoding='utf-8') as file:
            for i, line in enumerate(file):
                if re.search(r'[А-Яа-яЁё]', line):
                    out.write(f"{f}:{i+1}: {line.strip()}\n")
