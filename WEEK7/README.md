# WEEK 7

## Pod-to-Pod communication, ingress, and services in Kubernetes

### This is week's content is within the services & networking section of the exam curriculum
- [Exam Curriculum](https://github.com/cncf/curriculum/blob/master/CKA_Curriculum_v1.24.pdf)

We'll focus on communication inside the cluster, as well as providing entry into the application from outside using ingress. In communicating inside the cluster, we'll discover DNS and how it's used to simplify routing

### RESOURCES

- [VIDEO: Life of a packet](https://youtu.be/0Omvgd7Hg1I)
- [VIDEO: Services Explained](https://youtu.be/T4Z7visMM4E)
- [VIDEO: Services In-Depth](https://youtu.be/5lzUpDtmWgM)
- [VIDEO: Ingress For Begineers](https://youtu.be/80Ew_fsV4rM)
- [VIDEO: Ingress Explained](https://youtu.be/GhZi4DxaxxE)
- [VIDEO: What is CNI and Cilim Intro](https://youtu.be/LF-itMcCkWs)
- [VIDEO: Networking 101 - Kubecon Talk](https://youtu.be/cUGXu2tiZMc)
- [VIDEO: Understanding CoreDNS](https://youtu.be/qRiLmLACYSY)
- [VIDEO: CoreDNS Deep Dive](https://youtu.be/rNlSgYZoIYs)
- [VIDEO: Troubleshoot DNS](https://youtu.be/9ONo0VvL14A)
### CHALLENGES

1. Start a new container and look at the resolv.conf file to ensure it's pointing to the correct DNS service
2. Change the DNS coniguration in the cluster by changing the CIDR range from 10.96.0.0/16 to 100.96.0.0/16. Next, change the IP address associated with the cluster DNS service to match this new service range. 
3. Change the kubelet configuration, so that new pods can receive the new DNS service IP address, and so they can resolve domain names. Edit the kubelet config map, so that kubelet is updated in place and immediately reflected. Upgrade the node to receive the new kubelet configuration. 
4. Install an ingress controller to proxy communication into the cluster via an ingress resource. Then, create a deployment named “hello” using the image “nginxdemos/hello:plain-text”. The container is exposed on port 80. 
5. Create a service named “hello-svc” that targets the “hello” deployment on port 80. Then, create an ingress resource that will allow you to resolve the dns name hello.com to the ClusterIP service named “hello-svc” in Kubernetes. 