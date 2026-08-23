# Step 1 — Launch the EC2 Instance

## Console steps

1. Sign in to the AWS Console → go to **EC2** → **Instances** → **Launch instances**.
2. **Name**: `module17-lab-instance`
3. **Application and OS Images (AMI)**: choose **Ubuntu Server 22.04 LTS** (or
   **Amazon Linux 2023** — the SSH/UFW docs are written for Ubuntu; Amazon
   Linux uses `firewalld` instead of `ufw`, see the note in
   [`07-ufw-firewall.md`](07-ufw-firewall.md)).
4. **Instance type**: `t2.micro` or `t3.micro` (Free Tier eligible).
5. **Key pair**: create a new key pair, e.g. `module17-lab-key`, type
   `RSA` or `ED25519`, format `.pem`. Download and store it securely —
   this is what you'll use for SSH instead of a password.
   - **Do not commit this key file to the repo.**
6. **Network settings**:
   - Click **Edit**.
   - VPC/subnet: default is fine for a lab.
   - Auto-assign public IP: **Enable** (needed to SSH in from your machine).
   - Firewall (security group): choose **Create security group**, name it
     `module17-lab-sg`. Leave the default SSH rule for now — you'll lock
     it down in [`02-security-groups.md`](02-security-groups.md) right
     after launch.
7. **Configure storage**: default 8 GiB gp3 is fine.
8. **Advanced details**: leave **IAM instance profile** as "No IAM Role"
   for now — you will attach the role in
   [`04-iam-role-for-ec2.md`](04-iam-role-for-ec2.md) after creating it
   (the role must exist first).
9. Click **Launch instance**.
10. Wait for **Instance state = Running** and **Status checks = 2/2 passed**.

## Connect to verify it's up

From the EC2 console, select the instance → **Connect** → **SSH client**
tab for the exact command, or use:

```bash
chmod 400 module17-lab-key.pem
ssh -i module17-lab-key.pem ubuntu@<INSTANCE_PUBLIC_IP>
```

(User is `ubuntu` for Ubuntu AMIs, `ec2-user` for Amazon Linux.)

## Screenshot checklist for this step

- [ ] `screenshots/01-instance-running.png` — EC2 console showing instance
      state **running**, with instance ID, AMI, and instance type visible.
- [ ] `screenshots/01-ssh-connect-success.png` — terminal showing a
      successful SSH login (`whoami`, `hostname` output visible).

## CLI equivalent (optional, for reference)

```bash
aws ec2 run-instances \
  --image-id ami-xxxxxxxxxxxxxxxxx \
  --instance-type t2.micro \
  --key-name module17-lab-key \
  --security-group-ids sg-xxxxxxxxxxxxxxxxx \
  --subnet-id subnet-xxxxxxxxxxxxxxxxx \
  --associate-public-ip-address \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=module17-lab-instance}]'
```

Next: [`02-security-groups.md`](02-security-groups.md)
