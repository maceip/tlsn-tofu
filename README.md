<p align="center">
    <img src="./tlsn-banner.png" width=1280 />
</p>

<p align="center">
<b>One-click Trusted Execution Environment For TLSNotary</b>
    <br>
    ⚠️ not for production ⚠️ 
</p>  

tlsn-tofu was born as a reference for simple and secure infra for tlsnotary to leverage secure enclaves, and to demonstrate how to use their most important (and complex) feature: remote attestation!

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

#### 4) install ansible and the terraform extension:
- mac:
```
brew update && brew install ansible && ansible-galaxy collection install cloud.terraform
```
- debian/ubuntu linux:
```
sudo apt-add-repository ppa:ansible/ansible && sudo apt update && sudo apt install ansible && ansible-galaxy collection install cloud.terraform
```

#### 5) configure tofo:
this will create an azure resource group, a vm suitable for SGX, an azure vault, and an SSH key:
```
tofu init && tofu plan && tofu apply
```
if all is well, tofu will ask you to confirm:<br>


<p align="center">
    <img src="./tofu_plan.png" width=476 />
</p>

type yes and hit enter

#### 6) run ansible:
this will configure the vm created above:
```
ansible-playbook -i inventory.yml playbook.yml
```

#### 7) tear it down:

```
tofu destroy
```

#### 8) confetti: 🎉you just ran a tlsnotary verifier inside a TEE!🎉

<h3>Notes</h3>

-  This repo utilizes open tofu to provision TEE capable hardware across various cloud providers. Currently, it only supports a single notary running inside SGX via Gramine on Azure. 

-  The hardware is configured with Ansible, and sets up SGX Remote Attestation (DCAP /w ECDSA), a Provisioning Certificate Caching Service, and a development gramine key.

-  inspect the cloud configuration via:
   - ```tofu show```
-  to see the ansible-host that tofu created, run:
   - ```ansible-playbook -i inventory.yml playbook.yml   --list-hosts```

###### tofu creates a ssh key in ```~/.ssh/${var.resource_group_name_prefix}-sshkey.pem"```. This key is deleted when you use tofu destroy!
