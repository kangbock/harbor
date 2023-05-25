#!/bin/bash
# ssl 인증서
wget https://harbor.k-tech.cloud/api/v2.0/systeminfo/getcert --no-check-certificate
mv getcert /etc/docker/ca.crt

cat > /etc/docker/daemon.json <<EOF
{
"insecure-registries" : ["harbor.k-tech.cloud", "0.0.0.0"]
}
EOF

systemctl restart docker

# harbor login
cat > my_password.txt <<EOF
Harbor12345
EOF
cat ./my_password.txt | docker login https://harbor.k-tech.cloud --username admin --password-stdin
