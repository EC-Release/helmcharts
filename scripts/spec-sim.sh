#!/bin/bash

#kubectl cluster-info
helm version
echo $(pwd)

printf "\n\n\n*** update the pkg chart params \n"
eval "sed -i -e 's#<AGENT_HELPER_CHART_REV>#${AGENT_HELPER_CHART_REV}#g' k8s/agent+helper/Chart.yaml"
eval "sed -i -e 's#<AGENT_CHART_REV>#${AGENT_CHART_REV}#g' k8s/agent/Chart.yaml"
eval "sed -i -e 's#<AGENT_HELPER_CHART_REV>#${AGENT_HELPER_CHART_REV}#g' k8s/agent/Chart.yaml"
eval "sed -i -e 's#<AGENT_PLG_CHART_REV>#${AGENT_PLG_CHART_REV}#g' k8s/agent+plg/Chart.yaml"
eval "sed -i -e 's#<AGENT_HELPER_CHART_REV>#${AGENT_HELPER_CHART_REV}#g' k8s/agent+plg/Chart.yaml"
eval "sed -i -e 's#<AGENT_LBER_CHART_REV>#${AGENT_LBER_CHART_REV}#g' k8s/agent+lber/Chart.yaml"
eval "sed -i -e 's#<AGENT_HELPER_CHART_REV>#${AGENT_HELPER_CHART_REV}#g' k8s/agent+lber/Chart.yaml"
eval "sed -i -e 's#<OAUTH_CHART_REV>#${OAUTH_CHART_REV}#g' k8s/oauth/Chart.yaml"
eval "sed -i -e 's#<AGENT_WEBPORTAL_CHART_REV>#${AGENT_WEBPORTAL_CHART_REV}#g' k8s/webportal/Chart.yaml"
eval "sed -i -e 's#<EC_SERVICE_CHART_REV>#${EC_SERVICE_CHART_REV}#g' k8s/ec-service/Chart.yaml"
eval "sed -i -e 's#<AGENT_HELPER_CHART_REV>#${AGENT_HELPER_CHART_REV}#g' k8s/examples/agent/Chart.yaml"
eval "sed -i -e 's#<AGENT_PLG_CHART_REV>#${AGENT_PLG_CHART_REV}#g' k8s/examples/agent/Chart.yaml"
eval "sed -i -e 's#<AGENT_CHART_REV>#${AGENT_CHART_REV}#g' k8s/examples/agent/Chart.yaml"
eval "sed -i -e 's#<AGENT_LBER_CHART_REV>#${AGENT_LBER_CHART_REV}#g' k8s/examples/lber/Chart.yaml"
eval "sed -i -e 's#<OAUTH_CHART_REV>#${OAUTH_CHART_REV}#g' k8s/examples/oauth/Chart.yaml"
eval "sed -i -e 's#<AGENT_WEBPORTAL_CHART_REV>#${AGENT_WEBPORTAL_CHART_REV}#g' k8s/examples/webportal/Chart.yaml"
eval "sed -i -e 's#<EC_SERVICE_CHART_REV>#${EC_SERVICE_CHART_REV}#g' k8s/examples/ec-service/Chart.yaml"

cat k8s/agent+helper/Chart.yaml k8s/agent/Chart.yaml k8s/agent+plg/Chart.yaml k8s/agent+lber/Chart.yaml k8s/oauth/Chart.yaml k8s/webportal/Chart.yaml k8s/ec-service/Chart.yaml
cat k8s/examples/agent/Chart.yaml k8s/examples/lber/Chart.yaml k8s/examples/oauth/Chart.yaml k8s/examples/webportal/Chart.yaml k8s/examples/ec-service/Chart.yaml

printf "\n\n\n*** update server+tls.env \n"
eval "sed -i -e 's#{{EC_TEST_OA2}}#${EC_TEST_OA2}#g' k8s/examples/agent/server+tls.env"
eval "sed -i -e 's#{{EC_TEST_AID}}#${EC_TEST_AID}#g' k8s/examples/agent/server+tls.env"
eval "sed -i -e 's#{{EC_TEST_TKN}}#${EC_TEST_TKN}#g' k8s/examples/agent/server+tls.env"
eval "sed -i -e 's#{{EC_TEST_SST}}#${EC_TEST_SST}#g' k8s/examples/agent/server+tls.env"
eval "sed -i -e 's#{{EC_TEST_HST}}#${EC_TEST_HST}#g' k8s/examples/agent/server+tls.env"
eval "sed -i -e 's#{{EC_TEST_ZON}}#${EC_TEST_ZON}#g' k8s/examples/agent/server+tls.env"
eval "sed -i -e 's#{{EC_TEST_GRP}}#${EC_TEST_GRP}#g' k8s/examples/agent/server+tls.env"
eval "sed -i -e 's#{{EC_TEST_CID}}#${EC_TEST_CID}#g' k8s/examples/agent/server+tls.env"
eval "sed -i -e 's#{{EC_TEST_CSC}}#${EC_TEST_CSC}#g' k8s/examples/agent/server+tls.env"

printf "\n\n\n*** update client+vln.env \n"
eval "sed -i -e 's#{{EC_TEST_OA2}}#${EC_TEST_OA2}#g' k8s/examples/agent/client+vln.env"
eval "sed -i -e 's#{{EC_TEST_ZON}}#${EC_TEST_ZON}#g' k8s/examples/agent/client+vln.env"
eval "sed -i -e 's#{{EC_TEST_GRP}}#${EC_TEST_GRP}#g' k8s/examples/agent/client+vln.env"
eval "sed -i -e 's#{{EC_TEST_CID}}#${EC_TEST_CID}#g' k8s/examples/agent/client+vln.env"
eval "sed -i -e 's#{{EC_TEST_CSC}}#${EC_TEST_CSC}#g' k8s/examples/agent/client+vln.env"

printf "\n\n\n*** update agent/gateway.env \n"
eval "sed -i -e 's#{{EC_TEST_ZON}}#${EC_TEST_ZON}#g' k8s/examples/agent/gateway.env"
eval "sed -i -e 's#{{EC_TEST_GRP}}#${EC_TEST_GRP}#g' k8s/examples/agent/gateway.env"
eval "sed -i -e 's#{{EC_TEST_SST}}#${EC_TEST_SST}#g' k8s/examples/agent/gateway.env"
eval "sed -i -e 's#{{EC_TEST_TKN}}#${EC_TEST_TKN}#g' k8s/examples/agent/gateway.env"

printf "\n\n\n*** update lber/gateway.env \n"
eval "sed -i -e 's#{{EC_TEST_ZON}}#${EC_TEST_ZON}#g' k8s/examples/lber/gateway.env"
eval "sed -i -e 's#{{EC_TEST_GRP}}#${EC_TEST_GRP}#g' k8s/examples/lber/gateway.env"
eval "sed -i -e 's#{{EC_TEST_SST}}#${EC_TEST_SST}#g' k8s/examples/lber/gateway.env"
eval "sed -i -e 's#{{EC_TEST_TKN}}#${EC_TEST_TKN}#g' k8s/examples/lber/gateway.env"

printf "\n\n\n*** update oauth.env \n"
eval "sed -i -e 's#{{CA_PPRS}}#${CA_PPRS}#g' k8s/examples/oauth/oauth.env"
eval "sed -i -e 's#{{EC_OIDC_CID}}#${EC_OIDC_CID}#g' k8s/examples/oauth/oauth.env"
eval "sed -i -e 's#{{EC_OIDC_CSC}}#${EC_OIDC_CSC}#g' k8s/examples/oauth/oauth.env"
eval "sed -i -e 's#{{EC_PVTKEY}}#${EC_PVTKEY}#g' k8s/examples/oauth/oauth.env"

printf "\n\n\n*** update webportal.env \n"
eval "sed -i -e 's#{{EC_PORT}}#${EC_PORT}#g' k8s/examples/webportal/webportal.env"
eval "sed -i -e 's#{{EC_OAUTH_URL}}#${EC_OAUTH_URL}#g' k8s/examples/webportal/webportal.env"
eval "sed -i -e 's#{{EC_CID}}#${EC_CID}#g' k8s/examples/webportal/webportal.env"
eval "sed -i -e 's#{{EC_CSC}}#${EC_CSC}#g' k8s/examples/webportal/webportal.env"

printf "\n\n\n*** update ec-service.env \n"
eval "sed -i -e 's#{{EC_SVC_ID}}#${EC_SVC_ID}#g' k8s/examples/ec-service/ec-service.env"
eval "sed -i -e 's#{{EC_SVC_URL}}#${EC_SVC_URL}#g' k8s/examples/ec-service/ec-service.env"
eval "sed -i -e 's#{{EC_SVC_NAT_URL}}#${EC_SVC_NAT_URL}#g' k8s/examples/ec-service/ec-service.env"
eval "sed -i -e 's#{{EC_ADM_TKN}}#${EC_ADM_TKN}#g' k8s/examples/ec-service/ec-service.env"
eval "sed -i -e 's#{{EC_SAC_URL}}#${EC_SAC_URL}#g' k8s/examples/ec-service/ec-service.env"
eval "sed -i -e 's#{{EC_ATH_URL}}#${EC_ATH_URL}#g' k8s/examples/ec-service/ec-service.env"
eval "sed -i -e 's#{{EC_CID}}#${EC_CID}#g' k8s/examples/ec-service/ec-service.env"
eval "sed -i -e 's#{{EC_CSC}}#${EC_CSC}#g' k8s/examples/ec-service/ec-service.env"
eval "sed -i -e 's#{{EC_SCRIPT_1}}#${EC_SCRIPT_1}#g' k8s/examples/ec-service/ec-service.env"
eval "sed -i -e 's#{{EC_SCRIPT_2}}#${EC_SCRIPT_2}#g' k8s/examples/ec-service/ec-service.env"
eval "sed -i -e 's#{{EC_SCRIPT_3}}#${EC_SCRIPT_3}#g' k8s/examples/ec-service/ec-service.env"
eval "sed -i -e 's#{{EC_SETTING}}#${EC_SETTING}#g' k8s/examples/ec-service/ec-service.env"


printf "\n\n\n*** packaging w/ dependencies (ec-release/oci) \n"
mkdir -p k8s/pkg/agent/$AGENT_CHART_REV k8s/pkg/agent+helper/$AGENT_HELPER_CHART_REV k8s/pkg/agent+plg/$AGENT_PLG_CHART_REV k8s/pkg/agent+lber/$AGENT_LBER_CHART_REV k8s/pkg/oauth/$OAUTH_CHART_REV k8s/pkg/webportal/$AGENT_WEBPORTAL_CHART_REV k8s/pkg/ec-service/$EC_SERVICE_CHART_REV

ls -la k8s/pkg
helm package k8s/agent+helper -d k8s/pkg/agent+helper/$AGENT_HELPER_CHART_REV
helm package k8s/oauth -d k8s/pkg/oauth/$OAUTH_CHART_REV
helm package k8s/webportal -d k8s/pkg/webportal/$AGENT_WEBPORTAL_CHART_REV
helm package k8s/ec-service -d k8s/pkg/ec-service/$EC_SERVICE_CHART_REV

helm dependency update k8s/agent
helm dependency update k8s/agent+plg
helm dependency update k8s/agent+lber
helm package k8s/agent -d k8s/pkg/agent/$AGENT_CHART_REV
helm package k8s/agent+plg -d k8s/pkg/agent+plg/$AGENT_PLG_CHART_REV
helm package k8s/agent+lber -d k8s/pkg/agent+lber/$AGENT_LBER_CHART_REV

printf "update dependencies in examples charts for test"
helm dependency update k8s/examples/agent
ls -la k8s/examples/agent/charts/
helm dependency update k8s/examples/lber
ls -la k8s/examples/lber/charts/
helm dependency update k8s/examples/oauth
ls -la k8s/examples/oauth/charts/
helm dependency update k8s/examples/webportal
ls -la k8s/examples/webportal/charts/
helm dependency update k8s/examples/ec-service
ls -la k8s/examples/ec-service/charts/

printf "\n\n\n*** test oauth template\n"
helm template k8s/examples/oauth --debug --set-file global.oauthConfig=k8s/examples/oauth/oauth.env

printf "\n\n\n*** test webportal\n"
helm template k8s/examples/webportal --debug --set-file global.webportalConfig=k8s/examples/webportal/webportal.env

printf "\n\n\n*** test ec-service\n"
helm template k8s/examples/ec-service --debug --set-file global.ecServiceConfig=k8s/examples/ec-service/ec-service.env

#printf "\n\n\n*** test server with tls template\n"
#yq e '.global.agtK8Config.withPlugins.tls.enabled = true' -i k8s/examples/agent/values.yaml
#yq e '.global.agtK8Config.withPlugins.vln.enabled = false' -i k8s/examples/agent/values.yaml
#helm template k8s/examples/agent --debug --set-file global.agtConfig=k8s/examples/agent/server+tls.env
#
#printf "\n\n\n*** test client with local vln template\n"
#yq e '.global.agtK8Config.withPlugins.tls.enabled = false' -i k8s/examples/agent/values.yaml
#yq e '.global.agtK8Config.withPlugins.vln.enabled = true' -i k8s/examples/agent/values.yaml
#yq e '.global.agtK8Config.withPlugins.vln.remote = false' -i k8s/examples/agent/values.yaml
#helm template k8s/examples/agent --debug --set-file global.agtConfig=k8s/examples/agent/client+vln.env
#
#printf "\n\n\n*** test client with remote vln template\n"
#yq e '.global.agtK8Config.withPlugins.tls.enabled = false' -i k8s/examples/agent/values.yaml
#yq e '.global.agtK8Config.withPlugins.vln.enabled = true' -i k8s/examples/agent/values.yaml
#yq e '.global.agtK8Config.withPlugins.vln.remote = true' -i k8s/examples/agent/values.yaml
#helm template k8s/examples/agent --debug --set-file global.agtConfig=k8s/examples/agent/client+vln.env

printf "\n\n\n*** test agent/gateway agt template\n"
helm template k8s/examples/agent --debug --set-file global.agtConfig=k8s/examples/agent/gateway.env

printf "\n\n\n*** test lber/gateway agt template\n"
helm template k8s/examples/lber --debug --set-file global.agtConfig=k8s/examples/lber/gateway.env

printf "\n\n\n*** pkg indexing (ec-release/oci)\n"
#https://raw.githubusercontent.com/EC-Release/helmcharts/disty/agent/0.1.7
helm repo index k8s/pkg/agent/$AGENT_CHART_REV --url https://ec-release.github.io/oci/agent/$AGENT_CHART_REV
helm repo index k8s/pkg/agent+helper/$AGENT_HELPER_CHART_REV --url https://ec-release.github.io/oci/agent+helper/$AGENT_HELPER_CHART_REV
helm repo index k8s/pkg/agent+plg/$AGENT_PLG_CHART_REV --url https://ec-release.github.io/oci/agent+plg/$AGENT_PLG_CHART_REV
helm repo index k8s/pkg/agent+lber/$AGENT_LBER_CHART_REV --url https://ec-release.github.io/oci/agent+lber/$AGENT_LBER_CHART_REV
helm repo index k8s/pkg/oauth/$OAUTH_CHART_REV --url https://ec-release.github.io/oci/oauth/$OAUTH_CHART_REV
helm repo index k8s/pkg/webportal/$AGENT_WEBPORTAL_CHART_REV --url https://ec-release.github.io/oci/webportal/$AGENT_WEBPORTAL_CHART_REV
helm repo index k8s/pkg/ec-service/$EC_SERVICE_CHART_REV --url https://ec-release.github.io/oci/ec-service/$EC_SERVICE_CHART_REV


printf "\n\n\n*** packaging w/ dependencies (ec-release/helmcharts)\n"
mkdir -p k8s/pkg-new/agent/$AGENT_CHART_REV k8s/pkg-new/agent+helper/$AGENT_HELPER_CHART_REV k8s/pkg-new/agent+plg/$AGENT_PLG_CHART_REV k8s/pkg-new/agent+lber/$AGENT_LBER_CHART_REV k8s/pkg-new/oauth/$OAUTH_CHART_REV k8s/pkg-new/webportal/$AGENT_WEBPORTAL_CHART_REV k8s/pkg-new/ec-service/$EC_SERVICE_CHART_REV

cp -R k8s/pkg/* k8s/pkg-new
ls -la k8s/pkg-new
helm package k8s/agent+helper -d k8s/pkg-new/agent+helper/$AGENT_HELPER_CHART_REV
helm package k8s/oauth -d k8s/pkg-new/oauth/$OAUTH_CHART_REV
helm package k8s/webportal -d k8s/pkg-new/webportal/$AGENT_WEBPORTAL_CHART_REV
helm package k8s/ec-service -d k8s/pkg-new/ec-service/$EC_SERVICE_CHART_REV

helm dependency update k8s/agent
helm dependency update k8s/agent+plg
helm dependency update k8s/agent+lber
helm package k8s/agent -d k8s/pkg-new/agent/$AGENT_CHART_REV
helm package k8s/agent+plg -d k8s/pkg-new/agent+plg/$AGENT_PLG_CHART_REV
helm package k8s/agent+lber -d k8s/pkg-new/agent+lber/$AGENT_LBER_CHART_REV

printf "\n\n\n*** pkg indexing (ec-release/helmcharts)\n"
helm repo index k8s/pkg-new/agent/$AGENT_CHART_REV --url https://raw.githubusercontent.com/EC-Release/helmcharts/disty/agent/$AGENT_CHART_REV
helm repo index k8s/pkg-new/agent+helper/$AGENT_HELPER_CHART_REV --url https://raw.githubusercontent.com/EC-Release/helmcharts/disty/agent+helper/$AGENT_HELPER_CHART_REV
helm repo index k8s/pkg-new/agent+plg/$AGENT_PLG_CHART_REV --url https://raw.githubusercontent.com/EC-Release/helmcharts/disty/agent+plg/$AGENT_PLG_CHART_REV
helm repo index k8s/pkg-new/agent+lber/$AGENT_LBER_CHART_REV --url https://raw.githubusercontent.com/EC-Release/helmcharts/disty/agent+lber/$AGENT_LBER_CHART_REV
helm repo index k8s/pkg-new/oauth/$OAUTH_CHART_REV --url https://raw.githubusercontent.com/EC-Release/helmcharts/disty/oauth/$OAUTH_CHART_REV
helm repo index k8s/pkg-new/webportal/$AGENT_WEBPORTAL_CHART_REV --url https://raw.githubusercontent.com/EC-Release/helmcharts/disty/webportal/$AGENT_WEBPORTAL_CHART_REV
helm repo index k8s/pkg-new/ec-service/$EC_SERVICE_CHART_REV --url https://raw.githubusercontent.com/EC-Release/helmcharts/disty/ec-service/$EC_SERVICE_CHART_REV
