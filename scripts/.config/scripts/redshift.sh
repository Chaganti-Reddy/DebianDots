#!/bin/bash

# Kill all running redshift instances
echo "Killing all Redshift instances..."
killall redshift

# Wait a moment to ensure processes are terminated
sleep 0.5

# Start redshift
echo "Starting Redshift..."
redshift &

echo "Redshift restarted successfully."
