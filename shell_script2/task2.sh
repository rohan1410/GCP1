#!/bin/sh
echo "Creating Backends..."
gcloud compute --project "pe-training" backend-services create "pe-rmm-backend" --http-health-checks "pe-rmm-healthcheck" --connection-draining-timeout "300" --protocol "HTTP" --global
echo "Backend Created...\nAttaching Backend to group"
gcloud compute --project "pe-training" backend-services add-backend "pe-rmm-backend" --instance-group="pe-rmm-group" --global --instance-group-region="us-east1"
echo "Backend Attached..\nCreating Forwarding Rules..."
gcloud compute addresses create pe-rmm-externalip \
    --ip-version=IPV4 \
    --global

gcloud compute url-maps create pe-rmm-urlmap \
    --default-service pe-rmm-backend

gcloud compute target-http-proxies create pe-rmm-proxy \
    --url-map pe-rmm-urlmap

gcloud --project "pe-training" compute forwarding-rules create "pe-rmm-frontend" --target-http-proxy="pe-rmm-proxy" --address="pe-rmm-externalip" --global --ports 80 
echo "Forwarding-rules Created.."