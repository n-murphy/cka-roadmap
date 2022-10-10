# WEEK 3

## Using kubeadm to upgrade a cluster and add nodes

### This is week's content is within the cluster architecture, installation & configuration section of the exam curriculum
- [Exam Curriculum](https://github.com/cncf/curriculum/blob/master/CKA_Curriculum_v1.24.pdf)

We'll discover using kubeadm as a multi-purpose tool, including upgrading control plane components and adding nodes to an existing cluster.

---

## Resources

- [Upgrading Kubeadm clusters](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)
- [kubeadm join command](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-join/)
- [joining nodes to a cluster](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#join-nodes)
- [add node to existing cluster](https://www.golinuxcloud.com/kubernetes-add-node-to-existing-cluster/)


---

## Exercises

1. Upgrade kubeadm to version 1.25.0 on all nodes in the cluster
2. Upgrade the version of api, scheduler, controller manager and etcd to 1.25.0.
3. Bring up a new node and add the node to an existing cluster