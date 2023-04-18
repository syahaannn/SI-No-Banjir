<?php
    include 'conn.php';
    $nodeid = $_REQUEST['node_id'];

    $queryResult = $connect->query("SELECT * FROM detail WHERE node_id='$nodeid'");
    $result = array();
    while($fetchData = $queryResult->fetch_assoc()){
        $result[] = $fetchData;
    }
    echo json_encode($result);
?>