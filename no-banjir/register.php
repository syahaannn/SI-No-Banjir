<?php
	include 'conn.php';
	$username = $_REQUEST['username'];
	$password = $_REQUEST['password'];
	// sql to delete a record
	$sql = "INSERT INTO user (username,password) VALUES ('".$username."',"."'".$password."')";
	$result = mysqli_query($connect, $sql); 
	echo json_encode($result);
?>