ssh govcloud
sudo su
export newuser=maustin
echo $newuser
adduser $newuser
echo "standardhardpass" | passwd $newuser --stdin
mkdir /home/$newuser/.ssh
chmod 700 /home/$newuser/.ssh
chown -R $newuser:$newuser /home/$newuser/.ssh

vim /home/$newuser/.ssh/authorized_keys
chmod 400 /home/$newuser/.ssh/authorized_keys
chown -R $newuser:$newuser /home/$newuser/.ssh

-- Grant sudo
usermod -aG wheel $newuser
