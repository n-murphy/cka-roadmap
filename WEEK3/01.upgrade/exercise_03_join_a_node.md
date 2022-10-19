Bring up a new node and add the node to an existing cluster
===========================================================


Using multipass I spun up a new instance `node02`

Command:

```bash
multipass launch --name node02 --cpus 2 --mem 2G --disk 8G --cloud-init ./cloud-init.yaml focal
```


I then used the `install-k8s.sh` script from week 01 to do the initial setup but changed version variable to `KUBE_VERSION="1.25.0-00"` 



#### Generate the token and join command

Command:

```bash
kubeadm token create --print-join-command
```

Command Output:

```bash
root@controlplane:~# kubeadm token create --print-join-command
kubeadm join 192.168.64.9:6443 --token vpec41.wdbjsd9xtjjceeyo --discovery-token-ca-cert-hash sha256:f9e286446c9b4d591dfb17fd2a13a8ae1b70d0e4319176cdb0f9f76c80aaad6a
```

#### Add node02 to the cluster

*Note* Because I have containerd and cri-dockerd installed I need to specify the socket that I want to use.

Command:

```bash
kubeadm join 192.168.64.9:6443 --token vpec41.wdbjsd9xtjjceeyo --discovery-token-ca-cert-hash sha256:f9e286446c9b4d591dfb17fd2a13a8ae1b70d0e4319176cdb0f9f76c80aaad6a --cri-socket unix:///var/run/cri-dockerd.sock
```

Command Output:

```bash
root@node02:~# kubeadm join 192.168.64.9:6443 --token vpec41.wdbjsd9xtjjceeyo --discovery-token-ca-cert-hash sha256:f9e286446c9b4d591dfb17fd2a13a8ae1b70d0e4319176cdb0f9f76c80aaad6a --cri-socket unix:///var/run/cri-dockerd.sock
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.

```


#### Check the status of the cluster

```bash
root@controlplane:~# k get nodes
NAME           STATUS     ROLES           AGE   VERSION
controlplane   Ready      control-plane   12d   v1.25.0
node01         Ready      <none>          12d   v1.25.0
node02         NotReady   <none>          9s    v1.25.0

root@controlplane:~# k get nodes
NAME           STATUS   ROLES           AGE     VERSION
controlplane   Ready    control-plane   12d     v1.25.0
node01         Ready    <none>          12d     v1.25.0
node02         Ready    <none>          2m13s   v1.25.0
```

**healthcheck**

```bash
root@controlplane:~# k get --raw='/readyz?verbose'
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