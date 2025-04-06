#!/bin/sh
#
# Fake rustc binary to get `rust -vV` (stable) on FreeBSD
# Necessary for GH actions Swatinem/rust-cache
#

cat << EOF
rustc 1.86.0 (05f9846f8 2025-03-31)
binary: rustc
commit-hash: 05f9846f893b09a1be1fc8560e33fc3c815cfecb
commit-date: 2025-03-31
host: x86_64-unknown-freebsd
release: 1.86.0
LLVM version: 19.1.7
EOF
