<?php

/**
 * Description of device_model
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class Device_Model extends Model {

    private $_setting;

    public function __construct() {
        global $REG;
        $this->_setting = $REG;
        parent::__construct();
    }

    public function search_count_devices($param) {
        try {
            $form = new Form();

            $form->post('imei')
                    ->post('msisdn')
                    ->post('simNumber')
                    ->post('device_status');

            $form->submit();
            //echo 'Form passed';
            $postf = $form->fetch();
        } catch (Exception $e) {
            echo $e->getMessage();
        }
        //print_r($postf);

        $sth = $this->db->prepare("CALL Search_Count_Devices(:imei,:msisdn,:simNumber,:device_status)");
        $sth->execute(array(':imei' => $postf['imei'],
            ':msisdn' => $postf['msisdn'],
            ':simNumber' => $postf['simNumber'],
            ':device_status' => (int) $postf['device_status']));
        $rec_num = $sth->fetchColumn();
        //print "records: " . $rec_num;
        return $rec_num;
    }

    public function search_devices($param, $sort) {
        try {
            $form = new Form();

            $form->post('imei')
                    ->post('msisdn')
                    ->post('simNumber')
                    ->post('device_status');

            $form->submit();
            //echo 'Form passed';
            $postf = $form->fetch();
        } catch (Exception $e) {
            echo $e->getMessage();
        }
        //print_r($postf);
        $offset = ((int) $param - 1) * $this->_setting->limit;

        $sth = $this->db->prepare("CALL Search_Devices(:imei,:msisdn,:simNumber,:device_status,:row,:limit,:sort)");
        $sth->execute(array(':imei' => $postf['imei'],
            ':msisdn' => $postf['msisdn'],
            ':simNumber' => $postf['simNumber'],
            ':device_status' => (int) $postf['device_status'],
            ':row' => $offset,
            ':limit' => $this->_setting->limit,
            ':sort' => $sort));
        $data = $sth->fetchAll();
        //print_r($data);
        Session::set('url', 'device/search'); // set the current page to use in ajax load
        return $data;
    }

    public function get_device($imei = '') {
        
        $sth = $this->db->prepare("CALL Get_Device_By_Number(:number)");
        $sth->execute(array(':number' => $imei));
        $data = $sth->fetch();
        //print $data['imei'];
        //print $param;
        //print_r($data);

        return $data;
    }

    public function count_notes($imei = '') {
        $sth = $this->db->prepare("CALL `Count_Imei_Notes`(:imei)");
        $sth->execute(array(':imei' => $imei));
        $data = $sth->fetch();
        
        return $data['notes_count'];
        //$rec_num = $sth->fetchColumn();
        //print 'Imei: ' . $imei . ' count: ' . $rec_num;
        //return $rec_num;
    }

    public function get_all_device_status() {
        $sth = $this->db->prepare("SELECT * FROM all_device_status");
        $sth->execute();
        $data = $sth->fetchAll();

        return $data;
    }

    public function save($param = '') {
        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {

            $result["mtype"] = '';
            $result["msg"] = '';
            try {
                $form = new Form();
                $form->post('state')->post('dNumber')
                        ->post('deviceVersion')
                        ->post('imei')
                        ->post('msisdn')
                        ->post('simNumber')
                        ->post('deviceStatus');
                $postf = $form->fetch();
            } catch (Exception $e) {
                $result['msg'] = $e->getMessage();
            }

            $result['$form'] = $postf;
            $log = Auth::log_info();
            //$result['log'] = $log;
            try {
                if ($postf['state'] == "NEW") {
                    $sth = $this->db->prepare("CALL Add_Device(:id,:deviceVersion,:imei,:msisdn,:simNumber,:deviceStatus,:user_id,:machine,:ip_address,:action_type)");
                    $result['method'] = 'Add';
                    $store = array(':id' => $postf['dNumber'],
                        ':deviceVersion' => $postf['deviceVersion'],
                        ':imei' => $postf['imei'],
                        ':msisdn' => $postf['msisdn'],
                        ':simNumber' => $postf['simNumber'],
                        ':deviceStatus' => (int) $postf['deviceStatus'],
                        ':user_id' => (int) $log['user_id'],
                        ':machine' => $log['machine'],
                        ':ip_address' => $log['ip_address'],
                        ':action_type' => 'Insert from Interface');
                } else {
                    $sth = $this->db->prepare("CALL Update_Device(:id,:deviceVersion,:imei,:msisdn,:simNumber,:deviceStatus,:user_id,:machine,:ip_address,:action_type)");
                    $result['method'] = 'Update';
                    $store = array(':id' => $postf['dNumber'],
                        ':deviceVersion' => $postf['deviceVersion'],
                        ':imei' => $postf['imei'],
                        ':msisdn' => $postf['msisdn'],
                        ':simNumber' => $postf['simNumber'],
                        ':deviceStatus' => (int) $postf['deviceStatus'],
                        ':user_id' => (int) $log['user_id'],
                        ':machine' => $log['machine'],
                        ':ip_address' => $log['ip_address'],
                        ':action_type' => 'Update from Interface');
                }
                //$result['store'] = $store;
                $sth->execute($store);
                $count = $sth->rowCount();
            } catch (PDOException $e) {
                $result['mtype'] = "E";
                $result['msg'] = $e->getMessage();
            }
            if ($count > 0) {
                $result['mtype'] = "S";
                $result['msg'] = "Device Saved Successfully";
                Session::set('url', 'device/search'); // set the current page to use in ajax load
                //header("Location: " . $this->_setting->url);
            } else {
                $result['mtype'] = "E";
                $result['msg'] = "Device could not be saved";
            }
            echo json_encode($result);
            die();
        }
    }

    public function delete($param) {
        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {
            $result['mtype'] = "";
            $result['msg'] = "";

            $data = Auth::log_info();

            $sth = $this->db->prepare("CALL Delete_Device(:id,:user_id,:machine,:ip_address,:action_type)");
            $sth->execute(array(':id' => (int) $param,
                ':user_id' => (int) $data['user_id'],
                ':machine' => $data['machine'],
                ':ip_address' => $data['ip_address'],
                ':action_type' => 'Delete from Interface'));
            $count = $sth->rowCount();
            if ($count > 0) {
                $result['mtype'] = "S";
                $result['msg'] = "Device Deleted Successfully";
                Session::set('current_page', 'user/search'); // set the current page to use in ajax load
                //header("Location: " . $this->_setting->url);
            } else {
                $result['mtype'] = "E";
                $result['msg'] = "Device could not be deleted";
            }
            echo json_encode($result);
            die();
        }
    }

}
