# ! /bin/sh
# Зададим переменные
DATE=$(date +%Y-%m-%d_%H-%M)
FTP="FTP_адрес"
FTPU="Логин_FTP"
FTPP="Пароль_FTP"
STORAGEDIR="storage.ru/backups/test" #Путь откуда производится скачивание backup с FTP
pathlast="/backups/test/backupslast/" #Путь откуда производится скачивание backupslast файла с FTP
tmpback="/var/backups/"
tmplast="/var/backups/backupslast/" #Путь куда производится скачивание backupslast на локальную машину
dbname="test1" #Имя БД

#Копирование проверочного файла с FTP
cd $tmplast
wget ftp://$FTPU:$FTPP@$STORAGEDIR/backupslast/*.psql.gz 
files=$(ls -t|head -1)

#Копирование бэкапа базы на сервер
cd $tmpback
wget ftp://$FTPU:$FTPP@$STORAGEDIR/$files

sudo -u postgres dropdb $dbname
sudo -u postgres createdb -T template0 $dbname
gunzip -c $files | sudo -u postgres psql --set ON_ERROR_STOP=on $dbname

#Уборка
rm -f $tmpback$files
rm -f $tmplast$files

ftp -ni $FTP <<END
quote USER $FTPU
quote PASS $FTPP
cd $pathlast
mdelete *
quit
END

#Скрипт для запуска DT.cmd на удаленном пк
cd /home/user/
./3.sh