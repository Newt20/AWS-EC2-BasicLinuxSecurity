# Step 5 — Verify S3 Access From EC2 Without Access Keys

SSH into the instance for this whole step:

```bash
ssh -i module17-lab-key.pem ubuntu@<INSTANCE_PUBLIC_IP>
```

## 5.1 Install the AWS CLI on the instance (if not preinstalled)

```bash
sudo apt update
sudo apt install -y unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

## 5.2 Prove there are no credentials configured on the instance

```bash
aws configure list
cat ~/.aws/credentials 2>&1   # expect: No such file or directory
```

`aws configure list` should show all values as blank/`<not set>` (or only
`region` set from an env var) — **no** access key, no secret key.

## 5.3 Prove the instance is using the attached Role via metadata/STS

```bash
# Instance Metadata Service v2 (IMDSv2) — shows the role name is exposed
# to the instance, not a static key
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/iam/security-credentials/

# Confirm which identity the AWS CLI resolves to — should show the role's
# assumed-role ARN, e.g. arn:aws:sts::<ACCOUNT_ID>:assumed-role/module17-ec2-s3-role/i-xxxxxxxx
aws sts get-caller-identity
```

## 5.4 Access the S3 bucket — this is the keyless proof

```bash
# List the specific bucket allowed by the role's policy
aws s3 ls s3://<BUCKET_NAME>

# Download an object the policy allows GetObject on
aws s3 cp s3://<BUCKET_NAME>/test-file.txt ./test-file.txt
cat test-file.txt

# Sanity check: least privilege still holds — listing ALL buckets should
# be denied, since the role policy only grants ListBucket on one bucket
aws s3 ls
```

Expected result: the specific-bucket commands succeed, `aws s3 ls` (all
buckets) fails with `AccessDenied` — same least-privilege behavior as the
IAM user in Step 3, but achieved with **zero credentials stored on disk**.

## Screenshot checklist for this step

- [ ] `screenshots/05-no-credentials-file.png` — terminal showing
      `aws configure list` (blank keys) and `cat ~/.aws/credentials`
      failing (file doesn't exist).
- [ ] `screenshots/05-sts-caller-identity.png` — output of
      `aws sts get-caller-identity` showing the `assumed-role` ARN.
- [ ] `screenshots/05-s3-ls-success.png` — successful `aws s3 ls
      s3://<BUCKET_NAME>` and `aws s3 cp` from the instance.
- [ ] `screenshots/05-s3-least-privilege-denied.png` — `aws s3 ls` (all
      buckets) returning `AccessDenied`.

Next: [`06-ssh-hardening.md`](06-ssh-hardening.md)
