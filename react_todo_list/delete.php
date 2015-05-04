<?php

echo "START<br>";

if (isset($_POST['id'])) {
  $id = $_POST['id'];
  require ("db_access.php");

  $stmt = $conn->prepare("DELETE FROM items WHERE id = ?");
  $stmt->bind_param('d', $id);
  if ( $stmt->execute())
    die(json_encode(true));

  $stmt->close();
  $conn->close();
}
  die(json_encode(false));



