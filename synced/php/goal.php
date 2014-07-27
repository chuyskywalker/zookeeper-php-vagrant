<?php

$params = array(array(
'perms'  => Zookeeper::PERM_ALL,
'scheme' => 'world',
'id'     => 'anyone'
));

$zk = new Zookeeper('127.0.0.1:2101');
$path = '/testme4';

function cb() {
    var_dump('cb');
}

$zk->get($path, 'cb');

$zk->create("$path", 'hello ' . rand(1, 256), $params);

var_dump( $zk->exists("$path") );
var_dump( $zk->get("$path") );


$zk->get($path, 'cb');

var_dump( "1" );

$zk->set($path, 'hello ' . rand(1, 256), -1, 'cb');

var_dump( "1" );

var_dump( $zk->get("$path") );


//
//function ex() {
//    global $path;
//    var_dump($path . ' now exists');
//}
//
//$zk->watch("$path", 'ex');
//
//var_dump( $zk->exists("$path") );
//$zk->create("$path", 'hello ' . rand(1, 256), $params);
//var_dump( $zk->exists("$path") );
