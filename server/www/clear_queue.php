<?php

include ("PHPSonos.inc.php"); 

$sonos = new PHPSonos("192.168.1.144");
$sonos->ClearQueue(); 

echo "done"

?>
