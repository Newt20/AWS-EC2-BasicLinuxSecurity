# Security Group: `module17-lab-sg`

## Inbound rules

| Type | Protocol | Port range | Source | Description |
|---|---|---|---|---|
| SSH | TCP | 22 | `<YOUR_IP>/32` | Admin SSH access from a single known IP only |

> No other inbound rules. In particular, **no rule with source
> `0.0.0.0/0` or `::/0`** should exist unless a task genuinely requires
> public inbound traffic (e.g. testing a public web server), in which
> case add it explicitly and scope it to the minimum needed port
> (e.g. HTTP/80, HTTPS/443) — never widen SSH/RDP to the internet.

## Outbound rules

| Type | Protocol | Port range | Destination | Description |
|---|---|---|---|---|
| All traffic | All | All | `0.0.0.0/0` | Default allow-all outbound (needed for package updates, S3/STS HTTPS calls, etc.) |

## AWS CLI equivalents

```bash
# Create the security group
aws ec2 create-security-group \
  --group-name module17-lab-sg \
  --description "Module 17 lab - SSH restricted to admin IP" \
  --vpc-id <VPC_ID>

# Authorize inbound SSH from your IP only
aws ec2 authorize-security-group-ingress \
  --group-id <SG_ID> \
  --protocol tcp --port 22 \
  --cidr <YOUR_IP>/32

# Revoke an overly-permissive rule if one exists
aws ec2 revoke-security-group-ingress \
  --group-id <SG_ID> \
  --protocol tcp --port 22 \
  --cidr 0.0.0.0/0
```

## Notes

- Security Groups are **stateful** — a rule allowing inbound SSH
  automatically allows the corresponding outbound response traffic, no
  separate outbound rule is needed for the SSH reply.
- This is a network-layer control; it's paired with host-level UFW rules
  (see [`../ufw/setup-ufw.sh`](../ufw/setup-ufw.sh)) for defense in depth.
