# #!/bin/bash

# # Activate Conda environment
# source ~/miniconda3/bin/activate 

# # Set VastAI API key
# vastai set api-key 4324b414f517f1c06c87f991c5b90a3ceda4295b3908bab7d89277a44044143c 

# # Search for available GPU instances
# vastai search offers "reliability>0.98 num_gpus=1 gpu_ram>18 gpu_ram<26 rented=False inet_down>300 inet_up>300 disk_space>10" > vastai_output.txt

# # Extract instance IDs using Python script
# ids=$(python test.py)

# echo "Target Instance IDs: $ids"

# # Ensure SSH key exists locally
# if [ ! -f ~/.ssh/id_rsa.pub ]; then
#     echo "Generating a new SSH key..."
#     ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
# fi

# # Loop through each instance ID and create instances
# for id in $ids; do
#     echo "Creating instance: $id"
    
#     # Create instance and capture output (verbose mode)
#     instance_info=$(vastai create instance $id --image pytorch/pytorch --disk 16 --jupyter --direct --disk 16 --raw 2>&1
# )
#     echo "Instance creation output: $instance_info"
    
#     # Extract instance ID from creation output
#     instance_id=$(echo "$instance_info" | jq -r '.new_contract')
    
#     if [ -z "$instance_id" ]; then
#         echo "Failed to create instance $id"
#         continue
#     fi
    
#     echo "Instance created with ID: $instance_id"

#     # Wait for instance to be fully ready (increase wait time)
#     echo "Waiting for instance $instance_id to be ready..."
#     sleep 60  # Adjust this as needed



#     # Attach SSH key to th`e instance
#     echo "Attaching SSH key to instance $instance_id..."
#     vastai attach ssh $instance_id "$(cat ~/.ssh/id_rsa.pub)"

#     # Check if SSH key is attached
#     echo "Checking instance status..."
#     vastai show instance $instance_id

#     echo "Instance $instance_id is ready."
# done

















#!/bin/bash

# Activate Conda environment
source ~/miniconda3/bin/activate 

# Set VastAI API key
vastai set api-key 4324b414f517f1c06c87f991c5b90a3ceda4295b3908bab7d89277a44044143c 

# Search for available GPU instances
vastai search offers "reliability>0.98 cpu_cores_effective>60 num_gpus=1 gpu_ram>15 gpu_ram<26 rented=False inet_down>300 inet_up>300 disk_space>10" > vastai_output.txt

# Extract instance IDs using Python script
ids=$(python test.py)

# echo "Target Instance IDs: $ids"

# # Ensure SSH key exists locally
# if [ ! -f ~/.ssh/id_rsa.pub ]; then
#     echo "Generating a new SSH key..."
#     ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
# fi

# # Initialize counter for script selection
# counter=1

# # Loop through each instance ID and create instances
# for id in $ids; do
#     echo "Creating instance: $id"
    
#     # Create instance and capture output (verbose mode)
#     instance_info=$(vastai create instance $id --image pytorch/pytorch --disk 16 --jupyter --direct --disk 16 --raw 2>&1)
#     echo "Instance creation output: $instance_info"
    
#     # Extract instance ID from creation output
#     instance_id=$(echo "$instance_info" | jq -r '.new_contract')
    
#     if [ -z "$instance_id" ]; then
#         echo "Failed to create instance $id"
#         continue
#     fi
    
#     echo "Instance created with ID: $instance_id"

#     # Wait for instance to be fully ready
#     echo "Waiting for instance $instance_id to be ready..."
#     sleep 40  # Adjust this as needed

#     # Attach SSH key to the instance
#     echo "Attaching SSH key to instance $instance_id..."
#     vastai attach ssh $instance_id "$(cat ~/.ssh/id_rsa.pub)"

#     # Check if SSH key is attached
#     echo "Checking instance status..."
#     vastai show instance $instance_id

#     echo "Instance $instance_id is ready."

#     # Run script1.sh on the first instance
#     if [ "$counter" -eq 1 ]; then
#         echo "Running script1.sh on instance $instance_id"
#         echo "BAT==>>XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#         ssh -i ~/.ssh/id_rsa root@$instance_id 'bash -s' < ./BAT_deploy.sh &  # Run in the background
#         echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#     fi

#     # Run script2.sh on the second instance
#     if [ "$counter" -eq 2 ]; then
#         echo "Running script2.sh on instance $instance_id"
#         echo "UBL==>>XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#         ssh -i ~/.ssh/id_rsa root@$instance_id 'bash -s' < ./UBL_deploy.sh &  # Run in the background
#         echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#     fi

#     # Increment the counter for the next instance
#     ((counter++))
# done

# # Wait for both background tasks to finish
# wait
# echo "Both scripts have completed execution."
