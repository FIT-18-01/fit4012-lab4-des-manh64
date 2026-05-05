#!/usr/bin/env bash
set -euo pipefail
g++ -std=c++17 des.cpp -o des_test
PT="1100110011001100110011001100110011001100110011001100110011001100"
KEY="1111111111111111000000000000000011111111111111110000000000000000"
CIPHER=$(echo -e "1\n$PT\n$KEY" | ./des_test)
DECRYPTED=$(echo -e "2\n$CIPHER\n$KEY" | ./des_test)
if [[ "$DECRYPTED" != "$PT" ]]; then exit 1; fi
echo "[PASS] Encrypt-Decrypt roundtrip successful."
rm -f des_test