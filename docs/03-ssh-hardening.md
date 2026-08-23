# Step 3 — SSH Hardening

Still SSH'd into the instance as `ubuntu` (or `ec2-user`).

## 3.1 Confirm key-based auth already works before disabling passwords

```bash
ssh -i module17-lab-key.pem ubuntu@<INSTANCE_PUBLIC_IP> "echo key-auth-ok"
```

Don't proceed until this succeeds — disabling password auth before
confirming key auth works risks locking yourself out.

## 3.2 Apply the hardening config

Rather than editing `/etc/ssh/sshd_config` directly, drop a config file
into `/etc/ssh/sshd_config.d/` (Ubuntu's `sshd_config` includes this
directory by default, and files here take precedence, keeping the change
isolated and easy to review/revert).

```bash
sudo cp 99-hardening.conf /etc/ssh/sshd_config.d/99-hardening.conf
```

(Copy the file up first, e.g. `scp -i module17-lab-key.pem
configs/ssh/99-hardening.conf ubuntu@<INSTANCE_PUBLIC_IP>:~`, or
recreate it on the instance with the contents of
[`configs/ssh/99-hardening.conf`](../configs/ssh/99-hardening.conf).)

Key settings applied (see the file for the full list):

| Setting | Value | Why |
|---|---|---|
| `PermitRootLogin` | `no` | Root can't be targeted directly over SSH; must `sudo` after logging in as a normal user, which is logged and auditable. |
| `PasswordAuthentication` | `no` | Eliminates brute-force password guessing entirely; key-only auth. |
| `PermitEmptyPasswords` | `no` | Defense in depth even though passwords are already disabled. |
| `ChallengeResponseAuthentication` | `no` | Disables keyboard-interactive fallback that could reintroduce password-like prompts. |
| `MaxAuthTries` | `3` | Limits brute-force attempts per connection before disconnect. |
| `ClientAliveInterval` / `ClientAliveCountMax` | `300` / `2` | Drops idle/dead sessions automatically. |
| `X11Forwarding` | `no` | Not needed for this lab; reduces attack surface. |
| `AllowUsers` | `ubuntu` | Restricts SSH login to a named allow-list of users only. |

## 3.3 Validate config syntax, then restart sshd

```bash
sudo sshd -t                 # syntax check — no output means OK
sudo systemctl restart ssh   # Ubuntu service name is "ssh" (Amazon Linux: "sshd")
sudo systemctl status ssh
```

## 3.4 Verify from a **second terminal without closing the first**

Keep your original SSH session open in case something's wrong.

```bash
# Should succeed (key-based)
ssh -i module17-lab-key.pem ubuntu@<INSTANCE_PUBLIC_IP> "whoami"

# Should be refused — root login disabled
ssh root@<INSTANCE_PUBLIC_IP>

# Should be refused — password auth disabled (no key offered)
ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no \
  ubuntu@<INSTANCE_PUBLIC_IP>
```

Only close your original session once the new-terminal key-based login is
confirmed working.

## (Optional) fail2ban for extra brute-force protection

```bash
sudo apt install -y fail2ban
sudo systemctl enable --now fail2ban
sudo fail2ban-client status sshd
```

## Screenshot checklist for this step

- [ ] `screenshots/03-sshd-config-applied.png` — `cat
      /etc/ssh/sshd_config.d/99-hardening.conf` on the instance.
- [ ] `screenshots/03-root-login-denied.png` — `ssh root@<IP>` being
      refused.
- [ ] `screenshots/03-password-auth-denied.png` — password auth attempt
      being refused.
- [ ] `screenshots/03-key-login-still-works.png` — key-based login still
      succeeding after hardening.

Next: [`04-ufw-firewall.md`](04-ufw-firewall.md)
