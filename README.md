# Cost Optimization Framework

## Overview
Schedule non-production instances to shutdown during non-working hours, Cost Optimization Framework (COF) will allow you to schedule the instance shutdown and startup time. COF also provide ability to re-size instances based on their current utilization pattern.


## Pre-requiste

### 1. Instance tagging
Add tag to all the instances which will be shutdown/start using cost optimization framework.
```
shutdown: true
```
### 2. Authentication configuration

In Development environment, authentication is performed via a local YAML configuration file. Stored at default location `~/.cof/csp_auth.yaml` or `.cof/csp_auth.yaml`, however, authentication file path can be supplied at the runtime as script parameter to csp-authentication.sh script.

Authentication YAML format:
```
auth_configs:
  aws:
    access_key: xxxxxxxxxxxxxxxxxxxxxx
    secret_access_key: xxxxxxxxxxxxxxxxxxxxxx
    region: <region-name>
    output: json
  azure:
    tenant: "xxxxxxxxxxxxxxxxxxxxxx"
    subscription_id: "xxxxxxxxxxxxxxxxxxxxxx"
    client_id: "xxxxxxxxxxxxxxxxxxxxxx"
    client_secret: "xxxxxxxxxxxxxxxxxxxxxx"
```
> NOTE: You should have AWS and Azure account with appropriate permissions.

### 3. Configure mail server

Ensure mail server is configured on runner instance to send email. Follow instruction documented in [configure-gmail-stmp.md](./docs/configure-gmail-stmp.md) for configuring gmail smtp.

<br>

## Usage

Execute init script to either start/stop VMs.

```
init.sh --action stop

init.sh --action start

```
<br>

## Supported Cloud Vendors & Services Matrix
| CSP | Resource | Scheduled based | Event based | Resizing | Remark |
| --- | -------- | --------------- | ----------- | -------- | ------ |
| AWS | EC2      | Yes             | No          | No       | N/A    |
| AWS | ASG      | No              | No          | No       | N/A    |
| AWS | RDS        | No            | No          | No       | N/A    |
| Azure | VM       | Yes           | No          | No       | N/A    |
| Azure | VMSS     | No            | No          | No       | N/A    |
| Azure | AzureSQL | No            | No          | No       | N/A    |

## Contributor

## Future support

## License