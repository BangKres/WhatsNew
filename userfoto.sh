#!/data/data/com.termux/files/usr/bin/bash

# URL Firebase
FIREBASE_URL="https://projectbesar-4f8ce-default-rtdb.firebaseio.com/users.json"

# Ambil semua data user, lalu tampilkan nama + buka foto
curl -s "$FIREBASE_URL" | jq -r 'to_entries[] | "