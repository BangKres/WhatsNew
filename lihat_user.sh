#!/data/data/com.termux/files/usr/bin/bash

# URL Firebase
URL="https://projectbesar-4f8ce-default-rtdb.firebaseio.com/users.json"

echo "Mengambil data user dari Firebase..."
echo "--------------------------------------"

# Ambil dan tampilkan data dengan format rapi pakai jq
curl -s "$URL" | jq
