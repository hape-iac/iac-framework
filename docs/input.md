# Input Quick Reference

## Purpose
This file is a quick reference for the most important runtime inputs used by the Milestone 1 workflow.

## Required Runtime Values
- `ORGANIZATION_ID`
- `BILLING_ACCOUNT`
- `GOOGLE_APPLICATION_CREDENTIALS`
- `VM_ACCESS_USER_EMAIL`

## Optional Runtime Values
- `MACHINE_TYPE` (default `e2-micro`)
- `ENABLE_PUBLIC_IP` (`true` or `false`)
- `USE_PUBLIC_SUBNET` (`true` or `false`)

## Notes
- `VM_ACCESS_USER_EMAIL` is the user granted IAP and OS Login access to the private VM.
- Keep `ENABLE_PUBLIC_IP=false` and `USE_PUBLIC_SUBNET=false` for private VM mode.
- Set both to `true` to use public VM mode with an external IP in the public subnet.
- `ENABLE_PUBLIC_IP=true` requires `USE_PUBLIC_SUBNET=true`.
- For full details, see `docs/inputs.md`.
