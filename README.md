# G81 shared-source compatibility patches

`lineage-17.1/series.json` pins the upstream base and exact result-file hashes
for 12 projects. It contains the working uncommitted changes plus previously
local telephony, lineage-sdk and navbar commits. Use the matching pinned
manifest; do not mix this series with the older lineage-15.1 patches.

```sh
python3 patches/g81/lineage-17.1/apply.py --check /path/to/source
python3 patches/g81/lineage-17.1/apply.py /path/to/source
```

Application is idempotent for an exact already-applied tree; incompatible or
partially modified files stop the operation rather than being reset.
