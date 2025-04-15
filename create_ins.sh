
#!/bin/bash
set -e  # Exit on any error

# Activate Conda environment
source ~/miniconda3/bin/activate


# Set API key for VastAI
vastai set api-key 4324b414f517f1c06c87f991c5b90a3ceda4295b3908bab7d89277a44044143c

# Search for available offers and save output
vastai search offers "reliability>0.98 cpu_cores>70 num_gpus=1 gpu_ram>15 rented=False inet_down>300 inet_up>300 disk_space>12" > vastai_output.txt
ids=$(python test.py)

echo "Target Instance IDs: $ids"


counter=1

for id in $ids; do
    echo "Creating instance: $id"
    
    # Create instance
    instance_info=$(vastai create instance $id --image pytorch/pytorch --disk 16 --jupyter --direct --raw 2>&1)
    echo "Instance creation output: $instance_info"
    
    # Extract instance ID
    instance_id=$(echo "$instance_info" | jq -r '.new_contract')
    
    if [ -z "$instance_id" ]; then
        echo "Failed to create instance $id"
        continue
    fi
    
    echo "Instance created with ID: $instance_id"

    echo "Waiting for instance $instance_id to be ready..."
    sleep 10
    echo "instance $instance_id is ready"


    ((counter++))
done


