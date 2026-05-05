#!/usr/bin/env bash
set -euo pipefail
g++ -std=c++17 des.cpp -o des_test
# 66 bits -> Phải tự động pad thành 128 bits
PT="101010101010101010101010101010101010101010101010101010101010101011" 
KEY="1111111111111111000000000000000011111111111111110000000000000000"
CIPHER=$(echo -e "1\n$PT\n$KEY" | ./des_test)
if [[ "${#CIPHER}" -ne 128 ]]; then exit 1; fi
echo "[PASS] Multi-block zero padding successful."
rm -f des_test