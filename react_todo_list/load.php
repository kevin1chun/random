<?php
require ("db_access.php");
$sql = "SELECT id, note FROM items";
$result = $conn->query($sql);

$output = array();

if ($result->num_rows > 0) {

    while($row = $result->fetch_assoc()) {
         $output[] = array("id" =>$row["id"], "note" => $row["note"]);
    }
} 


$conn->close();

die(json_encode($output));
?>
