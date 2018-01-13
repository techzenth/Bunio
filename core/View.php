<?php

class View {

    function __construct() {
        //print "View main";
    }

    public function render($name) {
        require "app/views/$name.php";
    }

}

?>