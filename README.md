<p align="center">
    <img src="./tlsn-banner.png" width=1280 />
</p>

<p align="center">
<b>One-click Trusted Execution Environment For TLSNotary</b>
</p>  

### quick start:

clone this repo; cd into it, then: 
#### 1) install azure cli:
- mac:
```
brew update && brew install azure-cli
```
- linux:
```
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

#### 2) login to azure:
 ```az login```
#### 3) install open tofu:

```
chmod +x ./install_tofu.sh && bash ./install_tofu.sh
```
#### 4) tofu magic:
```
tofu plan && tofu apply
```
#### 5) install ansible:
- mac:
```
brew update && brew install ansible
```
- debian/ubuntu linux:
```
sudo apt-add-repository ppa:ansible/ansible && sudo apt update && sudo apt install ansible```
```
#### 6) ansible magic:

```
ansible-playbook -vvv -i inventory.yml playbook.yml
```

#### 7) tear it down:

```
tofu destroy
```

#### 8) confetti: 🎉you just ran code inside a TEE!🎉

<h3>Notes</h3>

-  This repo utilizes open tofu to provision TEE capable hardware across various cloud providers. Currently, it only supports a single notary running inside SGX via Gramine on Azure. 

-  The hardware is configured with Ansible, and sets up SGX Remote Attestation (DCAP /w ECDSA), a Provisioning Certificate Caching Service, and a development gramine key.

-  inspect the cloud configuration via:
   - ```tofu show```
-  to see the ansible-host that tofu created, run:
   - ```ansible-playbook -i inventory.yml playbook.yml   --list-hosts```

###### tofu creates a ssh key in ```~/.ssh/${var.resource_group_name_prefix}-sshkey.pem"```. This key is not removed when you use tofu destroy, but it will be rotated automatically.
