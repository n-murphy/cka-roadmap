#### 1. Start a new container and look at the resolv.conf file to ensure it's pointing to the correct DNS service

##### Commands

```bash

```

##### Commands Output

```bash

```


#### 2. Change the DNS coniguration in the cluster by changing the CIDR range from 10.96.0.0/16 to 100.96.0.0/16. Next, change the IP address associated with the cluster DNS service to match this new service range. 

##### Commands

```bash

```

##### Commands Output

```bash

```


#### 3. Change the kubelet configuration, so that new pods can receive the new DNS service IP address, and so they can resolve domain names. Edit the kubelet config map, so that kubelet is updated in place and immediately reflected. Upgrade the node to receive the new kubelet configuration. 

##### Commands

```bash

```

##### Commands Output

```bash

```


#### 4. Install an ingress controller to proxy communication into the cluster via an ingress resource. Then, create a deployment named “hello” using the image “nginxdemos/hello:plain-text”. The container is exposed on port 80. 

##### Commands

```bash

```

##### Commands Output

```bash

```


#### 5. Create a service named “hello-svc” that targets the “hello” deployment on port 80. Then, create an ingress resource that will allow you to resolve the dns name hello.com to the ClusterIP service named “hello-svc” in Kubernetes.

##### Commands

```bash

```

##### Commands Output

```bash

```

