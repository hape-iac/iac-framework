SHELL := /bin/bash

STACK_ROOT := terraform/terragrunt/development
STACK_ORDER := folder project network private-vm
DESTROY_ORDER := private-vm network project folder
VM_STACK := private-vm
VM_ZONE ?= europe-west1-b
REPO_NAME := $(notdir $(CURDIR))
ENV_FILE ?= .env.local
PYTHON ?= python3
INIT_ARGS ?=

.DEFAULT_GOAL := help

.PHONY: help init preview apply destroy destroy-vm ssh

define load_env
if [[ -f "$(ENV_FILE)" ]]; then \
	set -a; source "$(ENV_FILE)"; set +a; \
fi; \
if [[ -z "$$ORGANIZATION_ID" || "$$ORGANIZATION_ID" == "123456789012" ]]; then \
	echo "ORGANIZATION_ID is missing or still a placeholder."; \
	echo "Run 'make init' and verify $(ENV_FILE)."; \
	exit 1; \
fi; \
if [[ -z "$$BILLING_ACCOUNT" || "$$BILLING_ACCOUNT" == "000000-000000-000000" ]]; then \
	echo "BILLING_ACCOUNT is missing or still a placeholder."; \
	echo "Run 'make init' and verify $(ENV_FILE)."; \
	exit 1; \
fi; \
if [[ -z "$$GOOGLE_APPLICATION_CREDENTIALS" ]]; then \
	echo "GOOGLE_APPLICATION_CREDENTIALS is not set."; \
	echo "Source $(ENV_FILE) or export GOOGLE_APPLICATION_CREDENTIALS."; \
	exit 1; \
fi; \
if [[ -z "$${VM_ACCESS_USER_EMAIL:-}" && -n "$${ACCESS_USER_EMAIL:-}" ]]; then \
	export VM_ACCESS_USER_EMAIL="$$ACCESS_USER_EMAIL"; \
fi; \
access_email="$${VM_ACCESS_USER_EMAIL:-}"; \
if [[ -z "$$access_email" || "$$access_email" == "user@example.com" || "$$access_email" == "<YOUR_VM_ACCESS_USER_EMAIL>" || "$$access_email" == "<YOUR_ACCESS_USER_EMAIL>" ]]; then \
	echo "VM_ACCESS_USER_EMAIL is missing or still a placeholder."; \
	echo "Run 'make init' and verify $(ENV_FILE)."; \
	exit 1; \
fi; \
public_ip="$${ENABLE_PUBLIC_IP:-false}"; \
public_subnet="$${USE_PUBLIC_SUBNET:-false}"; \
public_ip="$$(printf '%s' "$$public_ip" | tr '[:upper:]' '[:lower:]')"; \
public_subnet="$$(printf '%s' "$$public_subnet" | tr '[:upper:]' '[:lower:]')"; \
if [[ "$$public_ip" == "true" && "$$public_subnet" != "true" ]]; then \
	echo "ENABLE_PUBLIC_IP=true requires USE_PUBLIC_SUBNET=true."; \
	echo "Update $(ENV_FILE) or run: make init INIT_ARGS='--enable-public-ip true --use-public-subnet true'"; \
	exit 1; \
fi
endef

help: ## Show available make commands
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*## "} /^[a-zA-Z_-]+:.*## / {printf "  make %-12s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: ## Initialize workspace and create .env.local
	@$(PYTHON) scripts/init_workspace.py --env-file "$(ENV_FILE)" $(INIT_ARGS)

preview: ## Run hcl format/init/validate/plan for all stacks
	@set -euo pipefail; $(load_env); \
	echo "==> all stacks: terragrunt hcl format"; \
	(cd "$(STACK_ROOT)" && terragrunt hcl format); \
	for stack in $(STACK_ORDER); do \
		echo "==> $$stack: terragrunt init"; \
		(cd "$(STACK_ROOT)/$$stack" && terragrunt init); \
		echo "==> $$stack: terragrunt validate"; \
		(cd "$(STACK_ROOT)/$$stack" && terragrunt validate); \
		echo "==> $$stack: terragrunt plan"; \
		(cd "$(STACK_ROOT)/$$stack" && terragrunt plan); \
	done

apply: ## Apply all stacks in dependency order
	@set -euo pipefail; $(load_env); for stack in $(STACK_ORDER); do \
		echo "==> $$stack: terragrunt apply"; \
		(cd "$(STACK_ROOT)/$$stack" && terragrunt apply); \
	done

destroy: ## Destroy all stacks (requires two confirmations)
	@set -euo pipefail; $(load_env); read -r -p "Type yes to continue with destroy: " confirm; \
	if [[ "$$confirm" != "yes" ]]; then \
		echo "Destroy aborted."; \
		exit 1; \
	fi; \
	read -r -p "Type repository name ($(REPO_NAME)) to confirm: " repo; \
	if [[ "$$repo" != "$(REPO_NAME)" ]]; then \
		echo "Repository name mismatch. Destroy aborted."; \
		exit 1; \
	fi
	for stack in $(DESTROY_ORDER); do \
		echo "==> $$stack: terragrunt destroy"; \
		(cd "$(STACK_ROOT)/$$stack" && terragrunt destroy); \
	done

destroy-vm: ## Destroy only the private-vm stack
	@set -euo pipefail; $(load_env); read -r -p "Type yes to destroy private-vm stack: " confirm; \
	if [[ "$$confirm" != "yes" ]]; then \
		echo "Destroy VM aborted."; \
		exit 1; \
	fi; \
	echo "==> $(VM_STACK): terragrunt destroy"; \
	(cd "$(STACK_ROOT)/$(VM_STACK)" && terragrunt destroy)

ssh: ## Open VM terminal via IAP SSH
	@set -euo pipefail; $(load_env); \
	project_id="$$(cd "$(STACK_ROOT)/project" && terragrunt output -raw project_id)"; \
	vm_name="$$(cd "$(STACK_ROOT)/private-vm" && terragrunt output -raw vm_name)"; \
	zone="$(VM_ZONE)"; \
	if [[ -z "$$project_id" || -z "$$vm_name" || -z "$$zone" ]]; then \
		echo "Missing project_id, vm_name, or zone value."; \
		echo "Apply stacks first and verify VM_ZONE."; \
		exit 1; \
	fi; \
	echo "Connecting to $$vm_name in $$project_id ($$zone) using IAP..."; \
	gcloud compute ssh "$$vm_name" --project "$$project_id" --zone "$$zone" --tunnel-through-iap
