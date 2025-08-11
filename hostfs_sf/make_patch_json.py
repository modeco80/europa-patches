#!/bin/env python3

# This script makes the patch.json
# that output_pnach will use.

import sys
import re
import json

known_equates = {}
region = sys.argv[1]

patch_json = {
    "patchName": "Lily\\HostFS",
    "patchAuthor": "modeco80",
    "patchDescription": f"HostFS for Starfighter (region {region})",
    "patchSegments": [
    ]
}

def parse_equates():
    # Pull out equates from the region include file.
    # This "parser" is incredibly brittle. But it should work
    with open(f'regions/{region}.inc', 'r') as incFile:
        for line in incFile:
            line = line.removesuffix('\n')
            if line == "":
                continue
            # comments
            if line.startswith(';'):
                continue
            line = re.sub(';.*', '', line)
            line = line.strip()
            split = line.split(' ')
            if split[0].startswith('CPS2CDStore_') or split[0].startswith('sceCdSt') or split[0].startswith('EuropaCD') or split[0].startswith('mpeg_'):
                known_equates[split[0]] = split[2]

parse_equates()

# Add a patch segment for each thunk
for equate_name, equate_value in known_equates.items():
    patch_json['patchSegments'].append({
        'name': f'{equate_name.replace('_', '::')}',
        'org': equate_value,
        'source': f'obj/{region}/{equate_name}.bin'
    })

print(json.dumps(patch_json, indent=4))