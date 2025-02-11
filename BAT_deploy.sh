#!/bin/bash

# Update and install necessary packages
sudo apt update && sudo apt upgrade -y

sudo apt update && sudo apt upgrade -y && sudo apt-get install -y iproute2 libgl1 && sudo apt-get install -y nano wget unzip nvtop git git-lfs

# Setup ngrok
sudo apt update && sudo apt-get install -y build-essential cmake libopenblas-dev liblapack-dev libx11-dev libgtk-3-dev libgl1-mesa-glx libglib2.0-0
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt update
sudo apt install -y ngrok

# Add ngrok authentication token
ngrok config add-authtoken 2lPN9d5cdnGlSrWb4JGEGVI1Mah_4bvvrGdKKU2ME7nkck8L7

# Install Python dependencies
pip install -r requirements.txt


pip install mtcnn
pip install facenet-pytorch --no-deps

python get_nltk_data.py

# Start the Django server
# python projectBAT/manage.py runserver localhost:8679
# Start Django server in the background
echo "Starting BAT AI server..."
tmux new-session -d -s deploy "python BAT_API.py"

# Give Django time to start
sleep 10

# Start ngrok in the background
echo "Starting ngrok..."
tmux new-window -t deploy "ngrok http --domain=hasb.nagadpulse.com 8679"

# Output success message
echo "The BAT Local AI Server started Successfully !!!"
echo "The BAT Local AI server and ngrok started successfully"

echo "==================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>=================================="

