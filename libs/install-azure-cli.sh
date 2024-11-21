#!/bin/bash

echo "INFO: Installing az command line utility"

# Perform sanity check
if command -v az >/dev/null; then
  echo "INFO: az cli is already installed, skipping installation."
else
  echo "INFO: az command not found, proceeding with installation."

  # Update apt repo and install unzip
  apt update -y >/dev/null
  apt install curl unzip -y >/dev/null

  # Download installation script
  mkdir /opt/scripts

  curl -sL https://aka.ms/InstallAzureCLIDeb > /opt/scripts/install_az.sh
  chmod +x /opt/scripts/install_az.sh

  /opt/scripts/install_az.sh > /dev/null

  # Post installation validation
  command -v az > /dev/null

  RETURN_CODE=${?}

  if [[ ${RETURN_CODE} -ne 0 ]]; then
    echo "ERROR: az cli installation failed with unexpected error."
  else
    echo "INFO: az cli installation completed successfully."
  fi
fi