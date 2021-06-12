TERRAFORM K3S
----------------------------------

Using terraform to provide a k3s cluster. K3S is developed by Rancher (known for the RKE project). 

K3S is used in small and medium projects at half the cost of other Kubernetes services - but you 
have to manage more I think this is a trade-off. 

Here, I use Google Cloud Platform (GCP) to deploy K3S. Assuming you are quite familiar with 
GCP, Kubernetes, Terraform. 

Some configurations you need to keep in mind:

* VM Instance:
  - Machine Type: e2-medium
  - Disk Size: 50 GiB
  - Disk Type: pd-standard
  - Boot Image: Ubuntu 18.04 
  - Default nodes:
    + master: 01
    + worker: 02

* VPC:
  - Subnetwork: 
    + IP range: 10.0.0.0/16
    + Second range: 10.1.0.0/16
		
Please check supported variables at `./cluster/variables.tf`. 
To enhance the security of your cluster you should limit ip access to the master-node with 
the `allowed_ips` (recommended). 

* DATA STORAGE: By default K3S using SQLite to store cluster configuration (instead of etcd in k8s). 
  You can use MySQL, PostgreSQL or etcd. You can read it at here: 
  
        https://rancher.com/docs/k3s/latest/en/installation/datastore
  
  By default I using SQLite to store cluster configuration. But I wrote a 
  terraform file (cuslter/database.tf) to provide Google Cloud SQL (PostgreSQL), you can also 
  use it by uncommenting them. 

* ARCHITECTURE: By default, these nodes will be in the VPC and communicate with each other 
  via private ip (open all ports with ip range 10.0.0.0/16). Also with master-node will be open 
  port 6443 (default port of k3s) with `allowed_ips` that I mentioned above. 
  
  I have created a firewall named `${var.group_name}-ingress` for worker nodes. It will open 2 
  ports 80 and 443 with CloudFlare IP ranges. If you don't use CloudFlare you can remove these IP ranges. 

* NOTE: 
- By default k3s use traefik ingress. If you want to use another ingress controller (e.g: ingress-nginx, 
  ambassador, contour, ...) you must remove traefik ingress first. It was disabled in cluster/scripts/master.sh 
	
  + Follow this instruction to remove traefik:
	
        https://github.com/k3s-io/k3s/issues/1160#issuecomment-561572618
	
  + Note that at step 3 have an issue. The correct is: 
  
        '--no-deploy' \ 
        'traefik' \
        ....
        
- Note that when selecting the IP for LoadBalancer, select the IP of one of the worker nodes. DO NOT use 
  the IP of the master node. 

- I'm using ingress-nginx. So you must provide an external IP by command below:
  
        $ helm upgrade --set service.externalIPs={YOUR_EXTERNAL_IP} ingress-nginx bitnami/nginx-ingress-controller -n ingress-nginx

  or edit ingress-nginx/value.yaml:
  
        service:
          externalIPs: 
          - YOUR_EXTERNAL_IP

- To get the configuration of the cluster, you need to `ssh` to the master node and execute the command below: 
  
        $ sudo cat /etc/rancher/k3s/k3s.yaml
        
  Tip: You also use `scp` to download this file to your `kubeconfig`
  
------------------------
DOCUMENT REFERENCE:
  * https://rancher.com/docs/k3s/latest/en/
  * https://bitnami.com/stack/nginx-ingress-controller/helm
  
