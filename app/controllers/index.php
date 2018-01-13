<?php

class Index extends Controller {

    public $cfg;

    function __construct() {
        global $REG;
        $this->cfg = $REG;
        parent::__construct();
        //print "Index Page"; 
        //$this->model->checkSession();

    }

    function index() {
        $this->logged = Auth::handleLogin();

        $this->view->title = 'Index';
        $this->view->data = array('description' => 'This page is the index',
            'cfg' => $this->cfg,
            'loggedin' => $this->logged,
            'url' => Session::get('url'));

        $this->view->alert = Session::get('alert'); // show in view
        $this->view->alert['sticky'] == true ? : Session::set('alert', ''); // unset so that it is displayed once
        echo "<!--" . strtoupper("Welcome to " . $this->view->data['cfg']->title) . "-->";
        $this->view->render("header");
        $this->view->render("index/index");
        $this->view->render("footer");
    }

}
