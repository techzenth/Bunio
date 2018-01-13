<?php

/**
 * Description of device_assignment_model
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class Device_Assignment_Model extends Model {

    private $_setting;

    public function __construct() {
        global $REG;
        $this->_setting = $REG;
        parent::__construct();
    }

    public function assign($param = '') {
        if ($param == 'save' && filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {
            $result["mtype"] = '';
            $result["msg"] = '';
            try {
                $form = new Form();

                $form->post('customer')->post('customerId')
                        ->post('simNumber')
                        ->post('imei')
                        ->post('imeiNumber')
                        ->post('installDate')
                        ->post('installFee')
                        ->post('subscribeFee')
                        ->post('additionalFeatures')
                        ->post('technician')
                        ->post('jobDecription')
                        ->post_array('services');

                $form->submit();
                //echo 'Form passed';
                $postf = $form->fetch();
            } catch (Exception $e) {
                $result["mtype"] = 'E';
                $result['msg'] = $e->getMessage();
            }

            //$result['postArray'] = implode(",",$_POST['services']);
            //$result['$form'] = $postf;
            $log = Auth::log_info();
            //$result['log'] = $log;
            try {
                if ($postf['customer'] == "") {
                    $sth = $this->db->prepare("CALL Add_Device_Assignment(:id,:sim_number,:imei,:install_date,:install_fee,:subscribe_fee,:additional_features,:technician,:job_description,:services,:user_id,:machine,:ip_address,:action_type)");
                    $result['method'] = 'Add';
                    $store = array(':id' => $postf['customerId'],
                        ':sim_number' => $postf['simNumber'],
                        ':imei' => $postf['imei'],
                        ':install_date' => $postf['installDate'],
                        ':install_fee' => $postf['installFee'],
                        ':subscribe_fee' => $postf['subscribeFee'],
                        ':additional_features' => trim($postf['additionalFeatures']),
                        ':technician' => (int) $postf['technician'],
                        ':job_description' => trim($postf['jobDecription']),
                        ':services' => $postf['services'],
                        ':user_id' => (int) $log['user_id'],
                        ':machine' => $log['machine'],
                        ':ip_address' => $log['ip_address'],
                        ':action_type' => 'Insert from Interface');
                } else {
                    $sth = $this->db->prepare("CALL Update_Device_Assignment(:id,:sim_number,:imei, :new_imei,:install_date,:install_fee,:subscribe_fee,:additional_features,:technician,:job_description,:services,:user_id,:machine,:ip_address,:action_type)");
                    $result['method'] = 'Update';
                    $store = array(':id' => $postf['customerId'],
                        ':sim_number' => $postf['simNumber'],
                        ':imei' => $postf['imeiNumber'],
                        ':new_imei' => $postf['imei'],
                        ':install_date' => $postf['installDate'],
                        ':install_fee' => $postf['installFee'],
                        ':subscribe_fee' => $postf['subscribeFee'],
                        ':additional_features' => trim($postf['additionalFeatures']),
                        ':technician' => (int) $postf['technician'],
                        ':job_description' => trim($postf['jobDecription']),
                        ':services' => $postf['services'],
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
                $result['msg'] = "Device Assignment Saved Successfully";
                Session::set('url', 'device_assignment/search'); // set the current page to use in ajax load
                //header("Location: " . $this->_setting->url);
            } else {
                $result['mtype'] = "E";
                $result['msg'] = "Device Assignment could not be saved";
            }
            echo json_encode($result);
            die();
        }
    }

    public function delete($id, $imei) {
        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {
            $result['mtype'] = "";
            $result['msg'] = "";

            $data = Auth::log_info();

            $sth = $this->db->prepare("CALL Delete_Device_Assignment(:id, :imei,:user_id,:machine,:ip_address,:action_type)");
            $sth->execute(array(':id' => (int) $id,
                ':imei' => $imei,
                ':user_id' => (int) $data['user_id'],
                ':machine' => $data['machine'],
                ':ip_address' => $data['ip_address'],
                ':action_type' => 'Delete from Interface'));
            $count = $sth->rowCount();
            if ($count > 0) {
                $result['mtype'] = "S";
                $result['msg'] = "Device_Assignment Deleted Successfully";
                Session::set('current_page', 'user/search'); // set the current page to use in ajax load
                //header("Location: " . $this->_setting->url);
            } else {
                $result['mtype'] = "E";
                $result['msg'] = "Device_Assignment could not be deleted";
            }
            echo json_encode($result);
            die();
        }
    }

    public function search_count_device_assignment($param = '') {
        try {
            $form = new Form();

            $form->post('customerId')
                    ->post('customerName')
                    ->post('imei')
                    ->post('licenseNumber');

            $form->submit();
            //echo 'Form passed';
            $postf = $form->fetch();
        } catch (Exception $e) {
            echo $e->getMessage();
        }

        //print_r($postf);

        $sth = $this->db->prepare("CALL Search_Count_Device_Assignment(:id,:customerName,:imei,:licenseNumber)");
        $sth->execute(array(':id' => (int) $postf['customerId'],
            ':customerName' => $postf['customerName'],
            ':imei' => $postf['imei'],
            ':licenseNumber' => $postf['licenseNumber']));
        $rec_num = $sth->fetchColumn();
        //print "records: " . $rec_num;
        return $rec_num;
    }

    public function search_device_assignment($param = '', $sort = '') {
        try {
            $form = new Form();

            $form->post('customerId')
                    ->post('customerName')
                    ->post('imei')
                    ->post('licenseNumber');

            $form->submit();
            //echo 'Form passed';
            $postf = $form->fetch();
        } catch (Exception $e) {
            echo $e->getMessage();
        }

        $offset = ((int) $param - 1) * $this->_setting->limit;
        //print "page: ".$page;

        $sth = $this->db->prepare("CALL Search_Device_Assignment(:id,:customerName,:imei,:licenseNumber,:row,:limit,:sort)");
        $sth->execute(array(':id' => (int) $postf['customerId'],
            ':customerName' => $postf['customerName'],
            ':imei' => $postf['imei'],
            ':licenseNumber' => $postf['licenseNumber'],
            ':row' => $offset,
            ':limit' => $this->_setting->limit,
            ':sort' => $sort));

        $data = $sth->fetchAll();
        Session::set('url', 'device_assignment/search'); // set the current page to use in ajax load
        return $data;
    }

    public function get_assignment($id = '', $imei = '') {
        $sth = $this->db->prepare("CALL Get_Assignment_By_Customer_Device(:id,:imei)");
        $sth->execute(array(':id' => $id, ':imei' => $imei));
        $data = $sth->fetch();
        //print $param;
        //print_r($data);

        return $data;
    }

    public function get_all_customers($param = '') {

        $sth = $this->db->prepare("SELECT * FROM all_customers");
        $sth->execute();
        $data = $sth->fetchAll();

        return $data;
    }

    public function get_customers($param = '') {
        try {
            $form = new Form();

            $form->post('customer');

            $form->submit();
            //echo 'Form passed';
            $postf = $form->fetch();
        } catch (Exception $e) {
            $result['mtype'] = 'E';
            $result['msg'] = $e->getMessage();
        }
        $sth = $this->db->prepare("SELECT id, customer_name FROM all_customers WHERE customer_name LIKE :customer LIMIT 10");
        $sth->execute(array(':customer' => $postf['customer'] . '%'));
        $result['data'] = $sth->fetchAll(PDO::FETCH_ASSOC);
        $count = $sth->rowCount();
        if ($count > 0) {
            $result['mtype'] = 'S';
            $result['msg'] = $count . ' Customers ';
        } else {
            $result['mtype'] = 'E';
            $result['msg'] = 'No values';
        }
        return $result;
    }

    public function get_all_devices($param = '') {

        $sth = $this->db->prepare("SELECT * FROM all_devices");
        $sth->execute();
        $data = $sth->fetchAll();

        return $data;
    }

    public function get_all_technicians($param = '') {

        $sth = $this->db->prepare("SELECT * FROM all_technicians");
        $sth->execute();
        $data = $sth->fetchAll();
        //print_r($data);
        return $data;
    }

}
