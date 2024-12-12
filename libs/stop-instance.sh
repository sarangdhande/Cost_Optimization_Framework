#!/bin/bash

#==================FUNCTION===================
# NAME: stop_ec2, stop_azvm
# DESCRIPTION:
#---------------------------------------------
stop_ec2(){
    instance=$1
    instance_state=$(aws ec2 describe-instances --instance-id "${instance}" --query "Reservations[].Instances[].State.Name" --output text)

    if [[ ${instance_state} == "running" ]]; then
      echo "INFO: Instance is in running state, stopping instance ""${instance}""..."
      aws ec2 stop-instances --instance-ids "${instance}" > /dev/null
    else
      echo "INFO: Instance is already in stopped state"
    fi
}

stop_azvm(){
    azvm=$1
    azvm_rg=$(az vm list --query "[?name=='$azvm'].resourceGroup")
    azvm_state=$(az vm show -d --name "${azvm}" -g "${azvm_rg}" --query 'powerState' -o tsv | awk '{print $NF}')

    if [[ ${azvm_state} == "running" ]]; then
      echo "INFO: VM is in running state, deallocating VM ${azvm}..."
      az vm stop --name "${azvm}" --resource-group "${azvm_rg}" --no-wait
    else
      echo "INFO: VM is already in deallocated state"
    fi
}
#=============================================

#=================MAIN SCRIPT=================

#---------------------AWS---------------------
for instance_id in $(aws ec2 describe-instances --filter "Name=tag:shutdown,Values=true" --query "Reservations[].Instances[].InstanceId" --output text); do
  stop_ec2 "${instance_id}"
done
#---------------------------------------------

#--------------------AZURE--------------------
for azvm_name in $(az vm list --query "[?tags.shutdown=='true'].name" -o tsv); do
  stop_azvm "${azvm_name}"
done
#---------------------------------------------