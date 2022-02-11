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
