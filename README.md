[![Build Status](https://travis-ci.com/darkwizard242/devopsubuntu1804.svg?branch=master)](https://travis-ci.com/darkwizard242/devopsubuntu1804)

## 1. devopsubuntu1804
`devopsubuntu1804` is a Vagrant VM box with underlying base image of Ubuntu 18.04 LTS (bionic). It is created using [Hashicorp Packer](https://www.packer.io/) and is provisioned with multiple DevOps tools, programming/scripting languages and environments pre-installed and pre-configured to be ready to be used instantly after boot up. Tested using [ServerSpec](https://serverspec.org/).

`devopsubuntu1804 Releases`: [Vagrant Cloud URL](https://app.vagrantup.com/darkwizard242/boxes/devopsubuntu1804)

Supported Provider: **VirtualBox**

#### Audience
IT professionals, organizations, enthusiasts or learners with a focus or interest towards CI/CD/CM/Containerization/DevOps.

#### Disclaimer:
It is expected that you have Vagrant and Virtualbox installed on your host machine (whether the host is Windows, Linux or OSX). If not, then please download/install [Vagrant](https://www.vagrantup.com/downloads.html) and [Virtualbox](https://www.virtualbox.org/wiki/Downloads).

## 2. List of Tools and Languages:
 * _Docker_
    * `Docker version 18.06.1-ce, build e68fc7a`
 * _Ansible_
    * `ansible 2.7.1`
 * _Terraform_
    * `terraform 0.12.0`
 * _Jenkins_
    * `Jenkins ver. 2.138.2`
 * _Git_
    * `git version 2.17.1`
 * _Subversion_
    * `subversion x.x.x`
 * _AWS-CLI_
    * `awscli x.x.x`
 * _Azure-CLI_
    * `az x.x.x`
 * _GoogleCloudSDK-CLI_
    * `gcloud x.x.x`
 * _Python_
    * `Python 2.7.15rc1`
    * `Python 3.x.x`
 * _Pip3_
    * `pip x.x.x`
 * _Java_
    * `openjdk version "1.8.0_181"`
 * _Ruby_
    * `ruby x.x.x`
  * _ServerSpec_
    * `serverspec x.x.x`
 * _etc.._
 
All of the tools have been preset to run at boot time using the `init` system, so you don't have to worry about doing that and can instantly get on to working with these awesome tools!


## 3. Virtualizing `devopsubuntu1804` on Vagrant
This section covers easy to use steps to get started with downloading and virtualizing `devopsubuntu1804` virtual environment.

### 3.1. Single Machine Mode:
Single Machine mode is a mode where you will only be initializing a fresh vagrant virtual envrionment to use`devopsubuntu1804`. Open CMD (for **Windows** host) or Terminal (for **Linux/OSX** host), then change to a directory of your liking on the Command Prompt or Terminal and run the following command:

```shell
vagrant init darkwizard242/devopsubuntu1804
```

Now that `Vagrantfile` has been created for `devopsubuntu1804`, you can initialize/boot up the box (it will download the box if not already downloaded) using the following command:

```shell
vagrant up
```

Once the box is up, do `vagrant ssh` and you will be within the virtualized box.

### 3.2. Multi Machine Mode:
As per Vagrant's website, "Vagrant is able to define and control multiple guest machines per Vagrantfile. This is known as a 'multi-machine' environment." So if you are running in a **multi-machine mode**, you can simple add the following chunk within the existing Vagrantfile:

```shell
config.vm.define "mydevopsbox" do |mydevopsbox|
   mydevopsbox.vm.box = "darkwizard242/devopsubuntu1804"
   mydevopsbox.vm.hostname = 'mydevopsbox'
end
```

Now run the following command so that the box can be downloaded (if not already) and be booted up:
```shell
vagrant up mydevopsbox
```

Once the box is up, do `vagrant ssh mydevopsbox` and you will be within the virtualized box.


## 4. Users - for `devopsubuntu1804` Vagrant box
Docker, Ansible and Jenkins each have their own respective system users i.e. `docker` , `ansible` & `jenkins`.

Like any other vagrant box, you can easily ssh into devopsubuntu1804 using the default `vagrant ssh` command and make use of any of the other system level users or application level ones as you like.

### 4.1. Type and list of users and passwords:

Below is table listing the type of users as well as their usernames and passwords:


|          User Type           |                  Username                |              Password              |
|        -------------       |                  -------------           |               -------------       |
|           System User        |                    vagrant               |                 password           |
|           System User        |                    root                  |                 password           |
|           System User        |                    docker                |                 password           |
|           System User        |                    ansible               |                 password           |
|           System User        |                    jenkins               |                 password           |
|Jenkins Web-Application Console|                    admin                |                 stored in ( `/var/lib/jenkins/secrets/initialAdminPassword` )              |


**NOTE:** _Though, the passwords for all of the users have been set by default by me so that anyone can use them easily. I would highly recommend to change the passwords of system level users via `root` user using the following commands:_

 * `passwd vagrant`
 * `passwd root`
 * `passwd docker`
 * `passwd ansible`
 * `passwd jenkins`
 
### 4.2. Users and permissions:


Following users have already been added as **sudoers** with privileges to perform desired operations without supplying passwords:

```shell
root@devopsubuntu1804:~# egrep -w 'ansible|docker|vagrant|jenkins' /etc/sudoers
vagrant ALL=(ALL) NOPASSWD: ALL
ansible ALL=(ALL) NOPASSWD: ALL
docker  ALL=(ALL) NOPASSWD: ALL
jenkins ALL=(ALL) NOPASSWD: ALL
```

### 4.3. Users and home directories:

Following table consists the system **users** and their `$HOME` directories.

|          User                |            Home Directory                |
|        :-------------       |                  :-------------         |
|           root               |                    /root                 |
|           vagrant            |                    /home/vagrant         |
|           ansible            |                    /home/ansible         |
|           docker             |                    /home/docker          |
|           jenkins            |                    /var/lib/jenkins      |


## 5. `devopsubuntu1804` Build & Testing:
Vagrant box `devopsubuntu1804` can be built using Packer. Pre-requisites include Virtualbox as that is the builder being used for the packer build.

### 5.1. Building out your own customized `devopsubuntu1804`: 
Assuming that Virtualbox and Packer are installed on the host system with internet accessibility, you can build `devopsubuntu1804` yourself using the following steps:

1. Downloading **devopsubuntu1804** source code archive: `curl -Lo devopsubuntu1804.zip https://github.com/darkwizard242/devopsubuntu1804/archive/master.zip`
1. Extracting **devopsubuntu1804** source code archive: `unzip devopsubuntu1804.zip -d devopsubuntu1804`
1. Changing to packer build directory: `cd devopsubuntu1804/devopsubuntu1804-master/`
1. Running Packer build: `packer build devopsubuntu1804.json`

### 5.2. Testing `devopsubuntu1804` box:
*ServerSpec* is used for the purpose of testing _devopsubuntu1804_ box as the last phase in the packer build.
You may customize the test cases to meet your needs.

Test report for `devopsubuntu1804`:
```ruby

```

## 6. Initializing your customized version of `devopsubuntu1804` Build:
Once you have built out a `devopsubuntu1804` box. You can easily test it out by adding it as vagrant box using the following commands:

1. `vagrant box add mydevopubuntu1804box` /path/to/devopubuntu1804.box - This command will add the newly built customized devopsubuntu1804 box to vagrant so that it can be used. It would be wise to use the exact path to the devopsubuntu1804 box you have built.

2. `vagrant init mydevopubuntu1804box` - This command will initialize the box you have associated your vagrant image with.

3. `vagrant up mydevopsubuntu1804box` - Boots up the box.


## Acknowledgements:
 * [Packer](https://www.packer.io/)
 * [Vagrant](https://www.vagrantup.com/)
 * [Ubuntu](https://www.ubuntu.com/)
 * [ServerSpec](https://serverspec.org/)

## Authors:
 * [Ali Muhammad](https://www.linkedin.com/in/ali-muhammad-759791130/)