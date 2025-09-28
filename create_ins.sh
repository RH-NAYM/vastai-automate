#!/bin/bash
set -eu  # Exit on error (e) and treat unset variables as an error (u)

# --- CONFIGURATION ---
# *** CRITICAL FIX: Using the Template Hash ID instead of the Docker Image Name
TEMPLATE_HASH="305ac3ffd3e42e0d9ad1f4ae14729ec2"
DISK_SPACE=12 # Disk space in GB

# --- SETUP ---

# Activate Conda environment (optional)
if command -v conda &> /dev/null; then
    echo "Activating Conda..."
    source "$(conda info --base)/etc/profile.d/conda.sh"
    conda activate base 
fi

# Set API key for VastAI
vastai set api-key 4324b414f517f1c06c87f991c5b90a3ceda4295b3908bab7d89277a44044143c

# --- SEARCH AND FILTER ---

echo "Searching for available offers..."
vastai search offers "reliability>0.98 cpu_cores>70 num_gpus=1 gpu_ram>15 rented=False inet_down>300 inet_up>300 disk_space>$DISK_SPACE" > vastai_output.txt

ids=$(python filter_data.py)

if [ -z "$ids" ]; then
    echo "No target Instance IDs found. Exiting."
    exit 1
fi

echo "Target Instance IDs: $ids"

# --- INSTANCE CREATION LOOP ---

for id in $ids; do
    echo "-----------------------------------"
    echo "Attempting to create instance for offer ID: $id with template hash: $TEMPLATE_HASH"
    
    # Run the creation command using the TEMPLATE HASH
    # The --image argument is REMOVED and --template_hash is ADDED
    instance_info=$(vastai create instance "$id" --template_hash "$TEMPLATE_HASH" --disk "$DISK_SPACE" --jupyter --direct --raw 2> instance_error.txt)
    create_status=$?

    if [ $create_status -ne 0 ]; then
        echo "VastAI command failed for ID $id."
        echo "Error details:"
        cat instance_error.txt
        
        continue
    fi
    
    # Safely extract instance ID using jq
    instance_id=$(echo "$instance_info" | jq -r '.new_contract' 2>/dev/null)
    
    if [ -z "$instance_id" ] || [ "$instance_id" == "null" ]; then
        echo "Failed to extract new contract ID from JSON for instance $id."
        echo "Raw output:"
        echo "$instance_info"
        continue
    fi
    
    echo "Instance successfully created with ID: **$instance_id**"

    echo "Waiting 10 seconds for instance $instance_id to initialize..."
    sleep 10
    echo "Instance initialization time complete."

done

echo "-----------------------------------"
echo "Script finished."
