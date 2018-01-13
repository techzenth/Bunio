<?php

/**
 * Description of about
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class About  extends Controller {

    public $cfg;

    function __construct() {
        global $REG;
        $this->cfg = $REG;
        parent::__construct();
        //print "Index Page";
    }
    
    function index($param='') {
        
        $this->view->title = 'About';
        $this->view->data = array('description' => 'This page is the about page', 
            'cfg' => $this->cfg, 
            'records' => $data);
        //$this->view->css = array('/signin/css/signin.css');
        //$this->view->render("header");
        $this->view->render("about/index");
        //$this->view->render("footer");
    }
    
    function help($param='') {
        
    }
}
