#!/bin/sh
echo 'start to pull sqlserver2017'
sudo docker pull microsoft/mssql-server-linux:2017-latest
echo 'finish pulling sqlserver2017'

#声明变量，自定义控制变量名
PT_STORE2017_ABS_PATH=/Users/qinkai/Desktop/PT_STORE2017_20190327.bak
PT_STORE_JCGL_SK_ABS_PATH=/Users/qinkai/Desktop/PT_STORE_JCGL_SK-20190412.BAK
PT_STORE2017_FILE=`basename $PT_STORE2017_ABS_PATH`
PT_STORE_JCGL_SK_FILE=`basename $PT_STORE_JCGL_SK_ABS_PATH`

sudo docker run -e 'ACCEPT_EULA=Y' -e 'MSSQL_SA_PASSWORD=eMbMs1234!' -e 'MSSQL_COLLATION=Chinese_PRC_CI_AS' -p 1433:1433 --name sqlserver -d microsoft/mssql-server-linux:2017-latest

sudo docker exec -it sqlserver /bin/bash -c 'mkdir -p /var/opt/mssql/backup'

echo 'start to copy files to sqlserver container'

docker cp $PT_STORE2017_ABS_PATH sqlserver:/var/opt/mssql/backup

docker cp $PT_STORE_JCGL_SK_ABS_PATH sqlserver:/var/opt/mssql/backup

echo 'finish copying files to sqlserver container'

echo 'start to restore PT_Store2017'

sudo docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost \
    -U SA -P 'eMbMs1234!' \
    -Q "RESTORE FILELISTONLY FROM DISK = '/var/opt/mssql/backup/$PT_STORE2017_FILE'"\
    | tr -s ' ' | cut -d ' ' -f 1-2

sudo docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd \
   -S localhost -U SA -P 'eMbMs1234!' \
   -Q "RESTORE DATABASE PT_STORE2017 FROM DISK = '/var/opt/mssql/backup/$PT_STORE2017_FILE' WITH MOVE 'PT_Store2017' TO '/var/opt/mssql/data/PT_Store2017.mdf', MOVE 'PT_Store2017_log' TO '/var/opt/mssql/data/PT_Store2017.ldf'"


echo 'finish restoring PT_Store2017'

echo 'start to restore PT_STORE_JCGL_SK'

sudo docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost \
   -U SA -P 'eMbMs1234!' \
   -Q "RESTORE FILELISTONLY FROM DISK = '/var/opt/mssql/backup/$PT_STORE_JCGL_SK_FILE'"\
   | tr -s ' ' | cut -d ' ' -f 1-2

sudo docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd \
   -S localhost -U SA -P 'eMbMs1234!' \
   -Q "RESTORE DATABASE PT_STORE_JCGL_SK FROM DISK = '/var/opt/mssql/backup/$PT_STORE_JCGL_SK_FILE' WITH MOVE 'PT_STORE' TO '/var/opt/mssql/data/PT_STORE.mdf', MOVE 'PT_STORE_log' TO '/var/opt/mssql/data/PT_STORE.ldf'"

echo 'finish  restoring PT_STORE_JCGL_SK'