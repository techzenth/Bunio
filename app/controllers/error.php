<?php

class Error extends Controller{

	function __construct(){
              global $REG;
        $this->cfg = $REG;
		parent::__construct();
		//print "<h1>Error Page</h1>";
		
	}
	
	function index(){
		$this->view->title = 'Error';
		$this->view->data=array('description'=>'This is the error page', 'msg'=>'The page doesn\'t exists','cfg'=>$this->cfg);
		$this->view->css = array('/error/css/error-template.css');
		//$this->view->render("header");
		$this->view->render("error/index");
		//$this->view->render("footer");
	}
}