<?php

$beginTms= round(microtime(true) * 1000);

///Connection////////////////////////////////////////////
//echo "Connection Attempt";
//echo "<br>";
$username="root";
$password="";
$dsn_origem="mysql:host=localhost;dbname=sid_php";
$dsn_destino="mysql:host=localhost;dbname=sid_php_destino";

try{
	$pdo_origem= new PDO($dsn_origem, $username, $password);
	$pdo_destino= new PDO($dsn_destino, $username, $password);
//	echo "Connection Completed";
	// echo "<br>";
}catch(PDOException $e){
	$error_message = $e->getMessage();
	echo "Error when connecting to DB";
	exit();
}
$pdo_origem->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$pdo_destino->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
/////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
/////User_logs Migration//////////////////////////////////////////////
////GET LAST ID/////////////////////////////////////////////////

$lastlogid = $pdo_destino->query("SELECT * FROM user_logs ORDER BY ID DESC")->fetch(PDO::FETCH_ASSOC);
// echo "Last log Migrated id: ";
$lastid=0;
if($lastlogid!=null){
	$lastid=array_values($lastlogid)[0];
}
// echo $lastid;
// echo "<br>";

//GET DATA TO BE UPDATED FROM ORIGIN/////////////////////////////

$query_origem = "SELECT * FROM user_logs WHERE ID>$lastid";
//printf("Query origem: %s", $query_origem);
//echo "<br>";
$data = $pdo_origem->query($query_origem);
//echo "QO completed";
//echo "<br>";
//echo "Data: ";
//echo "<br>";

////INSERT DATA TO BE UPDATED ON DESTINATION///////////////////////

$query_destino="INSERT INTO user_logs (ID, op, opUser, opData, usernameAntes, usernameDepois,  
emailAntes, emailDepois, nomeAntes, nomeDepois, apelidoAntes, apelidoDepois) 
VALUES (:ID, :op, :opUser, :opData, :usernameAntes, :usernameDepois,  
:emailAntes, :emailDepois, :nomeAntes, :nomeDepois, :apelidoAntes, :apelidoDepois)";
//printf("Query destino: %s", $query_destino);
$stmt= $pdo_destino->prepare($query_destino);
// echo "<br>";
//echo"Statement Prepared";
//echo "<br>";
foreach ($data->fetchAll(PDO::FETCH_ASSOC) as $row){
	$stmt->execute($row);
}

////GET NEW LAST ID AND COUNT CHANGES/////////////////////////////////////////////////
$newlogid = $pdo_destino->query("SELECT * FROM user_logs ORDER BY ID DESC")->fetch(PDO::FETCH_ASSOC);
$newid=0;
if($newlogid!=null){
$newid=array_values($newlogid)[0];
}
// printf("newid: %s", $newid);
// echo"<br>";
$user_logs_inserted=$newid-$lastid;
// printf("User logs migration completed: %s records inserted",$user_logs_inserted);
// echo"<br>";

//////////////////////////////////////////////////////////////////////
/////Medicoes_logs Migration//////////////////////////////////////////
////GET LAST ID/////////////////////////////////////////////////

$lastlogid = $pdo_destino->query("SELECT * FROM medicoes_logs ORDER BY ID DESC")->fetch(PDO::FETCH_ASSOC);
// echo "Last log Migrated id: ";
$lastid=0;
if($lastlogid!=null){
	$lastid=array_values($lastlogid)[0];
}
// echo $lastid;
// echo "<br>";

//GET DATA TO BE UPDATED FROM ORIGIN/////////////////////////////

$query_origem = "SELECT * FROM medicoes_logs WHERE ID>$lastid";
//printf("Query origem: %s", $query_origem);
//echo "<br>";
$data = $pdo_origem->query($query_origem);
//echo "QO completed";
//echo "<br>";
//echo "Data: ";
//echo "<br>";

////INSERT DATA TO BE UPDATED ON DESTINATION///////////////////////

$query_destino="INSERT INTO medicoes_logs (ID, valor, dataHora) 
VALUES (:ID, :valor, :dataHora)";
//printf("Query destino: %s", $query_destino);
$stmt= $pdo_destino->prepare($query_destino);
// echo "<br>";
//echo"Statement Prepared";
//echo "<br>";
foreach ($data->fetchAll(PDO::FETCH_ASSOC) as $row){
	$stmt->execute($row);
}

////GET NEW LAST ID AND COUNT CHANGES/////////////////////////////////////////////////
$newlogid = $pdo_destino->query("SELECT * FROM medicoes_logs ORDER BY ID DESC")->fetch(PDO::FETCH_ASSOC);
$newid=0;
if($newlogid!=null){
$newid=array_values($newlogid)[0];
}
// printf("newid: %s", $newid);
// echo"<br>";
$medicoes_logs_inserted=$newid-$lastid;
// printf("Medições logs migration completed: %s records inserted",$medicoes_logs_inserted);
// echo"<br>";

//////////////////////////////////////////////////////////////////////
/////Ronda_logs Migration/////////////////////////////////////////////
////GET LAST ID/////////////////////////////////////////////////

$lastlogid = $pdo_destino->query("SELECT * FROM ronda_logs ORDER BY ID DESC")->fetch(PDO::FETCH_ASSOC);
// echo "Last log Migrated id: ";
$lastid=0;
if($lastlogid!=null){
	$lastid=array_values($lastlogid)[0];
}
// echo $lastid;
// echo "<br>";

//GET DATA TO BE UPDATED FROM ORIGIN/////////////////////////////

$query_origem = "SELECT * FROM ronda_logs WHERE ID>$lastid";
//printf("Query origem: %s", $query_origem);
//echo "<br>";
$data = $pdo_origem->query($query_origem);
//echo "QO completed";
//echo "<br>";
//echo "Data: ";
//echo "<br>";

////INSERT DATA TO BE UPDATED ON DESTINATION///////////////////////

$query_destino="INSERT INTO ronda_logs (ID, op, opUser, opData, 
diaAntes, diaDepois, inicioAntes, inicioDepois, duracaoAntes, duracaoDepois) 
VALUES (:ID, :op, :opUser, :opData, :diaAntes, :diaDepois,  
:inicioAntes, :inicioDepois, :duracaoAntes, :duracaoDepois)";
//printf("Query destino: %s", $query_destino);
$stmt= $pdo_destino->prepare($query_destino);
// echo "<br>";
//echo"Statement Prepared";
//echo "<br>";
foreach ($data->fetchAll(PDO::FETCH_ASSOC) as $row){
	$stmt->execute($row);
}

////GET NEW LAST ID AND COUNT CHANGES/////////////////////////////////////////////////
$newlogid = $pdo_destino->query("SELECT * FROM ronda_logs ORDER BY ID DESC")->fetch(PDO::FETCH_ASSOC);
$newid=0;
if($newlogid!=null){
$newid=array_values($newlogid)[0];
}
// printf("newid: %s", $newid);
// echo"<br>";
$ronda_logs_inserted=$newid-$lastid;
// printf("Ronda logs migration completed: %s records inserted",$ronda_logs_inserted);
// echo"<br>";

//////////////////////////////////////////////////////////////////////
/////RondaPlaneada_logs Migration/////////////////////////////////////
////GET LAST ID/////////////////////////////////////////////////

$lastlogid = $pdo_destino->query("SELECT * FROM rondaplaneada_logs ORDER BY ID DESC")->fetch(PDO::FETCH_ASSOC);
// echo "Last log Migrated id: ";
$lastid=0;
if($lastlogid!=null){
	$lastid=array_values($lastlogid)[0];
}
// echo $lastid;
// echo "<br>";

//GET DATA TO BE UPDATED FROM ORIGIN/////////////////////////////

$query_origem = "SELECT * FROM rondaplaneada_logs WHERE ID>$lastid";
//printf("Query origem: %s", $query_origem);
//echo "<br>";
$data = $pdo_origem->query($query_origem);
//echo "QO completed";
//echo "<br>";
//echo "Data: ";
//echo "<br>";

////INSERT DATA TO BE UPDATED ON DESTINATION///////////////////////

$query_destino="INSERT INTO rondaplaneada_logs (ID, data) 
VALUES (:ID, :data)";
//printf("Query destino: %s", $query_destino);
$stmt= $pdo_destino->prepare($query_destino);
// echo "<br>";
//echo"Statement Prepared";
//echo "<br>";
foreach ($data->fetchAll(PDO::FETCH_ASSOC) as $row){
	$stmt->execute($row);
}

////GET NEW LAST ID AND COUNT CHANGES/////////////////////////////////////////////////
$newlogid = $pdo_destino->query("SELECT * FROM rondaplaneada_logs ORDER BY ID DESC")->fetch(PDO::FETCH_ASSOC);
$newid=0;
if($newlogid!=null){
$newid=array_values($newlogid)[0];
}
// printf("newid: %s", $newid);
// echo"<br>";
$rondaplaneada_logs_inserted=$newid-$lastid;
// printf("Ronda Planeada logs migration completed: %s records inserted",$rondaplaneada_logs_inserted);
// echo"<br>";

//////////////////////////////////////////////////////////////////////
/////RondaExtra_logs Migration////////////////////////////////////////
////GET LAST ID/////////////////////////////////////////////////

$lastlogid = $pdo_destino->query("SELECT * FROM rondaextra_logs ORDER BY ID DESC")->fetch(PDO::FETCH_ASSOC);
// echo "Last log Migrated id: ";
$lastid=0;
if($lastlogid!=null){
	$lastid=array_values($lastlogid)[0];
}
// echo $lastid;
// echo "<br>";

//GET DATA TO BE UPDATED FROM ORIGIN/////////////////////////////

$query_origem = "SELECT * FROM rondaextra_logs WHERE ID>$lastid";
//printf("Query origem: %s", $query_origem);
//echo "<br>";
$data = $pdo_origem->query($query_origem);
//echo "QO completed";
//echo "<br>";
//echo "Data: ";
//echo "<br>";

////INSERT DATA TO BE UPDATED ON DESTINATION///////////////////////

$query_destino="INSERT INTO rondaextra_logs (ID, op, opUser, opData, dataAntes, dataDepois) 
VALUES (:ID, :op, :opUser, :opData, :dataAntes, :dataDepois)";
//printf("Query destino: %s", $query_destino);
$stmt= $pdo_destino->prepare($query_destino);
// echo "<br>";
//echo"Statement Prepared";
//echo "<br>";
foreach ($data->fetchAll(PDO::FETCH_ASSOC) as $row){
	$stmt->execute($row);
}

////GET NEW LAST ID AND COUNT CHANGES/////////////////////////////////////////////////
$newlogid = $pdo_destino->query("SELECT * FROM rondaextra_logs ORDER BY ID DESC")->fetch(PDO::FETCH_ASSOC);
$newid=0;
if($newlogid!=null){
$newid=array_values($newlogid)[0];
}
// printf("newid: %s", $newid);
// echo"<br>";
$rondaextra_logs_inserted=$newid-$lastid;
// printf("Ronda Extra logs migration completed: %s records inserted",$rondaextra_logs_inserted);
// echo"<br>";

//////////////////////////////////////////////////////////////////////
/////Sensores_logs Migration//////////////////////////////////////////

////GET LAST ID/////////////////////////////////////////////////

$lastlogid = $pdo_destino->query("SELECT * FROM sensores_logs ORDER BY ID DESC")->fetch(PDO::FETCH_ASSOC);
// echo "Last log Migrated id: ";
$lastid=0;
if($lastlogid!=null){
	$lastid=array_values($lastlogid)[0];
}
// echo $lastid;
// echo "<br>";

//GET DATA TO BE UPDATED FROM ORIGIN/////////////////////////////

$query_origem = "SELECT * FROM sensores_logs WHERE ID>$lastid";
//printf("Query origem: %s", $query_origem);
//echo "<br>";
$data = $pdo_origem->query($query_origem);
//echo "QO completed";
//echo "<br>";
//echo "Data: ";
//echo "<br>";

////INSERT DATA TO BE UPDATED ON DESTINATION///////////////////////

$query_destino="INSERT INTO sensores_logs (ID, op, opUser, opData, senTip, senEstadoAntes, senEstadoDepois,  
senAckAntes, senAckDepois, senAvisoAntes, senAvisoDepois, senAlarmeAntes, senAlarmeDepois, sen_leitura) 
VALUES (:ID, :op, :opUser, :opData, :senTip, :senEstadoAntes, :senEstadoDepois,  
:senAckAntes, :senAckDepois, :senAvisoAntes, :senAvisoDepois, :senAlarmeAntes, :senAlarmeDepois, :sen_leitura)";
//printf("Query destino: %s", $query_destino);
$stmt= $pdo_destino->prepare($query_destino);
// echo "<br>";
//echo"Statement Prepared";
//echo "<br>";
foreach ($data->fetchAll(PDO::FETCH_ASSOC) as $row){
	$stmt->execute($row);
}

////GET NEW LAST ID AND COUNT CHANGES/////////////////////////////////////////////////
$newlogid = $pdo_destino->query("SELECT * FROM sensores_logs ORDER BY ID DESC")->fetch(PDO::FETCH_ASSOC);
$newid=0;
if($newlogid!=null){
$newid=array_values($newlogid)[0];
}
// printf("newid: %s", $newid);
// echo"<br>";
$sensores_logs_inserted=$newid-$lastid;
// printf("Sensores logs migration completed: %s records inserted",$sensores_logs_inserted);
// echo"<br>";

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
// echo"<br>";

$endTms = round(microtime(true) * 1000);
$totalInserted=$user_logs_inserted+$ronda_logs_inserted+
$rondaextra_logs_inserted+$rondaplaneada_logs_inserted+$sensores_logs_inserted+$medicoes_logs_inserted;
printf("Migration Complete. Total records inserted: %s <br>",$totalInserted);

$timeElapsed=$endTms-$beginTms;
printf("Time taken: %s milliseconds", $timeElapsed);


?>