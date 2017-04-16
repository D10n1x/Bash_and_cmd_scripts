# ! /bin/sh
# Зададим переменные
DATE=$(date +%Y-%m-%d_%H-%M)
FTP="FTP_адрес"
FTPU="Логин_FTP"
FTPP="Пароль_FTP"
HOSTNAME=pgservertest
pathback="/backups/test/" #Путь куда производится backup на FTP
pathlast="/backups/test/backupslast/" #Путь куда производится backup backupslast файла FTP
tmplast="/var/backups/backupslast/" #Путь откуда производится скачивание backupslast на локальной машине
tmpback="/var/backups/"
dbname="test1" #Имя БД


#Резервное копирование
cd $tmpback
sudo -u postgres pg_dump $dbname | gzip > $DATE-$dbname-$HOSTNAME.psql.gz
cd $tmplast
touch $DATE-$dbname-$HOSTNAME.psql.gz

ftp -ni $FTP <<END
quote USER $FTPU
quote PASS $FTPP
cd $pathback
put $tmpback$DATE-$dbname-$HOSTNAME.psql.gz $DATE-$dbname-$HOSTNAME.psql.gz
cd $pathlast
mdelete *
put $tmplast$DATE-$dbname-$HOSTNAME.psql.gz $DATE-$dbname-$HOSTNAME.psql.gz
quit
END

#Уборка
rm -f $tmpback$DATE-$dbname-$HOSTNAME.psql.gz
rm -f $tmplast$DATE-$dbname-$HOSTNAME.psql.gz

#Запуск скрипта на другой машине
ssh root@192.168.0.1 'bash -s' < 2.sh