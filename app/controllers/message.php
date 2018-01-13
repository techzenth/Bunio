<?php

/*
 * Here comes the text of your license
 * Each line should be prefixed with  * 
 */

/**
 * Description of message
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class Message extends Controller{

    public $cfg;
    
	function __construct(){
	global $REG;
        $this->cfg = $REG;	
            parent::__construct();
		
		
	}
	
        function index(){
            $data = $this->model->get_message_users();
            echo json_encode($data);
            die();
        }
        
        function text($param){
            $data = $this->model->get_chat($param);
            echo json_encode($data);
            die();
        }
}
