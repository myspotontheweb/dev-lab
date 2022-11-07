NAME=mocdevlab

AZURE_SUBSCRIPTION=${ARM_SUBSCRIPTION_ID}
AZURE_REGION=eastus
AZURE_RESOURCE_GROUP=$(NAME)
AZURE_REGISTRY=$(NAME).azurecr.io
AZURE_CLUSTER=$(NAME)
AZURE_NODES=2

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

