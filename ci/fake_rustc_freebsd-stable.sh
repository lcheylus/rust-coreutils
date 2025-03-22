#!/bin/sh
#
# Fake rustc binary to get `rust -vV` (stable) on FreeBSD
# Necessary for GH actions Swatinem/rust-cache
#

cat << EOF
rustc 1.85.1 (4eb161250 2025-03-15)
binary: rustc
commit-hash: 4eb161250e340c8f48f66e2b929ef4a5bed7c181
commit-date: 2025-03-15
host: x86_64-unknown-freebsd
release: 1.85.1
LLVM version: 19.1.7
EOF
