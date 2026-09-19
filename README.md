# android_patches_g81

Device-specific LineageOS 15.1 patch series for `g81`.

The `lineage-15.1` branch targets the pinned LineageOS 15.1 manifest revision.
Run `lineage-15.1/apply-patches.sh /path/to/lineage-source` after `repo sync`.
The script is idempotent and refuses a source tree whose patch context does not
match, avoiding silent application to a different upstream base.

| Patch | Upstream project | Purpose |
| --- | --- | --- |
| 0001 | `device/lineage/sepolicy` | Resolve the stock MTK split-policy label collision. |
| 0002 | `frameworks/native` | Ignore invalid legacy HWC VSYNC timestamps. |
| 0003-0004 | `packages/apps/Trebuchet` | Low-RAM drawer and wallpaper-permission stability. |
| 0005-0006 | `lineage-sdk` | Stabilize service publication and overlay access. |
| 0007 | `frameworks/opt/telephony` | Bridge the validated MTK OEM radio transport. |
| 0008 | `system/connectivity/wificond` | Demote expected malformed MTK scan-entry noise. |
| 0009 | `frameworks/opt/telephony` | Bridge the MTK incoming-call handshake and call-control callbacks. |
| 0010 | `device/lineage/sepolicy` | Keep the recovery system-remount exception out of production `user` policy. |
| 0011 | `device/lineage/sepolicy` | Keep the unused A/B backup helper enforcing in production `user` policy. |
| 0012 | `frameworks/opt/telephony` | Forward standard and MTK data-call responses to the AOSP data stack. |

These patches are source-visible and reviewable. They do not carry proprietary
files, images, device dumps, identifiers, or factory applications.
