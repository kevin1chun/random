<?php



if (isset($_POST['note'])) {
  $note = $_POST['note'];
  require ("db_access.php");
  $stmt = $conn->prepare("INSERT INTO items (note) VALUES (?)");
  $stmt->bind_param('s', $note);
  if ( $stmt->execute())
    die(json_encode(true));

  $stmt->close();
  $conn->close();
}
  die(json_encode(false));


