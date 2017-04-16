::Переменные
set path1с="C:\Program Files (x86)\1cv8\8.3.9.1850\bin\"
set pathDT=C:\
set login=Логин
set password=Пароль
set nameser1c=адресс_сервера_1c
set namebas1c=Имя_базы_1с
set nameDT=Имя выгружаемого *.dt

set servFTP=адресс_сервера_FTP_куда делается_backups
set loginFTP=Логин
set passFTP=Пароль
::Путь к месту расположения Backup-ов
set pathFTP=/backups/test/dtbackups/ 

start /wait /d%path1с% 1cv8.exe ENTERPRISE /S"%nameser1c%:1541\%namebas1c%" /N%login% /P%password% /DisableStartupMessages /CЗавершитьРаботуПользователей

start /wait /d%path1с% 1cv8.exe DESIGNER /S"%nameser1c%:1541\%namebas1c%" /N"%login%" /P"%password%" /UCКодРазрешения /DumpIB "%pathDT%%nameDT%_%date:~-10%.dt"

start /wait /d%path1с% 1cv8.exe ENTERPRISE /S"%nameser1c%:1541\%namebas1c%" /N"%login%" /P"%password%" /C"РазрешитьРаботуПользователей" /UCКодРазрешения

::Отправка на FTP
cd %pathDT%
set addr=script
echo.open %servFTP%> %ADDR%
echo.%loginFTP%>> %ADDR%
echo.%passFTP%>> %ADDR%
echo.cd %pathFTP%>> %ADDR%
echo.bin>> %ADDR%
echo.send "%pathDT%%nameDT%_%date:~-10%.dt">> %ADDR%
echo.quit>> %ADDR%
%SystemRoot%\system32\ftp.exe -i -s:%ADDR%

::Чистка временных файлов
del script
del %pathDT%%nameDT%_%date:~-10%.dt
exit