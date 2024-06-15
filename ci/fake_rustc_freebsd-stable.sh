#!/bin/sh
#
# Fake rustc binary to get `rust -vV` (stable) on FreeBSD
# Necessary for GH actions Swatinem/rust-cache
#

cat << EOF
rustc 1.79.0 (129f3b996 2024-06-10)
binary: rustc
commit-hash: 129f3b9964af4d4a709d1383930ade12dfe7c081
commit-date: 2024-06-10
host: x86_64-unknown-freebsd
release: 1.79.0
LLVM version: 18.1.7
EOF
