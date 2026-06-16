# Manual Commands

## Prerequisites
- `GOOGLE_APPLICATION_CREDENTIALS` points to your service account key file.
- `gcloud` and `terragrunt` are installed locally.

## Makefile Shortcuts
Run these from `iac-agent/iac-framework/`:

```bash
make help
make init
make preview
make apply
make ssh
make destroy-vm
make destroy
```

`make destroy` requires two verification steps:
1. Type `yes`.
2. Type `iac-framework`.

`make destroy-vm` requires one verification step:
1. Type `yes`.

## Human Apply Sequence
```bash
export GOOGLE_APPLICATION_CREDENTIALS="<ABSOLUTE_PATH_TO_SERVICE_ACCOUNT_KEY_JSON>"

cd terraform/terragrunt/development/folder
terragrunt apply

cd ../project
terragrunt apply

cd ../network
terragrunt apply

cd ../private-vm
terragrunt apply
```

## Human SSH Verification Example
```bash
gcloud compute ssh "<VM_NAME>" \
  --project "<PROJECT_ID>" \
  --zone "europe-west1-b" \
  --tunnel-through-iap
```

## Human Destroy Sequence
```bash
cd terraform/terragrunt/development/private-vm
terragrunt destroy

cd ../network
terragrunt destroy

cd ../project
terragrunt destroy

cd ../folder
terragrunt destroy
```
