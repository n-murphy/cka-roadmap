#!/usr/bin/bash

KUBE_VERSION="1.24.0-00"
DOCKER_VERSION="5:20.10.6~3-0~ubuntu-focal"


function msg () {
  YELLOW=$'\e[1;33m'
  NC=$'\e[0m'

  echo "${YELLOW}$@${NC}"
}


# Not sure if curl is available by default on ubuntu 20.04 distro
msg "installing curl"
sudo apt update -qq
sudo apt install -y -qq curl
command -v curl


# Add Docker’s official GPG key
# complete the rest of the command after curl
# google "install docker ce" if you get stuck
msg "adding Dockers GPG key"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# disable swapoff
msg "disable swap"
sudo swapoff -a

# Update the apt package index
msg "update apt package index"
sudo apt update -qq

# Install packages to allow apt to use a repository over HTTPS
# complete the rest of the command with the packages to install
# google "install docker ce" if you get stuck
msg "install packages to allow apt to use a repository over HTTPS (ca-certificates , apt-transport-https etc)"
sudo apt install -qq -y \
ca-certificates \
apt-transport-https \
gnupg \
lsb-release


# Set up the Docker stable repository
# complete the rest of the command with the repsitory to add
# google "install docker ce" if you get stuck
# TODO switch this out to using the sudo add-apt-repository
msg "setting up docker stable repository"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Add Kubernetes gpg key
# complete the rest of the command after curl
# go to kubernetes.io/docs and search "install kubeadm" if you get stuck
msg "adding K8s GPG key"
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

# Add Kubernetes stable repository
# fill in what goes between the two "EOF" statements
# go to kubernetes.io/docs and search "install kubeadm" if you get stuck
# TODO switch this out to using the sudo add-apt-repository
msg "adding K8s stable repository"
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update the apt package index
msg "update apt package index"
sudo apt update -qq

# Install the 20.10.6 version of Docker Engine - Community
# complete the rest of the command after "apt install"
# google "install docker ce" if you get stuck
msg "installing Docker version $DOCKER_VERSION"
sudo apt install -qq -y docker-ce=${DOCKER_VERSION} docker-ce-cli=${DOCKER_VERSION} containerd.io docker-compose-plugin

# run hello-world to make sure that its working
msg "verify that docker runs successfully"
docker run --rm hello-world

# Install cri-dockerd (otherwise we can't use docker alone as our container runtime)
msg "installing cri-dockerd"
CRI_VERSION=$(curl -s https://api.github.com/repos/Mirantis/cri-dockerd/releases/latest|grep tag_name | cut -d '"' -f 4|sed 's/v//g')
OS="$(lsb_release -d | awk '{print tolower($2)}')-$(lsb_release -c | awk '{print $2}')"
msg "downloading version $CRI_VERSION for $OS"
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/Mirantis/cri-dockerd/releases/latest | grep browser_download_url | grep $OS | awk -F\" '{print $4}')
wget $DOWNLOAD_URL
CRI_DEB_PKG=$(echo $DOWNLOAD_URL | awk -F\/ '{print $NF}')
msg "installing deb package $CRI_DEB_PKG"
sudo dpkg -i $CRI_DEB_PKG

# Check cri-dockerd is installed.
msg "verifying that cri-dockerd was installed successfully"
cri-dockerd --version
systemctl status cri-docker.socket


# Install kubelet, kubeadm and kubectl packages
# complete teh command to install kubelet, kubeadm, and kubectl according to the version environment variable on the first line of this file
msg "installing kubelet=${KUBE_VERSION} kubeadm=${KUBE_VERSION} kubectl=${KUBE_VERSION}"
sudo apt install -y kubelet=${KUBE_VERSION} kubeadm=${KUBE_VERSION} kubectl=${KUBE_VERSION}

# hold at kubeadm, kubectl, kubelet at their current versions
msg "hold at kubeadm, kubectl, kubelet at their current versions"
sudo apt-mark hold kubelet kubeadm kubectl

# download yaml flannel 
msg "downloading flannel yaml configuration"
# sudo wget -O ${HOME}/flannel.yaml "https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"
sudo wget -O ${HOME}/flannel.yaml "https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml"
ls -1 ${HOME}/flannel.yaml
