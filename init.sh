#!/bin/bash
source ~/miniconda3/bin/activate 
vastai set api-key 4324b414f517f1c06c87f991c5b90a3ceda4295b3908bab7d89277a44044143c 
vastai search offers "reliability>0.98 cpu_cores>60 num_gpus=1 gpu_ram>15 gpu_ram<26 rented=False inet_down>300 inet_up>300 disk_space>10" > vastai_output.txt
ids=$(python test.py)

echo "Target Instance IDs: $ids"
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo "Generating a new SSH key..."
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
fi
counter=1
for id in $ids; do
    echo "Creating instance: $id"
    
    instance_info=$(vastai create instance $id --image pytorch/pytorch --disk 16 --jupyter --direct --disk 16 --raw 2>&1)
    echo "Instance creation output: $instance_info"
    
    instance_id=$(echo "$instance_info" | jq -r '.new_contract')
    
    if [ -z "$instance_id" ]; then
        echo "Failed to create instance $id"
        continue
    fi
    
    echo "Instance created with ID: $instance_id"

    echo "Waiting for instance $instance_id to be ready..."
    sleep 40

    echo "Attaching SSH key to instance $instance_id..."
    vastai attach ssh $instance_id "$(cat ~/.ssh/id_rsa.pub)"

    echo "Checking instance status..."
    vastai show instance $instance_id

    echo "Instance $instance_id is ready."

    if [ "$counter" -eq 1 ]; then
        echo "Running script1.sh on instance $instance_id"
        echo "BAT==>>XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        echo "ssh -i $(cat ~/.ssh/id_rsa.pub) root@$instance_id 'bash -s' < ./BAT_deploy.sh"
        # ssh -i ~/.ssh/id_rsa root@$instance_id 'bash -s' < ./BAT_deploy.sh &  # Run in the background
        echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    fi

    if [ "$counter" -eq 2 ]; then
        echo "Running script2.sh on instance $instance_id"
        echo "UBL==>>XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        echo "ssh -i $(cat ~/.ssh/id_rsa.pub) root@$instance_id 'bash -s' < ./UBL_deploy.sh"
        # ssh -i ~/.ssh/id_rsa root@$instance_id 'bash -s' < ./UBL_deploy.sh &  # Run in the background
        echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    fi

    ((counter++))
done
wait
echo "Both scripts have completed execution."
