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

## Info
echo "## user infos"
pw usershow "$(id -u)"

# Install rust toolchain
echo "## install Rust toolchain"
curl https://sh.rustup.rs -sSf --output rustup.sh
sh rustup.sh -y -c rustfmt,clippy --profile=minimal -t stable
. ${HOME}/.cargo/env
rm rustup.sh

# Install nextest
mkdir -p ${HOME}/.cargo/bin
curl -LsSf https://get.nexte.st/latest/freebsd | tar zxf - -C ${HOME}/.cargo/bin

# environment
echo "## environment"
echo "CI='${CI}'"
echo "REPO_NAME='${REPO_NAME}'"
echo "WORKSPACE_PARENT='${WORKSPACE_PARENT}'"
echo "WORKSPACE='${WORKSPACE}'"
env | sort

# tooling info
printf "\n## tooling info\n"
rustc -V
cargo -V
cargo nextest --version

cd "${WORKSPACE}"
unset FAULT
export CARGO_TERM_COLOR=always

# TODO: fail build if fault in "Style and Lint" job

cargo build || FAULT=1

export RUST_BACKTRACE=1

if test -z "$FAULT"; then
    cargo nextest run --hide-progress-bar --profile ci --features "${FEATURES}" || FAULT=1
fi
if test -z "$FAULT"; then
    cargo nextest run --hide-progress-bar --profile ci --all-features -p uucore || FAULT=1
fi

# Display sccache stats (Rust cache)
echo "## sccache stats"
sccache --show-stats

if test -n "$FAULT"; then
    exit 1
fi

exit 0
