# Screenshots

Place proof screenshots here using the exact filenames referenced in each
`docs/0N-*.md` file and consolidated in
[`docs/08-verification-checklist.md`](../docs/08-verification-checklist.md).

| Filename | Proves |
|---|---|
| `01-instance-running.png` | EC2 instance launched and running |
| `01-ssh-connect-success.png` | Successful SSH connection to the instance |
| `02-security-group-inbound-rules.png` | SSH restricted to a single `/32` source IP |
| `02-ssh-blocked-external.png` | SSH refused from an unauthorized source |
| `03-iam-policy-json.png` | Least-privilege custom IAM policy JSON |
| `03-iam-user-created.png` | IAM user created with the policy attached |
| `03-mfa-enabled.png` | MFA device assigned to the IAM user |
| `03-cli-access-verified.png` | CLI access with the user's keys, scoped correctly |
| `04-iam-role-trust-policy.png` | EC2 role trust policy (`ec2.amazonaws.com`) |
| `04-iam-role-permissions.png` | EC2 role's attached S3 permissions |
| `04-role-attached-to-instance.png` | Role attached to the running instance |
| `05-no-credentials-file.png` | No access keys stored on the instance |
| `05-sts-caller-identity.png` | `aws sts get-caller-identity` shows assumed-role |
| `05-s3-ls-success.png` | S3 bucket access working via the role |
| `05-s3-least-privilege-denied.png` | Access to other buckets denied |
| `06-sshd-config-applied.png` | SSH hardening config present on the instance |
| `06-root-login-denied.png` | Root SSH login refused |
| `06-password-auth-denied.png` | Password-based SSH refused |
| `06-key-login-still-works.png` | Key-based SSH still works after hardening |
| `07-ufw-status-active.png` | UFW active with deny-by-default + SSH allow rule |
| `07-ufw-ssh-still-works.png` | SSH still reachable after enabling UFW |
| `07-ufw-blocks-other-port.png` | An unopened port blocked by UFW |
| `08-full-verification-output.png` (or `.txt`) | Consolidated final verification run |

Redact your real public IP / account ID with a black box if you'd prefer
not to publish them, but keep enough of the screenshot visible (e.g. the
`/32` suffix, the resource names) to prove the configuration.
