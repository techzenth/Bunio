<?php

require '../../app/util/CsvImporter.php';

//$importer = new CsvImporter("ACTIVE.txt",true); 
//$data = $importer->get(); 
//print_r($data); 

$importer = new CsvImporter("ACTIVE.txt", true);
while ($data = $importer->get(2000)) {
    print_r($data);
} 