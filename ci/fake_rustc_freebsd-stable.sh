#!/bin/sh
#
# Fake rustc binary to get `rust -vV` (stable) on FreeBSD
# Necessary for GH actions Swatinem/rust-cache
#

cat << EOF
rustc 1.77.1 (7cf61ebde 2024-03-27)
binary: rustc
commit-hash: 7cf61ebde7b22796c69757901dd346d0fe70bd97
commit-date: 2024-03-27
host: x86_64-unknown-freebsd
release: 1.77.1
LLVM version: 17.0.6
EOF
