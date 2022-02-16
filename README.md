# Cloud Media Requests

Deploy a media request site such as [Ombi](https://ombi.io/) or [Overseerr](https://overseerr.dev/) in the cloud. 

The site runs in Docker behind a reverse proxy and provides HTTPS via Let's Encrypt. It then uses a VPN to communicate with a remote media server infrastructure (for example, Plex, Sonarr, Radarr, etc.).

This project uses [Terraform](https://www.terraform.io/), [Ansible](https://www.ansible.com/), and [Packer](https://www.packer.io/) to create a golden image, deploy an EC2 instance, and configure Docker on the host. It 

The main goal is cost-effectiveness and simplicity, so reliability and scalability practices such as load balancing or microservices are not currently a consideration.

<p align="right">(<a href="#top">back to top</a>)</p>


## Getting Started

A few things are required before getting started:

### Prerequisites

* An active AWS account with programmatic access
* Remote media server infrastructure to handle requests
* A domain name

I am also using an existing AWS hosted zone, which I get with a data call, but this could be created via Terraform as well.
Instead of using variables for everything, some items use an AWS Parameter Store data call, but these could easily be converted to Terraform variables.

<p align="right">(<a href="#top">back to top</a>)</p>


## Details

### Packer

A weekly "golden image" is built and pushed to AWS as an AMI.  
The main reason for this instead of using a public AMI is speed of startup, plus just wanting to use Packer.

### Terraform

The Terraform configuration is fairly straightforward - simply update the `terraform/terraform.tfvars`.  
However, this project currently uses AWS Parameter Store for some variables in order to protect my privacy in this public repo (please see `terraform/data.tf` for details).  
The Terraform also assumes an AWS hosted zone already exists - this decision was made so I could reuse an existing hosted zone for other projects.

### Ansible

Variables and container image versions are set in `ansible/group_vars/all.yml`.  
Ansible runs after the EC2 instance is brought online and performs the following:  

* Updates YUM
* Clones [the docker-compose repo](https://github.com/rnwood13/docker-nginx-letsencrypt-ombi)
* Sets up WireGuard to talk back to the remote media server
* Restores the media requests database from S3 (if applicable)
* Configures docker-compose as a systemd process and starts it

Some variables are stored in AWS Parameter Store for ease of use and my own privacy.  
There is a media request database backup task that is intended to be run ad-hoc, using something like:  
`ansible -i inventory -m include_tasks -a file=roles/cloud-media-requests/tasks/media-request-db-backup.yml _Servers -e ansible_ssh_private_key_file=~/.ssh/aws-key-pair.pem -u ec2-user`.  
The idea is that this would be automated and periodically backup the DB to S3.  

Note about CI: the CircleCI config has a job that adds a temporary Security Group rule allowing the /32 IP address of the runner in order to apply the Ansible. This requires the project name to be included as a CI environment variable or uncommenting the environment variable in the job itself. 

### CircleCI

CI/CD is provided by CircleCI.  
I have added SSH keys for Ansible as context variables as well as an environment variable for the project name.  
See `.circleci/config.yml` for details.

<p align="right">(<a href="#top">back to top</a>)</p>


## Development

Here is an example of how to begin development on Ubuntu.

### Install the Tools

* Terraform (using [tfenv](https://github.com/tfutils/tfenv))
  ```sh
  git clone https://github.com/tfutils/tfenv.git ~/.tfenv
  echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
  ln -s ~/.tfenv/bin/* /usr/local/bin
  cd ./terraform
  tfenv install # This will download the version of Terraform listed in `.terraform-version`
  ```
* Ansible
  ```sh
  sudo apt update
  sudo apt install software-properties-common
  sudo add-apt-repository --yes --update ppa:ansible/ansible
  sudo apt install ansible
  ```
* Packer
  ```sh
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  sudo apt-get update && sudo apt-get install packer
  ```

<p align="right">(<a href="#top">back to top</a>)</p>


## License

Distributed under the MIT License. See `LICENSE` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>

## Thanks

* luzifer-ansible's [docker-compose](https://github.com/luzifer-ansible/docker-compose) project

<p align="right">(<a href="#top">back to top</a>)</p>
