yum install epel-release -y
yum install spawn-fcgi php php-cli mod_fcgid httpd -y 

sed -i -e 's/^#\b//g' /etc/sysconfig/spawn-fcgi

cat >/etc/systemd/system/spawn-fcgi.service <<'EOF'
[Unit]
Description=Spawn-fcgi startup service
After=network.target

[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/sysconfig/spawn-fcgi
ExecStart=/usr/bin/spawn-fcgi -n $OPTIONS
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

systemctl start spawn-fcgi

