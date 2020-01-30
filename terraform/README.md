## Provision Base Infrastructure with Terraform
Provides terraform plans for launching management infrastructure in AWS and nodes checking into Automate from Azure, GCP and AWS.

The terraform contained here will provision the following:

* AWS VPC, Subnet and supporting resources
* A2 Server
* Concourse CI cluster

You will need the following pre-reqs:

* Terraform
* jq
* Console access to AWS

> **Note:** If you are using Okta to access AWS you can find instruction on how to set up aws cli access [here](https://github.com/chef/okta_aws)

Note: **In order for Chef and InSpec to report successfully to Automate, Automate needs to have a valid certificate.**

Note: **The terraform builds a new vpc so if there are not enough you may hit an issue**

Note: **The default TTL for this project is 8 hours.  Adjust in the appropriate `.tfvars` as needed**

### Provision Infrastructure (AWS)
1. `cd terraform/aws`
2. Create a `terraform.tfvars` file based on the supplied `terraform.tfvars.example` file
3. Modify your new the values of the `terraform.tfvars` file to fit your needs.
4. Copy `chef_automate_alb.tf.example` to `chef_automate_alb.tf` to support automatic ALB and DNS provisioning.  It is required that you have permission to add records to a managed R53 zone, AND that you have a managed cert in ACM.
>**Note:** Most of the AWS regions in the SA and Success accounts have been configured to support ACM. You can confirm that the region you are building in has the correct configuration to request a certificate by going to the certificate manager in the AWS console.
>**Note:** When choosing the FQDN for your Automate instance be sure to only go to one level below what the certificate manager is configure for. For example `a2-jsnow.chef-demo.com` instead of `a2.jsnow.chef-demo.com`
5. Verify the Terraform version indicated in `data.tf` matches the version installed
6. Run `terraform init` followed by `terraform plan` to validate
7. Run `terraform apply`
8. Make a note of the A2 credentials and data collector token listed in the terraform output - you'll need these to log in to your A2 instance.

```bash
...
Apply complete! Resources: 37 added, 0 changed, 0 destroyed.

Outputs:

a2_admin = blah
a2_admin_password = someCrazyPassword
a2_token = someToken
a2_url = https://blah.blah.com
chef_automate_server_public_ip = X.X.X.X
concourse_db_ip = X.X.X.X
concourse_elb_dns = concourse-elb-yourname.aws
concourse_web_ip = X.X.X.X
concourse_worker_ips = [
    X.X.X.X,
    X.X.X.X,
    X.X.X.X
]
permanent_peer_public_ip = X.X.X.X
subnet_id = subnet-blahblah
vpc_id = vpc-blahblah
```

### Create Certificate using letsencrypt (OPTIONAL)

This section is optional if your have problems with the Application Load Balancer or if you want to use a different domain then what is available in AWS.
>**Note:** The branch `tls/no_merge_letsencrypt contains the terraform code necessary to make the use of the letencrypt certificate option work. If you want to use this option checkout that branch and modify your terrafrom.tfvars as per the instructions below.

1. Create an Ubuntu server in AWS. <!-- TODO: Add terraform to automate these tasks -->
2. Configure AWS Route53 to point to newly created instance
Note: There are domains inside both the SA and Success AWS accounts that can be configured for this. It is recommended that you use the `a2.<yourname>.<domain_from_aws>`. This server is only to assist in the certificate request process and will not be used to build A2.
3. Change the hostname to be the FQDN for automate
```bash
sudo hostname <Desired FQDN for Automate>
```
4. Install habitat on the server
```
curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo bash
```
5. Add the hab user and the hab group
``bash
sudo groupadd hab
sudo useradd -g hab hab
```
6. Install tomcat and java using habitat
```
sudo hab pkg install core/jre8
sudo hab pkg install thelunaticscripter/tomcat8
sudo hab sup run thelunaticscripter/tomcat8
```
7. Open a new terminal and install [certbot](https://certbot.eff.org/lets-encrypt/ubuntuxenial-apache.html) for apache (this is make take bit since it is updating ubuntu)
```
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install python-certbot-apache
```

8. Request certificate for A2 using certbot and follow the prompts
```
$ sudo certbot --apache certonly
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator apache, Installer apache
Enter email address (used for urgent renewal and security notices) (Enter 'c' to
cancel): (**your email address**)
Starting new HTTPS connection (1): acme-v02.api.letsencrypt.org

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please read the Terms of Service at
https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf. You must
agree in order to register with the ACME server at
https://acme-v02.api.letsencrypt.org/directory
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(A)gree/(C)ancel: A

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Would you be willing to share your email address with the Electronic Frontier
Foundation, a founding partner of the Let's Encrypt project and the non-profit
organization that develops Certbot? We'd like to send you email about our work
encrypting the web, EFF news, campaigns, and ways to support digital freedom.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: Y
Starting new HTTPS connection (1): supporters.eff.org
No names were found in your configuration files. Please enter in your domain
name(s) (comma and/or space separated)  (Enter 'c' to cancel): **Your Automate Hostname**
Obtaining a new certificate
Performing the following challenges:
http-01 challenge for blah.blah.blah
Enabled Apache rewrite module
Waiting for verification...
Cleaning up challenges

IMPORTANT NOTES:
- Congratulations! Your certificate and chain have been saved at:
  /etc/letsencrypt/live/**Your Automate Hostname**/fullchain.pem
  Your key file has been saved at:
  /etc/letsencrypt/live/**Your Automate Hostname**/privkey.pem
  Your cert will expire on 2019-04-17. To obtain a new or tweaked
  version of this certificate in the future, simply run certbot
  again. To non-interactively renew *all* of your certificates, run
  "certbot renew"
- Your account credentials have been saved in your Certbot
  configuration directory at /etc/letsencrypt. You should make a
  secure backup of this folder now. This configuration directory will
  also contain certificates and private keys obtained by Certbot so
  making regular backups of this folder is ideal.
- If you like Certbot, please consider supporting our work by:

  Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
  Donating to EFF:                    https://eff.org/donate-le

- We were unable to subscribe you the EFF mailing list because your
  e-mail address appears to be invalid. You can try again later by
  visiting https://act.eff.org.
```

9. Copy the private key and the full chain. The files that contain these are outputs from the previous command

10. Past the certs into the correct location in your `terraform.tfvars` file

11. Shut down server but don't terminate it as you may need it for cert renewal.

12. Remove the Rout53 DNS record so that the terraform can create it for A2.