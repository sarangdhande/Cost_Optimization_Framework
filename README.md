# Cost Optimization Framework

## Overview
Schedule non-production instances to shutdown during non-working hours, Cost Optimization Framework (COF) will allow you to schedule the instance shutdown and startup time. COF also provide ability to re-size instances based on their current utilization pattern.


## Pre-requiste

### 1. Instance tagging
Information to be updated

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