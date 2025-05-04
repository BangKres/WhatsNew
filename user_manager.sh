
#!/data/data/com.termux/files/usr/bin/bash

BASE_URL="https://projectbesar-4f8ce-default-rtdb.firebaseio.com/users"

while true; do
    clear
    echo "===== MANAJEMEN DATA USER (Firebase) ====="
    echo
    echo "[1] Lihat semua user"
    echo "[2] Lihat foto user berdasarkan ID"
    echo "[3] Hapus user berdasarkan ID"
    echo "[4] Keluar"
    echo

    read -p "Pilih opsi (1-4): " opsi

    if [[ "$opsi" == "1" ]]; then
        echo
        echo "== DATA USER =="
        curl -s "${BASE_URL}.json" | jq
        read -p "Tekan enter untuk melanjutkan..."
    elif [[ "$opsi" == "2" ]]; then
        echo
        echo "== DAFTAR USER =="
        curl -s "${BASE_URL}.json" | jq -r '. | keys[] as $k | "\($k) - \(.[$k].nama) - \(.[$k].kode)"'
        echo
        while true; do
            read -p "Masukkan ID user (atau ketik 'kembali' untuk kembali ke menu utama): " USER_ID
            if [[ "$USER_ID" == "kembali" ]]; then
                break
            fi
            FOTO_URL=$(curl -s "${BASE_URL}/${USER_ID}/profileUrl.json" | tr -d '"')
            NAMA=$(curl -s "${BASE_URL}/${USER_ID}/nama.json" | tr -d '"')
            KODE=$(curl -s "${BASE_URL}/${USER_ID}/kode.json" | tr -d '"')
            if [[ "$FOTO_URL" != "null" && -n "$FOTO_URL" ]]; then
                echo "===================================="
                echo "Nama: $NAMA"
                echo "ID: $USER_ID"
                echo "Kode: $KODE"
                echo "URL Foto: $FOTO_URL"
                echo "===================================="
                TEMP_FILE=$(mktemp /data/data/com.termux/files/usr/tmp/userfoto_XXXXXX.jpg)
                curl -s -o "$TEMP_FILE" "$FOTO_URL"
                echo
                echo "Menampilkan foto di terminal..."
                chafa "$TEMP_FILE"
                rm "$TEMP_FILE"
            else
                echo "Foto tidak ditemukan untuk user '$USER_ID'."
            fi
        done
    elif [[ "$opsi" == "3" ]]; then
        echo
        read -p "Masukkan ID user yang ingin dihapus (contoh: ma7u346u4266): " USER_ID
        read -p "Yakin ingin menghapus user '$USER_ID'? (y/n): " CONFIRM
        if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
            curl -X DELETE "${BASE_URL}/${USER_ID}.json"
            echo -e "\nUser '$USER_ID' berhasil dihapus (jika ID valid)."
        else
            echo "Penghapusan dibatalkan."
        fi
        read -p "Tekan enter untuk melanjutkan..."
    elif [[ "$opsi" == "4" ]]; then
        echo "Keluar..."
        break
    else
        echo "Opsi tidak valid."
        read -p "Tekan enter untuk melanjutkan..."
    fi
done