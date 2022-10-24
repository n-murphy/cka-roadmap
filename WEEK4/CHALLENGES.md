### Week 04 Challenges


#### Find where the certificate and key are for etcd in a kubeadm cluster

You can find the etcd related certs by either describing the etcd pod that runs under the `kube-system` namespace or looking directly at the static pod manifest `/etc/kubernetes/manifests/etcd.yaml` Both will show that the certs are located in:

`/etc/kubernetes/pki/etcd`

**Commands:**

```bash
k get po -n kube-system | grep etcd
k describe po -n kube-system etcd-controlplane | grep cert
```

**Commands Output:**

```bash
# Get the name of the etcd pod running in the kube-system namespace.
controlplane $ k get po -n kube-system | grep etcd
etcd-controlplane                          1/1     Running   0          4d23h

# describe the etcd-controlplane pod and lookup the cert information.
controlplane $ k describe po -n kube-system etcd-controlplane | grep cert
      --cert-file=/etc/kubernetes/pki/etcd/server.crt
      --client-cert-auth=true
      --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
      --peer-client-cert-auth=true
      /etc/kubernetes/pki/etcd from etcd-certs (rw)
  etcd-certs:
```


#### Backup etcd and store it in a new data directory (other than the default)

**Commands:**

```bash
export ETCDCTL_API=3
mkdir -p ~/etcd/backup
etcdctl snapshot save ~/etcd/backup/snapshot.db  --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key
etcdctl snapshot status ~/etcd/backup/snapshot.db --write-out=table
```

**Commands Output:**

```bash
controlplane $ export ETCDCTL_API=3
controlplane $ mkdir -p ~/etcd/backup
controlplane $ etcdctl snapshot save ~/etcd/backup/snapshot.db  --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key
{"level":"info","ts":1666537791.448293,"caller":"snapshot/v3_snapshot.go:68","msg":"created temporary db file","path":"/root/etcd/backup/snapshot.db.part"}
{"level":"info","ts":1666537791.4582937,"logger":"client","caller":"v3/maintenance.go:211","msg":"opened snapshot stream; downloading"}
{"level":"info","ts":1666537791.4585278,"caller":"snapshot/v3_snapshot.go:76","msg":"fetching snapshot","endpoint":"127.0.0.1:2379"}
{"level":"info","ts":1666537791.5640168,"logger":"client","caller":"v3/maintenance.go:219","msg":"completed snapshot read; closing"}
{"level":"info","ts":1666537791.5987566,"caller":"snapshot/v3_snapshot.go:91","msg":"fetched snapshot","endpoint":"127.0.0.1:2379","size":"4.4 MB","took":"now"}
{"level":"info","ts":1666537791.5990515,"caller":"snapshot/v3_snapshot.go:100","msg":"saved","path":"/root/etcd/backup/snapshot.db"}
Snapshot saved at /root/etcd/backup/snapshot.db

# Check the status of the snapshot.
controlplane $ etcdctl snapshot status ~/etcd/backup/snapshot.db --write-out=table
Deprecated: Use `etcdutl snapshot status` instead.

+----------+----------+------------+------------+
|   HASH   | REVISION | TOTAL KEYS | TOTAL SIZE |
+----------+----------+------------+------------+
| e0050545 |     3396 |        819 |     4.4 MB |
+----------+----------+------------+------------+
```

#### Find the port that etcd uses

According to the official [docs](https://kubernetes.io/docs/reference/ports-and-protocols/) etcd uses the port range 2379-2380, however looking at the etcd pod running in the `kube-system` namespace you can see that it uses 2381 for metrics as well.


But the main port that etcd runs on is `2379` (based on looking at the `advertise-client-urls` and `listen-client-urls` parameters)

**Commands:**

```bash
k describe po -n kube-system etcd-controlplane
```

#### Find the YAML used to run the etcd pod

As this is a static pod. It's YAML can be found in `/etc/kubernetes/manifests/etcd.yaml`

**Commands:**

```bash
vim /etc/kubernetes/manifests/etcd.yaml
```


#### Restore etcd to a different data directory

Despite being able to successfully restore etcd, it would appear that once an update to its pod yaml is done it ends up in a Pending state, despite this the cluster appears to function successfully (see below for more). The docs mention taking down the api server first but it does describe how you should do this. The only method that I can think of is to move the `kube-apiserver.yaml` from the `/etc/kubernetes/manifests` directory temporarily, perform the restore, update the `etcd.yaml` and then move the `kube-apiserver.yaml` back.


**Commands:**

```bash
etcdctl snapshot restore ~/etcd/backup/snapshot.db --data-dir /var/lib/etcd-restore
vim /etc/kubernetes/manifests/etcd.yaml
# Change line 78 so that it now matches the new data directory specified in the restore.
#  77   - hostPath:
#  78       path: /var/lib/etcd-restore
#  79       type: DirectoryOrCreate
#  80     name: etcd-data

# wait 3 mins
sleep 180

# check what system pods were restarted
k get po -n kube-system | awk 'NR == 1 || $4 > 0 { print $0 }'

# check what system pods are not in a running state
k get po -n kube-system | awk 'NR == 1 || $3 != "Running" { print $0 }'
```

**Commands Output:**

```bash
controlplane $ etcdctl snapshot restore ~/etcd/backup/snapshot.db --data-dir /var/lib/etcd-restore
Deprecated: Use `etcdutl snapshot restore` instead.

2022-10-23T16:02:35Z    info    snapshot/v3_snapshot.go:251     restoring snapshot      {"path": "/root/etcd/backup/snapshot.db", "wal-dir": "/var/lib/etcd-restore/member/wal", "data-dir": "/var/lib/etcd-restore", "snap-dir": "/var/lib/etcd-restore/member/snap", "stack": "go.etcd.io/etcd/etcdutl/v3/snapshot.(*v3Manager).Restore\n\t/tmp/etcd-release-3.5.0/etcd/release/etcd/etcdutl/snapshot/v3_snapshot.go:257\ngo.etcd.io/etcd/etcdutl/v3/etcdutl.SnapshotRestoreCommandFunc\n\t/tmp/etcd-release-3.5.0/etcd/release/etcd/etcdutl/etcdutl/snapshot_command.go:147\ngo.etcd.io/etcd/etcdctl/v3/ctlv3/command.snapshotRestoreCommandFunc\n\t/tmp/etcd-release-3.5.0/etcd/release/etcd/etcdctl/ctlv3/command/snapshot_command.go:128\ngithub.com/spf13/cobra.(*Command).execute\n\t/home/remote/sbatsche/.gvm/pkgsets/go1.16.3/global/pkg/mod/github.com/spf13/cobra@v1.1.3/command.go:856\ngithub.com/spf13/cobra.(*Command).ExecuteC\n\t/home/remote/sbatsche/.gvm/pkgsets/go1.16.3/global/pkg/mod/github.com/spf13/cobra@v1.1.3/command.go:960\ngithub.com/spf13/cobra.(*Command).Execute\n\t/home/remote/sbatsche/.gvm/pkgsets/go1.16.3/global/pkg/mod/github.com/spf13/cobra@v1.1.3/command.go:897\ngo.etcd.io/etcd/etcdctl/v3/ctlv3.Start\n\t/tmp/etcd-release-3.5.0/etcd/release/etcd/etcdctl/ctlv3/ctl.go:107\ngo.etcd.io/etcd/etcdctl/v3/ctlv3.MustStart\n\t/tmp/etcd-release-3.5.0/etcd/release/etcd/etcdctl/ctlv3/ctl.go:111\nmain.main\n\t/tmp/etcd-release-3.5.0/etcd/release/etcd/etcdctl/main.go:59\nruntime.main\n\t/home/remote/sbatsche/.gvm/gos/go1.16.3/src/runtime/proc.go:225"}
2022-10-23T16:02:35Z    info    membership/store.go:119 Trimming membership information from the backend...
2022-10-23T16:02:35Z    info    membership/cluster.go:393       added member    {"cluster-id": "cdf818194e3a8c32", "local-member-id": "0", "added-peer-id": "8e9e05c52164694d", "added-peer-peer-urls": ["http://localhost:2380"]}
2022-10-23T16:02:35Z    info    snapshot/v3_snapshot.go:272     restored snapshot       {"path": "/root/etcd/backup/snapshot.db", "wal-dir": "/var/lib/etcd-restore/member/wal", "data-dir": "/var/lib/etcd-restore", "snap-dir": "/var/lib/etcd-restore/member/snap"}

sleep 180

controlplane $ k get po -n kube-system | awk 'NR == 1 || $4 > 0 { print $0 }'
NAME                                       READY   STATUS    RESTARTS        AGE
calico-kube-controllers-58dbc876ff-hlwfp   1/1     Running   4 (5m18s ago)   5d17h
kube-apiserver-controlplane                1/1     Running   1               5d17h
kube-controller-manager-controlplane       1/1     Running   2 (6m15s ago)   5d17h
kube-scheduler-controlplane                1/1     Running   2 (6m14s ago)   5d17h
controlplane $ 

controlplane $ k get po -n kube-system | awk 'NR == 1 || $3 != "Running" { print $0 }'
NAME                                       READY   STATUS    RESTARTS        AGE
etcd-controlplane                          0/1     Pending   0               5m41s
controlplane $ 
```
