<?php

/*
 * Here comes the text of your license
 * Each line should be prefixed with  * 
 */

/**
 * Description of imei_note_model
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class Imei_Note_Model extends Model {

    private $_setting;

    public function __construct() {
        global $REG;
        $this->_setting = $REG;
        parent::__construct();
    }

    public function view_notes($imei) {
        try {
            $sth = $this->db->prepare("CALL View_Imei_Notes(:imei)");
            $sth->execute(array(':imei' => $imei));
            $data = $sth->fetchAll();
        } catch (PDOException $e) {

            print $e->getMessage();
        }
        //print_r($data);
        return $data;
    }

    public function save($id) {
        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {

            $result["mtype"] = '';
            $result["msg"] = '';
            try {
                $form = new Form();
                $form->post('state')
                        ->post('imei')
                        ->post('imei_notes')
                        ->post('expiryDate');
                $postf = $form->fetch();
            } catch (Exception $e) {
                $result['msg'] = $e->getMessage();
            }

            $log = Auth::log_info();
            //$result['log'] = $log;
            try {
                if ($postf['state'] == "NEW") {
                    $sth = $this->db->prepare("CALL Add_Imei_Note(:imei, :notes, :expiryDate,:user_id,:machine,:ip_address,:action_type)");
                    $result['method'] = 'Add';
                    $store = array(':imei' => $postf['imei'],
                        ':notes' => $postf['imei_notes'],
                        ':expiryDate' => $postf['expiryDate'],
                        ':user_id' => (int) $log['user_id'],
                        ':machine' => $log['machine'],
                        ':ip_address' => $log['ip_address'],
                        ':action_type' => 'Insert from Interface');
                } else {
                    $sth = $this->db->prepare("CALL Update_Imei_Note(:imei, :id, :notes, :expiryDate,:user_id,:machine,:ip_address,:action_type)");
                    $result['method'] = 'Update';
                    $store = array(':id' => $id,
                        ':imei' => $postf['imei'],
                        ':notes' => $postf['imei_notes'],
                        ':expiryDate' => $postf['expiryDate'],
                        ':user_id' => (int) $log['user_id'],
                        ':machine' => $log['machine'],
                        ':ip_address' => $log['ip_address'],
                        ':action_type' => 'Update from Interface');
                }
                $result['store'] = $store;
                $sth->execute($store);

                $count = $sth->rowCount();
            } catch (PDOException $e) {
                $result['mtype'] = "E";
                $result['msg'] = $e->getMessage();
            }
            if ($count > 0) {
                $result['mtype'] = "S";
                $result['msg'] = "Imei_Note Saved Successfully";
                Session::set('url', 'device/search'); // set the current page to use in ajax load
                //header("Location: " . $this->_setting->url);
            } else {
                $result['mtype'] = "E";
                $result['msg'] = "Imei_Note could not be saved";
            }
            echo json_encode($result);
            die();
        }
    }

}
