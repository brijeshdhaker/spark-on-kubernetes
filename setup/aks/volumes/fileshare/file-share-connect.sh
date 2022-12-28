sudo mkdir -p /mnt/azure-file-share
if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir -p /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/csg100320025a786393.cred" ]; then
    sudo bash -c 'echo "username=csg100320025a786393" >> /etc/smbcredentials/csg100320025a786393.cred'
    sudo bash -c 'echo "password=QjhwrUQ1gcQhebsYoIPmQONO8s2vD/rJy4NNxwMfI4zz9ENeGusZNbZFIshgxEaCJ4QRJ3VqAShD+AStXMEfrw==" >> /etc/smbcredentials/csg100320025a786393.cred'
fi
sudo chmod 600 /etc/smbcredentials/csg100320025a786393.cred

# sudo bash -c 'echo "//csg100320025a786393.file.core.windows.net/azure-file-share /mnt/azure-file-share cifs nofail,credentials=/etc/smbcredentials/csg100320025a786393.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30,vers=3.1.1,sec=ntlmssp" >> /etc/fstab'
sudo mount -t cifs //csg100320025a786393.file.core.windows.net/azure-file-share /mnt/azure-file-share -o credentials=/etc/smbcredentials/csg100320025a786393.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30,vers=3.1.1,sec=ntlmssp