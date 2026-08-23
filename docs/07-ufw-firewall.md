# Step 7 — UFW Host-Level Firewall

UFW (Uncomplicated Firewall) adds an **OS-level** firewall on top of the
Security Group's **network-level** control — defense in depth: even if a
Security Group is ever misconfigured, the host itself still enforces
rules.

> **Amazon Linux note**: Amazon Linux 2/2023 does not ship UFW by default
> and typically uses `firewalld` instead. If you launched Amazon Linux in
> Step 1, either `sudo yum install -y ufw` (may require EPEL) or use
> `firewalld` equivalents (`firewall-cmd --add-service=ssh --permanent`,
> etc.). The steps below assume **Ubuntu**, which ships UFW.

## 7.1 Install and inspect UFW

```bash
sudo apt update
sudo apt install -y ufw
sudo ufw status verbose   # should show "Status: inactive" initially
```

## 7.2 Set default policies (deny in, allow out)

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

## 7.3 Explicitly allow only what's needed, before enabling

**Critical**: allow SSH *before* enabling UFW, or enabling it will lock
you out of your own SSH session.

```bash
sudo ufw allow OpenSSH        # or: sudo ufw allow 22/tcp
sudo ufw limit OpenSSH        # rate-limits repeated connection attempts (basic brute-force mitigation)
```

Run the setup script (same commands, scripted) instead if you prefer:

```bash
scp -i module17-lab-key.pem configs/ufw/setup-ufw.sh ubuntu@<INSTANCE_PUBLIC_IP>:~
ssh -i module17-lab-key.pem ubuntu@<INSTANCE_PUBLIC_IP>
chmod +x setup-ufw.sh
sudo ./setup-ufw.sh
```

## 7.4 Enable UFW

```bash
sudo ufw enable   # confirm "y" — reminds you it may disrupt existing SSH; that's expected, OpenSSH is already allowed
sudo ufw status verbose
```

Expected output includes:

```
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)

To                         Action      From
--                         ------      ----
OpenSSH                    LIMIT       Anywhere
OpenSSH (v6)                LIMIT       Anywhere (v6)
```

## 7.5 Verify from a second terminal (don't close the first)

```bash
ssh -i module17-lab-key.pem ubuntu@<INSTANCE_PUBLIC_IP> "sudo ufw status"
```

Confirm SSH still works, then optionally test that a random unopened port
(e.g. 8080) is blocked:

```bash
# from your local machine
nc -vz <INSTANCE_PUBLIC_IP> 8080   # expect: connection refused/timed out
```

## Screenshot checklist for this step

- [ ] `screenshots/07-ufw-status-active.png` — `sudo ufw status verbose`
      showing active status, default deny incoming, and the SSH allow/limit
      rule.
- [ ] `screenshots/07-ufw-ssh-still-works.png` — a fresh SSH session
      succeeding after UFW is enabled.
- [ ] `screenshots/07-ufw-blocks-other-port.png` — an unopened port being
      refused/blocked from outside.

Next: [`08-verification-checklist.md`](08-verification-checklist.md)
