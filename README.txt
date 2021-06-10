Terraform K3S
-------------------

Note: 
* If you want to connect to the master node from outside internet, run the command below:
$ curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--tls-san $(curl ipinfo.io/ip)" sh -s -
