# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANT_API_VERSION = 2

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |vb|
    vb.customize [
      'modifyvm', :id,
      '--memory', (1 * 1024).to_s,
      '--cpus', 1
    ]
  end

  config.vm.define 'dev' do |dev|
    dev.vm.synced_folder 'bridge', '/home/vagrant/bridge'
    dev.vm.hostname = 'dev'
    dev.vm.network 'private_network', ip: '192.168.11.22'
    dev.vm.provision 'shell', path: 'dev-bootstrap.sh'
  end

  config.vm.define 'storage' do |storage|
    storage.vm.hostname = 'storage'
    storage.vm.network 'private_network', ip: '192.168.11.33'
    storage.vm.provision 'shell', path: 'storage-bootstrap.sh'

    storage.vm.provider :virtualbox do |vb|
      vb.customize [
        'modifyvm', :id,
        '--memory', '1024',
        '--cpus', 1
      ]
    end
  end
end
