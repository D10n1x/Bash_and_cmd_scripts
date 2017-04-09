#!/usr/bin/expect -f
#Последовательный запуск скрипта на выполнение с Linux сервера на Windows сервер

#Установить OpenSSH на Win2k12_or_2k8 http://winitpro.ru/index.php/2016/03/31/sftp-ssh-ftp-na-windows-server-2012-r2/#h2_3 откуда скачивать https://github.com/PowerShell/Win32-OpenSSH/releases 

https://www.mls-software.com/opensshd.html верия setupssh-7.5p1-1.exe прекрасно работает на W2k8 
http://tdkare.ru/sysadmin/index.php/OpenSSH_for_Windows

#Разрешение на запуск скриптов .PS1 http://winlined.ru/articles/Windows_7_Kak_razreshit_vypolnenie_skriptov_PowerShell.php
#На Linux сервере необходимо Произвести установку Expect: apt-get install expect
#Логин, пароль и IP вводятся через пробел после переменной без каких либо дополнительных символов

set timeout 2
set user Логин_Пользователя_SSH_на_Windows
set pass Пароль_Пользователя_SSH_на_Windows
set host IP_Адресс_Windows_машины

spawn ssh $user@$host
expect {
 
"(yes/no)?*" {
send "yes\r"
 }
}
expect "*?assword:*"
send -- "$pass\r"
sleep 5
send -- "start c:\\DT.cmd\r"
sleep 5
send -- "exit\r"
expect eof
