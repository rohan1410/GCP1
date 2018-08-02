#!/bin/sh
echo "Creating Private Instance"
gcloud compute --project=pe-training instances create rmm-private --zone=us-east1-b --machine-type=n1-standard-1 --subnet=pe-rmm --private-network-ip=10.142.0.2 --no-address --maintenance-policy=MIGRATE --service-account=912623308461-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --image=debian-9-stretch-v20180716 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=rmm-private
echo "Private Instance Created\nCreating Firewall"
gcloud compute firewall-rules create rmm-allow-internal \
    --allow tcp:1-65535,udp:1-65535,icmp \
    --source-ranges 10.142.0.0/20	 \
    --network pe-rmm
echo "Firewall Created\nCreating NAT"
gcloud compute instances create rmm-nat-gateway --network pe-rmm \
    --subnet pe-rmm	 \
    --can-ip-forward \
    --zone us-east1-b \
    --image-family debian-8 \
    --image-project debian-cloud \
    --tags nat \
    --metadata=startup-script=\#\!/bin/sh$'\n'sudo\ sysctl\ -w\ net.ipv4.ip_forward=1$'\n'sudo\ iptables\ -t\ nat\ -A\ POSTROUTING\ -o\ eth0\ -j\ MASQUERADE
echo "NAT Created"
gcloud compute instances add-tags rmm-private --tags no-ip
echo "Creating Route"
gcloud compute routes create no-ip-internet-route \
    --network pe-rmm \
    --destination-range 0.0.0.0/0 \
    --next-hop-instance rmm-nat-gateway \
    --next-hop-instance-zone us-east1-b \
    --tags no-ip --priority 800
echo "Route Created "
echo "Connecting to NAT"
gcloud compute ssh rmm-nat-gateway