# -*- mode: ruby -*-
# vi: set ft=ruby :

$before_script = <<SCRIPT
 
vag_prof=/etc/profile.d/vagrant.sh
echo export BENCH_HOME=#{ENV['BENCH_HOME']} > $vag_prof
echo export BENCH_NAME=#{ENV['BENCH_NAME']} >> $vag_prof
echo export BENCH_GIT=#{ENV['BENCH_GIT']} >> $vag_prof
echo export MYSQL_ROOT_PWD=#{ENV['MYSQL_ROOT_PWD']} >> $vag_prof
echo export FRAPPE_SITE=#{ENV['FRAPPE_SITE']} >> $vag_prof
echo export FRAPPE_ADMIN_PWD=#{ENV['FRAPPE_ADMIN_PWD']} >> $vag_prof
echo export ERPNEXT_GIT=#{ENV['ERPNEXT_GIT']} >> $vag_prof
echo export APT_INSTALL=#{ENV['APT_INSTALL']} >> $vag_prof

chmod +x $vag_prof
SCRIPT



Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network "forwarded_port", guest: 8000, host: 8080

  config.vm.provider "virtualbox" do |vb|
    # vb.gui = true
    # Customize the amount of memory on the VM:
    vb.memory = "1024"
  end
  
  config.vm.provision :shell, inline: $before_script
  config.vm.provision :shell, path: "bootstrap.sh"
end
