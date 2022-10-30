#### Install the nginx ingress controller nginx-stable via https://helm.nginx.com/stable


**Commands**

```bash
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo ls
helm repo update
helm install my-release nginx-stable/nginx-ingress
helm ls
```


**Commands Output**

```bash
controlplane $ helm repo add nginx-stable https://helm.nginx.com/stable
"nginx-stable" has been added to your repositories

controlplane $ helm repo ls
NAME            URL                          
nginx-stable    https://helm.nginx.com/stable

controlplane $ helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "nginx-stable" chart repository
Update Complete. ⎈Happy Helming!⎈

controlplane $ helm install my-release nginx-stable/nginx-ingress
NAME: my-release
LAST DEPLOYED: Sun Oct 30 15:39:02 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
The NGINX Ingress Controller has been installed.

controlplane $ helm ls
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
my-release      default         1               2022-10-30 15:39:02.172281601 +0000 UTC deployed        nginx-ingress-0.15.1    2.4.1      
```


#### Install Hashicorp Vault via helm chart hashicorp/vault at https://helm.releases.hashicorp.com

**Commands**

```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo ls
helm repo update
helm install vault hashicorp/vault
helm ls
```


**Commands Output**


```bash
controlplane $ helm repo add hashicorp https://helm.releases.hashicorp.com
"hashicorp" has been added to your repositories


controlplane $ helm repo ls
NAME            URL                                
nginx-stable    https://helm.nginx.com/stable      
hashicorp       https://helm.releases.hashicorp.com


controlplane $ helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "nginx-stable" chart repository
...Successfully got an update from the "hashicorp" chart repository
Update Complete. ⎈Happy Helming!⎈


controlplane $ helm install vault hashicorp/vault
NAME: vault
LAST DEPLOYED: Sun Oct 30 15:44:55 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
Thank you for installing HashiCorp Vault!

Now that you have deployed Vault, you should look over the docs on using
Vault with Kubernetes available here:

https://www.vaultproject.io/docs/


Your release is named vault. To learn more about the release, try:

  $ helm status vault
  $ helm get manifest vault


controlplane $ helm ls  
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
my-release      default         1               2022-10-30 15:39:02.172281601 +0000 UTC deployed        nginx-ingress-0.15.1    2.4.1      
vault           default         1               2022-10-30 15:44:55.940289423 +0000 UTC deployed        vault-0.22.1            1.12.0 
```


#### Override the values file for vault using the default here: https://github.com/hashicorp/vault-helm/blob/main/values.yaml

**Commands**

```bash
helm upgrade vault hashicorp/vault --values https://raw.githubusercontent.com/hashicorp/vault-helm/main/values.yaml 
helm history vault
```

TODO: how to validate that this was successful. Also noted that there is an issue with the vault pods. seeing the following:

```yaml
status:
  conditions:
  - lastProbeTime: null
    lastTransitionTime: "2022-10-30T15:44:57Z"
    message: '0/2 nodes are available: 2 pod has unbound immediate PersistentVolumeClaims.
      preemption: 0/2 nodes are available: 2 Preemption is not helpful for scheduling.'
    reason: Unschedulable
    status: "False"
    type: PodScheduled
  phase: Pending
  qosClass: BestEffort
```

**Commands Output**


```bash
controlplane $ helm upgrade vault hashicorp/vault --values https://raw.githubusercontent.com/hashicorp/vault-helm/main/values.yaml 
Release "vault" has been upgraded. Happy Helming!
NAME: vault
LAST DEPLOYED: Sun Oct 30 15:53:13 2022
NAMESPACE: default
STATUS: deployed
REVISION: 2
NOTES:
Thank you for installing HashiCorp Vault!

Now that you have deployed Vault, you should look over the docs on using
Vault with Kubernetes available here:

https://www.vaultproject.io/docs/


Your release is named vault. To learn more about the release, try:

  $ helm status vault
  $ helm get manifest vault


controlplane $ helm history vault
REVISION        UPDATED                         STATUS          CHART           APP VERSION     DESCRIPTION     
1               Sun Oct 30 15:44:55 2022        superseded      vault-0.22.1    1.12.0          Install complete
2               Sun Oct 30 15:53:13 2022        deployed        vault-0.22.1    1.12.0          Upgrade complete

```


#### Create a helm chart from scratch and deploy it to Kubernetes

**Commands**

```bash

```


**Commands Output**


```bash

```
