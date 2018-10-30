#!/bin/zsh
cd resource-manifests
echo ''
echo '--------------------------------------------------------------------------------'
echo 'Clean up'
echo '--------------------------------------------------------------------------------'
#minikube delete
echo ''
echo '--------------------------------------------------------------------------------'
echo 'Create the minikube VM'
echo '--------------------------------------------------------------------------------'
#minikube --cpus 4 --memory 8192 start
echo ''
echo '--------------------------------------------------------------------------------'
echo 'Create the Frontend PODs/Service'
echo '--------------------------------------------------------------------------------'
kubectl apply -f sa-frontend-deployment.yaml
kubectl create -f service-sa-frontend-lb.yaml
# go into the shell
# kubectl exec -it sa-frontend -- /bin/bash
echo ''
echo '--------------------------------------------------------------------------------'
echo 'Create the Logic PODs/Service'
echo '--------------------------------------------------------------------------------'
kubectl apply -f sa-logic-deployment.yaml --record
kubectl apply -f service-sa-logic.yaml --record
echo ''
echo '--------------------------------------------------------------------------------'
echo 'Create the WebApp PODs/Service'
echo '--------------------------------------------------------------------------------'
kubectl apply -f sa-web-app-deployment.yaml --record
kubectl apply -f sa-web-app-deployment.yaml
echo ''
echo '--------------------------------------------------------------------------------'
echo 'List the Frontend PODs/Service'
echo '--------------------------------------------------------------------------------'
kubectl get pod -l app=sa-frontend
kubectl get svc
echo ''
echo '--------------------------------------------------------------------------------'
echo 'Open the Frontend PODs/Service'
echo '--------------------------------------------------------------------------------'
minikube service sa-frontend-lb