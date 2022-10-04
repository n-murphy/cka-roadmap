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

if (( $? == 0 )) ; then
  msg "cluster initialization was successful applying the flannel configuration"
  # apply the pod network
  kubectl apply -f ${HOME}/flannel.yaml
fi
