## Helm Chart for EC Service

### Getting Started

```bash
# Bootstrap the script
$ helm create example
# Delete files from example/templates dir
$ rm -rf example/templates
# REQUIRED: add the helper library as the dependency to support usage
$ helm repo add ec-service https://raw.githubusercontent.com/EC-Release/helmcharts/disty/ec-service/<version. E.g. "0.1.0"> -n namespace
$ helm repo list -n namespace
NAME         URL
ec-service https://raw.githubusercontent.com/EC-Release/helmcharts/disty/ec-service/0.1.0
```

#### Update Dependency List

```yaml
# add chart dependencies to example/Chart.yaml
dependencies:
# REQUIRED
- name: ec-service
  version: 0.1.0
  repository: "@ec-service"
```

```bash
# update chart repo index after modify the list
$ helm dependency update example -n namespace
```

#### Update the ec service config

```yaml
...
global:
  ecServiceConfig: |-
    EC_SVC_ID={my-test-id}
    EC_SVC_URL={my-test-url}
    EC_SVC_NAT_URL=http://{ec-k8s-svc-name}.{namespace}.svc.cluster.local:18090
    EC_ADM_TKN={my-legacy-cf-admin-token}
    EC_SAC_URL=http://{sac-svc-name}.{namespace}.svc.cluster.local:18090
    EC_ATH_URL=http://{auth-svc-name}.{namespace}.svc.cluster.local:18090
    EC_CID={cid-for-sac}
    EC_CSC={csc-for-sac}
    EC_SCRIPT_1={EC_SCRIPT_1}
    EC_SCRIPT_2={EC_SCRIPT_2}
    EC_SCRIPT_3={EC_SCRIPT_3}
    EC_SETTING={EC_SETTING}
```

#### Chart Installation

```bash
# Verify the configuration
$ helm template example example/ -n namespace
# Install the chart
$ helm install --debug|dry-run example example/ -n namespace
```

#### Parameters

EC Service configuration parameters - `global.ecServiceConfig`

| Parameter     | Description                                                                                      | 
| ------------- | ------------------------------------------------------------------------------------------------ | 
| `EC_SVC_ID`   | EC Service id (Zone id)                                                                          | 
| `EC_SVC_URL`  | EC Service URI - ex: `https://{zone-id}.digitalconnect.apps.ge.com`                              |
| `EC_SVC_NAT_URL` | EC Service NAT URL - ex: `http://{ec-k8s-svc-name}.{namespace}.svc.cluster.local:18090`       |
| `EC_ADM_TKN`  | EC Service legacy admin token                                                                    | 
| `EC_SAC_URL`  | SAC application URI - ex: `http://{sac-svc-name}.{namespace}.svc.cluster.local:18090`            | 
| `EC_ATH_URL`  | OAuth application URI for SAC - ex: `http://{auth-svc-name}.{namespace}.svc.cluster.local:18090` | 
| `EC_CID`      | OAuth client ID to authenticate SAC application                                                  | 
| `EC_CSC`      | OAuth client secret to authenticate SAC application                                              | 
| `EC_SCRIPT_1` | EC_SCRIPT_1                                                                                      | 
| `EC_SCRIPT_2` | EC_SCRIPT_2                                                                                      | 
| `EC_SCRIPT_3` | EC_SCRIPT_3                                                                                      |
| `EC_SETTING`  | EC accounts information                                                                          |
