# ! /bin/sh
# Зададим переменные
DATE=$(date +%Y-%m-%d_%H-%M)
FTP="FTP_адрес"
FTPU="Логин_FTP"
FTPP="Пароль_FTP"
HOSTNAME=pgservertest
path="/backups/test/" #Путь куда производится backup на FTP
pathlast="/backups/test/lastbackups/" #Путь куда производится backup lastbackups файла FTP
tmplast="/var/tmp/" #Путь откуда производится скачивание backupа на локальной машине
dbname="test1" #Имя БД


#Резервное копирование
cd /var
sudo -u postgres pg_dump $dbname | gzip > $DATE-$dbname-$HOSTNAME.psql.gz
touch $tmplast$DATE-$dbname-$HOSTNAME.psql.gz

ftp -ni $FTP <<END
quote USER $FTPU
quote PASS $FTPP
cd $path
put $DATE-$dbname-$HOSTNAME.psql.gz $DATE-$dbname-$HOSTNAME.psql.gz
cd $pathlast
mdelete *
put $tmplast$DATE-$dbname-$HOSTNAME.psql.gz $DATE-$dbname-$HOSTNAME.psql.gz
quit
END

#Уборка
rm -f $DATE-$dbname-$HOSTNAME.psql.gz
rm -f $tmplast$DATE-$dbname-$HOSTNAME.psql.gz

#Запуск скрипта на другой машине
ssh root@192.168.0.1 'bash -s' < 2.sh