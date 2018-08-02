#!/bin/sh
echo "Creating VPC"
gcloud compute --project=pe-training networks create pe-rmm --subnet-mode=auto
echo "VPC Created\nCreating Firewall"
gcloud compute --project=pe-training firewall-rules create pe-rmm-firewall --direction=INGRESS --priority=800 --network=pe-rmm --action=ALLOW --rules=tcp:22,udp:22 --source-ranges=59.152.53.0/24
echo "Firewall Created"
