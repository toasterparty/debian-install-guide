# Automated Setup Script

## Script Prerequisites

1. Boot into the OS and login with your user credentials created during installation.

2. Give yourself permission to use `sudo` commands using the root password created during installation.

```sh
su - -c 'usermod -aG sudo $(logname) && apt install -y sudo'
exit
```

You will be prompted to log back in afterwards.


3. Download and run the configuration script from this repository:

```sh
sudo apt install -y wget
wget -N https://toasterparty.github.io/debian-setup-guide/configure.sh
chmod +x configure.sh
./configure.sh
```
