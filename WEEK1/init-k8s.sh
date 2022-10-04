#!/usr/bin/bash


if (( $# != 1 )) ; then
  echo "usage: $(basename $0) IP_ADDRESS"
  exit 1
else
  IP_ADDR=$1
fi

kubeadm init --apiserver-advertise-address $IP_ADDR --apiserver-cert-extra-sans controlplane --pod-network-cidr 10.244.0.0/16

if (( $? == 0 )) ; then
  # apply the pod network
  kubectl apply -f ${HOME}/flannel.yaml
fi
