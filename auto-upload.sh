#!/data/data/com.termux/files/usr/bin/bash

# Masuk ke folder project
cd /storage/emulated/0/HtmlWhatsApp || { echo "Folder tidak ditemukan!"; exit 1; }

# Konfigurasi Git (hanya kalau belum di-set)
if ! git config --get user.name >/dev/null; then
    git config --global user.name "BangKres"
fi

if ! git config --get user.email >/dev/null; then
    git config --global user.email "email@gmail.com"
fi

# Tambahkan safe.directory hanya jika belum ada
if ! git config --global --get-all safe.directory | grep -q "$(pwd)"; then
    git config --global --add safe.directory "$(pwd)"
fi

# Pastikan remote sudah ada
if ! git remote get-url origin >/dev/null 2>&1; then
    git remote add origin https://github.com/BangKres/WhatsNew.git
fi

# Pastikan file yang dipantau ada
if [ ! -f index.html ] || [ ! -f menu.html ]; then
    echo "File index.html atau menu.html tidak ditemukan!"
    exit 1
fi

echo "Memantau perubahan index.html dan menu.html..."

# Loop pantau perubahan
while inotifywait -e modify index.html menu.html; do
    echo "Perubahan terdeteksi. Menyiapkan upload ke GitHub..."

    git add .
    git commit -m "Auto upload $(date '+%Y-%m-%d %H:%M:%S')" || echo "Tidak ada perubahan baru untuk di-commit."

    until git push origin main --force; do
        echo "Push gagal, coba lagi dalam 10 detik..."
        sleep 10
    done

    echo "Upload selesai!"
done