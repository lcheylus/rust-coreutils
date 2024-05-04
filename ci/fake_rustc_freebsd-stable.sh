#!/bin/sh
#
# Fake rustc binary to get `rust -vV` (stable) on FreeBSD
# Necessary for GH actions Swatinem/rust-cache
#

cat << EOF
rustc 1.78.0 (9b00956e5 2024-04-29)
binary: rustc
commit-hash: 9b00956e56009bab2aa15d7bff10916599e3d6d6
commit-date: 2024-04-29
host: x86_64-unknown-freebsd
release: 1.78.0
LLVM version: 18.1.2
EOF
