# WEEK 2

## Managing users and access in Kubernetes

### This is week's content is within the cluster architecture, installation & configuration section of the exam curriculum
- [Exam Curriculum](https://github.com/cncf/curriculum/blob/master/CKA_Curriculum_v1.24.pdf)


We'll discover RBAC and how users and service accounts are managed in Kubernetes.

---

## Resources

- [Understanding RBAC - video](https://youtu.be/jvhKOAyD8S8)
- [Complete RBAC understanding - video](https://youtu.be/PSDVanXZ0a4)
- [Creating users and roles](https://killercoda.com/chadmcrowell/scenario/kubernetes-create-user)
- [Access the raw API with curl](https://killercoda.com/chadmcrowell/scenario/kubernetes-access-raw-api)
- [Control service account permissions using RBAC](https://killercoda.com/killer-shell-cka/scenario/rbac-serviceaccount-permissions)
- [Setting user permissions using RBAC](https://killercoda.com/killer-shell-cka/scenario/rbac-user-permissions)


---

## Exercises

1. Create the YAML for a `role` named "pod-reader" that allows users to perform get, watch and list on pods.
2. Create the YAML for a `roleBinding` named "admin-binding", in the namespace "acme", granting permissions for the "admin" ClusterRole to a user named "bob".