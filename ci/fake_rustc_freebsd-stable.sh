#!/bin/sh
#
# Fake rustc binary to get `rust -vV` (stable) on FreeBSD
# Necessary for GH actions Swatinem/rust-cache
#

cat << EOF
rustc 1.83.0 (90b35a623 2024-11-26)
binary: rustc
commit-hash: 90b35a6239c3d8bdabc530a6a0816f7ff89a0aaf
commit-date: 2024-11-26
host: x86_64-unknown-freebsd
release: 1.83.0
LLVM version: 19.1.1
EOF
