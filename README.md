<p align="center">
    <img src="./tlsn-banner.png" width=1280 />
</p>

<center><h2>One-click Trusted Execution Environment For TLSNotary</h2></center>
  

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
#### 7) confetti: 🎉you just ran code inside a TEE!🎉

