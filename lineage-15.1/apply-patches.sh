#!/usr/bin/env bash

set -euo pipefail

patch_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source_root="${1:-$PWD}"

if [[ ! -d "${source_root}/.repo" ]]; then
    echo "Not an Android repo checkout: ${source_root}" >&2
    exit 1
fi

apply_one() {
    local patch_name="$1"
    local project_path="$2"
    local project="${source_root}/${project_path}"
    local patch_file="${patch_root}/${patch_name}"

    if [[ ! -d "${project}/.git" ]]; then
        echo "Missing source project: ${project_path}" >&2
        exit 1
    fi

    if git -C "${project}" apply --check "${patch_file}" >/dev/null 2>&1; then
        git -C "${project}" apply "${patch_file}"
        echo "Applied ${patch_name}"
    elif git -C "${project}" apply --reverse --check "${patch_file}" >/dev/null 2>&1; then
        echo "Already applied ${patch_name}"
    else
        echo "Patch does not match its expected LineageOS 15.1 base: ${patch_name}" >&2
        exit 1
    fi
}

apply_or_detect_integrated() {
    local patch_name="$1"
    local project_path="$2"
    local marker_file="$3"
    local marker="$4"
    local project="${source_root}/${project_path}"
    local patch_file="${patch_root}/${patch_name}"

    if git -C "${project}" apply --check "${patch_file}" >/dev/null 2>&1; then
        git -C "${project}" apply "${patch_file}"
        echo "Applied ${patch_name}"
    elif git -C "${project}" apply --reverse --check "${patch_file}" >/dev/null 2>&1; then
        echo "Already applied ${patch_name}"
    elif grep -Fq -- "${marker}" "${project}/${marker_file}"; then
        # The MTK bridge patches touch one shared Java file. A later bridge
        # patch can make an earlier patch impossible to reverse-check even
        # though its behavior is present. Detect the behavior, not the patch
        # hunk, so a rebuilt checkout stays idempotent.
        echo "Already present (integrated) ${patch_name}"
    else
        echo "Patch does not match its expected LineageOS 15.1 base: ${patch_name}" >&2
        exit 1
    fi
}

apply_one 0001-sepolicy-let-mtk-vendor-label-fuseblk.patch device/lineage/sepolicy
apply_one 0002-frameworks-native-ignore-zero-hwc-vsync.patch frameworks/native
apply_one 0003-trebuchetgo-disable-heavy-drawer-effects.patch packages/apps/Trebuchet
apply_one 0004-trebuchet-handle-missing-wallpaper-permission.patch packages/apps/Trebuchet
apply_one 0005-lineage-sdk-start-services-once.patch lineage-sdk
apply_one 0006-lineage-sdk-reacquire-overlay-service.patch lineage-sdk
telephony_project="${source_root}/frameworks/opt/telephony"
incoming_call_patch="${patch_root}/0009-telephony-mtk-incoming-call-indication.patch"
apply_or_detect_integrated \
    0007-telephony-mtk-vendor-oem-request-bridge.patch \
    frameworks/opt/telephony \
    src/java/com/android/internal/telephony/MtkRadioBridge.java \
    SET_RESPONSE_FUNCTIONS_MTK
apply_one 0008-wificond-demote-mtk-empty-bssid-scan-log.patch system/connectivity/wificond
apply_or_detect_integrated \
    0009-telephony-mtk-incoming-call-indication.patch \
    frameworks/opt/telephony \
    src/java/com/android/internal/telephony/MtkRadioBridge.java \
    INCOMING_CALL_INDICATION
apply_or_detect_integrated \
    0012-telephony-mtk-data-response-bridge.patch \
    frameworks/opt/telephony \
    src/java/com/android/internal/telephony/MtkRadioBridge.java \
    GET_DATA_CALL_LIST_RESPONSE_EX
apply_one 0010-sepolicy-gate-recovery-system-mount.patch device/lineage/sepolicy
apply_one 0011-sepolicy-enforce-backuptool-on-user.patch device/lineage/sepolicy
