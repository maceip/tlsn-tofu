<h1>one-click Trusted Execution Environment for TLSNotary verifiers</h1>

#quick start
install azure cli, run ```az login```
then
```
chmod +x ./install_tofu.sh
./install_tofu.sh
```
then
```
tofu plan
tofu apply
```
then 
```
ansible-playbook -vvv -i inventory.yml playbook.yml
```

