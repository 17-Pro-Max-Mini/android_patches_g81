# G81 LineageOS 15.1 source snapshot

`lineage-15.1/series.json` is the authoritative complete export: 8 upstream
projects / 14 files, including the previously untracked MtkRadioBridge.java,
composer VSYNC fallback and the existing Dialer factory-code route.
The numbered 0001..0012 patches are retained as historical explanations, not
applied a second time. `apply-patches.sh` delegates to the hash-checked snapshot.

Run `python3 lineage-15.1/apply.py --check SOURCE` to check, or omit `--check`
to apply. Application is idempotent by exact result hashes and never resets
unrelated work. This is the preserved Android 8.1/15.1 implementation, not a
claim that the Android 10 runtime was downgraded and hardware-retested.
