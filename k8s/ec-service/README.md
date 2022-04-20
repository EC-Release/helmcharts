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

Only necessary fields to update were added here. For complete configuration please refer to values.yaml file.

```yaml
...
global:
  # ConfigMap name with ec root certs
  ecCertsConfigmapName: {ecCertsConfigmapName}
  # Secret name with CID and CSC secrets
  ecSecretName: {ecSecretName}
  efsPersistence:
    # Persistence volume claim name for EC service accounts information (ec-setting)
    pvc: {pvc | ec-eng-efs-pvc}
    mountPath: /root/svcs
    subPath: {ci|preprod|prod}/svcs/{ec-svc-id}
  ecServiceK8Config:
    replicaCount: {ec-svc-replicacount}
    withIngress:
      hosts:
        host: {ec-svc-dns-name}
  ecServiceConfig: |-
    EC_SAC_MSTR_URL={sac-master-url}
    EC_SAC_SLAV_URL={sac-slave-url}
    EC_SVC_URL={ec-svc-url}
    ADMIN_USR=admin
    ADMIN_TKN={ec-legacy-cf-admin-token}
    EC_SETTING={ec-settings}
    EC_SVC_ID={ec-svc-id}
    EC_PORT=:7990
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

| Parameter         | Description                                                                             | 
|-------------------|-----------------------------------------------------------------------------------------| 
| `EC_SAC_MSTR_URL` | SAC Master application URI - ex: `http://{sac-mstr-name}.{namespace}.svc.cluster.local` |
| `EC_SAC_SLAV_URL` | SAC Slave application URI - ex: `http://{sac-slav-name}.{namespace}.svc.cluster.local`  |
| `EC_SVC_URL`      | EC Service URI - ex: `https://{zone-id}.digitalconnect.apps.ge.com`                     |
| `ADMIN_USR`       | EC Service legacy admin user. Default value: `admin`                                    |
| `ADMIN_TKN`       | EC Service legacy admin token                                                           |
| `EC_SETTING`      | EC accounts information                                                                 |
| `EC_SVC_ID`       | EC Service id (Zone id)                                                                 |
| `EC_PORT`         | EC Service container port. Default value: `7990`                                        |

