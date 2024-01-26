#!/usr/bin/env bash
#
# Bash script to run Tests job (GH workflow) on OpenBSD
#

set -e

# First, we check that this script is not run as root because it would fail tests.
if [ "root" == "$(whoami)" ]; then
    echo "ERROR: don't run this script as root"
    exit 1;
fi

# Increase the number of file descriptors - See https://github.com/rust-lang/cargo/issues/11435
ulimit -n 1024

## Info
# user info
echo "## user infos"
userinfo "$(id -u)"

# environment
echo "## environment"
echo "CI='${CI}'"
echo "REPO_NAME='${REPO_NAME}'"
echo "WORKSPACE_PARENT='${WORKSPACE_PARENT}'"
echo "WORKSPACE='${WORKSPACE}'"
env | sort

# Install nextest latest version from lcheylus/cargo-nextest-openbsd GH repository
mkdir -p "${HOME}"/.cargo/bin

LATEST_NEXTEST_URL=$(curl -sLf https://api.github.com/repos/lcheylus/cargo-nextest-openbsd/releases/latest | grep 'download_url' | cut -d\" -f4)
echo "Latest cargo-nextest version for OpenBSD - URL archive = '${LATEST_NEXTEST_URL}'"

curl -LsSf "${LATEST_NEXTEST_URL}" | tar zxf - -C "${HOME}"/.cargo/bin
printf "# ls -l %s/.cargo/bin\n" "${HOME}"
ls -l "${HOME}"/.cargo/bin

# tooling info
printf "\n## tooling info\n"
rustc -V
cargo -V
cargo nextest --version

cd "${WORKSPACE}"
rm -f tests-status
unset FAULT
export CARGO_TERM_COLOR=always

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

# Clean to avoid to rsync back the files
cargo clean

# Do not exit for shell with return code 1 => prevent further execution of GH workflow
if test -n "$FAULT"; then
    echo "1" > "${WORKSPACE}/tests-status
fi

echo "0" > "${WORKSPACE}/tests-status
