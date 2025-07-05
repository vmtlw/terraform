### Быстрый старт:

```bash
git clone https://github.com/vmtlw/terraform && cd terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
apt update && sudo apt upgrade -y
apt install -y curl gnupg terraform libvirt-daemon-system
teterraform -version
wget -O /tmp/debian-12.qcow2 https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2
terraform init
terraform validate
terraform output -json > ips.json
systemctl disable --now apparmor ## для применения изменений уходим в reboot
systemctl enable --now libvirtd 
terraform apply -auto-approve
```

### Удалить созданное хозяйство:
```
terraform destroy -auto-approve
for vm in k8s-0 k8s-1 k8s-2 k8s-3
do
  virsh destroy $vm
  virsh undefine $vm
  rm /var/lib/libvirt/images/$vm.qcow2
done

  rm /var/lib/libvirt/images/cloudinit-*
```
