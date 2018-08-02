#!/bin/sh
gcloud container clusters create pe-rmm-cluster \
--zone us-east1-b \
--node-locations us-east1-c,us-east1-b \
--enable-autoscaling --max-nodes 3 --min-nodes 1 \
--labels="name"="rohan","project"="pe-training"

gcloud container clusters get-credentials pe-rmm-cluster

kubectl run pe-rmm-server --image gcr.io/google-samples/hello-app:1.0 --port 8080 --replicas 3

kubectl expose deployment pe-rmm-server --type LoadBalancer \
  --port 4000 --target-port 8080