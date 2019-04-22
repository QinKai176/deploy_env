#!/bin/sh
sudo docker pull microsoft/mssql-server-linux:2017-latest

sudo docker run -e 'ACCEPT_EULA=Y' -e 'MSSQL_SA_PASSWORD=eMbMs1234!' -e 'MSSQL_COLLATION=Chinese_PRC_CI_AS' -p 1433:1433 --name sqlserver -d microsoft/mssql-server-linux:2017-latest

docker cp /Users/qinkai/Desktop/PT_STORE_JCGL_SK-20190412.BAK sqlserver:/var/opt/mssql/backup

docker cp /Users/qinkai/Desktop/PT_STORE2017_20190327.bak sqlserver:/var/opt/mssql/backup

sudo docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost \
    -U SA -P 'eMbMs1234!' \
    -Q 'RESTORE FILELISTONLY FROM DISK = "/var/opt/mssql/backup/PT_STORE2017_20190327.bak"' \
    | tr -s ' ' | cut -d ' ' -f 1-2

sudo docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd \
   -S localhost -U SA -P 'eMbMs1234!' \
   -Q 'RESTORE DATABASE PT_STORE2017 FROM DISK = "/var/opt/mssql/backup/PT_STORE2017_20190327.bak" WITH MOVE "PT_Store2017" TO "/var/opt/mssql/data/PT_Store2017.mdf", MOVE "PT_Store2017_log" TO "/var/opt/mssql/data/PT_Store2017.ldf"'

sudo docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost \
   -U SA -P 'eMbMs1234!' \
   -Q 'RESTORE FILELISTONLY FROM DISK = "/var/opt/mssql/backup/PT_STORE_JCGL_SK-20190412.BAK"' \
   | tr -s ' ' | cut -d ' ' -f 1-2

sudo docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd \
   -S localhost -U SA -P 'eMbMs1234!' \
   -Q 'RESTORE DATABASE PT_STORE_JCGL_SK FROM DISK = "/var/opt/mssql/backup/PT_STORE_JCGL_SK-20190412.BAK" WITH MOVE "PT_STORE" TO "/var/opt/mssql/data/PT_STORE.mdf", MOVE "PT_STORE_log" TO "/var/opt/mssql/data/PT_STORE.ldf"'