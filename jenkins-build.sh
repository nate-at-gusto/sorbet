#!/bin/bash
set -eux
. /usr/stripe/bin/docker/stripe-init-build

cd "$( dirname "${BASH_SOURCE[0]}" )"

export BAZEL_BIN_LOC=/cache/bazel_binary

./tools/scripts/format_build_files.sh -t
./tools/scripts/format_cxx.sh -t

cp bazelrc-jenkins .bazelrc


# Disable leak sanatizer. Does not work in docker
# https://github.com/google/sanitizers/issues/764

bazel test //... --test_output=errors --test_env="ASAN_OPTIONS=detect_leaks=0" --test_env="LSAN_OPTIONS=verbosity=1:log_threads=1"
