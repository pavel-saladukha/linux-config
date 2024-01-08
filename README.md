Run scripts
```
sudo bash 01_root.sh > root.txt 2>&1
bash 02_user.sh > user.txt 2>&1

reboot

bash 03_leftovers.sh
```