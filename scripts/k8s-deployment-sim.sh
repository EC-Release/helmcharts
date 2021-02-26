#!/bin/bash

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
kubectl get deployments && kubectl get pods && kubectl get services
printf "\n\n\n*** [2.2] verify deployment spec\n"
kubectl describe deployments $(kubectl get deployments|grep agent-plg|awk '{print $1}'|head -n 1)
printf "\n\n\n*** [2.3] verify service spec\n"
kubectl describe services $(kubectl get services|grep agent-plg|awk '{print $1}'|head -n 1)
#printf "\n\n\n*** done debug go ahead delete all.\n\n"
printf "\n\n\n*** [2.4] clear installation\n"
kubectl delete --all deployments && kubectl delete --all pods && kubectl delete --all services

: 'printf "\n\n\n*** install client with remote vln template in minikube\n\n"
yq e '.global.agtK8Config.withPlugins.tls.enabled = false' -i k8s/example/values.yaml
yq e '.global.agtK8Config.withPlugins.vln.enabled = true' -i k8s/example/values.yaml
yq e '.global.agtK8Config.withPlugins.vln.remote = true' -i k8s/example/values.yaml
helm install k8s/example --set-file global.agtConfig=k8s/example/client+vln.env --generate-name

printf "\n\n\n*** verify logs in minikube\n\n"
kubectl get deployments && kubectl get pods && kubectl get services && kubectl get ingresses
#kubectl logs -p $(kubectl get pods|grep agent-plg|awk '{print $1}'|head -n 1) --since=5m
kubectl rollout status deploy/$(kubectl get deployments|grep agent-plg|awk '{print $1}'|head -n 1)
#kubectl describe deployments $(kubectl get pods|grep agent-plg|awk '{print $1}'|head -n 1)
printf "\n\n\n*** done debug go ahead delete all.\n\n"
kubectl delete --all deployments && kubectl delete --all pods && kubectl delete --all services && kubectl delete --all ingresses'
