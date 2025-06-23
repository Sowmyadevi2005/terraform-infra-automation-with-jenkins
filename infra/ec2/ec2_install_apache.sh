#!/bin/bash

cd /home/ubuntu || exit 1

# Update and install dependencies
yes | sudo apt update
yes | sudo apt install python3 python3-pip python3-venv git -y

# Clone your Flask app repo
git clone https://github.com/Sowmyadevi2005/flask-mysql-webapp.git
cd flask-mysql-webapp || exit 1

# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Install Python requirements inside virtual environment
pip install -r requirements.txt

# Export DB environment variables from Terraform
echo "export DB_HOST='${db_host}'" >> ~/.bashrc
echo "export DB_USER='${db_user}'" >> ~/.bashrc
echo "export DB_PASSWORD='${db_password}'" >> ~/.bashrc
echo "export DB_NAME='${db_name}'" >> ~/.bashrc

# Also export in current shell so they're available now
export DB_HOST='${db_host}'
export DB_USER='${db_user}'
export DB_PASSWORD='${db_password}'
export DB_NAME='${db_name}'

# Wait a bit before launching
sleep 10

# Run Flask app in background using virtualenv python
nohup venv/bin/python app.py > /home/ubuntu/app.log 2>&1 &
