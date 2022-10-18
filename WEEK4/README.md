# WEEK 4

## Backing up and restoring etcd

### This is week's content is within the cluster architecture, installation & configuration section of the exam curriculum
- [Exam Curriculum](https://github.com/cncf/curriculum/blob/master/CKA_Curriculum_v1.24.pdf)


We'll focus on working with etcd, how to backup and restore it, in order to preserve the Kubernetes cluster configuration.

---

## RESOURCES 

- [RAFT Consensus Algorithm](https://raft.github.io/)
- [VIDEO: Intro to RAFT](https://youtu.be/6bBggO6KN_k)
- [VIDEO: Distributed Consensus via Raft](https://youtu.be/RHDP_KCrjUc)
- [Backup and Restore Practice](https://kodekloud.com/topic/practice-test-backup-and-restore-methods/)
- [Backup and Restore ETCD](https://killercoda.com/chadmcrowell/scenario/kubernetes-backup-etcd)

## CHALLENGES

1. Find where the certificate and key are for etcd in a kubeadm cluster
2. Backup etcd and store it in a new data directory (other than the default)
3. Find the port that etcd uses
4. Find the YAML used to run the etcd pod
5. Restore etcd to a different data directory