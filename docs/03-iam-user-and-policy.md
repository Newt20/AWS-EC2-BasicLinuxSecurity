# Step 3 — IAM User & Custom Policy

This step creates a **human** IAM user with least-privilege console/CLI
access, separate from the EC2 instance's own access (which uses a Role —
see Step 4). This demonstrates the difference between user-based and
role-based access.

## 3.1 Create a least-privilege policy

1. IAM console → **Policies** → **Create policy**.
2. Switch to the **JSON** tab and paste the contents of
   [`configs/iam/iam-user-policy.json`](../configs/iam/iam-user-policy.json),
   replacing `<BUCKET_NAME>` with your actual bucket name (you can create
   the bucket now in S3 console if you haven't, e.g. `module17-lab-<yourname>-bucket`).
3. **Next** → Name: `Module17-S3-ReadOnly-UserPolicy` → **Create policy**.

This policy grants only:
- `s3:ListBucket` on the specific bucket
- `s3:GetObject` on objects inside that specific bucket

No `s3:*`, no wildcard resources, no access to any other bucket.

## 3.2 Create the IAM user

1. IAM console → **Users** → **Create user**.
2. Username: `module17-lab-user`.
3. Check **Provide user access to the AWS Management Console** if you want
   console login too (optional for this lab) — set a custom password,
   require reset on first login.
4. **Next: Permissions** → **Attach policies directly** → search for and
   select `Module17-S3-ReadOnly-UserPolicy`.
5. **Next** → **Create user**.

## 3.3 Enable MFA (recommended best practice)

1. Select the new user → **Security credentials** tab → **Assign MFA
   device**.
2. Choose **Authenticator app**, scan the QR code with an app (Google
   Authenticator, Authy, etc.), enter two consecutive codes → **Add MFA**.

## 3.4 Generate access keys (for local CLI testing only)

Access keys here are used **only to test from your local machine** to
contrast with the keyless role-based access you'll set up on EC2 in Step 5.
**Never put these keys on the EC2 instance.**

1. User → **Security credentials** → **Access keys** → **Create access key**.
2. Use case: **Command Line Interface (CLI)** → acknowledge the warning →
   **Create access key**.
3. Copy the Access Key ID and Secret Access Key (shown once) or download
   the `.csv`. **Do not commit these to git.**
4. Locally: `aws configure --profile module17-lab-user` and paste the
   keys in.
5. Test: `aws s3 ls s3://<BUCKET_NAME> --profile module17-lab-user` should
   succeed. `aws s3 ls` (listing **all** buckets) should fail with
   `AccessDenied` — proving least privilege is enforced.

## Screenshot checklist for this step

- [ ] `screenshots/03-iam-policy-json.png` — the custom policy's JSON tab
      in the IAM console.
- [ ] `screenshots/03-iam-user-created.png` — IAM user summary page
      showing the attached policy.
- [ ] `screenshots/03-mfa-enabled.png` — security credentials tab showing
      an MFA device assigned.
- [ ] `screenshots/03-cli-access-verified.png` — terminal showing
      `aws s3 ls s3://<BUCKET_NAME> --profile module17-lab-user` succeeding
      and `aws s3 ls --profile module17-lab-user` (all buckets) being
      denied.

Next: [`04-iam-role-for-ec2.md`](04-iam-role-for-ec2.md)
