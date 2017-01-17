Attempt to bootstrap my mac laptop with ansible, this also has evolved into bootstrapping my work machine pretty much

```bash
bash -xec "$(curl -L https://raw.githubusercontent.com/limed/ansible-laptop/master/bootstrap.sh)"
ansible-playbook -i ansible-home/bootstrap.yml
```
