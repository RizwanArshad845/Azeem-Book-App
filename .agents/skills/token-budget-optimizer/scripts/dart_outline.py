#!/usr/bin/env python3
"""
dart_outline.py: Lightweight Dart File Outliner for Token Conservation.
Extracts imports, classes, abstract classes, mixins, enums, extensions,
and method/property signatures without dumping massive function bodies or build() trees.
"""

import sys
import re
import os

CLASS_OR_TYPE_REGEX = re.compile(
    r'^\s*(abstract\s+class|class|mixin|enum|extension)\s+([A-Za-z0-9_]+)',
    re.MULTILINE
)

METHOD_OR_FIELD_REGEX = re.compile(
    r'^\s{2,4}(@override\s+)?(?:(?:final|const|late|var|static|async|Future|Stream|[A-Za-z0-9_<>,? ]+)\s+)?([A-Za-z0-9_]+)\s*(\([^\)]*\)|;|=)',
    re.MULTILINE
)

def outline_dart_file(filepath: str) -> str:
    if not os.path.exists(filepath):
        return f"Error: File '{filepath}' not found."
    
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        lines = f.readlines()

    output = [f"=== Outline for {os.path.basename(filepath)} ({len(lines)} lines) ==="]
    
    in_multiline_comment = False
    brace_depth = 0
    
    for i, line in enumerate(lines, 1):
        stripped = line.strip()
        
        # Handle comment states
        if '/*' in stripped:
            in_multiline_comment = True
        if '*/' in stripped:
            in_multiline_comment = False
            continue
        if in_multiline_comment or stripped.startswith('//'):
            continue
            
        # Top-level imports / part statements
        if stripped.startswith('import ') or stripped.startswith('export ') or stripped.startswith('part '):
            output.append(f"L{i:04d}: {stripped}")
            continue

        # Class / Type definitions
        match_type = CLASS_OR_TYPE_REGEX.search(line)
        if match_type:
            output.append(f"\nL{i:04d}: {stripped.split('{')[0].strip()} {{")
            brace_depth += line.count('{') - line.count('}')
            continue

        # Top-level or 1-level deep signatures
        if 0 <= brace_depth <= 1:
            if any(stripped.startswith(k) for k in ['final ', 'const ', 'late ', '@', 'void ', 'Future', 'Stream', 'Widget ', 'bool ', 'String ', 'int ', 'double ']):
                sig = stripped.split('{')[0].strip()
                if sig.endswith('=>'):
                    sig += ' ...'
                output.append(f"  L{i:04d}: {sig}")

        brace_depth += line.count('{') - line.count('}')

    return "\n".join(output)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python dart_outline.py <path_to_dart_file>")
        sys.exit(1)
    
    target = sys.argv[1]
    print(outline_dart_file(target))
