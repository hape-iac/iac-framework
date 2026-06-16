#!/usr/bin/env python3
"""Initialize local workspace configuration for iac-framework."""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path

PLACEHOLDER_CREDENTIALS = "<ABSOLUTE_PATH_TO_SERVICE_ACCOUNT_KEY_JSON>"
PLACEHOLDER_VM_ACCESS_USER_EMAIL = "<YOUR_VM_ACCESS_USER_EMAIL>"


def run_command(command: list[str]) -> str:
    """Run a command and return stdout."""
    result = subprocess.run(command, capture_output=True, text=True, check=False)
    if result.returncode != 0:
        stderr = result.stderr.strip() or "No stderr output."
        stdout = result.stdout.strip()
        details = f"\nstdout: {stdout}" if stdout else ""
        raise RuntimeError(f"Command failed: {' '.join(command)}\nstderr: {stderr}{details}")
    return result.stdout


def extract_first_id(command: list[str], prefix: str) -> str:
    """Extract the first ID from a gcloud value(name) output."""
    output = run_command(command)
    values = [line.strip() for line in output.splitlines() if line.strip()]
    if not values:
        raise RuntimeError(f"No values returned from command: {' '.join(command)}")
    first = values[0]
    if first.startswith(prefix):
        return first[len(prefix) :]
    return first


def detect_credentials_path(explicit_path: str | None) -> str:
    """Return best available credentials path for local workflow."""
    if explicit_path:
        return explicit_path

    env_path = os.environ.get("GOOGLE_APPLICATION_CREDENTIALS")
    if env_path:
        return env_path

    adc_path = Path.home() / ".config" / "gcloud" / "application_default_credentials.json"
    if adc_path.exists():
        return str(adc_path)

    return PLACEHOLDER_CREDENTIALS


def detect_vm_access_user_email(explicit_email: str | None) -> str:
    """Return best available VM access user email for IAM bindings."""
    if explicit_email:
        return explicit_email

    env_email = os.environ.get("VM_ACCESS_USER_EMAIL") or os.environ.get("ACCESS_USER_EMAIL")
    if env_email:
        return env_email

    active_account = run_command(
        ["gcloud", "auth", "list", "--filter=status:ACTIVE", "--format=value(account)"]
    )
    values = [line.strip() for line in active_account.splitlines() if line.strip()]
    if values:
        return values[0]

    return PLACEHOLDER_VM_ACCESS_USER_EMAIL


def detect_bool_string(explicit_value: str | None, env_name: str, default: str) -> str:
    """Return normalized bool-like string for env files."""
    value = explicit_value if explicit_value is not None else os.environ.get(env_name, default)
    normalized = value.strip().lower()
    if normalized in {"true", "1", "yes", "y"}:
        return "true"
    if normalized in {"false", "0", "no", "n"}:
        return "false"
    return default


def detect_string(explicit_value: str | None, env_name: str, default: str) -> str:
    """Return configured string value for env files."""
    value = explicit_value if explicit_value is not None else os.environ.get(env_name, default)
    return value.strip() or default


def write_env_file(
    env_file: Path,
    billing_account: str,
    organization_id: str,
    credentials_path: str,
    vm_access_user_email: str,
    machine_type: str,
    enable_public_ip: str,
    use_public_subnet: str,
) -> None:
    """Write the .env.local file with restrictive permissions."""
    env_file.parent.mkdir(parents=True, exist_ok=True)
    content = (
        f'BILLING_ACCOUNT="{billing_account}"\n'
        f'ORGANIZATION_ID="{organization_id}"\n'
        f'GOOGLE_APPLICATION_CREDENTIALS="{credentials_path}"\n'
        f'VM_ACCESS_USER_EMAIL="{vm_access_user_email}"\n'
        f'MACHINE_TYPE="{machine_type}"\n'
        f'ENABLE_PUBLIC_IP="{enable_public_ip}"\n'
        f'USE_PUBLIC_SUBNET="{use_public_subnet}"\n'
    )
    env_file.write_text(content, encoding="utf-8")
    os.chmod(env_file, 0o600)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Initialize local iac-framework .env.local file.")
    parser.add_argument("--env-file", default=".env.local", help="Target env file path.")
    parser.add_argument("--billing-account", default=None, help="Override billing account ID.")
    parser.add_argument("--organization-id", default=None, help="Override organization ID.")
    parser.add_argument(
        "--credentials-path",
        default=None,
        help="Override GOOGLE_APPLICATION_CREDENTIALS path.",
    )
    parser.add_argument(
        "--vm-access-user-email",
        dest="vm_access_user_email",
        default=None,
        help="Override VM_ACCESS_USER_EMAIL value.",
    )
    parser.add_argument(
        "--access-user-email",
        dest="vm_access_user_email",
        default=None,
        help="Deprecated alias for --vm-access-user-email.",
    )
    parser.add_argument(
        "--enable-public-ip",
        default=None,
        help='Set ENABLE_PUBLIC_IP in .env.local ("true" or "false").',
    )
    parser.add_argument(
        "--use-public-subnet",
        default=None,
        help='Set USE_PUBLIC_SUBNET in .env.local ("true" or "false").',
    )
    parser.add_argument(
        "--machine-type",
        default=None,
        help='Set MACHINE_TYPE in .env.local (default "e2-micro").',
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    try:
        billing_account = args.billing_account or extract_first_id(
            ["gcloud", "billing", "accounts", "list", "--format=value(name)"],
            "billingAccounts/",
        )
        organization_id = args.organization_id or extract_first_id(
            ["gcloud", "organizations", "list", "--format=value(name)"],
            "organizations/",
        )
        credentials_path = detect_credentials_path(args.credentials_path)
        vm_access_user_email = detect_vm_access_user_email(args.vm_access_user_email)
        machine_type = detect_string(args.machine_type, "MACHINE_TYPE", "e2-micro")
        enable_public_ip = detect_bool_string(args.enable_public_ip, "ENABLE_PUBLIC_IP", "false")
        use_public_subnet = detect_bool_string(args.use_public_subnet, "USE_PUBLIC_SUBNET", "false")
        env_file = Path(args.env_file)
        write_env_file(
            env_file,
            billing_account,
            organization_id,
            credentials_path,
            vm_access_user_email,
            machine_type,
            enable_public_ip,
            use_public_subnet,
        )
    except RuntimeError as error:
        print(f"Initialization failed: {error}", file=sys.stderr)
        return 1

    print(f"Wrote {args.env_file}")
    if credentials_path == PLACEHOLDER_CREDENTIALS:
        print(
            "GOOGLE_APPLICATION_CREDENTIALS could not be auto-detected. "
            "Update the placeholder value in the env file.",
            file=sys.stderr,
        )
    if vm_access_user_email == PLACEHOLDER_VM_ACCESS_USER_EMAIL:
        print(
            "VM_ACCESS_USER_EMAIL could not be auto-detected. "
            "Update the placeholder value in the env file.",
            file=sys.stderr,
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
