# Effortless Lifecycle
A reference architecture for a pipeline which brings together Effortless Config and Effortless Audit to build, harden and patch operating system images and then provision them with Habitized application workloads.

Please contact Niamh Cahill (ncahill@chef.io) if you have questions or would like more information!

## Contents

- Terraform: To build out infrastructure and demo instances see click the [link to see the terraform documentation](terraform/README.md)
- Packer: Example templates to be used by Concourse as starting points to build hardened and compliant Images. (Currently only supports AWS AMI's)
- Concourse: Example pipeline for building hardened images and spin up demo instances.

## Usage

This repo can be used to create infrastructure to demonstrate the Effortless Config and Effortless Audit models.

## Steps

1. [Deploy Automate, Concourse, and other infrastructure in AWS.](terraform/README.md)
2. Build external github repo for packer changes.
3. [Configure concourse pipeline](concourse_pipeline_examples/README.md)
4. Profit
