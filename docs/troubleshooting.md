# Troubleshooting

## `terragrunt init` fails with auth error
- Check `GOOGLE_APPLICATION_CREDENTIALS` path.
- Verify the service account key file exists and is readable.

## Billing attachment fails
- Confirm `billing_account` is valid and accessible by the service account.
- Confirm required billing permissions are assigned.

## Project creation fails due to naming
- Project IDs are globally unique.
- Adjust the naming suffix input or regenerate the suffix.

## IAP SSH fails
- Confirm VM has no external IP and IAP tunnel is used.
- Confirm the user has required IAM roles for IAP and OS Login.
- Confirm firewall rules allow IAP SSH source ranges.
