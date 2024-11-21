#!/bin/bash

echo "Installing AWS cli"

#perform sanity check

if command -v aws > /dev/null; then
  echo "INFO: AWS cli is already installed, skipping installation"
  exit 1
else
  echo "INFO: Proceeding Installation"
  #update apt and installing unzip
  sudo apt update -y > /dev/null
  sudo apt install unzip > /dev/null

  #download package and store in tmp
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
  #extract zip file to opt
  unzip /tmp/awscliv2.zip -d /opt > /dev/null
  #delete zip file
  rm -f /tmp/awscliv2.zip
  #installing aws cli
  sudo ./opt/aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli
  
  #post installation validation
  command -v aws > /dev/null
  RETURN_CODE=${?}

  if [[ "${RETURN_CODE}" -eq 0 ]]; then
    echo "INFO: Installation Completed"
  else
    echo "ERROR: Installation Failed"
  fi
fi
exit 0