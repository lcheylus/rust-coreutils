#!/usr/bin/env bash
#
# Bash script to run "Style and Lint" job (GH workflow) on OpenBSD
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
echo "## user infos"
userinfo "$(id -u)"

## VARs setup
cd "${WORKSPACE}"

unset FAIL_ON_FAULT
case "${STYLE_FAIL_ON_FAULT}" in
''|0|f|false|n|no|off)
    FAULT_TYPE=warning ;;
*)
    FAIL_ON_FAULT=true
    FAULT_TYPE=error ;;
esac;

FAULT_PREFIX=$(echo "${FAULT_TYPE}" | tr '[:lower:]' '[:upper:]')

# determine sub-crate utility list
UTILITY_LIST="$(./util/show-utils.sh --features "${FEATURES}")"
CARGO_UTILITY_LIST_OPTIONS="$(for u in ${UTILITY_LIST}; do echo -n "-puu_${u} "; done;)"

# environment
echo "## environment"
echo "CI='${CI}'"
echo "REPO_NAME='${REPO_NAME}'"
echo "WORKSPACE_PARENT='${WORKSPACE_PARENT}'"
echo "WORKSPACE='${WORKSPACE}'"
echo "FAULT_PREFIX='${FAULT_PREFIX}'"
echo "UTILITY_LIST='${UTILITY_LIST}'"
env | sort

# tooling info
printf "\n## tooling info\n"
rustc -V
cargo -V

# To ensure that files are cleaned up, we don't want to exit on error
set +e
unset FAULT

## cargo fmt testing
echo "## cargo fmt testing"

# * convert any errors/warnings to GHA UI annotations; ref: <https://help.github.com/en/actions/reference/workflow-commands-for-github-actions#setting-a-warning-message>
S=$(cargo fmt -- --check) && printf "%s\n" "$S" || {
    printf "%s\n" "$S"
    printf "%s\n" "$S" | sed -E -n -e "s/^Diff[[:space:]]+in[[:space:]]+${PWD//\//\\/}\/(.*)[[:space:]]+at[[:space:]]+[^0-9]+([0-9]+).*$/::${FAULT_TYPE} file=\1,line=\2::${FAULT_PREFIX}: \`cargo fmt\`: style violation (file:'\1', line:\2; use \`cargo fmt -- \"\1\"\`)/p"
    FAULT=true
}

## cargo clippy lint testing
if [ -z "${FAULT}" ]; then
    echo "## cargo clippy lint testing"
    # * convert any warnings to GHA UI annotations; ref: <https://help.github.com/en/actions/reference/workflow-commands-for-github-actions#setting-a-warning-message>
    S=$(cargo clippy --all-targets ${CARGO_UTILITY_LIST_OPTIONS} -- -W clippy::manual_string_new -D warnings 2>&1) && printf "%s\n" "$S" || {
        printf "%s\n" "$S"
        printf "%s" "$S" | sed -E -n -e '/^error:/{' -e "N; s/^error:[[:space:]]+(.*)\\n[[:space:]]+-->[[:space:]]+(.*):([0-9]+):([0-9]+).*$/::${FAULT_TYPE} file=\2,line=\3,col=\4::${FAULT_PREFIX}: \`cargo clippy\`: \1 (file:'\2', line:\3)/p;" -e '}'
        FAULT=true
    }
fi

# Clean to avoid to rsync back the files
cargo clean
if [ -n "${FAIL_ON_FAULT}" ] && [ -n "${FAULT}" ]; then
    exit 1
fi
