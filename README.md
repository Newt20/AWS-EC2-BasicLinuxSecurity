# AWS EC2 Security Practice Lab

Hands-on lab covering EC2 launch, Security Groups, IAM Users/Policies, IAM
Roles, keyless S3 access from EC2, and basic Linux hardening (SSH + UFW).

This repo contains **documentation and config files only**. All AWS/Linux
steps must be performed manually in your own AWS account by following the
guides in [`docs/`](docs/). Screenshots proving completion go in
[`screenshots/`](screenshots/).

## Objectives

1. Launch an EC2 instance
2. Restrict access with a Security Group (SSH from your IP only)
3. Create an IAM User with a least-privilege custom Policy
4. Create an IAM Role and attach it to the EC2 instance
5. Access an S3 bucket **from EC2 using the Role — no access keys**
6. Harden SSH (key-only auth, no root login)
7. Configure UFW as a host-level firewall

## Repo structure

```
module-17/
├── README.md                          # this file
├── docs/                              # step-by-step guides, one per task
│   ├── 01-ec2-launch.md
│   ├── 02-security-groups.md
│   ├── 03-iam-user-and-policy.md
│   ├── 04-iam-role-for-ec2.md
│   ├── 05-s3-access-from-ec2.md
│   ├── 06-ssh-hardening.md
│   ├── 07-ufw-firewall.md
│   └── 08-verification-checklist.md   # final checklist + screenshot list
├── configs/                           # config files referenced by the docs
│   ├── iam/
│   │   ├── ec2-trust-policy.json      # who can assume the EC2 role
│   │   ├── ec2-s3-readonly-policy.json# least-privilege S3 policy for the role
│   │   └── iam-user-policy.json       # least-privilege policy for the IAM user
│   ├── security-group/
│   │   └── security-group-rules.md    # inbound/outbound rules used
│   ├── ssh/
│   │   └── 99-hardening.conf          # sshd_config drop-in
│   ├── ufw/
│   │   └── setup-ufw.sh               # UFW rules script
│   └── s3/
│       └── bucket-policy.json         # optional bucket policy (defense in depth)
└── screenshots/
    └── README.md                      # required screenshot filenames/checklist
```

## How to use this repo

1. Read each file in `docs/` in order (01 → 08) and perform the steps in
   your own AWS account (console or CLI, as noted per step).
2. Copy/adapt the files in `configs/` when a doc tells you to — replace the
   placeholders (`<ACCOUNT_ID>`, `<BUCKET_NAME>`, `<YOUR_IP>`, etc.) with
   your real values. **Do not commit real account IDs, bucket names, or IPs
   you consider sensitive** — placeholders are fine for submission.
3. Save each proof screenshot into `screenshots/` using the filenames listed
   in [`docs/08-verification-checklist.md`](docs/08-verification-checklist.md).
4. Commit and push this repo to GitHub for submission.

## Prerequisites

- An AWS account (Free Tier eligible instance types are used throughout)
- AWS CLI v2 installed locally (for the IAM user steps) —
  https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
- An SSH client (OpenSSH, PuTTY, or the AWS Console's browser-based SSH)
- Basic familiarity with the Linux command line

## Key security principles applied

- **Least privilege** — IAM policies grant only the specific S3 actions on
  the specific bucket needed, nothing broader (no `s3:*`, no `Resource: "*"`
  unless the action requires it, e.g. `s3:ListAllMyBuckets`).
- **No long-lived credentials on EC2** — the instance uses an IAM Role
  (via the instance profile → STS temporary credentials), never an access
  key/secret stored on disk.
- **Network defense in depth** — Security Group (stateful, instance-level,
  AWS-managed) + UFW (host-level, OS-managed) both restrict traffic.
- **Reduced SSH attack surface** — key-based auth only, no root login, SSH
  restricted to a single known source IP at the Security Group layer.

## Cost / cleanup note

Remember to **terminate the EC2 instance**, delete the S3 test bucket/objects,
and remove the IAM user/role/policies when you're done practicing, to avoid
any unexpected charges.
