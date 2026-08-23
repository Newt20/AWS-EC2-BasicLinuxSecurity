# Screenshots

Place proof screenshots here using the exact filenames referenced in each
`docs/0N-*.md` file and consolidated in
[`docs/05-verification-checklist.md`](../docs/05-verification-checklist.md).

| Filename | Proves |
|---|---|
| `01-instance-running.png` | EC2 instance launched and running |
| `01-ssh-connect-success.png` | Successful SSH connection to the instance |
| `02-security-group-inbound-rules.png` | SSH restricted to a single `/32` source IP |
| `02-ssh-blocked-external.png` | SSH refused from an unauthorized source |
| `03-sshd-config-applied.png` | SSH hardening config present on the instance |
| `03-root-login-denied.png` | Root SSH login refused |
| `03-password-auth-denied.png` | Password-based SSH refused |
| `03-key-login-still-works.png` | Key-based SSH still works after hardening |
| `04-ufw-status-active.png` | UFW active with deny-by-default + SSH allow rule |
| `04-ufw-ssh-still-works.png` | SSH still reachable after enabling UFW |
| `04-ufw-blocks-other-port.png` | An unopened port blocked by UFW |
| `05-full-verification-output.png` (or `.txt`) | Consolidated final verification run |

Redact your real public IP with a black box if you'd prefer not to
publish it, but keep enough of the screenshot visible (e.g. the `/32`
suffix, the resource names) to prove the configuration.
