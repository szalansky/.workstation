# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |vb|
    vb.customize [
      'modifyvm', :id,
      '--memory', (1 * 1024).to_s,
      '--cpus', 1
    ]
  end

  config.vm.define 'default' do |default|
    default.vm.synced_folder 'bridge', '/home/vagrant/bridge'
    default.vm.hostname = 'dev'
    default.vm.network 'private_network', ip: '192.168.11.22'
  end
end
