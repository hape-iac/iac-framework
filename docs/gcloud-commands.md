# GCloud Commands

## Purpose
Use these commands to authenticate and collect `billing_account` and `organization_id` for `iac-framework` inputs.

## 1) Login

### Service account login (default for this repository)
```bash
export GOOGLE_APPLICATION_CREDENTIALS="<ABSOLUTE_PATH_TO_SERVICE_ACCOUNT_KEY_JSON>"
gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"
gcloud auth list
```

### Optional user login (interactive)
```bash
gcloud auth login
gcloud auth application-default login
gcloud auth list
```

## 2) Get billing account ID

```bash
gcloud billing accounts list --format="table(name,displayName,open)"
```

Extract only the ID value:

```bash
gcloud billing accounts list --format="value(name)" | sed 's#billingAccounts/##'
```

## 3) Get organization ID

```bash
gcloud organizations list --format="table(displayName,name)"
```

Extract only the ID value:

```bash
gcloud organizations list --format="value(name)" | sed 's#organizations/##'
```

## 4) Save local repo credentials safely (gitignored)

Preferred flow:

```bash
make init
```

This runs `scripts/init_workspace.py`, extracts billing and organization IDs, and creates `.env.local`.
The file is ignored by git through `.gitignore`.
It also sets `VM_ACCESS_USER_EMAIL` from your active `gcloud` account when available.

Manual fallback:

```bash
cat > .env.local <<'EOF'
BILLING_ACCOUNT="<YOUR_BILLING_ACCOUNT_ID>"
ORGANIZATION_ID="<YOUR_ORGANIZATION_ID>"
GOOGLE_APPLICATION_CREDENTIALS="<ABSOLUTE_PATH_TO_SERVICE_ACCOUNT_KEY_JSON>"
VM_ACCESS_USER_EMAIL="<YOUR_VM_ACCESS_USER_EMAIL>"
MACHINE_TYPE="e2-micro"
ENABLE_PUBLIC_IP="false"
USE_PUBLIC_SUBNET="false"
EOF
```

If you used interactive user login, `GOOGLE_APPLICATION_CREDENTIALS` can point to:

```bash
$HOME/.config/gcloud/application_default_credentials.json
```

Load values in your current shell:

```bash
set -a
source .env.local
set +a
```

Optional check:

```bash
echo "$BILLING_ACCOUNT"
echo "$ORGANIZATION_ID"
echo "$GOOGLE_APPLICATION_CREDENTIALS"
echo "$VM_ACCESS_USER_EMAIL"
echo "$MACHINE_TYPE"
echo "$ENABLE_PUBLIC_IP"
echo "$USE_PUBLIC_SUBNET"
```
