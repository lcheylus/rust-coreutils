#!/usr/bin/env bash
#
# Bash script to run Tests job (GH workflow) on OpenBSD
#

set -e

# First, we check that this script is not run as root because it would fail tests.
if [ "root" == "$(whoami)" ]; then exit 1; fi

echo "## whoami"
whoami

# Increase the number of file descriptors - See https://github.com/rust-lang/cargo/issues/11435
ulimit -n 1024

# Install nextest latest version from lcheylus/cargo-nextest-openbsd GH repository
mkdir -p ~/.cargo/bin
LATEST_NEXTEST_URL=$(curl -sLf https://api.github.com/repos/lcheylus/cargo-nextest-openbsd/releases/latest | grep 'download_url' | cut -d\" -f4)
echo "Latest cargo-nextest version for OpenBSD - URL archive = '${LATEST_NEXTEST_URL}'"
curl -LsSf "${LATEST_NEXTEST_URL}" | tar zxf - -C ~/.cargo/bin
ls -l ~/.cargo/bin

## Info
# environment
echo "## environment"
echo "CI='${CI}'"
echo "REPO_NAME='${REPO_NAME}'"
echo "TEST_USER='${TEST_USER}'"
echo "WORKSPACE_PARENT='${WORKSPACE_PARENT}'"
echo "WORKSPACE='${WORKSPACE}'"
env | sort

# tooling info
printf "\n## tooling info\n"
rustc -V
cargo -V
cargo nextest --version

# To ensure that files are cleaned up, we don't want to exit on error
# set +e
# cd "${WORKSPACE}"
# unset FAULT
# cargo build || FAULT=1
# export PATH=~/.cargo/bin:${PATH}
# export RUST_BACKTRACE=1
# export CARGO_TERM_COLOR=always
# if (test -z "\$FAULT"); then cargo nextest run --hide-progress-bar --profile ci --features '${{ matrix.job.features }}' || FAULT=1 ; fi
# if (test -z "\$FAULT"); then cargo nextest run --hide-progress-bar --profile ci --all-features -p uucore || FAULT=1 ; fi
# # Clean to avoid to rsync back the files
# cargo clean
# if (test -n "\$FAULT"); then exit 1 ; fi

