# Terraform and yaml files

Sources:

- https://www.slingacademy.com/article/using-yaml-with-terraform-a-practical-guide-with-examples/
- https://spacelift.io/blog/terraform-yaml

Using YAML files with Terraform can simplify the management of complex configurations and reduce the need to frequently modify .tf files.
Here are some common examples of how YAML files might be used in conjunction with Terraform:

1. Configuration Management:

VM Configuration: Define virtual machine configurations in YAML and use Terraform to read these configurations and provision VMs.

```yaml
# vm_config.yaml
vms:
  - name: "vm1"
    size: "small"
  - name: "vm2"
    size: "medium"
```

```
locals {
  vm_config = yamldecode(file("${path.module}/vm_config.yaml"))
}

resource "virtual_machine" "vm" {
  count = length(local.vm_config.vms)
  name  = local.vm_config.vms[count.index].name
  size  = local.vm_config.vms[count.index].size
}
```

2. Service Definitions

Microservices: Define microservice configurations in YAML and use Terraform to deploy these services.

```yaml
# services.yaml
services:
  - name: "service1"
    image: "service1:latest"
  - name: "service2"
    image: "service2:latest"
```

```
locals {
  services = yamldecode(file("${path.module}/services.yaml"))
}

resource "kubernetes_deployment" "service" {
  for_each = { for service in local.services.services : service.name => service }

  metadata {
    name = each.key
  }

  spec {
    template {
      spec {
        container {
          name  = each.key
          image = each.value.image
        }
      }
    }
  }
}
```

3. IAM Policies:
   Role Definitions: Define IAM roles and policies in YAML and use Terraform to apply these roles.

```yaml
# iam_roles.yaml
roles:
  - name: "role1"
    permissions:
      - "compute.instances.create"
      - "compute.instances.delete"
  - name: "role2"
    permissions:
      - "storage.buckets.create"
      - "storage.buckets.delete"
```

```
locals {
  iam_roles = yamldecode(file("${path.module}/iam_roles.yaml"))
}

resource "google_project_iam_custom_role" "role" {
  for_each = { for role in local.iam_roles.roles : role.name => role }

  role_id     = each.key
  title       = each.key
  permissions = each.value.permissions
}
```

4. Network Configurations:
   VPC and Subnets: Define VPC and subnet configurations in YAML and use Terraform to create these resources.

```yaml
# network.yaml
vpcs:
  - name: "vpc1"
    subnets:
      - name: "subnet1"
        cidr: "10.0.1.0/24"
      - name: "subnet2"
        cidr: "10.0.2.0/24"
```

```
locals {
  network_config = yamldecode(file("${path.module}/network.yaml"))
}

resource "google_compute_network" "vpc" {
  for_each = { for vpc in local.network_config.vpcs : vpc.name => vpc }

  name = each.key
}

resource "google_compute_subnetwork" "subnet" {
  for_each = { for vpc in local.network_config.vpcs : vpc.name => vpc.subnets }

  name          = each.value.name
  ip_cidr_range = each.value.cidr
  network       = google_compute_network.vpc[each.key].name
}
```

By using YAML files for these configurations, teams can manage infrastructure as code more efficiently, making it easier to update and maintain complex setups!
