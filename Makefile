init:
	terraform -chdir=terraform/ init

plan:
	terraform -chdir=terraform/ plan -var-file="config/terraform.tfvars"

apply:
	terraform -chdir=terraform/ apply -var-file="config/terraform.tfvars" -auto-approve 