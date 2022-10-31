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

See [swagger-editor-chart](./swagger-editor-chart/)

I first generated the chart template files via:

```bash
helm create swagger-editor-chart
```

I then genereated the deployment and service template yaml using the following commands:

```bash
# generate deployment template yaml
k create deployment swagger-editor --image=swaggerapi/swagger-editor:v4.5.1 --replicas=1 --port=8080 --dry-run=client -o yaml

# generate service template yaml
k expose deployment swagger-editor --type=NodePort --name=swagger-editor-service --dry-run=client -o yaml
```

I then modified the generated template yaml to add the helm templating as well as the NodePort etc.

[swagger-editor-deploy.yaml](swagger-editor-chart/templates/swagger-editor-deploy.yaml)
[swagger-editor-svc.yaml](swagger-editor-chart/templates/swagger-editor-svc.yaml)


Next I updated the `values.yaml` 

```yaml
replicaCount: 1

image:
  repository: swaggerapi/swagger-editor
  pullPolicy: IfNotPresent
  # Overrides the image tag whose default is the chart appVersion.
  tag: "v4.5.1"

service:
  type: NodePort
  nodePort: 30080
```

Finally I installed the chart.

```bash
helm install swagger-editor-app ./swagger-editor-chart
```


##### Test helm chart on KillerCoda

**Commands Output**

```bash
# Clone week05 branch of the cka-roadmap repo

controlplane $ git clone -b week05 https://github.com/n-murphy/cka-roadmap.git 
Cloning into 'cka-roadmap'...
remote: Enumerating objects: 159, done.
remote: Counting objects: 100% (159/159), done.
remote: Compressing objects: 100% (112/112), done.
remote: Total 159 (delta 66), reused 109 (delta 31), pack-reused 0
Receiving objects: 100% (159/159), 43.73 KiB | 3.36 MiB/s, done.
Resolving deltas: 100% (66/66), done.

# Goto the WEEK5 directory
controlplane $ cd cka-roadmap/WEEK5

# Install the swagger-editor-chart
controlplane $ helm install swagger-editor ./swagger-editor-chart/
NAME: swagger-editor
LAST DEPLOYED: Mon Oct 31 16:34:40 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None

# Check its running
controlplane $ helm ls
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                           APP VERSION
swagger-editor  default         1               2022-10-31 16:34:40.983729774 +0000 UTC deployed        swagger-editor-chart-4.5.1      4.5.1      


controlplane $ k get all -n default 
NAME                                        READY   STATUS    RESTARTS   AGE
pod/swagger-editor-deploy-85b9b8db7-5q6l8   1/1     Running   0          17s

NAME                         TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE
service/kubernetes           ClusterIP   10.96.0.1     <none>        443/TCP          13d
service/swagger-editor-svc   NodePort    10.108.4.14   <none>        8080:30080/TCP   17s

NAME                                    READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/swagger-editor-deploy   1/1     1            1           17s

NAME                                              DESIRED   CURRENT   READY   AGE
replicaset.apps/swagger-editor-deploy-85b9b8db7   1         1         1       17s
```

Finally goto the `Traffic Port Accessor` page and enter `30080` in Custom Ports and click `Access` and \o/ Huzzah!! Swagger Editor is up and running.