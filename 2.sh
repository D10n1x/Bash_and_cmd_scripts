# ! /bin/sh
# Зададим переменные
DATE=$(date +%Y-%m-%d_%H-%M)
FTP="FTP_адрес"
FTPU="Логин_FTP"
FTPP="Пароль_FTP"
STORAGEDIR="storage.ru/backups/test" #Путь откуда производится скачивание backup с FTP
path="/backups/test/" #Путь откуда производится скачивание backup с FTP
pathlast="/backups/test/lastbackups/" #Путь откуда производится скачивание lastbackups файла с FTP
tmplast="/var/tmp/" #Путь куда производится скачивание backupа на локальной машине
dbname="test1" #Имя БД

#Копирование проверочного файла с FTP
cd /var/tmp/
wget ftp://$FTPU:$FTPP@$STORAGEDIR/lastbackups/*.psql.gz 
files=$(ls -t|head -1)
cd /var/

#Копирование бэкапа базы на тестовый сервер
wget ftp://$FTPU:$FTPP@$STORAGEDIR/$files

sudo -u postgres dropdb $dbname
sudo -u postgres createdb -T template0 $dbname
gunzip -c $files | sudo -u postgres psql --set ON_ERROR_STOP=on $dbname

#Уборка
rm -f $files
rm -f $tmplast$files

ftp -ni $FTP <<END
quote USER $FTPU
quote PASS $FTPP
cd $pathlast
mdelete *
quit
END

#Скрипт для запуска DT.cmd на удаленном пк
cd /var/
./3.sh