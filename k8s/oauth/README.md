## Helm Chart for OAuth

### Getting Started

```bash
# Bootstrap the script
$ helm create example
# Delete files from example/templates dir
$ rm -rf example/templates
# REQUIRED: add the helper library as the dependency to support usage
$ helm repo add oauth https://raw.githubusercontent.com/EC-Release/helmcharts/disty/oauth/<version. E.g. "0.1.0"> -n namespace
$ helm repo list -n namespace
NAME         URL
oauth https://raw.githubusercontent.com/EC-Release/helmcharts/disty/oauth/0.1.0
```

#### Update Dependency List

```yaml
# add chart dependencies to example/Chart.yaml
dependencies:
# REQUIRED
- name: oauth
  version: 0.1.0
  repository: "@oauth"
```

```bash
# update chart repo index after modify the list
$ helm dependency update example -n namespace
```

#### Update the oauth config

```yaml
...
global:
  oauthConfig: |-
    AGENT_REV=temp_1.2-b.0.reiwa
    EC_AUTH_VALIDATE=sso
    EC_OAUTH_FAIL_URL=https://ng-portal.run.aws-usw02-dev.ice.predix.io/v1.2beta/ec
    EC_OIDC_AUTH_PATH=/fss/as/authorization.oauth2
    CA_PPRS={{CA_PPRS}}
    EC_OIDC_CID={{EC_OIDC_CID}}
    EC_OIDC_CSC={{EC_OIDC_CSC}}
    EC_PVTKEY={{EC_PVTKEY}}
    EC_OIDC_DOMAIN=https://fssfed.ge.com
    EC_OIDC_TOKEN_PATH=/fss/as/token.oauth2
    EC_OIDC_USER_PATH=https://fssfed.ge.com/fss/idp/userinfo.openid
    EC_PORT=:17990
    EC_SEED_HOST=https://ec-oauth-oidc-ci.digitalconnect.apps.ge.com/v1.2beta
    EC_SEED_NODE=https://ec-oauth-oidc-ci.digitalconnect.apps.ge.com/v1.2beta
    IsTimeController=true
```

#### Chart Installation

```bash
# Verify the configuration
$ helm template example example/ -n namespace
# Install the chart
$ helm install --debug|dry-run example example/ -n namespace
```

#### Parameters

OAuth configuration parameters - `global.oauthConfig`

| Parameter            | Description                                                     | 
| -------------------- | --------------------------------------------------------------- | 
| `AGENT_REV`          | `temp_1.2-b.0.reiwa`                                            | 
| `EC_AUTH_VALIDATE`   | `sso`                                                           | 
| `EC_OAUTH_FAIL_URL`  | `https://ng-portal.run.aws-usw02-dev.ice.predix.io/v1.2beta/ec` | 
| `EC_OIDC_AUTH_PATH`  | `/fss/as/authorization.oauth2`                                  | 
| `CA_PPRS`            | Owners hash to read from `oauth-owners-hash`                    | 
| `EC_OIDC_CID`        | OIDC client ID                                                  | 
| `EC_OIDC_CSC`        | OIDC client secret                                              | 
| `EC_PVTKEY`          | Developer private key                                           | 
| `EC_OIDC_DOMAIN`     | `https://fssfed.ge.com`                                         | 
| `EC_OIDC_TOKEN_PATH` | `/fss/as/token.oauth2`                                          | 
| `EC_OIDC_USER_PATH`  | `https://fssfed.ge.com/fss/idp/userinfo.openid`                 | 
| `EC_PORT`            | `17990`                                                         | 
| `EC_SEED_HOST`       | `https://{{DNS name / Ingress URL}}/v1.2beta`                   | 
| `EC_SEED_NODE`       | `https://{{DNS name / Ingress URL}}/v1.2beta`                   | 
| `IsTimeController`   | `false`                                                         | 
