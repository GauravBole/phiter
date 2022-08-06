init:
	terraform -chdir=terraform/ init
	python src/helper/package_manager.py                       

plan:
	terraform -chdir=terraform/ plan -var-file="config/terraform.tfvars"

apply:
	terraform -chdir=terraform/ apply -var-file="config/terraform.tfvars" -auto-approve 

load_scripts:
	python src/helper/package_manager.py --Scripts src/scripts