Upgrade the version of api, scheduler, controller manager and etcd to 1.25.0.
=============================================================================


#### Upgrade on the controlplane

Commands:

```bash
kubeadm upgrade apply v1.25.0
```

Commands Output:

```bash
root@controlplane:~# kubeadm upgrade apply v1.25.0
[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[preflight] Running pre-flight checks.
[upgrade] Running cluster health checks
[upgrade/version] You have chosen to change the cluster version to "v1.25.0"
[upgrade/versions] Cluster version: v1.24.6
[upgrade/versions] kubeadm version: v1.25.0
[upgrade] Are you sure you want to proceed? [y/N]: y
[upgrade/prepull] Pulling images required for setting up a Kubernetes cluster
[upgrade/prepull] This might take a minute or two, depending on the speed of your internet connection
[upgrade/prepull] You can also perform this action in beforehand using 'kubeadm config images pull'
[upgrade/apply] Upgrading your Static Pod-hosted control plane to version "v1.25.0" (timeout: 5m0s)...
[upgrade/etcd] Upgrading to TLS for etcd
[upgrade/staticpods] Preparing for "etcd" upgrade
[upgrade/staticpods] Renewing etcd-server certificate
[upgrade/staticpods] Renewing etcd-peer certificate
[upgrade/staticpods] Renewing etcd-healthcheck-client certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/etcd.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2022-10-17-18-17-04/etcd.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
[apiclient] Found 1 Pods for label selector component=etcd
[upgrade/staticpods] Component "etcd" upgraded successfully!
[upgrade/etcd] Waiting for etcd to become available
[upgrade/staticpods] Writing new Static Pod manifests to "/etc/kubernetes/tmp/kubeadm-upgraded-manifests2113475291"
[upgrade/staticpods] Preparing for "kube-apiserver" upgrade
[upgrade/staticpods] Renewing apiserver certificate
[upgrade/staticpods] Renewing apiserver-kubelet-client certificate
[upgrade/staticpods] Renewing front-proxy-client certificate
[upgrade/staticpods] Renewing apiserver-etcd-client certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-apiserver.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2022-10-17-18-17-04/kube-apiserver.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
[apiclient] Found 1 Pods for label selector component=kube-apiserver
[upgrade/staticpods] Component "kube-apiserver" upgraded successfully!
[upgrade/staticpods] Preparing for "kube-controller-manager" upgrade
[upgrade/staticpods] Renewing controller-manager.conf certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-controller-manager.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2022-10-17-18-17-04/kube-controller-manager.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
[apiclient] Found 1 Pods for label selector component=kube-controller-manager
[upgrade/staticpods] Component "kube-controller-manager" upgraded successfully!
[upgrade/staticpods] Preparing for "kube-scheduler" upgrade
[upgrade/staticpods] Renewing scheduler.conf certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-scheduler.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2022-10-17-18-17-04/kube-scheduler.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
[apiclient] Found 1 Pods for label selector component=kube-scheduler
[upgrade/staticpods] Component "kube-scheduler" upgraded successfully!
[upgrade/postupgrade] Removing the old taint &Taint{Key:node-role.kubernetes.io/master,Value:,Effect:NoSchedule,TimeAdded:<nil>,} from all control plane Nodes. After this step only the &Taint{Key:node-role.kubernetes.io/control-plane,Value:,Effect:NoSchedule,TimeAdded:<nil>,} taint will be present on control plane Nodes.
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

[upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.25.0". Enjoy!

[upgrade/kubelet] Now that your control plane is upgraded, please proceed with upgrading your kubelets if you haven't already done so.
```

**Drain the node to evict all workloads**

Commands:

```bash
k drain controlplane --ignore-daemonsets
```

Commands Output:

```bash
root@controlplane:~# k drain controlplane --ignore-daemonsets
node/controlplane cordoned
WARNING: ignoring DaemonSet-managed Pods: kube-flannel/kube-flannel-ds-8xpn8, kube-system/kube-proxy-kxkbw
evicting pod kube-system/coredns-565d847f94-rcfh4
pod/coredns-565d847f94-rcfh4 evicted
node/controlplane drained
```

**Upgrade kubelet and kubectl**

Commands:

```bash
sudo apt-mark unhold kubelet kubectl
sudo apt update -qq && sudo apt install -y kubelet=1.25.0-00 kubectl=1.25.0-00
sudo apt-mark hold kubelet kubectl
```

Commands Output:

```bash
root@controlplane:~# sudo apt-mark unhold kubelet kubectl
Canceled hold on kubelet.
Canceled hold on kubectl.
root@controlplane:~# sudo apt update -qq && sudo apt install -y kubelet=1.25.0-00 kubectl=1.25.0-00
9 packages can be upgraded. Run 'apt list --upgradable' to see them.
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubectl kubelet
2 upgraded, 0 newly installed, 0 to remove and 7 not upgraded.
Need to get 29.0 MB of archives.
After this operation, 2825 kB disk space will be freed.
Get:1 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubectl amd64 1.25.0-00 [9500 kB]
Get:2 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubelet amd64 1.25.0-00 [19.5 MB]
Fetched 29.0 MB in 3s (8921 kB/s)
(Reading database ... 95325 files and directories currently installed.)
Preparing to unpack .../kubectl_1.25.0-00_amd64.deb ...
Unpacking kubectl (1.25.0-00) over (1.24.0-00) ...
Preparing to unpack .../kubelet_1.25.0-00_amd64.deb ...
Unpacking kubelet (1.25.0-00) over (1.24.0-00) ...
Setting up kubectl (1.25.0-00) ...
Setting up kubelet (1.25.0-00) ...
root@controlplane:~# sudo apt-mark hold kubelet kubectl
kubelet set on hold.
kubectl set on hold.
```

**Restart kubelet**

Commands:

```bash
sudo systemctl daemon-reload
sudo systemctl restart kubelet
sudo systemctl status kubelet
kubelet --version
```


Command Output:

```bash
root@controlplane:~# sudo systemctl daemon-reload
root@controlplane:~# sudo systemctl restart kubelet
root@controlplane:~# sudo systemctl status kubelet
● kubelet.service - kubelet: The Kubernetes Node Agent
     Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor preset: enabled)
    Drop-In: /etc/systemd/system/kubelet.service.d
             └─10-kubeadm.conf
     Active: active (running) since Mon 2022-10-17 18:33:48 IST; 5s ago
       Docs: https://kubernetes.io/docs/home/
   Main PID: 71750 (kubelet)
      Tasks: 14 (limit: 2339)
     Memory: 38.1M
     CGroup: /system.slice/kubelet.service
             └─71750 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --container-runtime=remote --container-runtime-e>

Oct 17 18:33:50 controlplane kubelet[71750]: I1017 18:33:50.325193   71750 reconciler.go:169] "Reconciler: start to sync state"
Oct 17 18:33:50 controlplane kubelet[71750]: E1017 18:33:50.476911   71750 kubelet.go:1712] "Failed creating a mirror pod for" err="pods \"kube-apiserver-controlplane\" already exists" pod="kube-system/kube-apiserver-controlplan>
Oct 17 18:33:50 controlplane kubelet[71750]: E1017 18:33:50.874522   71750 kubelet.go:1712] "Failed creating a mirror pod for" err="pods \"kube-scheduler-controlplane\" already exists" pod="kube-system/kube-scheduler-controlplan>
Oct 17 18:33:51 controlplane kubelet[71750]: E1017 18:33:51.079003   71750 kubelet.go:1712] "Failed creating a mirror pod for" err="pods \"etcd-controlplane\" already exists" pod="kube-system/etcd-controlplane"
Oct 17 18:33:51 controlplane kubelet[71750]: I1017 18:33:51.269453   71750 request.go:601] Waited for 1.149104381s due to client-side throttling, not priority and fairness, request: POST:https://192.168.64.9:6443/api/v1/namespac>
Oct 17 18:33:51 controlplane kubelet[71750]: E1017 18:33:51.276722   71750 kubelet.go:1712] "Failed creating a mirror pod for" err="pods \"kube-controller-manager-controlplane\" already exists" pod="kube-system/kube-controller-m>
Oct 17 18:33:51 controlplane kubelet[71750]: E1017 18:33:51.427623   71750 configmap.go:197] Couldn't get configMap kube-flannel/kube-flannel-cfg: failed to sync configmap cache: timed out waiting for the condition
Oct 17 18:33:51 controlplane kubelet[71750]: E1017 18:33:51.427736   71750 nestedpendingoperations.go:335] Operation for "{volumeName:kubernetes.io/configmap/0f876b68-bdb5-42e7-9c12-ee03f420b2f0-flannel-cfg podName:0f876b68-bdb5>
Oct 17 18:33:51 controlplane kubelet[71750]: E1017 18:33:51.427644   71750 configmap.go:197] Couldn't get configMap kube-system/kube-proxy: failed to sync configmap cache: timed out waiting for the condition
Oct 17 18:33:51 controlplane kubelet[71750]: E1017 18:33:51.428054   71750 nestedpendingoperations.go:335] Operation for "{volumeName:kubernetes.io/configmap/8de99c2b-8811-4035-aae2-9f0e25aa27ba-kube-proxy podName:8de99c2b-8811->

root@controlplane:~# kubelet --version
Kubernetes v1.25.0
```

**Uncordon the Node and Verify the Node Status**

Commands:

```bash
k uncordon controlplane
k get nodes
```


Commands Output:
```bash
root@controlplane:~# k uncordon controlplane
node/controlplane uncordoned

root@controlplane:~# k get nodes
NAME           STATUS   ROLES           AGE   VERSION
controlplane   Ready    control-plane   12d   v1.25.0
node01         Ready    <none>          12d   v1.24.0
```


#### Upgrade the nodes (node01)


Commands:

```bash
kubeadm upgrade node
```

Commands Output:

```bash
root@node01:~# kubeadm upgrade apply v1.25.0
couldn't create a Kubernetes client from file "/etc/kubernetes/admin.conf": failed to load admin kubeconfig: open /etc/kubernetes/admin.conf: no such file or directory
To see the stack trace of this error execute with --v=5 or higher
```
Solution: copy the /etc/kubernetes/admin.conf from the controlplane to node01

```bash
root@controlplane:~# scp /etc/kubernetes/admin.conf root@node01.local:/etc/kubernetes/admin.conf
The authenticity of host 'node01.local (192.168.64.10)' can't be established.
ECDSA key fingerprint is SHA256:2ViRzHVoU3BBu1ib73cQ90bUDvZCWpLhQbqr55KjP8Q.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'node01.local,192.168.64.10' (ECDSA) to the list of known hosts.
admin.conf
```

```bash
export KUBECONFIG=/etc/kubernetes/admin.conf

root@node01:~# kubeadm upgrade node
[upgrade] Reading configuration from the cluster...
[upgrade] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[preflight] Running pre-flight checks
[preflight] Skipping prepull. Not a control plane node.
[upgrade] Skipping phase. Not a control plane node.
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[upgrade] The configuration for this node was successfully updated!
[upgrade] Now you should go ahead and upgrade the kubelet package using your package manager.
root@node01:~#
```


**Drain node01**

Commands:

```bash
k drain node01 --ignore-daemonsets
```

Commands Output:

```bash
root@node01:~# k drain node01 --ignore-daemonsets
node/node01 already cordoned
error: unable to drain node "node01" due to error:cannot delete Pods declare no controller (use --force to override): default/nginx, continuing command...
There are pending nodes to be drained:
 node01
cannot delete Pods declare no controller (use --force to override): default/nginx
root@node01:~#
root@node01:~# k drain node01 --ignore-daemonsets --force
node/node01 already cordoned
WARNING: deleting Pods that declare no controller: default/nginx; ignoring DaemonSet-managed Pods: kube-flannel/kube-flannel-ds-wz2g7, kube-system/kube-proxy-dpvrt
evicting pod kube-system/coredns-565d847f94-z98lh
evicting pod default/nginx
evicting pod kube-system/coredns-565d847f94-lvbbb
pod/nginx evicted
pod/coredns-565d847f94-z98lh evicted
pod/coredns-565d847f94-lvbbb evicted
node/node01 drained
```


**Upgrade kubelet and kubectl**

Commands:

```bash
sudo apt-mark unhold kubelet kubectl
sudo apt update -qq && sudo apt install -y kubelet=1.25.0-00 kubectl=1.25.0-00
sudo apt-mark hold kubelet kubectl
```


Commands Output:

```bash
root@node01:~# sudo apt-mark unhold kubelet kubectl
Canceled hold on kubelet.
Canceled hold on kubectl.
root@node01:~# sudo apt update -qq && sudo apt install -y kubelet=1.25.0-00 kubectl=1.25.0-00
25 packages can be upgraded. Run 'apt list --upgradable' to see them.
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubectl kubelet
2 upgraded, 0 newly installed, 0 to remove and 23 not upgraded.
Need to get 29.0 MB of archives.
After this operation, 2825 kB disk space will be freed.
Get:1 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubectl amd64 1.25.0-00 [9500 kB]
Get:2 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubelet amd64 1.25.0-00 [19.5 MB]
Fetched 29.0 MB in 3s (9546 kB/s)
(Reading database ... 64255 files and directories currently installed.)
Preparing to unpack .../kubectl_1.25.0-00_amd64.deb ...
Unpacking kubectl (1.25.0-00) over (1.24.0-00) ...
Preparing to unpack .../kubelet_1.25.0-00_amd64.deb ...
Unpacking kubelet (1.25.0-00) over (1.24.0-00) ...
Setting up kubectl (1.25.0-00) ...
Setting up kubelet (1.25.0-00) ...
root@node01:~# sudo apt-mark hold kubelet kubectl
kubelet set on hold.
kubectl set on hold.
```


**Restart kubelet**

Commands:

```bash
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

Commands Output:

```bash
sudo systemctl daemon-reload
sudo systemctl restart kubelet

```


**Uncordon node01**

Commands:

```bash
k uncordon node01
```


Commands Output:

```bash
root@node01:~# k uncordon node01
node/node01 uncordoned
```



**Check the status of the cluster**

Commands:

```bash
k get nodes
```

Commands Output:

```bash
root@node01:~# k get nodes
NAME           STATUS   ROLES           AGE   VERSION
controlplane   Ready    control-plane   12d   v1.25.0
node01         Ready    <none>          12d   v1.25.0
```




#### Run the healthcheck

Commands:

```bash
kubectl get --raw='/readyz?verbose'
```

Commands Output:

```bash
root@controlplane:~# kubectl get --raw='/readyz?verbose'
[+]ping ok
[+]log ok
[+]etcd ok
[+]etcd-readiness ok
[+]informer-sync ok
[+]poststarthook/start-kube-apiserver-admission-initializer ok
[+]poststarthook/generic-apiserver-start-informers ok
[+]poststarthook/priority-and-fairness-config-consumer ok
[+]poststarthook/priority-and-fairness-filter ok
[+]poststarthook/storage-object-count-tracker-hook ok
[+]poststarthook/start-apiextensions-informers ok
[+]poststarthook/start-apiextensions-controllers ok
[+]poststarthook/crd-informer-synced ok
[+]poststarthook/bootstrap-controller ok
[+]poststarthook/rbac/bootstrap-roles ok
[+]poststarthook/scheduling/bootstrap-system-priority-classes ok
[+]poststarthook/priority-and-fairness-config-producer ok
[+]poststarthook/start-cluster-authentication-info-controller ok
[+]poststarthook/aggregator-reload-proxy-client-cert ok
[+]poststarthook/start-kube-aggregator-informers ok
[+]poststarthook/apiservice-registration-controller ok
[+]poststarthook/apiservice-status-available-controller ok
[+]poststarthook/kube-apiserver-autoregistration ok
[+]autoregister-completion ok
[+]poststarthook/apiservice-openapi-controller ok
[+]poststarthook/apiservice-openapiv3-controller ok
[+]shutdown ok
readyz check passed
```