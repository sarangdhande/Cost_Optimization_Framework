#!/bin/bash

CSV_FILE="instance_report.csv"

echo "CLOUD_PROVIDER,INSTANCE_NAME,INSTANCE_IP,INSTANCE_STATE,DATE,TAGS" > $CSV_FILE

# Capture AWS Instance State
for instance_id in $(aws ec2 describe-instances --filter "Name=tag:shutdown,Values=true" --query "Reservations[].Instances[].InstanceId" --output text); do
  echo "INFO: Fetching details of AWS Instance for $instance_id"

  aws_name=$(aws ec2 describe-tags --filters "Name=resource-id,Values=${instance_id}" --query "Tags[?Key=='Name'].Value" --output text)
  aws_ip=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${aws_name}" --query 'Reservations[].Instances[].PrivateIpAddress' --output text)
  aws_state=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${aws_name}" --query 'Reservations[].Instances[].State.Name' --output text)
  datestamp=$(date +%Y%m%d-%H%M%S)

  echo "aws,$aws_name,$aws_ip,$aws_state,$datestamp,shutdown" >> $CSV_FILE
done

# Capture AZURE Virtual Machine State

#for instance_name in $(az vm list --query "[?tags.shutdown=='true'].name" -o tsv); do
 # echo "INFO: Fetching details of Azure Virtual Machine for $instance_name"

  #az_rg=$(az vm list --query "[?name=='$instance_name'].resourceGroup")
  #az_ip=$(az vm show -d --name $instance_name -g $az_rg --query 'privateIps' -o tsv)
  #az_state=$(az vm show -d --name $instance_name -g $az_rg --query 'powerState' -o tsv | awk '{print $NF}')
  #dates=$(date +%Y%m%d-%H%M%S)

  #echo "azure,$instance_name",$az_ip,$az_state,$dates,shutdown >> $CSV_FILE
  #done