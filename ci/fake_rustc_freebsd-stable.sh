#!/bin/sh
#
# Fake rustc binary to get `rust -vV` (stable) on FreeBSD
# Necessary for GH actions Swatinem/rust-cache
#

cat << EOF
rustc 1.85.0 (4d91de4e4 2025-02-17)
binary: rustc
commit-hash: 4d91de4e48198da2e33413efdcd9cd2cc0c46688
commit-date: 2025-02-17
host: x86_64-unknown-freebsd
release: 1.85.0
LLVM version: 19.1.7
EOF
