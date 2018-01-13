<?php

class Cover extends Controller{

	function __construct(){
		parent::__construct();
		//print "cover Page";
		Session::init();
		$logged = Session::get('loggedIn');
		
	}
	
	function index(){
		$this->view->data=array('title'=>'Cover', 'description'=>'This page is the index');
		$this->view->css = array('/cover/css/cover.css');
                $this->view->render("header");
		$this->view->render("cover/index");
                $this->view->render("footer");
		
	}
	
	
}