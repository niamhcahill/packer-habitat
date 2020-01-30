## Configure the base Concourse pipeline
Provides examples of a concourse pipeline to build hardened and compliant AMI's in AWS and automatically build the demo instances from those AMI's.

Attribution: ** This guide is taken largely from the [Stark and Wayne concourse tutorial](https://concoursetutorial.com/)**

### Create initial pipeline

1. Navigate to the concourse UI using the url for the ELB listed in the terraform output.
2. If you don't have the fly cli click on the image for you operating system to download it.
3. Place the fly binary in `/usr/local/bin` or `~/bin` on linux or mac or `c:\fly` on windows and set your `PATH` variable.
4. Configure your target and sync fly
```
fly --target habitat_managed login --concourse-url <url form terrform for elb> -u admin -p <password from terraform.tfvars>
fly --target habitat_managed sync
```

Note: Fly stores it configuration in the `~/.flyrc` file so if you need to remove a target you can do so there

Note: ** If you are using the git resource DO NOT use this repo as your source. Create a private repo under your github user or in chef-customers, if using for a specific customer. You will need to configure a key that concourse can use to read from the repo **

5. Create your pipeline
```
fly -t habitat_managed set-pipeline -c hab_managed_pipeline_example.yml -p image-pipeline
```
6. Unpause the pipeline
```
fly -t habitat_managed unpause-pipeline -p image-pipeline
```
7. Profit

