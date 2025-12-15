#!/usr/bin/env bash
#
# Bash script to run Tests job (GH workflow) on FreeBSD
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
pw usershow -u "$(id -u)"

echo "## hostname"
hostname

# Install rust-stable via rustup
curl https://sh.rustup.rs -sSf --output rustup.sh
sh rustup.sh -y -c rustfmt,clippy --profile=minimal -t stable
. ${HOME}/.cargo/env

# Install nextest
mkdir -p ~/.cargo/bin
curl -LsSf https://get.nexte.st/latest/freebsd | tar zxf - -C ~/.cargo/bin

# environment
echo "## environment"
echo "CI='${CI}'"
echo "REPO_NAME='${REPO_NAME}'"
echo "WORKSPACE_PARENT='${WORKSPACE_PARENT}'"
echo "WORKSPACE='${WORKSPACE}'"
env | sort

# tooling info
printf "\n## tooling info\n"
rustc -vV
cargo -vV
cargo nextest --version

cd "${WORKSPACE}"
rm -f tests-ok
unset FAULT
export CARGO_TERM_COLOR=always

cargo build || FAULT=1

export RUST_BACKTRACE=1

if test -z "$FAULT"; then
    # cargo nextest run --hide-progress-bar --profile ci --features "${FEATURES}" || FAULT=1
    NEXTEST_EXPERIMENTAL_LIBTEST_JSON=1 cargo nextest run --hide-progress-bar --profile ci --features "${FEATURES}" --message-format libtest-json-plus 1> "${WORKSPACE}/tests-unix.json" || FAULT=1
fi
# There is no systemd-logind on FreeBSD, so test all features except feat_systemd_logind ( https://github.com/rust-lang/cargo/issues/3126#issuecomment-2523441905 )
if test -z "$FAULT"; then
    # cargo nextest run --hide-progress-bar --profile ci --features "\$UUCORE_FEATURES" -p uucore || FAULT=1
    UUCORE_FEATURES=$(cargo metadata --format-version=1 --no-deps | jq -r '.packages[] | select(.name == "uucore") | .features | keys | .[]' | grep -v "feat_systemd_logind" | paste -s -d "," -)
    NEXTEST_EXPERIMENTAL_LIBTEST_JSON=1 cargo nextest run --hide-progress-bar --profile ci --features "${UUCORE_FEATURES}" -p uucore --message-format libtest-json-plus 1> "${WORKSPACE}/tests-uucore.json" || FAULT=1
fi

# Clean to avoid to rsync back the files
cargo clean

# Do not exit for shell with return code 1 => prevent further execution of GH workflow
if test -n "$FAULT"; then
    exit 0
else
    touch "${WORKSPACE}"/tests-ok
    exit 0
fi
