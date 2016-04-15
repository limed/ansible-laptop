Attempt to bootstrap my mac laptop with ansible

```bash
bash -xec "$(curl -L https://raw.githubusercontent.com/limed/ansible-laptop/master/bootstrap.sh)"
ansible-playbook -i ansible-home/bootstrap.yml
```
