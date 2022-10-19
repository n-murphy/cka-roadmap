Upgrade kubeadm to version 1.25.0 on all nodes in the cluster
=============================================================

Get the current cluster nodes:
```bash
root@controlplane:~# k get nodes
NAME           STATUS   ROLES           AGE   VERSION
controlplane   Ready    control-plane   12d   v1.24.0
node01         Ready    <none>          12d   v1.24.0
```


#### Upgrade kubeadm (controlplane)


**Check the existing version**

```bash
root@controlplane:~# kubeadm version -o json
{
  "clientVersion": {
    "major": "1",
    "minor": "24",
    "gitVersion": "v1.24.0",
    "gitCommit": "4ce5a8954017644c5420bae81d72b09b735c21f0",
    "gitTreeState": "clean",
    "buildDate": "2022-05-03T13:44:24Z",
    "goVersion": "go1.18.1",
    "compiler": "gc",
    "platform": "linux/amd64"
  }
}
```

**Check available versions of `kubeadm`**

```bash
root@controlplane:~# sudo apt update
root@controlplane:~# sudo apt-cache madison kubeadm | head -5
   kubeadm |  1.25.3-00 | https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
   kubeadm |  1.25.2-00 | https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
   kubeadm |  1.25.1-00 | https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
   kubeadm |  1.25.0-00 | https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
   kubeadm |  1.24.7-00 | https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
```

**Run an upgrade plan**

```bash
root@controlplane:~# sudo kubeadm upgrade plan
[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[preflight] Running pre-flight checks.
[upgrade] Running cluster health checks
[upgrade] Fetching available versions to upgrade to
[upgrade/versions] Cluster version: v1.24.6
[upgrade/versions] kubeadm version: v1.24.0
I1017 17:46:28.555346   19488 version.go:255] remote version is much newer: v1.25.3; falling back to: stable-1.24
[upgrade/versions] Target version: v1.24.7
[upgrade/versions] Latest version in the v1.24 series: v1.24.7

Components that must be upgraded manually after you have upgraded the control plane with 'kubeadm upgrade apply':
COMPONENT   CURRENT       TARGET
kubelet     2 x v1.24.0   v1.24.7

Upgrade to the latest version in the v1.24 series:

COMPONENT                 CURRENT   TARGET
kube-apiserver            v1.24.6   v1.24.7
kube-controller-manager   v1.24.6   v1.24.7
kube-scheduler            v1.24.6   v1.24.7
kube-proxy                v1.24.6   v1.24.7
CoreDNS                   v1.8.6    v1.8.6
etcd                      3.5.3-0   3.5.3-0

You can now apply the upgrade by executing the following command:

	kubeadm upgrade apply v1.24.7

Note: Before you can perform this upgrade, you have to update kubeadm to v1.24.7.

_____________________________________________________________________


The table below shows the current state of component configs as understood by this version of kubeadm.
Configs that have a "yes" mark in the "MANUAL UPGRADE REQUIRED" column require manual config upgrade or
resetting to kubeadm defaults before a successful upgrade can be performed. The version to manually
upgrade to is denoted in the "PREFERRED VERSION" column.

API GROUP                 CURRENT VERSION   PREFERRED VERSION   MANUAL UPGRADE REQUIRED
kubeproxy.config.k8s.io   v1alpha1          v1alpha1            no
kubelet.config.k8s.io     v1beta1           v1beta1             no
_____________________________________________________________________
```


**Remove hold on kubeadm**

```bash
root@controlplane:~# sudo apt-mark unhold kubeadm
Canceled hold on kubeadm.

root@controlplane:~# sudo apt update -qq && sudo apt install -y kubeadm=1.25.0-00 
The following packages will be upgraded:
  kubeadm
1 upgraded, 0 newly installed, 0 to remove and 24 not upgraded.
Need to get 9213 kB of archives.
After this operation, 578 kB disk space will be freed.
Get:1 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubeadm amd64 1.25.0-00 [9213 kB]
Fetched 9213 kB in 3s (3507 kB/s)
(Reading database ... 64255 files and directories currently installed.)
Preparing to unpack .../kubeadm_1.25.0-00_amd64.deb ...
Unpacking kubeadm (1.25.0-00) over (1.24.0-00) ...
Setting up kubeadm (1.25.0-00) ...

root@controlplane:~# sudo apt-mark hold kubeadm
kubeadm set on hold.
```


**Check the `kubeadm` version afterwards**

```bash
root@controlplane:~# kubeadm version -o json
{
  "clientVersion": {
    "major": "1",
    "minor": "25",
    "gitVersion": "v1.25.0",
    "gitCommit": "a866cbe2e5bbaa01cfd5e969aa3e033f3282a8a2",
    "gitTreeState": "clean",
    "buildDate": "2022-08-23T17:43:25Z",
    "goVersion": "go1.19",
    "compiler": "gc",
    "platform": "linux/amd64"
  }
}
```


#### Upgrade kubeadm (node01)


```bash
root@node01:~# sudo apt-mark unhold kubeadm
Canceled hold on kubeadm.

root@node01:~# sudo apt-mark unhold kubeadm
Canceled hold on kubeadm.
root@node01:~# sudo apt update -qq && sudo apt install -y kubeadm=1.25.0-00
25 packages can be upgraded. Run 'apt list --upgradable' to see them.
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubeadm
1 upgraded, 0 newly installed, 0 to remove and 24 not upgraded.
Need to get 9213 kB of archives.
After this operation, 578 kB disk space will be freed.
Get:1 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubeadm amd64 1.25.0-00 [9213 kB]
Fetched 9213 kB in 1s (10.0 MB/s)
(Reading database ... 64255 files and directories currently installed.)
Preparing to unpack .../kubeadm_1.25.0-00_amd64.deb ...
Unpacking kubeadm (1.25.0-00) over (1.24.0-00) ...
Setting up kubeadm (1.25.0-00) ..

root@node01:~# sudo apt-mark hold kubeadm
kubeadm set on hold.
```

Check the version afterwards

```bash
root@node01:~# kubeadm version -o json
{
  "clientVersion": {
    "major": "1",
    "minor": "25",
    "gitVersion": "v1.25.0",
    "gitCommit": "a866cbe2e5bbaa01cfd5e969aa3e033f3282a8a2",
    "gitTreeState": "clean",
    "buildDate": "2022-08-23T17:43:25Z",
    "goVersion": "go1.19",
    "compiler": "gc",
    "platform": "linux/amd64"
  }
}
```

