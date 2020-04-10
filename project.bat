@ECHO OFF
echo Iniciou exportacao: %time%
echo Welcome to SDI Project
IF EXIST "c:\Users\pmsan\Desktop\SID\migrateU.csv" (
	echo Deleting file U!
	del c:\Users\pmsan\Desktop\SID\migrateU.csv
)
IF EXIST "c:\Users\pmsan\Desktop\SID\migrateRP.csv" (
	echo Deleting file RP!
	del c:\Users\pmsan\Desktop\SID\migrateRP.csv
)
IF EXIST "c:\Users\pmsan\Desktop\SID\migrateRE.csv" (
	echo Deleting file RE!
	del c:\Users\pmsan\Desktop\SID\migrateRE.csv
)
IF EXIST "c:\Users\pmsan\Desktop\SID\migrateS.csv" (
	echo Deleting file S!
	del c:\Users\pmsan\Desktop\SID\migrateS.csv
)
IF EXIST "c:\Users\pmsan\Desktop\SID\migrateM.csv" (
	echo Deleting file M!
	del c:\Users\pmsan\Desktop\SID\migrateM.csv
)
cd c:\xampp\mysql\bin
mysql -u root main -e "select * from logutilizador where DATE(DataOperacao)=DATE(NOW()-INTERVAL 1 DAY) into outfile 'c:/Users/pmsan/Desktop/SID/migrateU.csv';"
mysql -u root main -e "select count(*) as 'Total Log_Utilizador Origem' from logutilizador where DATE(DataOperacao)=DATE(NOW()-INTERVAL 1 DAY);"
mysql -u root main -e "select * from logrondaplaneada where DATE(DataOperacao)=DATE(NOW()-INTERVAL 1 DAY) into outfile 'c:/Users/pmsan/Desktop/SID/migrateRP.csv';
mysql -u root main -e "select count(*) as 'Total Log_RondaPlaneada' from logrondaplaneada where DATE(DataOperacao)=DATE(NOW()-INTERVAL 1 DAY);"
mysql -u root main -e "select * from logrondaextra where DATE(DataOperacao)=DATE(NOW()-INTERVAL 1 DAY) into outfile 'c:/Users/pmsan/Desktop/SID/migrateRE.csv';"
mysql -u root main -e "select count(*) as 'Total Log_RondaExtra' from logrondaextra where DATE(DataOperacao)=DATE(NOW()-INTERVAL 1 DAY);"
mysql -u root main -e "select * from logsistema where DATE(DataOperacao)=DATE(NOW()-INTERVAL 1 DAY) into outfile 'c:/Users/pmsan/Desktop/SID/migrateS.csv';"
mysql -u root main -e "select count(*) as 'Total Log_Sistema' from logsistema where DATE(DataOperacao)=DATE(NOW()-INTERVAL 1 DAY);"
mysql -u root main -e "select * from logmedicoes where DATE(DataOperacao)=DATE(NOW()-INTERVAL 1 DAY) into outfile 'c:/Users/pmsan/Desktop/SID/migrateM.csv';"
mysql -u root main -e "select count(*) as 'Total Log_Medicoes' from logmedicoes where DATE(DataOperacao)=DATE(NOW()-INTERVAL 1 DAY);"
echo Acabou exportacao: %time% e inicia importacao
IF EXIST "c:\Users\pmsan\Desktop\SID\migrateU.csv" (
	echo File U created and data export!
	mysql -u root log -e "LOAD DATA INFILE 'c:/Users/pmsan/Desktop/SID/migrateU.csv' INTO TABLE logutilizador"
	echo Data imported to Table LogUtilizador!
	mysql -u root log -e "select count(*) as 'Total Log_Utilizador Destino' from logutilizador where DATE(DataOperacao)=DATE(NOW()-INTERVAL 1 DAY);"
) ELSE (
	echo Please export data from LogUtilizador
)
IF EXIST "c:\Users\pmsan\Desktop\SID\migrateRP.csv" (
	echo File RP created and data export!
	mysql -u root log -e "LOAD DATA INFILE 'c:/Users/pmsan/Desktop/SID/migrateRP.csv' INTO TABLE logrondaplaneada"
	echo Data imported to Table LogRondaPlaneada!
	mysql -u root log -e "select count(*) as 'Total Log_RondaPlaneada Destino' from logrondaplaneada where DATE(DataOperacao)=DATE(NOW()-INTERVAL 1 DAY);"
) ELSE (
	echo Please export data from LogRondaPlaneada
)
IF EXIST "c:\Users\pmsan\Desktop\SID\migrateRE.csv" (
	echo File RE created and data export!
	mysql -u root log -e "LOAD DATA INFILE 'c:/Users/pmsan/Desktop/SID/migrateRE.csv' INTO TABLE logrondaextra"
	echo Data imported to Table LogRondaExtra!
) ELSE (
	echo Please export data from LogRondaExtra
)
IF EXIST "c:\Users\pmsan\Desktop\SID\migrateS.csv" (
	echo File S created and data export!
	mysql -u root log -e "LOAD DATA INFILE 'c:/Users/pmsan/Desktop/SID/migrateS.csv' INTO TABLE logsistema"
	echo Data imported to Table LogSistema!
) ELSE (
	echo Please export data from LogSistema
)
IF EXIST "c:\Users\pmsan\Desktop\SID\migrateM.csv" (
	echo File M created and data export!
	mysql -u root log -e "LOAD DATA INFILE 'c:/Users/pmsan/Desktop/SID/migrateM.csv' INTO TABLE logmedicoes"
	echo Data imported to Table LogMedicoes!
) ELSE (
	echo Please export data from LogMedicoes
)
echo Terminou importacao: %time% e iniciou eliminacao de ficheiro
IF EXIST "c:\Users\pmsan\Desktop\SID\migrateU.csv" (
	echo Deleting file U!
	del c:\Users\pmsan\Desktop\SID\migrateU.csv
)
IF EXIST "c:\Users\pmsan\Desktop\SID\migrateRP.csv" (
	echo Deleting file RP!
	del c:\Users\pmsan\Desktop\SID\migrateRP.csv
)
IF EXIST "c:\Users\pmsan\Desktop\SID\migrateRE.csv" (
	echo Deleting file RE!
	del c:\Users\pmsan\Desktop\SID\migrateRE.csv
)
IF EXIST "c:\Users\pmsan\Desktop\SID\migrateS.csv" (
	echo Deleting file S!
	del c:\Users\pmsan\Desktop\SID\migrateS.csv
)
IF EXIST "c:\Users\pmsan\Desktop\SID\migrateM.csv" (
	echo Deleting file M!
	del c:\Users\pmsan\Desktop\SID\migrateM.csv
)
echo fim %time%