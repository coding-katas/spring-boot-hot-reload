# Creates GKE autopilot test-cluster
# Initializes APIS
# fail if PROJECT_ID is not set
if [[ -z "${GOOGLE_CLOUD_PROJECT}" ]]; then
  echo "The value of GOOGLE_CLOUD_PROJECT= is not set. Be sure to run export GOOGLE_CLOUD_PROJECT==YOUR-PROJECT first"
  exit 
fi
# Enables various APIs you'll need
gcloud services enable container.googleapis.com cloudbuild.googleapis.com \
    artifactregistry.googleapis.com clouddeploy.googleapis.com \
    cloudresourcemanager.googleapis.com
# test cluster
echo "creating test-cluster..."
gcloud beta container --project "$GOOGLE_CLOUD_PROJECT" clusters create-auto "test-cluster" \
--region "us-central1" --release-channel "regular" --network "projects/$GOOGLE_CLOUD_PROJECT/global/networks/default" \
--subnetwork "projects/$GOOGLE_CLOUD_PROJECT/regions/us-central1/subnetworks/default" \
--cluster-ipv4-cidr "/17" --services-ipv4-cidr "/22" --async

