<?php
    $connect = new mysqli("localhost", "root", "1234", "no_banjir");
    if ($connect){
        
    }else {
        echo "Connection Failed";
        exit();
    }
?>