# Table of Contents

- [Table of Contents](#table-of-contents)
- [General](#general)
- [Install Terraform](#install-terraform)
- [Install docker](#install-docker)
- [Set Up Visual Studio Code Extensions](#set-up-visual-studio-code-extensions)
- [Where to start with docker?](#where-to-start-with-docker)
- [Create a docker container for terraform](#create-a-docker-container-for-terraform)
- [Create a nginx server using Terraform](#create-a-nginx-server-using-terraform)
- [Topics and Resources](#topics-and-resources)
- [Next topics to look at](#next-topics-to-look-at)

# General

The first part of the workshop focuses on

# Install Terraform

- Download from the terraform website the `terraform.exe` resp. the zip : [Install | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/install)
- Place it in a empty folder of your choice
- Add the folder to the system path

# Install docker

1. **Install Docker**:
   - Download Docker from the Docker website and install it.
2. **Start Docker**:
   - Ensure Docker is running on your machine.

# Set Up Visual Studio Code Extensions

1. **Open Visual Studio Code**.
2. **Install Extensions**:
   - Go to the Extensions view by clicking on the Extensions icon in the Activity Bar or pressing `Ctrl+Shift+X`.
   - Search for and install the following extensions:
     - **HashiCorp Terraform**: Provides syntax highlighting, auto-completion, and other features for Terraform files.
     - **Docker**: Adds Docker support to Visual Studio Code.
     - **Podman manager**: lets you view your containers inside vs code

```
Alternatively you can use podman on windows via this command in powershell:

winget install --id=RedHat.Podman -e
```

# Where to start with docker?

A good starting point is always the terraform registry!
[Browse Providers | Terraform Registry](https://registry.terraform.io/browse/providers)

For the docker example, the kreuzwerker/docker provider will be used
[Docs overview | kreuzwerker/docker | Terraform | Terraform Registry](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs)

# Create a docker container for terraform

Create a `Dockerfile` file with this content:

```dockerfile
FROM hashicorp/terraform:latest

WORKDIR /workspace

COPY . /workspace
```

Build with:

```
docker build -t terraform-container .
```

# Create a nginx server using Terraform

1. Create a new folder `learn-terraform-docker-container`
2. Change directory: `cd learn-terraform-docker-container`
3. create `main.tf` with:

```terraform
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host    = "npipe:////.//pipe//docker_engine"
}

resource "docker_image" "nginx" {
  name         = "nginx"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "tutorial"

  ports {
    internal = 80
    external = 8000
  }
}
```

4. initialize Terraform: `terraform init`
5. Provision the NGINX server: `terraform apply`
   1. alternatively you can also execute `terraform plan` to see, what terraform will plan to do
6. Visit `localhost:8000`, where the nginx server should greet you with a welcome message
   1. ![[file-20250520195613040.png]]
7. Have a look at the created container with `docker -ps` and afterwards destroy the server `terraform destroy`

Again a list of the commands that are good to know in terraform:

| Command                                                                                                                                                                    | Explanation                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `terraform init`                                                                                                                                                           | When you create a new configuration — or check out an existing configuration from version control — you need to initialize the directory with `terraform init`.<br><br>Initializing a configuration directory downloads and installs the providers defined in the configuration, which in this case is the `docker` provider.<br><br>Terraform downloads the `docker` provider and installs it in a hidden subdirectory of your current working directory, named `.terraform`. The `terraform init` command prints out which version of the provider was installed. Terraform also creates a lock file named `.terraform.lock.hcl` which specifies the exact provider versions used, so that you can control when you want to update the providers used for your project. |
| `terraform fmt`                                                                                                                                                            | It is recommended to use consistent formatting. This command automatically updates configurations in the current directory for readability and consistency. Terraform will print out the names of the files it modified, if any.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| `terraform validate`                                                                                                                                                       | Makes sure your configuration is syntactically valid and internally consistent                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| `terraform plan`                                                                                                                                                           | Plan the changes terraform will be making<br><br>The prefix `-/+` means that Terraform will destroy and recreate the resource, rather than updating it in-place.<br>Terraform can update some attributes in-place (indicated with the `~` prefix)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| `terraform apply`                                                                                                                                                          | Apply the configuration                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `terraform show`                                                                                                                                                           | Inspect the current state                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| `terraform state rm docker_container.nginx`                                                                                                                                | Removes the docker container resource (type.name from the state or .tf file)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| `terraform import docker_container.nginx <full container id>`                                                                                                              | imports a resource by `<container id>` into the resource `docker_container.nginx`<br>NOTE: `docker ps` only gives you the shortened container id, therefore make sure to get the full one for the import, e.g. using `docker inspect`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `docker inspect '{{.Id}}' <container id>`                                                                                                                                  | get the id field from a docker container by its id (also if shortened id used)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| `docker inspect '{{.Config.Labels}}' <container id>`                                                                                                                       | get the labels of a container -> BUT: the result is a map! See the next command to get the json representation<br><br>`PS C:\source\otto\terraform-locally\learn-terraform-docker-container-step-4> docker inspect -f '{{.Config.Labels}}' cd465050c8e0`<br>`C:\source\otto\terraform-locally\learn-terraform-docker-container-step-4>podman inspect -f {{.Config.Labels}} cd465050c8e0`<br>`map[label1_PROD:value1_PROD label2_PROD:value2_PROD maintainer:NGINX Docker Maintainers <docker-maint@nginx.com>]`                                                                                                                                                                                                                                                           |
| `docker inspect '{{json .Config.Labels}}' <container id>`                                                                                                                  | get the labels (-object/-map) of a container in json format<br><br>`PS C:\source\otto\terraform-locally\learn-terraform-docker-container-step-4> docker inspect -f '{{json .Config.Labels}}' cd465050c8e0`<br>`C:\source\otto\terraform-locally\learn-terraform-docker-container-step-4>podman inspect -f "{{json .Config.Labels}}" cd465050c8e0`<br>`{"label1_PROD":"value1_PROD","label2_PROD":"value2_PROD","maintainer":"NGINX Docker Maintainers <docker-maint@nginx.com>"}`                                                                                                                                                                                                                                                                                         |
| `terraform workspace list`<br>`terraform workspace new <workspace name>`<br>`terraform workspace select <workspace name>`<br>`terraform workspace delete <workspace name>` | [Manage workspaces \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/cli/workspaces)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
|                                                                                                                                                                            |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |

The files of the directory:

| File                  | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `.terraform.lock.hcl` | lock file named which specifies the exact provider versions used, so that you can control when you want to update the providers used for your project.                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| `terraform.tfstate`   | Terraform stores the IDs and properties of the resources it manages in this file, so that it can update or destroy those resources going forward.<br><br>**The Terraform state file is the only way Terraform can track which resources it manages, and often contains sensitive information, so you must store your state file securely and restrict access to only trusted team members who need to manage your infrastructure.**<br><br>When Terraform created the nginx container, it also gathered the resource's metadata from the Docker provider and wrote the metadata to the state file. |
|                       |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |

On a second time apply i get a big output:

```shell
PS C:\source\otto\terraform-locally\learn-terraform-docker-container-step-2> terraform apply
docker_image.nginx: Refreshing state... [id=sha256:3b25b682ea82b2db3cc4fd48db818be788ee3f902ac7378090cf2624ec2442dfnginx]
docker_container.nginx: Refreshing state... [id=1d7bb6eea53e1832aafec1c6a137920a8a439fa6698cfb00fb6ac8a7387a371e]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # docker_container.nginx must be replaced
-/+ resource "docker_container" "nginx" {
      + bridge                                      = (known after apply)
      ~ command                                     = [
          - "nginx",
          - "-g",
          - "daemon off;",
        ] -> (known after apply)
      + container_logs                              = (known after apply)
      - cpu_shares                                  = 0 -> null
      - dns                                         = [] -> null
      - dns_opts                                    = [] -> null
      - dns_search                                  = [] -> null
      ~ entrypoint                                  = [
          - "/docker-entrypoint.sh",
        ] -> (known after apply)
      ~ env                                         = [] -> (known after apply)
      + exit_code                                   = (known after apply)
      - group_add                                   = [] -> null
      ~ hostname                                    = "1d7bb6eea53e" -> (known after apply)
      ~ id                                          = "1d7bb6eea53e1832aafec1c6a137920a8a439fa6698cfb00fb6ac8a7387a371e" -> (known after apply)
      ~ init                                        = false -> (known after apply)
      ~ ipc_mode                                    = "shareable" -> (known after apply)
      ~ log_driver                                  = "journald" -> (known after apply)
      - log_opts                                    = {} -> null
      - max_retry_count                             = 0 -> null
      - memory                                      = 0 -> null
      - memory_swap                                 = 0 -> null
        name                                        = "tutorial"
      ~ network_data                                = [
          - {
              - gateway                   = "10.88.0.1"
              - global_ipv6_prefix_length = 0
              - ip_address                = "10.88.0.7"
              - ip_prefix_length          = 16
              - mac_address               = "7a:36:ab:e9:26:e3"
              - network_name              = "podman"
                # (2 unchanged attributes hidden)
            },
        ] -> (known after apply)
      - privileged                                  = false -> null
      - publish_all_ports                           = false -> null
      ~ runtime                                     = "oci" -> (known after apply)
      ~ security_opts                               = [] -> (known after apply)
      ~ shm_size                                    = 62 -> (known after apply)
      ~ stop_signal                                 = "3" -> (known after apply)
      ~ stop_timeout                                = 10 -> (known after apply)
      - storage_opts                                = {} -> null
      - sysctls                                     = {} -> null
      - tmpfs                                       = {} -> null
      - working_dir                                 = "/" -> null
        # (20 unchanged attributes hidden)

      ~ healthcheck (known after apply)

      ~ labels (known after apply)

      ~ ports {
          ~ external = 8000 -> 8080 # forces replacement
            # (3 unchanged attributes hidden)
        }

        # (2 unchanged blocks hidden)
    }

Plan: 1 to add, 0 to change, 1 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```

The reason is, that not all the resource information are necessarily inside the state file! These can be "updated" with `terraform state rm <resource type>.<resource name>` and a reimport via `terraform import <resource type>.<resource name> <id of the resource>`.
Another thing that is visible here, is the `~ external = 8000 -> 8080 # forces replacement` -> with the "forces replacement" you can identify, why the resource has to be recreated!

# Topics and Resources

| Topic          | URL                                                                                                                                                          |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Workspaces     | [Manage workspaces \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/cli/workspaces)                                            |
| Dynamic Blocks | [Dynamic Blocks - Configuration Language \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks) |

# Next topics to look at

- Extended example
  - Hands-On -> Provisioning your own infrastructure locally -> nginx in a docker container
  - Local file system "infrastructure"
    - [Docs overview | hashicorp/local | Terraform | Terraform Registry](https://registry.terraform.io/providers/hashicorp/local/latest/docs)
- Where to store the state file? Why does it matter?
- GCP Cloud provider (and maybe others?) -> Looking at the Otto Infrastructure and answering questions
  - How to create buckets
  - importing resources and existing TFstates
  - Managing VMs
    - [Quickstart: Create a Compute Engine VM instance using Terraform  |  Google Cloud](https://cloud.google.com/docs/terraform/create-vm-instance)
    - [google_compute_instance | Resources | hashicorp/google | Terraform | Terraform Registry](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance)
  - Creating users
  - Creating networks
