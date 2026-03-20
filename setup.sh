#!/bin/bash
echo "Installation de Docker en cours..."
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
