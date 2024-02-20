BASE=bootstrap
ROOT_DIR=$(git rev-parse --show-toplevel)
BASE_DIR=${ROOT_DIR}/${BASE}
CD_CONFIG_DIR=${BASE_DIR}/clouddeploy-config
TF_DIR=${BASE_DIR}/terraform-config
KUBERNETES_DIR=${BASE_DIR}/kubernetes-config
GCLOUD_CONFIG=clouddeploy

export PROJECT_ID=$(gcloud config get-value core/project)
export REGION=us-central1

BACKEND=${PROJECT_ID}-${BASE}-tf

cd $TF_DIR
terraform destroy -auto-approve -var=project_id=$PROJECT_ID -var=region=$REGION
cd $ROOT_DIR

gsutil rm -r gs://$BACKEND/

rm -rf $TF_DIR/.terraform
rm -rf $TF_DIR/main.tf
rm -rf $TF_DIR/terraform.tfstat*
rm -rf $TF_DIR/terraform.tfplan

gcloud compute routers delete app-router --region=us-central1 --quiet
gcloud compute networks subnets delete app-subnetwork --region=us-central1 --quiet
gcloud compute networks delete app-network --quiet
#gcloud compute firewall-rules delete allow-ssh
#gcloud compute firewall-rules delete allow-health-check
#gcloud compute backend-services delete helloworld-backend-service
#gcloud compute url-maps delete helloworld-url-map
#gcloud compute target-http-proxies delete helloworld-target-http-proxy
#gcloud compute forwarding-rules delete helloworld-forwarding-rule
gcloud iam service-accounts delete tf-sa-staging@${PROJECT_ID}.iam.gserviceaccount.com --quiet
gcloud iam service-accounts delete cd-tut-deploy-sa@${PROJECT_ID}.iam.gserviceaccount.com --quiet
gcloud iam service-accounts delete tf-sa-test@${PROJECT_ID}.iam.gserviceaccount.com --quiet
