#!/bin/sh
#
# Fake rustc binary to get `rust -vV` (stable) on FreeBSD
# Necessary for GH actions Swatinem/rust-cache
#

cat << EOF
rustc 1.84.0 (9fc6b4312 2025-01-07)
binary: rustc
commit-hash: 9fc6b43126469e3858e2fe86cafb4f0fd5068869
commit-date: 2025-01-07
host: x86_64-unknown-freebsd
release: 1.84.0
LLVM version: 19.1.5
EOF
