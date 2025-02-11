#!/bin/bash

# Update and install necessary packages
sudo apt update && sudo apt upgrade -y

sudo apt update && sudo apt upgrade -y && sudo apt-get install -y iproute2 libgl1 && sudo apt-get install -y nano wget unzip nvtop git git-lfs

# Setup ngrok
sudo apt update && sudo apt-get install -y build-essential cmake libopenblas-dev liblapack-dev libx11-dev libgtk-3-dev
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt update
sudo apt install -y ngrok

# Add ngrok authentication token
ngrok config add-authtoken 2lPN9d5cdnGlSrWb4JGEGVI1Mah_4bvvrGdKKU2ME7nkck8L7

# Install Python dependencies
pip install -r requirements.txt
pip install facenet-pytorch --no-deps

# Start the Django server
# python projectBAT/manage.py runserver localhost:8679
# Start Django server in the background
echo "Starting Unilever AI server locally ..."
tmux new-session -d -s deploy "python UBL_API.py"

# Give Django time to start
sleep 10

# Start ngrok in the background
echo "Starting ngrok..."
# tmux new-window -t deploy "ngrok http --domain=batnlp.ngrok.app 5656"
tmux new-window -t deploy "ngrok http --domain=he.ngrok.app 5656"

# Output success message
echo "Unilever Local Server started Successfully !!!"
echo "Local AI server and ngrok started successfully"

echo "==================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>=================================="

