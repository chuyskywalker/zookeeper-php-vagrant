<?php

$zoo = new Zookeeper('127.0.0.1:2101');
$zoo->set('/bar', 1); 
$zoo->get('/bar', function($i, $type, $key) {
    echo "Insider Watcher\n";
    var_dump(func_get_args());
});

while( true ) { 
    echo '.';
    sleep(2);
}
