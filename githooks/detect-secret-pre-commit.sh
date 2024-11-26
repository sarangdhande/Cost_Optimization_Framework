#!/bin/bash

# Sanity Check
if command -v detect-secrets > /dev/null; then
  echo "INFO: Detect-secret is already installed, skipping installation"
else
  echo "INFO: Proceeding Installation"
  sudo apt install python3 python3-pip -y > /dev/null

  # Installing detect-secret using pip
  pip install detect-secrets

  # Add detect-secret path to shell PATH variable
  echo PATH=$PATH:~/.local/bin >> ~/.bashrc

  #Run .bashrc to successfully append the path
  bash .bashrc
fi

DETECT_SECRET=$(detect-secrets scan --exclude-files README.md | jq '.results | keys[]' | wc -l)
if [[ "${DETECT_SECRET}" -ne 0 ]]; then
  echo
  echo "ERROR: Sensative information detected"
  echo

  detect-secrets scan --exclude-files README.md | jq '.results'
  exit 1
else
  echo
  echo "INFO: No sensative information detected"
  echo
fi