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
    port={{port}}
    privateKey={{encrypted-private-key}}
    publicCert={{encrypted-public-key}}
    authValidate={{oidc|oaep}}
    oidcDomain={{ex: https://helloOauthDomain.com}}
    oidcAuthPath={{/authorize}}
    oidcTokenPath={{/oauth/token}}
    oidcUserPath={{oidc-user-path|""}}
    oidcCid={{oidc-cid|""}}
    oidcCsc={{oidc-csc|""}}
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

| Parameter         | Description                           | Allowed values                            |
| ----------------- | ------------------------------------- | ---------------------------------------   |
| `port`            |                                       |                                           |
| `privateKey`      |                                       |                                           |
| `publicCert`      |                                       |                                           |
| `authValidate`    |                                       |                                           |
| `oidcDomain`      |                                       |                                           |
| `oidcAuthPath`    |                                       |                                           |
| `oidcTokenPath`   |                                       |                                           |
| `oidcUserPath`    |                                       |                                           |
| `oidcCid`         |                                       |                                           |
| `oidcCsc`         |                                       |                                           |
