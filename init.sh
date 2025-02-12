
#!/bin/bash
set -e  # Exit on any error

# Activate Conda environment
source ~/miniconda3/bin/activate 

# Set API key for VastAI
vastai set api-key 4324b414f517f1c06c87f991c5b90a3ceda4295b3908bab7d89277a44044143c

# Search for available offers and save output
vastai search offers "reliability>0.98 cpu_cores>60 num_gpus=1 gpu_ram>15 gpu_ram<26 rented=False inet_down>300 inet_up>300 disk_space>10" > vastai_output.txt
ids=$(python test.py)

echo "Target Instance IDs: $ids"

# Ensure SSH key exists
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Generating SSH key..."
    ssh-keygen -q -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""  # No prompts
fi

# Install sshpass if not installed
if ! command -v sshpass &> /dev/null; then
    echo "Installing sshpass..."
    sudo apt-get install -y sshpass
fi

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
    sleep 40

    # Attach SSH key
    vastai attach ssh $instance_id "$(cat ~/.ssh/id_rsa.pub)"
    sleep 10  # Ensure SSH key is properly registered

    echo "Checking instance status..."
    vastai show instance $instance_id

    echo "Instance $instance_id is ready."

    ssh_url=$(vastai ssh-url $instance_id)
    echo "SSH URL: $ssh_url"

    # Extract values using proper parsing
    ssh_host=$(echo "$ssh_url" | sed -E 's|ssh://root@([^:]+):([0-9]+)|\1|')
    ssh_port=$(echo "$ssh_url" | sed -E 's|ssh://root@([^:]+):([0-9]+)|\2|')

    echo "Extracted SSH Host: $ssh_host"
    echo "Extracted SSH Port: $ssh_port"

    # Test SSH connection (with retry)
    for i in {1..5}; do
        ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -p "$ssh_port" "root@$ssh_host" exit && break
        echo "🔄 Retrying SSH connection in 5s..."
        sleep 5
    done

    if [ "$counter" -eq 1 ]; then
        echo "🚀 Deploying BAT_Master..."
        ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -p "$ssh_port" "root@$ssh_host" sudo apt update && sudo apt upgrade -y && sudo apt-get install -y iproute2 libgl1 nano wget unzip nvtop git git-lfs && git clone -b dev https://huggingface.co/HawkEyesAI/BAT_Master && cd BAT_Master && chmod +x deploy.sh && ./deploy.sh
        echo "🔗 BAT Run URL ==>> $ssh_url"
    fi

    if [ "$counter" -eq 2 ]; then
        sleep 30
        echo "🚀 Deploying UNILEVER_Master..."
        ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -p "$ssh_port" "root@$ssh_host" && sudo apt update && sudo apt upgrade -y && sudo apt-get install -y iproute2 libgl1 nano wget unzip nvtop git git-lfs && git clone -b dev https://huggingface.co/HawkEyesAI/UNILEVER_Master && cd UNILEVER_Master && chmod +x deploy.sh && ./deploy.sh && sleep 10 && python test.py
        echo "🔗 UBL Run URL ==>> $ssh_url"
    fi

    ((counter++))
done

wait
echo "✅ Both scripts have completed execution."







