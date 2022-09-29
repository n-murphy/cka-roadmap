KUBE_VERSION=1.24.0

# Add Docker’s official GPG key
# complete the rest of the command after curl
# google "install docker ce" if you get stuck
curl 

# disable swapoff
sudo swapoff -a

# Update the apt package index
sudo apt update

# Install packages to allow apt to use a repository over HTTPS
# complete the rest of the command with the packages to install
# google "install docker ce" if you get stuck
sudo apt install

# Set up the Docker stable repository
# complete the rest of the command with the repsitory to add
# google "install docker ce" if you get stuck
sudo add-apt-repository

# Add Kubernetes gpg key
# complete the rest of the command after curl
# go to kubernetes.io/docs and search "install kubeadm" if you get stuck
curl 

# Add Kubernetes stable repository
# fill in what goes between the two "EOF" statements
# go to kubernetes.io/docs and search "install kubeadm" if you get stuck
cat << EOF 
EOF

# Update the apt package index
sudo apt update

# Install the 20.10.6 version of Docker Engine - Community
# complete the rest of the command after "apt install"
# google "install docker ce" if you get stuck
sudo apt install

# Install kubelet, kubeadm and kubectl packages
# complete teh command to install kubelet, kubeadm, and kubectl according to the version environment variable on the first line of this file
sudo apt install 

# hold at kubeadm, kubectl, kubelet at their current versions
sudo apt-mark hold 

# download yaml flannel 
sudo wget -O ${HOME}/flannel.yaml "https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"