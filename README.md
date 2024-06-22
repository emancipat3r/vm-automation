# VM Automation Repository 
This repository started as a result of wanting to learn how to automate the process of creating a cybersecurity range similar to how [GOAD](https://github.com/Orange-Cyberdefense/GOAD) works. Generally, GOAD uses Vagrant to build the VMs and Ansible to configure them. One of the goals of this project is to add the ability to create custom images with Packer, for later use with Vagrant. This approach provides more control over the integrity and configuration of the images rather than placing blind trust in the integrity of the images on Hashicorp's cloud.

## Project Structure

### packer/
Contains all Packer-related files including templates and configuration files. Packer is used to create base images from ISO files.

- `http/`: Directory for HTTP files required during the installation process (e.g., kickstart and preseed files).
  - `ks.cfg`: Kickstart configuration file for automated installations (e.g., CentOS, Fedora).
  - `preseed.cfg`: Preseed configuration file for automated installations (e.g., Ubuntu).
- `centos.pkr.hcl`: Packer template for creating a CentOS base image.
- `fedora.pkr.hcl`: Packer template for creating a Fedora base image.
- `ubuntu.pkr.hcl`: Packer template for creating an Ubuntu base image.

### vagrant/
Contains the Vagrantfile which is used to configure and manage the virtual machine instances using the images created by Packer.

- `Vagrantfile`: Configuration file that defines how to instantiate and manage VMs with Vagrant.

### scripts/
Contains additional scripts for provisioning and automation tasks.

- `bootstrap.sh`: Script for initial provisioning and setup of the VMs.
- `build.sh`: Script to automate the Packer build process and add the resulting box to Vagrant.

### ansible/
Contains Ansible playbooks and inventory files for orchestrating the provisioning and configuration of Vagrant-managed VMs.

- `hosts.ini`: Ansible inventory file listing the Vagrant VMs.
- `playbook.yml`: Ansible playbook defining the tasks and configurations to be applied to the VMs.

### README.md
Provides documentation for the repository, including setup instructions and usage examples.

## Usage

### Building Base Images with Packer
1. Navigate to the `packer` directory.
2. Run Packer to build the desired base image, for example:
   ```sh
   packer build centos.pkr.hcl

---

### High-Level Concept

#### 1. Packer Create Base Images
**Note**: Used to create images from ISO files for use with Vagrant; template files written in HCL2.

**Requirements**:
- **ISO file(s) (.iso)**: The installation media for the operating systems you wish to create images for.
- **HCL2 template file(s) (.pkr.hcl)**: Packer configuration files defining how the images are built, including steps for automated installation and provisioning.

**Steps**:
1. Prepare Packer templates (`.pkr.hcl`) for each desired OS.
2. Include any preseed/kickstart files (`.cfg` or `.sh`) or scripts needed for automated installation.
3. Run Packer to build the VM images.
4. Output images (typically `.box` files) are ready to be used by Vagrant.

---

#### 2. Vagrant Files
**Note**: Used to configure and manage virtual machine instances using the images created by Packer.

**Requirements**:
- **Vagrantfile(s) (.rb)**: Configuration files for Vagrant that define how to instantiate and manage VMs.
- **Box file(s) (.box)**: Pre-built VM images created by Packer.

**Steps**:
1. Create `Vagrantfile` (`Vagrantfile.rb`) to define the VM configuration (networking, provisioning, resources, etc.).
2. Use the `box` command in Vagrant to add Packer-built images (`.box` files).
3. Define multi-machine configurations if needed for complex environments.
4. Use Vagrant commands (`up`, `halt`, `destroy`, etc.) to manage the lifecycle of the VMs.

---

#### 3. Ansible for Vagrant Orchestration
**Note**: Used to automate and orchestrate the provisioning and configuration of Vagrant-managed VMs.

**Requirements**:
- **Ansible playbooks (.yml)**: YAML files defining the tasks and configurations to be applied to VMs.
- **Inventory file(s) (.ini)**: Lists of hosts (VMs) to be managed by Ansible.

**Steps**:
1. Create an Ansible inventory file (`hosts.ini`) listing the Vagrant VMs.
2. Develop Ansible playbooks (`playbook.yml`) to define the desired state and configurations for the VMs.
3. Integrate Ansible with Vagrant using the Vagrantfile to ensure VMs are provisioned and configured automatically.
4. Run Ansible playbooks to apply configurations across all Vagrant-managed VMs.

**Example Tasks**:
- Installing necessary software packages.
- Configuring network settings.
- Setting up user accounts and permissions.
- Deploying application code.

### Summary

This setup allows for a streamlined, automated workflow for creating, managing, and orchestrating virtual environments:

1. **Packer** is used to create reusable base images from ISO files.
2. **Vagrant** manages the lifecycle of these VMs, using configurations defined in Vagrantfiles.
3. **Ansible** provides powerful orchestration and configuration management, ensuring all VMs are correctly set up and maintained.

By integrating these tools, you can achieve efficient and consistent environments for development, testing, and deployment.
