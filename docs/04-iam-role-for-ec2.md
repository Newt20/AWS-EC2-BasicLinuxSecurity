# Step 4 — IAM Role for EC2 (keyless S3 access)

Instead of storing an access key/secret on the instance, EC2 can **assume
an IAM Role** via its **instance profile**. AWS automatically rotates the
temporary credentials (delivered via the instance metadata service) — the
application/CLI never sees a long-lived key.

## 4.1 Create the role

1. IAM console → **Roles** → **Create role**.
2. Trusted entity type: **AWS service**.
3. Use case: **EC2** → **Next**.
   (This auto-generates the trust policy in
   [`configs/iam/ec2-trust-policy.json`](../configs/iam/ec2-trust-policy.json) —
   it allows the `ec2.amazonaws.com` service principal to assume this role.)
4. **Add permissions**: create/attach a customer-managed policy using
   [`configs/iam/ec2-s3-readonly-policy.json`](../configs/iam/ec2-s3-readonly-policy.json)
   (same least-privilege pattern as Step 3: `ListBucket` + `GetObject` on
   one specific bucket only). You can reuse the same policy JSON as the
   user policy, or create a separate one named
   `Module17-S3-ReadOnly-RolePolicy` for clarity.
5. Role name: `module17-ec2-s3-role`.
6. **Create role**.

## 4.2 Attach the role to the running EC2 instance

1. EC2 console → **Instances** → select `module17-lab-instance`.
2. **Actions** → **Security** → **Modify IAM role**.
3. Choose `module17-ec2-s3-role` → **Update IAM role**.

(If you're launching a fresh instance instead, you can select the role
directly under **Advanced details → IAM instance profile** during launch.)

## Why a Role instead of a User's access keys

| | Access key on disk | IAM Role (instance profile) |
|---|---|---|
| Credential lifetime | Long-lived until manually rotated/revoked | Short-lived (auto-rotated by AWS, hours) |
| Exposure if instance compromised | Attacker gets a durable, reusable secret | Attacker gets a temporary credential tied to the instance |
| Storage | Must be stored somewhere on disk/env (leak risk) | Never stored — fetched on demand from instance metadata |
| Rotation | Manual | Automatic |

This is why "S3 access from EC2 without access keys" is the target state,
and is what Step 5 verifies.

## Screenshot checklist for this step

- [ ] `screenshots/04-iam-role-trust-policy.png` — the role's **Trust
      relationships** tab showing `ec2.amazonaws.com` as trusted principal.
- [ ] `screenshots/04-iam-role-permissions.png` — the role's **Permissions**
      tab showing the attached S3 read-only policy.
- [ ] `screenshots/04-role-attached-to-instance.png` — EC2 instance
      details showing **IAM Role = module17-ec2-s3-role** under the
      Security tab.

Next: [`05-s3-access-from-ec2.md`](05-s3-access-from-ec2.md)
