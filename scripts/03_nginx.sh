cat >Dockerfile <<EOF
FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf
EOF

echo "Clearing all docker containers"
sudo docker remove -f $(sudo docker ps -a -q) || echo "There is no containers!"

sudo docker build --tag my-nginx .
sudo docker run -d -p 80:80 -p 3000:3000 -v /home/vagrant/logs:/var/log/nginx -v /home/vagrant/content:/usr/share/nginx/html:ro my-nginx
 
mkdir -p /home/vagrant/content/80
mkdir -p /home/vagrant/content/3000

cat >/home/vagrant/content/80/index.html <<EOF
Hello from 80!
EOF

cat >/home/vagrant/content/3000/index.html <<EOF
Hello from 3000!
EOF
