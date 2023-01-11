# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  :"mda" => {
    :box_name => "alvistack/centos-8-stream",
    :box_version => "20221224.1.1",
    :cpus => 4,
    :memory => 2048,
    :disks => {
      :sata1 => {:dfile=>'./sata1.vdi', :size => 250, :port => 1},
      :sata2 => {:dfile=>'./sata2.vdi', :size => 250, :port => 2},
      :sata3 => {:dfile=>'./sata3.vdi', :size => 250, :port => 3},
      :sata4 => {:dfile=>'./sata4.vdi', :size => 250, :port => 4},
    }
  }
}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

    config.vm.synced_folder ".", "/vagrant", disabled: true

    config.vm.define boxname do |box|

      box.vm.box = boxconfig[:box_name]
      box.vm.box_version = boxconfig[:box_version]
      box.vm.host_name = boxname.to_s

      box.vm.provider "virtualbox" do |v|
        v.memory = boxconfig[:memory]
        v.cpus = boxconfig[:cpus]
        
        need_controller = false
        boxconfig[:disks].each do |dname, dconf|
          unless File.exist?(dconf[:dfile])
            v.customize ["createhd", "--filename", dconf[:dfile], "--variant", "Fixed", "--size", dconf[:size]]
            need_controller = true
          end

        end
        
        if need_controller 
          v.customize ["storagectl", :id, "--name", "SATA", "--add", "sata"]
          boxconfig[:disks].each do |dname, dconf|
            v.customize ["storageattach", :id, "--storagectl", "SATA", "--port", dconf[:port], "--device", 0, "--type", "hdd", "--medium", dconf[:dfile]]
          end
        end
      end
      
      box.vm.provision "packages", type: "shell", inline: <<-SHELL
        mkdir -p ~root/.ssh
        cp ~vagrant/.ssh/auth* ~root/.ssh
        yum install -y mdadm smartmontools hdparm gdisk
      SHELL

      box.vm.provision "raid1", type: "shell", inline: <<-SHELL
        mdadm --zero-superblock --force /dev/sd{b,c,d,e}
        mdadm --create --verbose /dev/md0 --level=raid1 --raid-devices=4 --size=max /dev/sd{b,c,d,e}
        cat /proc/mdstat
      SHELL

    end
  end
end

