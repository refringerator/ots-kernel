echo "Adding some fake logs to tests"
echo "ALERT Its work!" > /var/log/watchlog.log

echo "Creating watchlog script"
cat >/opt/watchlog.sh <<'EOF'
#!bin/bash

WORD=$1
LOG=$2
DATE=`date`

if grep $WORD $LOG &> /dev/null
then
	logger "$DATE: I found word, Master!"
else
	exit 0
fi
EOF

chmod +x /opt/watchlog.sh

echo "Adding config file with params"
cat >/etc/sysconfig/watchlog <<'EOF'
# Configuration file for my strong watchlog service

# File and word in that file
# we are looking for
WORD="ALERT"
LOG=/var/log/watchlog.log
EOF

echo "Creating service unit"
cat >/etc/systemd/system/watchlog.service <<'EOF'
[Unit]
Description=My awesome watchlog service

[Service]
Type=oneshot
EnvironmentFile=/etc/sysconfig/watchlog
ExecStart=/opt/watchlog.sh $WORD $LOG
EOF

echo "Creating timer unit"
cat >/etc/systemd/system/watchlog.timer <<'EOF'
[Unit]
Description=Run awesome watchlog script every 30 secs

[Timer]
# Run every 30 sec
OnUnitActiveSec=30
Unit=watchlog.service

[Install]
WantedBy=multi-user.target
EOF

echo "Starting Watchlog service and timer"
systemctl enable --now watchlog.timer

# its needed to make timer work
# cos OnUnitActive shedule task relatively to the last time service was active
systemctl start watchlog.service
