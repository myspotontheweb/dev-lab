# dev-lab
Kubernetes Dev lab

## Getting started

Provision Azure AKS cluster (called "helloworld") and bootstrap Argocd

```
export ARM_SUBSCRIPTION_ID=xxxxxxxx-yyyy-zzzz-aaaa-bbbbbbbbbbbb

make azure argocd NAME=helloworld
```

Notes:

Assume the following tools are installed

* az
* kubectl
* argocd

