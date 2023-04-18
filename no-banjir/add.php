<?php
	include 'conn.php';
	$nodeid = $_REQUEST['node_id'];
	$namaloc = $_REQUEST['nama_loc'];
	$lat = $_REQUEST['latitude'];
	$lng = $_REQUEST['longitude'];
	// sql to delete a record
	$sql = "INSERT INTO location (node_id,nama_loc,latitude,longitude) VALUES ('".$nodeid."',"."'".$namaloc."',".$lat.",".$lng.")";
	$result = mysqli_query($connect, $sql); 
	echo json_encode($result);
?>