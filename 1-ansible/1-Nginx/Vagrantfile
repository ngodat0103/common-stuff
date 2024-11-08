Vagrant.configure("2") do |config|
  # Define the base box
  config.vm.box = "ubuntu/jammy64"

  # Provision script to install Kubernetes Python library
  provision_script = <<-SCRIPT
    sudo apt-get update
    sudo apt-get install -y
  SCRIPT

  # Define the first VM (master)
  config.vm.define "test-vm" do |master|
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: "192.168.56.10", name: "vboxnet0"
    master.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 2
    end
    master.vm.provision "shell", inline: provision_script
  end
end