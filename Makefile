###################
## Customization ##
###################
# Profile/Cluster name
AWS_PROFILE := coeros-cluster
CLUSTER_NAME := coreos-cluster
# To prevent you mistakenly using a wrong account (and end up destroying live environment),
# a list of allowed AWS account IDs should be defined:
#ALLOWED_ACCOUNT_IDS := "123456789012","012345678901"
AWS_ACCOUNT := $(shell aws --profile ${AWS_PROFILE} iam get-user | jq -r ".User.Arn" | grep -Eo '[[:digit:]]{12}')
ALLOWED_ACCOUNT_IDS := "${AWS_ACCOUNT}"

# For get-ami.sh
COREOS_UPDATE_CHANNE=beta
AWS_REGION=us-west-2
VM_TYPE=hvm

# Working Directories
ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SCRIPTS := $(ROOT_DIR)scripts
MODULES := $(ROOT_DIR)modules
RESOURCES := $(ROOT_DIR)resources
TF_RESOURCES := $(ROOT_DIR)resources/terraforms
BUILD := $(ROOT_DIR)build
CONFIG := $(BUILD)/cloud-config
CERTS := $(BUILD)/certs
SITE_CERT := $(CERTS)/site.pem
POLICIES := $(BUILD)/policies
AMI_VAR := ami.tf

# Terraform files
TF_PORVIDER := provider.tf
TF_DESTROY_PLAN_OUT := destroy.tfplan
TF_APPLY_PLAN := apply.tfplan
TF_STATE := terraform.tfstate

# Application repository. Automatically synced to /var/lib/apps
APP_REPOSITORY := https://github.com/dockerage/coreos-cluster-apps

# Terraform commands
# Note: for production, set -refresh=true to be safe
TF_APPLY := terraform apply -refresh=false
# Note: for production, remove --force to confirm destroy.
TF_DESTROY := terraform destroy -force
TF_DESTROY_PLAN := terraform plan -destroy -refresh=false
TF_GET := terraform get -update 
TF_GRAPH := terraform graph -draw-cycles -verbose
TF_PLAN := terraform plan -module-depth=1 -refresh=false
TF_SHOW := terraform show -module-depth=1
TF_REFRESH := terraform refresh
TF_TAINT := terraform taint -allow-missing

# cidr block to allow ssh; default to  $(curl -s http://ipinfo.io/ip)/32)
# TF_VAR_allow_ssh_cidr := 

##########################
## End of customization ##
##########################

export

all: worker

help:
	@echo "Usage: make plan_<resource> | <resource> | plan_destroy_<resource> | destroy_<resource>"
	@echo "Or make show_<resource> | graph"
	@echo "Or make plan_destroy_all | destroy_all"
	@echo "Available resources: vpc s3 route53 iam efs elb etcd worker admiral rds"
	@echo "For example: make plan_worker # to show what resources are planned for worker"

plan_destroy_all:
	cd $(BUILD); $(TF_DESTROY_PLAN)

destroy_all: destroy_confirm
	$(MAKE) destroy_admiral_key destroy_etcd_key destroy_worker_key \
	destroy_worker destroy_admiral destroy_etcd \
	destroy_iam destroy_s3 destroy_efs destroy_vpc

destroy_confirm:
	@echo "Are you sure to continue? [Y/N]: "; read ANSWER ; echo $$ANSWER; \
	if [ ! "$$ANSWER" == "Y" ]; then \
	  echo "Exiting." ; exit 1 ; \
	fi 

destroy: 
	@echo "Usage: make destroy_<resource> | make plan_destroy_all | make destroy_all"
	@echo "For example: make destroy_worker"
	@echo "Node: destroy may fail because of outstanding dependences"

clean_all: destroy_all
	rm -rf $(BUILD)

# TODO: Push/Pull terraform states from a tf state repo
# For team work, you need to commit terraform to a remote location, such as git repo, S3 
# Should implement a locking method to prevent alter infrastructure at the same time.
pull_tf_state:
	@mkdir -p $(BUILD)
	@echo pull terraform state from ....

push_tf_state:
	@echo push terraform state to ....

# Load all resouces makefile
include resources/makefiles/*.mk

.PHONY: all destroy destroy_all plan_destroy_all clean_all help pull_tf_state push_tf_state
