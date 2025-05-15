#!/bin/bash


apt-get -y update
apt-get -y upgrade

apt install -y curl gnupg2 ca-certificates lsb-release apt-transport-https curl software-properties-common vim git screen wget iproute2 net-tools


set -e

USER_NAME="xxx"
USER_SHELL="/bin/bash"
SSH_PUB_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPn+zg/1q3RHRwXWQSeO9fLs2BUhAc2ux4GztJjwpUlZ xxx@gmail.com"
ENABLE_SUDO_NOPASSWD=true 


echo "add user $USER_NAME"
useradd -m -s $USER_SHELL "$USER_NAME"


SSH_DIR="/home/$USER_NAME/.ssh"
mkdir -p "$SSH_DIR"
echo "$SSH_PUB_KEY" > "$SSH_DIR/authorized_keys"
chmod 700 "$SSH_DIR"
chmod 600 "$SSH_DIR/authorized_keys"
chown -R "$USER_NAME:$USER_NAME" "/home/$USER_NAME"

apt-get update -qq
apt-get install -y sudo

usermod -aG sudo "$USER_NAME"

if [ "$ENABLE_SUDO_NOPASSWD" = true ]; then
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$USER_NAME"
    chmod 440 "/etc/sudoers.d/$USER_NAME"
fi


SSHD_CONFIG="/etc/ssh/sshd_config"

sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' $SSHD_CONFIG
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' $SSHD_CONFIG
sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' $SSHD_CONFIG
sed -i 's/^#\?StrictModes.*/StrictModes yes/' $SSHD_CONFIG


systemctl restart sshd

sudo apt install -y nftables 
sudo systemctl enable --now nftables

sudo bash -c 'cat > /etc/nftables.conf' <<'EOF'
table inet filter {
  chain input {
    type filter hook input priority 0;
    policy drop;
    ct state established,related accept
    iif "lo" accept
    tcp dport {22,443,80} accept
  }
  chain forward { type filter hook forward priority 0; policy drop; }
  chain output { type filter hook output priority 0; policy accept; }
}
EOF


sudo nft flush ruleset 
sudo nft -f /etc/nftables.conf 
sudo systemctl restart nftables.service


sudo systemctl disable --now iptables
sudo systemctl disable --now netfilter-persistent
sudo apt remove -y iptables-persistent netfilter-persistent
sudo systemctl disable --now ufw
sudo apt remove -y ufw
sudo systemctl disable --now firewalld
sudo apt remove -y firewalld
