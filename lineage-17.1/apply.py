#!/usr/bin/env python3
"""Apply the G81 snapshot without resets; reject partial or unrelated edits."""
import argparse,hashlib,json,subprocess
from pathlib import Path

HERE=Path(__file__).resolve().parent
parser=argparse.ArgumentParser()
parser.add_argument('source',type=Path)
parser.add_argument('--check',action='store_true',help='Check applicability without applying patches.')
args=parser.parse_args();source=args.source.resolve()
series=json.loads((HERE/'series.json').read_text())
for item in series:
    root=source/item['project'];patch=HERE/item['patch']
    assert hashlib.sha256(patch.read_bytes()).hexdigest()==item['patch_sha256'],patch
    # Fully applied patches are accepted only when every exported file matches.
    def result_matches():
        for name,expected in item['result_files'].items():
            f=root/name
            if expected is None:
                if f.exists():return False
            elif not f.is_file() or hashlib.sha256(f.read_bytes()).hexdigest()!=expected:return False
        return True
    if result_matches():
        print('ALREADY_APPLIED='+item['project']);continue
    check=subprocess.run(['git','apply','--check',str(patch)],cwd=root,capture_output=True,text=True)
    if check.returncode:raise SystemExit('Patch does not match '+item['project']+'\n'+check.stderr)
    if args.check:print('APPLICABLE='+item['project']);continue
    subprocess.run(['git','apply',str(patch)],cwd=root,check=True)
    assert result_matches(),item['project']
    print('APPLIED='+item['project'])
print(('CHECKED' if args.check else 'VERIFIED')+'_PROJECTS='+str(len(series)))
