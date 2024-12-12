#!/bin/bash

#-----------------FUNCTION--------------------
script_usage(){
    echo
    echo "USAGE:"
    echo "  sudo ./$0 --action <start|stop>"
}
#---------------------------------------------

#-----------------VARIABLES-------------------
MAIL_CONTENT="render-email-content.html"
MAIL_RECIPIENT="sarangdhande04@gmail.com"
MAIL_FROM="noreply-cof@max.com"
#---------------------------------------------

#---------------------------------------------
#---------------MAIN PROGRAM------------------
#---------------------------------------------
if [[ $# -eq 0 ]]; then
  echo "ERROR: Missing required script parameter"
  script_usage
  exit 1
fi

if [[ $1 == "--action" ]]; then
  APP_ACTION=$2
else
  echo "ERROR: Unrecognized parameter provided to script, $1"
  script_usage
  exit 1
fi

# Install Cloud CLI
bash libs/install-aws-cli.sh
bash libs/install-azure-cli.sh

# AuthN to Cloud
if [[ -f .cof/csp-auth.yaml ]]; then
  bash libs/csp-authentication.sh .cof/csp-auth.yaml
elif [[ -f ~/.cof/csp-auth.yaml ]]; then
  bash libs/csp-authentication.sh ~/.cof/csp-auth.yaml
else
  echo "ERROR: AuthN file not found at default location, Check README.md for authN details"
fi

# Perform instance start/stop action
if [[ ${APP_ACTION} == "start" ]]; then
  bash libs/start-instance.sh
elif [[ ${APP_ACTION} == "stop" ]]; then
  bash libs/stop-instance.sh
else
  echo "ERROR: Wrong value provided for parameter --action: ${APP_ACTION}"
  script_usage
  exit 1
fi

# Capture instance state
bash libs/capture-instance-state.sh

# Generate HTML report
bash libs/generate-html-report.sh

# Send email notification
if [[ ! -f ${MAIL_CONTENT} ]]; then
  echo "ERROR: Email content file ${MAIL_CONTENT} not found"
  exit 1
fi

sendmail $MAIL_RECIPIENT <<EOF
From: $MAIL_FROM
To: $MAIL_RECIPIENT
Subject: Daily Instance schedule report.
Content-Type: text/html

$(cat ${MAIL_CONTENT})
EOF

if [[ $? -eq 0 ]]; then
  echo "INFO: Email sent to all the recipients successfully"
fi