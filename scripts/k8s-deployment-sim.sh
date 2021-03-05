#!/bin/bash

printf "\n\n\n*** [0] install gateway with HA in k8s\n"
yq e '.global.agtK8Config.withPlugins.tls.enabled = false' -i k8s/agent+lber/values.yaml
yq e '.global.agtK8Config.withPlugins.vln.enabled = false' -i k8s/agent+lber/values.yaml
helm install my-app k8s/agent+lber --set-file global.agtConfig=k8s/example/gateway.env
printf "\n\n\n*** [0.1] verify installation\n"
kubectl get deployments && kubectl get sts && kubectl get pods && kubectl get services && kubectl get ingress
printf "\n\n\n*** [0.2] verify deployment spec\n"
kubectl describe deployments $(kubectl get deployments|grep agentlber|awk '{print $1}'|head -n 1)
printf "\n\n\n*** [0.3] verify statefulset spec\n"
kubectl describe sts $(kubectl get sts|grep agent|awk '{print $1}'|head -n 1)
printf "\n\n\n*** [0.4] verify headless service spec\n"
kubectl describe services $(kubectl get services|grep -w my-app-agent|awk '{print $1}'|head -n 1)
printf "\n\n\n*** [0.5] verify lber service spec\n"
kubectl describe services $(kubectl get services|grep -w my-app-agentlber|awk '{print $1}'|head -n 1)
printf "\n\n\n*** [0.5] verify ingress spec\n"
kubectl describe ingress $(kubectl get ingress|grep agentlber|awk '{print $1}'|head -n 1)
printf "\n\n\n*** [0.6] clear installation\n"
kubectl delete --all deployments && kubectl delete --all sts && kubectl delete --all pods && kubectl delete --all services && kubectl delete --all ingress


printf "\n\n\n*** [1] install server with tls template in k8s\n"
yq e '.global.agtK8Config.withPlugins.tls.enabled = true' -i k8s/example/values.yaml
yq e '.global.agtK8Config.withPlugins.vln.enabled = false' -i k8s/example/values.yaml
helm install k8s/example --set-file global.agtConfig=k8s/example/server+tls.env --generate-name

printf "\n\n\n*** [1.1] verify installation\n"
kubectl get deployments && kubectl get pods && kubectl get services
#kubectl rollout status deploy/$(kubectl get deployments|grep agent-plg|awk '{print $1}'|head -n 1)
#sleep 2
#kubectl logs -p $(kubectl get pods|grep agent-plg|awk '{print $1}'|head -n 1) --since=5m
printf "\n\n\n*** [1.2] verify deployment spec\n"
kubectl describe deployments $(kubectl get deployments|grep agent-plg|awk '{print $1}'|head -n 1)
printf "\n\n\n*** [1.3] verify service spec\n"
kubectl describe services $(kubectl get services|grep agent-plg|awk '{print $1}'|head -n 1)
#printf "\n\n\n*** done debug go ahead delete all.\n\n"
printf "\n\n\n*** [1.4] clear installation\n"
kubectl delete --all deployments && kubectl delete --all pods && kubectl delete --all services

printf "\n\n\n*** [2] install client with local vln multi-contr template in k8s\n"
yq e '.global.agtK8Config.withPlugins.tls.enabled = false' -i k8s/example/values.yaml
yq e '.global.agtK8Config.withPlugins.vln.enabled = true' -i k8s/example/values.yaml
yq e '.global.agtK8Config.withPlugins.vln.remote = false' -i k8s/example/values.yaml
helm install k8s/example --set-file global.agtConfig=k8s/example/client+vln.env --generate-name

printf "\n\n\n*** [2.1] verify installation\n"
kubectl get deployments && kubectl get pods
printf "\n\n\n*** [2.2] verify deployment spec\n"
kubectl describe deployments $(kubectl get deployments|grep agent-plg|awk '{print $1}'|head -n 1)
printf "\n\n\n*** [2.3] clear installation\n"
kubectl delete --all deployments && kubectl delete --all pods && kubectl delete --all services

printf "\n\n\n*** [3] install client with remote vln template in minikube\n"
yq e '.global.agtK8Config.withPlugins.tls.enabled = false' -i k8s/example/values.yaml
yq e '.global.agtK8Config.withPlugins.vln.enabled = true' -i k8s/example/values.yaml
yq e '.global.agtK8Config.withPlugins.vln.remote = true' -i k8s/example/values.yaml
helm install k8s/example --set-file global.agtConfig=k8s/example/client+vln.env --generate-name

printf "\n\n\n*** [3.1] verify installation\n"
kubectl get deployments && kubectl get pods && kubectl get services
printf "\n\n\n*** [3.2] verify deployment spec\n"
kubectl describe deployments $(kubectl get deployments|grep agent-plg|awk '{print $1}'|head -n 1)
printf "\n\n\n*** [3.3] verify service spec\n"
kubectl describe services $(kubectl get services|grep agent-plg|awk '{print $1}'|head -n 1)
printf "\n\n\n*** [3.4] clear installation\n"
kubectl delete --all deployments && kubectl delete --all pods && kubectl delete --all services

printf "\n\n\n*** [4] install lber in k8s\n"
#helm install k8s/agent+lber --generate-name
: 'printf "\n\n\n*** [4.1] verify installation\n"
kubectl get deployments && kubectl get pods && kubectl get services && kubectl get ingresses
printf "\n\n\n*** [4.2] verify deployment spec\n"
kubectl describe deployments $(kubectl get deployments|grep agent-plg|awk '{print $1}'|head -n 1)
printf "\n\n\n*** [4.2] verify statefulset spec\n"
kubectl describe sts $(kubectl get sts|grep agent-plg|awk '{print $1}'|head -n 1)
printf "\n\n\n*** [4.3] verify service spec\n"
kubectl describe services $(kubectl get services|grep agent-plg|awk '{print $1}'|head -n 1)
printf "\n\n\n*** [4.4] verify ingress spec\n"
kubectl describe services $(kubectl get services|grep agent-plg|awk '{print $1}'|head -n 1)
printf "\n\n\n*** [4.5] clear installation\n"
kubectl delete --all deployments && kubectl delete --all pods && kubectl delete --all services'
