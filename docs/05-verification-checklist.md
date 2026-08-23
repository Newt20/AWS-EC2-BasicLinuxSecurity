# Step 5 — Final Verification Checklist

Use this as the submission checklist. Every box should map to a
screenshot saved in [`screenshots/`](../screenshots/) with the exact
filename shown (referenced from each step's doc too).

## 1. EC2 Instance
- [ ] `01-instance-running.png`
- [ ] `01-ssh-connect-success.png`

## 2. Security Group
- [ ] `02-security-group-inbound-rules.png`
- [ ] `02-ssh-blocked-external.png`

## 3. SSH Hardening
- [ ] `03-sshd-config-applied.png`
- [ ] `03-root-login-denied.png`
- [ ] `03-password-auth-denied.png`
- [ ] `03-key-login-still-works.png`

## 4. UFW Firewall
- [ ] `04-ufw-status-active.png`
- [ ] `04-ufw-ssh-still-works.png`
- [ ] `04-ufw-blocks-other-port.png`

## One-shot command summary (run on the EC2 instance, capture output)

```bash
echo "== SSH hardening applied =="
sudo sshd -T | egrep 'permitrootlogin|passwordauthentication|permitemptypasswords'

echo "== UFW active =="
sudo ufw status verbose
```

Save this combined output as `screenshots/05-full-verification-output.png`
(or `.txt` alongside the screenshots) as a single consolidated proof.

## Cleanup (after grading/submission, to avoid charges)

```bash
# Terminate the instance
aws ec2 terminate-instances --instance-ids <INSTANCE_ID>
```

(Console equivalent: EC2 → Instances → select instance → **Instance
state** → **Terminate instance**.)
