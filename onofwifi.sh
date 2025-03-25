#!/bin/bash

# Fungsi untuk menyalakan WiFi
turn_on_wifi() {
    echo "Menyalakan WiFi..."
    su -c "svc wifi enable"
}

# Fungsi untuk mematikan WiFi
turn_off_wifi() {
    echo "Mematikan WiFi..."
    su -c "svc wifi disable"
}

# Loop utama untuk memeriksa status jaringan
while true; do
    # Melakukan ping ke 8.8.8.8 dengan timeout 3 detik
    ping_result=$(timeout 3 ping -c 1 8.8.8.8 2>&1)

    # Memeriksa apakah timeout terjadi (tidak ada output dalam 3 detik)
    if [[ $? -eq 124 ]]; then
        echo "Ping tidak mengeluarkan hasil dalam 3 detik. Jaringan mungkin bermasalah."
        echo "Mematikan dan menyalakan ulang WiFi..."

        # Matikan WiFi
        turn_off_wifi
        
        # Tunggu beberapa detik sebelum menyalakan kembali
        sleep 5
        
        # Nyalakan WiFi
        turn_on_wifi
        
        # Tunggu beberapa detik lagi untuk stabilisasi
        sleep 5

    # Memeriksa hasil ping untuk "unreachable"
    elif echo "$ping_result" | grep -q "unreachable"; then
        echo "Jaringan tidak tersedia. Mematikan dan menyalakan ulang WiFi..."
        echo "$ping_result"
        
        # Matikan WiFi
        turn_off_wifi
        
        # Tunggu beberapa detik sebelum menyalakan kembali
        sleep 5
        
        # Nyalakan WiFi
        turn_on_wifi
        
        # Tunggu beberapa detik lagi untuk stabilisasi
        sleep 5

    else
        echo "Ping berhasil. WiFi tetap menyala."
    fi

    # Tunggu beberapa detik sebelum memeriksa lagi
    sleep 10
done
