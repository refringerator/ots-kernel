names=(first second)
ports=(8081 8082)

echo "Update httpd.service template"

# remove empty and commented lines
# insert empty line before sections
# change EnvironmentFile
sudo sed -i -e '/^EnvironmentFile.*$/d; /^#.*$/d; /^$/d; /^\[/i\\' -e '/\[Service\]/a EnvironmentFile=/etc/sysconfig/httpd-%i' /usr/lib/systemd/system/httpd@.service

echo "Adding custom options file"
for i in "${names[@]}"; do echo "OPTIONS=" >/etc/sysconfig/httpd-$i; done

echo "Creating configs by copying standard"
for i in "${!names[@]}"; 
do 
    cat /etc/httpd/conf/httpd.conf | sed -e '/^PidFile/d; /^Listen/d;' >/etc/httpd/conf/${names[$i]}.conf 

    echo -e "PidFile /var/run/httpd-${names[$i]}.pid\nListen ${ports[$i]}"  >>/etc/httpd/conf/${names[$i]}.conf 
done

echo "Starting httpd services"
for name in "${names[@]}"; 
do
    systemctl start httpd@$name
done

