# k8s-yaml

YAML files needed to get K8S working with Helm - specifically with Azure AKS 1.9.6

Download the files and run the following commands:

kubectl create serviceaccount tiller --namespace kube-system
kubectl create -f role-tiller.yaml
kubectl create -f rolebinding-tiller.yaml
kubectl create -f role-tiller-kube-system.yaml
kubectl create -f rolebinding-tiller-kube-system.yaml

# Configure HELM with the new Service Account
helm init --service-account=tiller

# Test Tiller installed
kubectl --namespace kube-system get pods | grep tiller
