#!/usr/bin/bash


function msg () {
  YELLOW=$'\e[1;33m'
  NC=$'\e[0m'

  echo "${YELLOW}$@${NC}"
}


if (( $# != 1 )) ; then
  msg "usage: $(basename $0) IP_ADDRESS"
  echo "You can get the ip address of the controlplane node by running:"
  msg "ip addr"
  exit 1
else
  IP_ADDR=$1
fi

# TODO probably want to check that kubeadm is installed first command -v kubeadm etc!
msg "initializing the cluster"
kubeadm init --apiserver-advertise-address $IP_ADDR --apiserver-cert-extra-sans controlplane --pod-network-cidr 10.244.0.0/16

# For testing on killercoda due to resource limitations and socket conflicts ie more than one to choose from you need to add:
# --cri-socket unix:///var/run/cri-dockerd.sock (as docker.sock already exists)
# --ignore-preflight-errors=NumCPU (Only 1 CPU available so need to turn this off.)
#kubeadm init --apiserver-advertise-address $IP_ADDR --apiserver-cert-extra-sans controlplane --pod-network-cidr 10.244.0.0/16 --cri-socket unix:///var/run/cri-dockerd.sock --ignore-preflight-errors=NumCPU

if (( $? == 0 )) ; then
  msg "cluster initialization was successful proceeding with setting up config for using kubectl"
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  # apply the pod network
  msg "applying the flannel configuration"
  kubectl apply -f ${HOME}/flannel.yaml
  # check the cluster
  kubectl cluster-info
  kubectl get all -A
fi
