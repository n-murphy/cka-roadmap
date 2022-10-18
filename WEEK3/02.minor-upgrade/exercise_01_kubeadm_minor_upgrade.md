Perform a minor upgrade from 1.25.0-00 to 1.25.1-00
===================================================


**Get the current cluster nodes:**

Commands:

```bash
k get nodes
```

Commands Output:

```bash
root@controlplane:~# k get nodes
NAME           STATUS   ROLES           AGE   VERSION
controlplane   Ready    control-plane   12d   v1.25.0
node01         Ready    <none>          12d   v1.25.0
node02         Ready    <none>          13h   v1.25.0
```



#### Upgrade kubeadm (controlplane)


**Check the existing version**

Commands:

Commands Output:

```bash
kubeadm version -o json
```


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

**Check available versions of `kubeadm`**

Commands:

```bash
sudo apt update -qq
sudo apt-cache madison kubeadm | head -5
```


```bash
root@controlplane:~# sudo apt update -qq
10 packages can be upgraded. Run 'apt list --upgradable' to see them.
root@controlplane:~# sudo apt-cache madison kubeadm | head -5
   kubeadm |  1.25.3-00 | https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
   kubeadm |  1.25.2-00 | https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
   kubeadm |  1.25.1-00 | https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
   kubeadm |  1.25.0-00 | https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
   kubeadm |  1.24.7-00 | https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
```

**Run an upgrade plan**

Commands:

```bash
sudo kubeadm upgrade plan v1.25.1
```


Commands Output:

```bash
root@controlplane:~# sudo kubeadm upgrade plan v1.25.1
[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[preflight] Running pre-flight checks.
[upgrade] Running cluster health checks
[upgrade] Fetching available versions to upgrade to
[upgrade/versions] Cluster version: v1.25.0
[upgrade/versions] kubeadm version: v1.25.0
[upgrade/versions] Target version: v1.25.1
[upgrade/versions] Latest version in the v1.25 series: v1.25.1

Components that must be upgraded manually after you have upgraded the control plane with 'kubeadm upgrade apply':
COMPONENT   CURRENT       TARGET
kubelet     3 x v1.25.0   v1.25.1

Upgrade to the latest version in the v1.25 series:

COMPONENT                 CURRENT   TARGET
kube-apiserver            v1.25.0   v1.25.1
kube-controller-manager   v1.25.0   v1.25.1
kube-scheduler            v1.25.0   v1.25.1
kube-proxy                v1.25.0   v1.25.1
CoreDNS                   v1.9.3    v1.9.3
etcd                      3.5.4-0   3.5.4-0

You can now apply the upgrade by executing the following command:

	kubeadm upgrade apply v1.25.1

Note: Before you can perform this upgrade, you have to update kubeadm to v1.25.1.


The table below shows the current state of component configs as understood by this version of kubeadm.
Configs that have a "yes" mark in the "MANUAL UPGRADE REQUIRED" column require manual config upgrade or
resetting to kubeadm defaults before a successful upgrade can be performed. The version to manually
upgrade to is denoted in the "PREFERRED VERSION" column.

API GROUP                 CURRENT VERSION   PREFERRED VERSION   MANUAL UPGRADE REQUIRED
kubeproxy.config.k8s.io   v1alpha1          v1alpha1            no
kubelet.config.k8s.io     v1beta1           v1beta1             no
```


**Remove hold on kubeadm and upgrade**

Commands:

```bash
sudo apt-mark unhold kubeadm
sudo apt update -qq && sudo apt install -y kubeadm=1.25.1-00
sudo apt-mark hold kubeadm
```

Commands Output:


```bash
root@controlplane:~# sudo apt-mark unhold kubeadm
Canceled hold on kubeadm.

root@controlplane:~# sudo apt update -qq && sudo apt install -y kubeadm=1.25.1-00
10 packages can be upgraded. Run 'apt list --upgradable' to see them.
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubeadm
1 upgraded, 0 newly installed, 0 to remove and 9 not upgraded.
Need to get 9215 kB of archives.
After this operation, 8192 B of additional disk space will be used.
Get:1 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubeadm amd64 1.25.1-00 [9215 kB]
Fetched 9215 kB in 2s (5924 kB/s)
(Reading database ... 95325 files and directories currently installed.)
Preparing to unpack .../kubeadm_1.25.1-00_amd64.deb ...
Unpacking kubeadm (1.25.1-00) over (1.25.0-00) ...
Setting up kubeadm (1.25.1-00) ...
root@controlplane:~#

root@controlplane:~# sudo apt-mark hold kubeadm
kubeadm set on hold.
```


**Check the `kubeadm` version **

Command:

```bash
kubeadm version -o json
```


Command Output:


```bash
{
  "clientVersion": {
    "major": "1",
    "minor": "25",
    "gitVersion": "v1.25.1",
    "gitCommit": "e4d4e1ab7cf1bf15273ef97303551b279f0920a9",
    "gitTreeState": "clean",
    "buildDate": "2022-09-14T19:47:53Z",
    "goVersion": "go1.19.1",
    "compiler": "gc",
    "platform": "linux/amd64"
  }
}
```


#### Upgrade kubeadm (node01)

Commands:

```bash
sudo apt-mark unhold kubeadm
sudo apt update -qq && sudo apt install -y kubeadm=1.25.1-00
sudo apt-mark hold kubeadm
```


Commands Output:

```bash
root@node01:~# sudo apt-mark unhold kubeadm
Canceled hold on kubeadm.
root@node01:~# sudo apt update -qq && sudo apt install -y kubeadm=1.25.1-00
9 packages can be upgraded. Run 'apt list --upgradable' to see them.
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubeadm
1 upgraded, 0 newly installed, 0 to remove and 8 not upgraded.
Need to get 9215 kB of archives.
After this operation, 8192 B of additional disk space will be used.
Get:1 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubeadm amd64 1.25.1-00 [9215 kB]
Fetched 9215 kB in 2s (4494 kB/s)
(Reading database ... 95325 files and directories currently installed.)
Preparing to unpack .../kubeadm_1.25.1-00_amd64.deb ...
Unpacking kubeadm (1.25.1-00) over (1.25.0-00) ...
Setting up kubeadm (1.25.1-00) ...
root@node01:~# sudo apt-mark hold kubeadm
kubeadm set on hold.
```

**Check the version afterwards**

Commands:

```bash
kubeadm version -o json
```

Commands Output:

```bash
{
  "clientVersion": {
    "major": "1",
    "minor": "25",
    "gitVersion": "v1.25.1",
    "gitCommit": "e4d4e1ab7cf1bf15273ef97303551b279f0920a9",
    "gitTreeState": "clean",
    "buildDate": "2022-09-14T19:47:53Z",
    "goVersion": "go1.19.1",
    "compiler": "gc",
    "platform": "linux/amd64"
  }
}
```

