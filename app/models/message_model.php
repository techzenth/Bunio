<?php

/*
 * Here comes the text of your license
 * Each line should be prefixed with  * 
 */

/**
 * Description of message_model
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class Message_Model extends Model {

    private $_setting;

    public function __construct() {
        global $REG;
        $this->_setting = $REG;
        parent::__construct();
    }
    
    public function get_message_users() {
        $data = Auth::log_info();
        $sth = $this->db->prepare("CALL Get_Message_Users(:id)");
        $sth->execute(array(':id' => $data['user_id']));
        $users = $sth->fetch(PDO::FETCH_ASSOC);
        //print $param;
        //print_r($data);

        return $users;
    }
    
    public function get_chat($param){
        $data = Auth::log_info();
        $sth = $this->db->prepare("CALL Get_Chat(:sender,:receiver)");
        $sth->execute(array(':sender' => $data['user_id'],':receiver'=>$param));
        $chat = $sth->fetch(PDO::FETCH_ASSOC);
        //print $param;
        //print_r($data);

        return $chat;
    }
}
