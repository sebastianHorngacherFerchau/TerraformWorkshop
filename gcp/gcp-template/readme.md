# About this folder

Here a minimal template is provided to get started with the exercises for the workshop part 2.

# Prerequisites

1. The `terraform` command can be executed
   1. download the terraform.exe file from the hashicorp website, move it to a folder of your choice (best to use a empty one)
   2. add the folder to the path variable ![Where to put the terraform file and adding it to the path variable](image.png)
2. Set the environment variable `GOOGLE_APPLICATION_CREDENTIALS` with the following command. Your personal key file is located in the folder `gcp\administrative\keys`. (More about this topic: https://cloud.google.com/docs/terraform/authentication)

Windows:

```shell
$env:GOOGLE_APPLICATION_CREDENTIALS="KEY_PATH"
```

Example:

```shell
$env:GOOGLE_APPLICATION_CREDENTIALS="C:\Users\username\Downloads\service-account-file.json"
```

Linux:

```shell
export GOOGLE_APPLICATION_CREDENTIALS="KEY_PATH"
```

Example:

```shell
export GOOGLE_APPLICATION_CREDENTIALS="/home/user/Downloads/service-account-file.json"
```

NOTE: The service accounts will be deleted after the workshop!
