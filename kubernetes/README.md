# Kubernetes

Some notes on k8s

```
source .env
terraform init
terraform apply

sudo snap install kubectl
#Get the k8s config file from provider
vim kubeconfig-tf-cluster.yaml
kubectl config current-context
kubectl get nodes

kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer
kubectl get services
curl <IP_ADDRESS>:80

kubectl delete all --all
terraform destroy
```

<!-- LICENSE -->
## License

Distributed with no conditions. See `LICENSE.txt` for more information.
