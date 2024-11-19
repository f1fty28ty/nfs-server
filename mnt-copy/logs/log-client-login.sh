#!/bin/bash

# Extract the client name from the pod hostname
CLIENT_NAME=${HOSTNAME:-unknown-client}

# Log client login details to login.txt
echo "$(date): Client ${CLIENT_NAME} logged in" >> /mnt/logs/login.txt

# Create a client-specific folder if it doesn't exist
CLIENT_FOLDER="/mnt/clients/${CLIENT_NAME}"
mkdir -p "${CLIENT_FOLDER}"
chmod 770 "${CLIENT_FOLDER}"