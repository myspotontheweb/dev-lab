NAME=mocdevlab

AZURE_SUBSCRIPTION=${ARM_SUBSCRIPTION_ID}
AZURE_REGION=eastus
AZURE_RESOURCE_GROUP=$(NAME)
AZURE_REGISTRY=$(NAME).azurecr.io
AZURE_CLUSTER=$(NAME)
AZURE_NODES=2

ARGO_BOOT_NAME=boot-dev-lab
ARGO_BOOT_REPO=https://github.com/myspotontheweb/dev-lab.git
ARGO_BOOT_PATH=environments/dev


default: azure

#
# Deploy ArgoCD
#
argocd: argocd-install argocd-login argocd-boot

argocd-install:
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/core-install.yaml

argocd-login:
	kubectl config set-context --current --namespace=argocd 
	argocd login --core

argocd-boot:
	argocd app create $(ARGO_BOOT_NAME) --repo $(ARGO_BOOT_REPO) --path $(ARGO_BOOT_PATH) --dest-server https://kubernetes.default.svc --dest-namespace argocd
	argocd app set  $(ARGO_BOOT_NAME) --sync-policy automated --self-heal

#
# Provision Azure AKS cluster
#
azure: azure-cluster azure-aks-creds

azure-setup:
	az account set --subscription $(AZURE_SUBSCRIPTION)
	az group create --name $(AZURE_RESOURCE_GROUP) --location $(AZURE_REGION)

azure-registry: azure-setup
	az acr create --resource-group $(AZURE_RESOURCE_GROUP) --name $(NAME) --sku Basic

azure-cluster: azure-registry
	az aks create --resource-group $(AZURE_RESOURCE_GROUP) --name $(AZURE_CLUSTER) --node-count $(AZURE_NODES) --attach-acr $(NAME)

azure-aks-creds:
	az aks get-credentials --resource-group $(AZURE_RESOURCE_GROUP) --name $(NAME) --overwrite-existing --admin

azure-clean:
	az group delete --name $(AZURE_RESOURCE_GROUP) --yes --no-wait

