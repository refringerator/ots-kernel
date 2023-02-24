# OTUS Administrator Linux. Professional course 
## HW8 Systemd

### TODO
1. Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова (файл лога и ключевое слово должны задаваться в /etc/sysconfig).
2. Из репозитория epel установить spawn-fcgi и переписать init-скрипт на unit-файл (имя service должно называться так же: spawn-fcgi).
3. Дополнить unit-файл httpd (он же apache) возможностью запустить несколько инстансов сервера с разными конфигурационными файлами.

#### othr
```
vagrant destroy -f && vagrant up && vagrant ssh -c "sudo -i"
```
