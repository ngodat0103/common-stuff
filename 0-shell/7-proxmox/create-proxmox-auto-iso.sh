#!/bin/bash
set -euo pipefail

ISO_URL="https://enterprise.proxmox.com/iso/proxmox-ve_8.4-1.iso"
ANSWER_FILE_URL="${ANSWER_FILE_URL:-https://raw.githubusercontent.com/ngodat0103/common-stuff/772d970332735255405d8058212ea6f2cec94c58/0-shell/7-proxmox/answer.toml}"
FIRST_BOOT_URL="${FIRST_BOOT_URL:-https://raw.githubusercontent.com/ngodat0103/common-stuff/772d970332735255405d8058212ea6f2cec94c58/0-shell/7-proxmox/first-boot.sh}"

# --- helpers ---
log() { echo "[INFO] $*"; }
die() { echo "[ERROR] $*" >&2; exit 1; }

need_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"; }

check_url() {
  local url=$1
  curl -fsI --retry 3 --retry-delay 2 "$url" >/dev/null || die "URL not reachable: $url"
}

# --- preflight ---
need_cmd curl
need_cmd wget
need_cmd proxmox-auto-install-assistant
need_cmd basename

log "Checking connectivity to required URLs..."
check_url "$ISO_URL"
check_url "$ANSWER_FILE_URL"
check_url "$FIRST_BOOT_URL"

# --- derive filenames ---
ISO_FILE=$(basename "$ISO_URL")
OUTPUT_FILE="${ISO_FILE%.iso}-auto.iso"

# --- ISO download ---
if [[ -f "$ISO_FILE" ]]; then
  log "ISO already exists: $ISO_FILE"
else
  log "Downloading ISO: $ISO_URL"
  wget -q --show-progress "$ISO_URL"
fi

# --- Run proxmox-auto-install-assistant with inline answer + first boot ---
log "Preparing auto-install ISO: $OUTPUT_FILE"
proxmox-auto-install-assistant prepare-iso "$ISO_FILE" \
  --fetch-from iso \
  --answer-file answer.toml \
  --output "$OUTPUT_FILE" \
  --on-first-boot first-boot.sh

log "Done: $OUTPUT_FILE"
