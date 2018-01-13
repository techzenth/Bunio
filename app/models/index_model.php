<?php

/**
 * Description of index_model
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class Index_Model extends Model {

    //put your code here

    private $_setting;

    public function __construct() {
        global $REG;
        $this->_setting = $REG;
        //print 111;
        parent::__construct();
    }

    public function checkSession() {
        $sess_id = Session::id();

        $sth = $this->db->prepare("CALL Check_Session(:session)");
        $sth->execute(array(':session' => $sess_id));
        $data = $sth->fetch();
        $count = $sth->rowCount();
        if ($count > 0) {
            // auto login
            Session::set('bunio_user', $data);
            Session::set('bunio_loggedIn', true);
        }
    }
   

}
