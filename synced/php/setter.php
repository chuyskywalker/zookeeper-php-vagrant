<?php

$zoo = new Zookeeper('127.0.0.1:2101');
$newval = rand(0,100);
var_dump( $newval );
var_dump( $zoo->set('/bar', $newval) );
