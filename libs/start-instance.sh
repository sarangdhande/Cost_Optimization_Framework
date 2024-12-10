#!/bin/bash

#==================FUNCTION===================
# NAME: start_ec2, start_azvm
# DESCRIPTION:
#---------------------------------------------
start_ec2(){
    instance=$1
    instance_state=$(aws ec2 describe-instances --instance-id "${instance}" --query "Reservations[].Instances[].State.Name" --output text)

    if [[ ${instance_state} == "stopped" ]]; then
      echo "INFO: Instance is in stopped state, starting instance ${instance}..."
      aws ec2 start-instances --instance-ids "${instance}" > /dev/null
    else
      echo "INFO: Instance is already in running state"
    fi
}

start_azvm(){
    azvm=$1
    azvm_rg=$(az vm list --query "[?name=='$azvm'].resourceGroup")
    azvm_state=$(az vm show -d --name "${azvm}" -g "${azvm_rg}" --query 'powerState' -o tsv | awk '{print $NF}')

    if [[ ${azvm_state} == "deallocated" ]]; then
      echo "INFO: VM is in stopped state, starting VM ${azvm}..."
      az vm start --name "${azvm}" --resource-group "${azvm_rg}" --no-wait
    else
      echo "INFO: VM is already in running state"
    fi
}
#=============================================

#=================MAIN SCRIPT=================

#---------------------AWS---------------------
for instance_id in $(aws ec2 describe-instances --filter "Name=tag:shutdown,Values=true" --query "Reservations[].Instances[].InstanceId" --output text); do
  start_ec2 "${instance_id}"
done
#---------------------------------------------

#--------------------AZURE--------------------
for azvm_name in $(az vm list --query "[?tags.shutdown=='true'].name" -o tsv); do
  start_azvm "${azvm_name}"
done
#---------------------------------------------