#!/bin/sh
gcloud components update && gcloud components install beta -y && gcloud components install alpha -y
gcloud pubsub topics create pe-rmm-topic
gcloud beta pubsub subscriptions create pe-rmm-subscription --topic pe-rmm-topic --topic-project pe-training
git clone https://github.com/rohan1410/GCP.git
cd GCP/
gcloud beta functions deploy pe-rmm-function --runtime python37 --trigger-topic pe-rmm-topic --timeout 540s --entry-point hello_pubsub
message=`cat template`
gcloud alpha pubsub topics publish pe-rmm-topic --message $message


