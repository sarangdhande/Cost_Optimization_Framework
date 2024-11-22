#!/bin/bash

# Declaring variables
SHELL_CHECK_VERSION="v0.10.0"
SHELL_FILES=$(git diff --cached --name-only | grep -E "\.sh$")
SHELL_CHECK_BINARY="/tmp/shellcheck-${SHELL_CHECK_VERSION}/shellcheck"

if command -v shellcheck > /dev/null; then
  echo "INFO: Shellcheck is already installed, skipping installation"
  exit 1
else
  echo "INFO: Proceeding Installation"
  # Installing Package
  wget https://github.com/koalaman/shellcheck/releases/download/${SHELL_CHECK_VERSION}/shellcheck-${SHELL_CHECK_VERSION}.linux.x86_64.tar.xz -O /tmp/shellcheck-${SHELL_CHECK_VERSION}.linux.x86_64.tar.xz
  tar -xf /tmp/shellcheck-${SHELL_CHECK_VERSION}.linux.x86_64.tar.xz -C /tmp/ > /dev/null
  # Deleting the file
  rm -rf /tmp/shellcheck-${SHELL_CHECK_VERSION}.linux.x86_64.tar.xz
fi

if [[ -n "${SHELL_FILES}" ]]; then
  $SHELL_CHECK_BINARY $(echo $SHELL_FILES) --severity=warning
  if [[ $? -ne 0 ]]; then
    echo
    echo "ERROR: shellcheck detected warning or errors, please see above and fix the issue(s)."
    echo
    exit 1
  fi
fi
