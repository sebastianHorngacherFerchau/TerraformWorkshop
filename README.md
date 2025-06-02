# TerraformWorkshop

This repository includes different examples for terraform using docker, local files and gcp

## First few examples - DOCKER

The first few examples show different steps from:
https://developer.hashicorp.com/terraform/tutorials/docker-get-started/install-cli
Each folder includes has a readme that explaines, what changed to the previous step.

## One example for locals provider

There are cases where you want to create files which content comes from the resources that were created.
As a simple start, here only a list of files with some content is created. For a more practical example see the gcp/administrative folder. Here each created service account gets a key assigned, which are then "exported" to a keys folder, which is handy for some testing scenarios.

## GCP

Last but not least this is all about gcp. The administrative folder is meant to create the environment for the workshop in an already existing google project.
The following resources were created manually:

- Google Project
- Admin Service Account and a key + owner role assignment
