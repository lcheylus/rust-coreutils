#!/usr/bin/env bash
#
# Bash script to run "Tests" job (GH workflow) on FreeBSD
#

set -e

# First, we check that this script is not run as root because it would fail tests.
if [ "root" == "$(whoami)" ]; then
    echo "ERROR: don't run this script as root"
    exit 1;
fi

## Infos
echo "## OS infos"
uname -a

echo "## user infos"
pw usershow "$(id -u)"

# environment
echo "## environment"
echo "CI='${CI}'"
echo "REPO_NAME='${REPO_NAME}'"
echo "WORKSPACE_PARENT='${WORKSPACE_PARENT}'"
echo "WORKSPACE='${WORKSPACE}'"
env | sort

# Install rust toolchain
echo "## install Rust toolchain"
curl https://sh.rustup.rs -sSf --output rustup.sh
sh rustup.sh -y -c rustfmt,clippy --profile=minimal -t stable
. "${HOME}"/.cargo/env
rm rustup.sh

# Install nextest
mkdir -p "${HOME}"/.cargo/bin
curl -LsSf https://get.nexte.st/latest/freebsd | tar zxf - -C "${HOME}"/.cargo/bin

# Rust tools infos
echo "## Rust infos"
rustc -vV
echo "## cargo infos"
cargo -vV
echo "## cargo-nextest version"
cargo nextest --version

cd "${WORKSPACE}"
rm -f tests-ok
unset FAULT
export CARGO_TERM_COLOR=always

# TODO: fail build if fault in "Style and Lint" job

echo "## cargo build"
cargo build || FAULT=1

export RUST_BACKTRACE=1

if test -z "$FAULT"; then
    # cargo nextest run --hide-progress-bar --profile ci --features "${FEATURES}" || FAULT=1
    NEXTEST_EXPERIMENTAL_LIBTEST_JSON=1 cargo nextest run --hide-progress-bar --profile ci --features "${FEATURES}" --message-format libtest-json-plus 1> "${WORKSPACE}/tests-unix.json" || FAULT=1
fi
if test -z "$FAULT"; then
    # cargo nextest run --hide-progress-bar --profile ci --all-features -p uucore || FAULT=1
    NEXTEST_EXPERIMENTAL_LIBTEST_JSON=1 cargo nextest run --hide-progress-bar --profile ci --all-features -p uucore --message-format libtest-json-plus 1> "${WORKSPACE}/tests-uucore.json" || FAULT=1
fi

# Get sccache stats (Rust cache)
sccache --show-stats > "${WORKSPACE}/sccache-stats.txt" 2>&1

# Do not exit for shell with return code 1 => prevent further execution of GH workflow
if test -n "$FAULT"; then
    exit 0
else
    touch "${WORKSPACE}"/tests-ok
    exit 0
fi
