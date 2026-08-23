# Step 2 — Security Group Hardening

Security Groups are **stateful, instance-level firewalls**. Default lab
setups often leave SSH open to `0.0.0.0/0` — this step locks it down.

## Console steps

1. EC2 console → **Security Groups** → select `module17-lab-sg`.
2. **Inbound rules** tab → **Edit inbound rules**.
3. Remove any rule with source `0.0.0.0/0` (or `::/0`) on port 22.
4. Add a single inbound rule:
   - Type: `SSH`
   - Protocol: `TCP`
   - Port range: `22`
   - Source: **My IP** (the console auto-fills your current public IP as
     `<YOUR_IP>/32`)
5. (Optional, only if hosting something web-facing for this lab) add:
   - Type: `HTTP`, port `80`, source `0.0.0.0/0` — only if actually needed.
6. **Outbound rules**: leave the default `All traffic → 0.0.0.0/0`. The
   instance needs outbound HTTPS (443) to reach S3/STS endpoints; there's
   no security benefit to restricting outbound in this lab, and doing so
   incorrectly can break the S3 verification step.
7. **Save rules**.

The full rule set is documented in
[`configs/security-group/security-group-rules.md`](../configs/security-group/security-group-rules.md).

## Why this matters

- `0.0.0.0/0` on port 22 exposes SSH to the entire internet — the single
  most common source of brute-force login attempts against EC2 instances.
- Restricting the source to your `/32` IP means only traffic originating
  from your current network can even reach the SSH port, before
  authentication is ever attempted.
- If your IP changes (e.g. different network, ISP re-assigns your IP),
  you'll need to update this rule again — that's expected and is part of
  why this is more secure than a static broad range.

## Verify

- From your machine: `ssh -i module17-lab-key.pem ubuntu@<INSTANCE_PUBLIC_IP>`
  should still work.
- From a different network (e.g. phone hotspot, or use an online port
  checker against `<INSTANCE_PUBLIC_IP>:22`) — the connection should
  **time out / be refused**, proving the restriction works.

## Screenshot checklist for this step

- [ ] `screenshots/02-security-group-inbound-rules.png` — Security Group
      inbound rules tab showing only SSH from `<YOUR_IP>/32` (redact your
      real IP with a black box if you prefer, but keep the `/32` visible).
- [ ] `screenshots/02-ssh-blocked-external.png` — evidence that SSH from
      an unauthorized source is blocked/times out (e.g. `nc -vz` timeout,
      or an online port-scan result).

Next: [`03-iam-user-and-policy.md`](03-iam-user-and-policy.md)
