<?php

class Account extends Controller {

    public $cfg;

    function __construct() {
    global $REG;
        $this->cfg = $REG;
        parent::__construct();
        //print "signin Page";
        //Session::init();
        //$logged = Session::get('bunio_loggedIn');
    }

    function index() {
        
        $this->view->title = 'Account';
        $this->view->data = array('description' => 'This page is the index', 'cfg' => $this->cfg);
        //$this->view->css = array('/signin/css/signin.css');
        //$this->view->render("header");
        $this->view->render("account/index");
        //$this->view->render("footer");
    }
    
    function check_session(){
        $this->model->checkSession();        
    }
    
    function logout() {    
        $this->model->logout();
        header('location: ' . $this->cfg->url . 'index');
    }
    
    function reset($param='') {
        $this->model->reset($param);
                
        $this->view->title = 'Reset Password';
        $this->view->data = array('description' => 'This page is the reset password', 'cfg' => $this->cfg);
        //$this->view->css = array('/signin/css/signin.css');
        //$this->view->render("header");
        $this->view->render("account/reset");
        //$this->view->render("footer");
    }
    

    function signin($param='') {    

        $this->model->signin();

        $this->view->title = 'Login';
        $this->view->data = array('description' => 'This page is the index', 'cfg' => $this->cfg);
        //$this->view->css = array('/signin/css/signin.css');
        //$this->view->render("header");
        $this->view->render("account/signin");
        //$this->view->render("footer");
    }

    

}
