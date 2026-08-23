# AWS EC2 Security Practice Lab

Hands-on lab covering EC2 launch, Security Groups, and basic Linux
hardening (SSH + UFW).

> **Scope note**: The original assignment also called for IAM
> User/Policy, an IAM Role, and S3 access from EC2 via that role (no
> access keys). Those steps are **omitted here** because the AWS account
> used for this lab has no permission to create IAM users, roles, or
> policies. Everything below is scoped to what's actually achievable in
> that account.

This repo contains **documentation and config files only**. All AWS/Linux
steps must be performed manually in your own AWS account by following the
guides in [`docs/`](docs/). Screenshots proving completion go in
[`screenshots/`](screenshots/).

## Objectives

1. Launch an EC2 instance
2. Restrict access with a Security Group (SSH from your IP only)
3. Harden SSH (key-only auth, no root login)
4. Configure UFW as a host-level firewall

## Repo structure

```
module-17/
├── README.md                          # this file
├── docs/                              # step-by-step guides, one per task
│   ├── 01-ec2-launch.md
│   ├── 02-security-groups.md
│   ├── 03-ssh-hardening.md
│   ├── 04-ufw-firewall.md
│   └── 05-verification-checklist.md   # final checklist + screenshot list
├── configs/                           # config files referenced by the docs
│   ├── security-group/
│   │   └── security-group-rules.md    # inbound/outbound rules used
│   ├── ssh/
│   │   └── 99-hardening.conf          # sshd_config drop-in
│   └── ufw/
│       └── setup-ufw.sh               # UFW rules script
└── screenshots/
    └── README.md                      # required screenshot filenames/checklist
```

## How to use this repo

1. Read each file in `docs/` in order (01 → 05) and perform the steps in
   your own AWS account (console or CLI, as noted per step).
2. Copy/adapt the files in `configs/` when a doc tells you to — replace the
   placeholders (`<YOUR_IP>`, `<INSTANCE_PUBLIC_IP>`, etc.) with your real
   values. **Do not commit real IPs you consider sensitive** — placeholders
   are fine for submission.
3. Save each proof screenshot into `screenshots/` using the filenames listed
   in [`docs/05-verification-checklist.md`](docs/05-verification-checklist.md).
4. Commit and push this repo to GitHub for submission.

## Prerequisites

- An AWS account (Free Tier eligible instance types are used throughout)
- An SSH client (OpenSSH, PuTTY, or the AWS Console's browser-based SSH)
- Basic familiarity with the Linux command line

## Key security principles applied

- **Network defense in depth** — Security Group (stateful, instance-level,
  AWS-managed) + UFW (host-level, OS-managed) both restrict traffic.
- **Reduced SSH attack surface** — key-based auth only, no root login, SSH
  restricted to a single known source IP at the Security Group layer.

## Cost / cleanup note

Remember to **terminate the EC2 instance** when you're done practicing,
to avoid any unexpected charges.
