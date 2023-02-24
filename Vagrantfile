# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  :"awesomeVM" => {
    :box_name => "alvistack/centos-8-stream",
    :box_version => "20221224.1.1",
    :cpus => 4,
    :memory => 2048,
  }
}

Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: true

  MACHINES.each do |machine_name, machine_config|

    config.vm.define machine_name do |box|

      box.vm.box = machine_config[:box_name]
      box.vm.box_version = machine_config[:box_version]
      box.vm.host_name = machine_name.to_s

      box.vm.provider "virtualbox" do |v|
        v.name = machine_name.to_s
        v.memory = machine_config[:memory]
        v.cpus = machine_config[:cpus]

        box.vm.provision "packages", type: "shell", path: "scripts/01_test.sh"
        box.vm.provision "watchlog service", type: "shell", path: "scripts/02_watchlog.sh"
      end
    end
  end
end

