# Terraform K3S
-------------------

#### Note: 
* If you want to connect to the master node from outside internet, run the command below:
  ```bash
  $ curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--tls-san $(curl ipinfo.io/ip)" sh -s -
  ```
* Default k3s use **traefik** ingress. If you want use another ingress controller (e.g: nginx ingress) you must remove traefik ingress first. 
	* Follow this instruction to remove traefik [https://github.com/k3s-io/k3s/issues/1160#issuecomment-561572618](https://github.com/k3s-io/k3s/issues/1160#issuecomment-561572618)
	* Note that at step 3 have an issue. The correct is: 
  	```
		'--no-deploy' \ 
		'traefik' \
		....
	```
* I'm using ingress nginx. So you must provide an external IP by command below:
  ```bash
  helm upgrade --set controller.service.externalIPs={YOUR_EXTERNAL_IP} ingress-nginx nginx-stable/nginx-ingress -n ingress-nginx
  ```