<?php

class Model {

    function __construct() {
        //print "Model main";
        global $REG;
        $this->cfg = $REG;
        $this->db = new Database();
    }

}
