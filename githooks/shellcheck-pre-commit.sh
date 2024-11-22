#!/bin/bash


if command -v shellcheck > /dev/null; then
  SHELL_CHECK_BINARY=$(command -v shellcheck)
  SHELL_CHECK_INSTALLED=0
else
  SHELL_CHECK_VERSION="0.10.0"
  SHELL_CHECK_BINARY="/tmp/${SHELL_CHECK_VERSION}/shellcheck"
  SHELL_CHECK_INSTALLED=1
fi

if [[ ${SHELL_CHECK_INSTALLED} -eq 1 ]]; then

  rm -f $SHELL_CHECK_BINARY

  wget -q https://github.com/koalaman/shellcheck/releases/download/v${SHELL_CHECK_VERSION}/shellcheck-v${SHELL_CHECK_VERSION}.linux.x86_64.tar.xz \
    -O /tmp/shellcheck-v${SHELL_CHECK_VERSION}.tar.xz

  tar -xf /tmp/shellcheck-v${SHELL_CHECK_VERSION}.tar.xz -C /tmp/ > /dev/null
  rm -rf /tmp/shellcheck-v${SHELL_CHECK_VERSION}.tar.xz
fi

SHELL_FILES=$(git diff --cached --name-only | grep -E "\.sh$")

if [[ -n "${SHELL_FILES}" ]]; then
  # shellcheck disable=SC2046
  $SHELL_CHECK_BINARY $(echo $SHELL_FILES) --severity=warning

  if [[ $? -ne 0 ]]; then
    echo
    echo "ERROR: shellcheck detected warning or errors, please see above and fix the issue(s)."
    echo
    exit 1
  fi
fi