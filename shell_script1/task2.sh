#!/bin/sh
echo "Creating VPC" 
gcloud compute --project=pe-training networks create pe-rmm-custom --subnet-mode=custom
echo "VPC Created\nCreating First Subnet"
gcloud compute --project=pe-training networks subnets create region1 --network=pe-rmm-custom --region=us-east1 --range=10.0.0.0/16
echo "First Subnet1 Created\nCreating Second Subnet"
gcloud compute --project=pe-training networks subnets create region2 --network=pe-rmm-custom --region=us-central1 --range=10.1.0.0/16
echo "Second Subnet Created"