#!/bin/bash

echo "Set up dns"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

apt update
apt install vim-nox

SRC_LINE='#source <(curl -fsSL https://raw.githubusercontent.com/ngodat0103/common-stuff/b3c39675ab7ae2ecb5dcc067aeab1b7791fe3330/0-shell/7-proxmox/create-admin-account.sh) || return'

grep -qxF "$SRC_LINE" ~/.bashrc || echo "$SRC_LINE" >> ~/.bashrc





set -euo pipefail

# === Config ===
TARGET_LINE='GRUB_CMDLINE_LINUX_DEFAULT="quiet pci=assign-busses apicmaintimer idle=poll reboot=cold,hard"'
GRUB_DEFAULT_FILE="/etc/default/grub"
LOG_LIB_URL="${LOG_LIB_URL:-https://raw.githubusercontent.com/ngodat0103/common-stuff/refs/heads/main/0-shell/7-log/log.sh}"
LOG_LIB_PATH="${LOG_LIB_PATH:-/tmp/log.sh}"

# === Logging bootstrap: use your log.sh if possible ===
fallback_logger() {
  # very small fallback if fetch/source fails
  print_info()    { printf '[INFO] %s\n' "$*"; }
  print_success() { printf '[SUCCESS] %s\n' "$*"; }
  print_warning() { printf '[WARNING] %s\n' "$*"; }
  print_error()   { printf '[ERROR] %s\n' "$*"; }
}

use_logging_lib() {
  # If a local path is provided and readable, prefer it
  if [[ -r "${LOG_LIB_PATH}" ]]; then
    # shellcheck source=/dev/null
    source "${LOG_LIB_PATH}" || fallback_logger
    return
  fi

  # Try to fetch the library
  if command -v curl >/dev/null 2>&1; then
    if curl -fsSL "${LOG_LIB_URL}" -o "${LOG_LIB_PATH}"; then
      # shellcheck source=/dev/null
      source "${LOG_LIB_PATH}" || fallback_logger
      return
    fi
  elif command -v wget >/dev/null 2>&1; then
    if wget -qO "${LOG_LIB_PATH}" "${LOG_LIB_URL}"; then
      # shellcheck source=/dev/null
      source "${LOG_LIB_PATH}" || fallback_logger
      return
    fi
  fi

  # last resort
  fallback_logger
}

use_logging_lib

# === Guard: Proxmox systemd-boot? ===
if command -v proxmox-boot-tool >/dev/null 2>&1; then
  # Heuristic: if /etc/kernel/cmdline exists, you're on systemd-boot flow.
  if [[ -f /etc/kernel/cmdline ]]; then
    print_warning "Detected Proxmox with systemd-boot (/etc/kernel/cmdline present)."
    print_warning "Do NOT edit ${GRUB_DEFAULT_FILE}. Instead run:"
    printf '  echo %q | tee /etc/kernel/cmdline\n  proxmox-boot-tool refresh\n' \
      'quiet pci=assign-busses apicmaintimer idle=poll reboot=cold,hard'
    exit 0
  fi
fi

# === CPU vendor detection ===
vendor="$(awk -F':' '/^vendor_id[[:space:]]*/{gsub(/[[:space:]]/,"",$2); print $2; exit}' /proc/cpuinfo || true)"
if [[ "${vendor:-}" != "AuthenticAMD" ]]; then
  print_info "CPU vendor='${vendor:-unknown}' is not AMD. Skipping changes."
  exit 0
fi
print_info "AMD CPU detected."

# === Sanity checks ===
if [[ ! -f "${GRUB_DEFAULT_FILE}" ]]; then
  print_error "${GRUB_DEFAULT_FILE} not found. Are you using GRUB on this host?"
  exit 1
fi

# === Backup ===
ts="$(date +%Y%m%d-%H%M%S)"
cp -a "${GRUB_DEFAULT_FILE}" "${GRUB_DEFAULT_FILE}.bak.${ts}"
print_info "Backed up to ${GRUB_DEFAULT_FILE}.bak.${ts}"

# === Apply (idempotent) ===
if grep -qE '^GRUB_CMDLINE_LINUX_DEFAULT=' "${GRUB_DEFAULT_FILE}"; then
  sed -i -E "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*$|${TARGET_LINE}|" "${GRUB_DEFAULT_FILE}"
else
  printf '\n%s\n' "${TARGET_LINE}" >> "${GRUB_DEFAULT_FILE}"
fi

# === Verify ===
if grep -qF "${TARGET_LINE}" "${GRUB_DEFAULT_FILE}"; then
  print_success "Set: ${TARGET_LINE}"
else
  print_error "Failed to set GRUB_CMDLINE_LINUX_DEFAULT."
  exit 1
fi

# === Rebuild GRUB config ===
if command -v update-grub >/dev/null 2>&1; then
  print_info "Running update-grub..."
  update-grub
elif command -v grub-mkconfig >/dev/null 2>&1; then
  out="/boot/grub/grub.cfg"
  [[ -d /boot/grub2 ]] && out="/boot/grub2/grub.cfg"
  print_info "Running grub-mkconfig -o ${out}..."
  grub-mkconfig -o "${out}"
else
  print_warning "Neither update-grub nor grub-mkconfig found. Regenerate GRUB config manually."
fi

print_success "Done. Reboot to apply the new kernel parameters."
