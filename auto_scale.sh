#!/bin/bash

# Threshold for CPU utilization
THRESHOLD=75
# Time interval between checks (in seconds)
INTERVAL=10

# Name of the VM to create
VM_NAME="auto-scale-vm"
ZONE="us-central1-a"
MACHINE_TYPE="e2-micro"
IMAGE_FAMILY="debian-11"
IMAGE_PROJECT="debian-cloud"

while true
do
  # Get current CPU utilization (user + system)
  CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
  CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc)

  echo "Current CPU Usage: $CPU_USAGE%"

  CPU_USAGE_INT=${CPU_USAGE%.*}

  if [ "$CPU_USAGE_INT" -gt "$THRESHOLD" ]; then
    echo "CPU is above threshold. Creating new VM in GCP..."
    gcloud compute instances create $VM_NAME \
      --zone=$ZONE \
      --machine-type=$MACHINE_TYPE \
      --image-family=$IMAGE_FAMILY \
      --image-project=$IMAGE_PROJECT
    break
  fi

  sleep $INTERVAL
done
