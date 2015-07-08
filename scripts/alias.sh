alias tf='terraform'
alias tfp='tf plan --var-file=../tfcommon/keys.tfvars --var-file=../tfcommon/network.tfvars'
alias tfr='~/bin/terraform/terraform -module-depth=-1 --var-file=network.tfvars refresh --var-file=keys.tfvars '
alias tfdp='tf  plan --var-file=../tfcommon/keys.tfvars -destroy --var-file=../tfcommon/network.tfvars --out=destroy.tfplan'
alias tfa='tf apply --var-file=../tfcommon/keys.tfvars --var-file=../tfcommon/network.tfvars'
alias tfda='tf apply destroy.tfplan '
alias tfg='tf graph'
alias tfs='tf show terraform.tfstate'
