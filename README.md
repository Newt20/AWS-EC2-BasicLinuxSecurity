# AWS EC2 Security Practice Lab

Hands-on lab covering EC2 launch, Security Groups, and basic Linux
hardening (SSH + UFW).

## Objectives

1. Launch an EC2 instance
2. Restrict access with a Security Group (SSH from your IP only)
3. Harden SSH (key-only auth, no root login)
4. Configure UFW as a host-level firewall


## Key security principles applied

- **Network defense in depth** — Security Group (stateful, instance-level,
  AWS-managed) + UFW (host-level, OS-managed) both restrict traffic.
- **Reduced SSH attack surface** — key-based auth only, no root login, SSH
  restricted to a single known source IP at the Security Group layer.

## Screenshots

![Instance running](screenshots/01-instance-running.png)
![SSH connect success](screenshots/01-ssh-connect-success.png)
![Security group inbound rules](screenshots/02-security-group-inbound-rules.png)
![sshd config applied](screenshots/03-sshd-config-applied.png)
![Root password auth denies](screenshots/03-root-passwdAuth-denies.png)
![UFW status active](screenshots/04-ufw-status-active.png)
![UFW SSH still works](screenshots/04-ufw-ssh-still-works.png)

