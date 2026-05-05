#!/usr/bin/env bash
set -euo pipefail
g++ -std=c++17 des.cpp -o des_test
PT="1100110011001100110011001100110011001100110011001100110011001100"
KEY="1111111111111111000000000000000011111111111111110000000000000000"
WRONG_KEY="0000000000000000111111111111111100000000000000001111111111111111"
CIPHER=$(echo -e "1\n$PT\n$KEY" | ./des_test)

# Giải mã bằng khóa sai
DECRYPTED=$(echo -e "2\n$CIPHER\n$WRONG_KEY" | ./des_test)

if [[ "$DECRYPTED" == "$PT" ]]; then exit 1; fi
echo "[PASS] Wrong key decryption successfully rejected."
rm -f des_test