# Step 8 — Final Verification Checklist

Use this as the submission checklist. Every box should map to a
screenshot saved in [`screenshots/`](../screenshots/) with the exact
filename shown (referenced from each step's doc too).

## 1. EC2 Instance
- [ ] `01-instance-running.png`
- [ ] `01-ssh-connect-success.png`

## 2. Security Group
- [ ] `02-security-group-inbound-rules.png`
- [ ] `02-ssh-blocked-external.png`

## 3. IAM User & Policy
- [ ] `03-iam-policy-json.png`
- [ ] `03-iam-user-created.png`
- [ ] `03-mfa-enabled.png`
- [ ] `03-cli-access-verified.png`

## 4. IAM Role for EC2
- [ ] `04-iam-role-trust-policy.png`
- [ ] `04-iam-role-permissions.png`
- [ ] `04-role-attached-to-instance.png`

## 5. S3 Access From EC2 (no access keys)
- [ ] `05-no-credentials-file.png`
- [ ] `05-sts-caller-identity.png`
- [ ] `05-s3-ls-success.png`
- [ ] `05-s3-least-privilege-denied.png`

## 6. SSH Hardening
- [ ] `06-sshd-config-applied.png`
- [ ] `06-root-login-denied.png`
- [ ] `06-password-auth-denied.png`
- [ ] `06-key-login-still-works.png`

## 7. UFW Firewall
- [ ] `07-ufw-status-active.png`
- [ ] `07-ufw-ssh-still-works.png`
- [ ] `07-ufw-blocks-other-port.png`

## One-shot command summary (run on the EC2 instance, capture output)

```bash
echo "== Identity (should be assumed-role, not IAM user) =="
aws sts get-caller-identity

echo "== No local credentials =="
aws configure list

echo "== S3 access via role =="
aws s3 ls s3://<BUCKET_NAME>

echo "== SSH hardening applied =="
sudo sshd -T | egrep 'permitrootlogin|passwordauthentication|permitemptypasswords'

echo "== UFW active =="
sudo ufw status verbose
```

Save this combined output as `screenshots/08-full-verification-output.png`
(or `.txt` alongside the screenshots) as a single consolidated proof.

## Cleanup (after grading/submission, to avoid charges)

```bash
# Terminate the instance
aws ec2 terminate-instances --instance-ids <INSTANCE_ID>

# Empty and delete the S3 bucket
aws s3 rm s3://<BUCKET_NAME> --recursive
aws s3 rb s3://<BUCKET_NAME>

# Detach and delete the IAM role/instance profile, delete the IAM user & policies
# (console: IAM → Roles/Users/Policies → Delete)
```
