# dev-lab
Kubernetes Dev lab

# Getting started

## Software
Assume the following tools are installed

* make
* kubectl
* argocd

Dependent on cluster provider

* az
* minikube

## Minikube

```
make minikube argocd
```

## Azure AKS

Provision Azure AKS cluster (called "helloworld") and bootstrap Argocd

```
export ARM_SUBSCRIPTION_ID=xxxxxxxx-yyyy-zzzz-aaaa-bbbbbbbbbbbb

make azure argocd NAME=helloworld
```

## Troubleshooting

If the cluster is not ready you can resubmit the following command to deploy the cluster workloads

```
make argocd-boot
```
