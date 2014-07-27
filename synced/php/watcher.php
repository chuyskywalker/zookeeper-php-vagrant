<?php

class ZookeeperDemo extends Zookeeper {

    public function watcher( $i, $type, $key ) { 
        echo "Insider Watcher\n";
        var_dump(func_get_args());
        // Watcher gets consumed so we need to set a new one
        $this->get($key, array($this, 'watcher' ) );
    }

}

$zoo = new ZookeeperDemo('127.0.0.1:2101');
$zoo->set('/bar', 1); 
$zoo->get('/bar', array($zoo, 'watcher') );

while( true ) { 
    echo '.';
    sleep(2);
}
