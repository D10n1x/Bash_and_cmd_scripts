::��६����
set path1�="C:\Program Files (x86)\1cv8\8.3.9.1850\bin\"
set pathDT=C:\
set login=�����
set password=��஫�
set nameser1c=�����_�ࢥ�_1c
set namebas1c=���_����_1�
set nameDT=��� ���㦠����� *.dt

set servFTP=�����_�ࢥ�_FTP_�㤠 ��������_backups
set loginFTP=�����
set passFTP=��஫�
::���� � ����� �ᯮ������� Backup-��
set pathFTP=/backups/test/dtbackups/ 

start /wait /d%path1�% 1cv8.exe ENTERPRISE /S"%nameser1c%:1541\%namebas1c%" /N%login% /P%password% /DisableStartupMessages /C�������쐠���㏮�짮��⥫��

start /wait /d%path1�% 1cv8.exe DESIGNER /S"%nameser1c%:1541\%namebas1c%" /N"%login%" /P"%password%" /UC�������襭�� /DumpIB "%pathDT%%nameDT%_%date:~-10%.dt"

start /wait /d%path1�% 1cv8.exe ENTERPRISE /S"%nameser1c%:1541\%namebas1c%" /N"%login%" /P"%password%" /C"������쐠���㏮�짮��⥫��" /UC�������襭��

::��ࠢ�� �� FTP
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

::���⪠ �६����� 䠩���
del script
del %pathDT%%nameDT%_%date:~-10%.dt
exit