<?php

class Controller {

    function __construct() {
        //print "Controller Main<br/>";
        global $REG;
        $this->cfg = $REG;
        $this->view = new View();
    }

    function loadModel($name, $modelpath) {
        $file = $modelpath . $name . '_model.php';
        if (file_exists($file)) {
            require $file;

            $modelName = $name . '_Model';
            $this->model = new $modelName;
        }
    }

    function run() {
        $this->model->run();
    }

}
