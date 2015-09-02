# ERPNext dev environment using Vagrant: #

1. Clone this repo into a local folder with `git clone https://github.com/frappe/erpnext_vagrant.git erpnext_vagrant`
2. Start your virtual machine by running `vagrant up`
3. Connect to your guest system via SSH with `vagrant ssh`
4. Set `"developer_mode": 1` in `/home/vagrant/erpnext-bench/sites/erpnext.local/site_config.json`
5. Go to your erpnext-bench folder with `cd /home/vagrant/erpnext-bench/` and start bench with `bench start`
6. Open your browser on your host system and work on your ERPNExt by browsing to `http://localhost:8080/` or `http://127.0.0.1:8080`

## vagrant up/provision with parameters


### Environment variables which affects vagrant up/provision:

| ENV variable  |     default   |
| ------------- | ------------- |
| BENCH_HOME | /home/vagrant |
| BENCH_NAME | erpnext-bench |
| BENCH_GIT |  https://github.com/frappe/bench |
| MYSQL_ROOT_PWD | root |
|  FRAPPE_SITE | erpnext.local |
| FRAPPE_ADMIN_PWD | admin |
| ERPNEXT_GIT |  https://github.com/frappe/erpnext.git |
| APT_INSTALL | yes |


### Example: using erpnext git repository, no apt-get install:

    ERPNEXT_GIT=https://github.com/hernad/erpnext.git APT_INSTALL=no vagrant provision


# Installing prerequisites under Windows: #

1. Download and install **Virtual Box**. Attention! There are known problems with VirtualBox 5.0.2 on Windows 10 hosts and with Windows 10 guests. Some of the problems are fixed in the most recent test build which can be found at https://www.virtualbox.org/wiki/Testbuilds.
2. Download and install **Vagrant** for Windows https://www.vagrantup.com/downloads.html
3. Download and install **GitHub Desktop** for Windows at https://desktop.github.com/
4. From now on use **Git Shell** (on your Desktop) to run all commands since it supports some Linux commands natively, most importantly SSH. This means you won't have to install and set up Putty.
5. (Optional) Install a good text editor such as **Atom** at https://atom.io/


