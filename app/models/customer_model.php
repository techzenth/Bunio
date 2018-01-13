<?php

/**
 * Description of customer_model
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class Customer_Model extends Model {

    private $_setting;

    public function __construct() {
        global $REG;
        $this->_setting = $REG;
        parent::__construct();
    }

    public function save($param = '') {
        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {

            $result["mtype"] = '';
            $result["msg"] = '';
            try {
                $form = new Form();
                $form->post('state')->post('customerId')
                        ->post('customerName')
                        ->post('fleetOrgNumber')
                        ->post('licenseNumber')
                        ->post('vehicleDescription');
                $postf = $form->fetch();
            } catch (Exception $e) {
                $result['msg'] = $e->getMessage();
            }

            $log = Auth::log_info();
            //$result['log'] = $log;
            try {
                if ($postf['state'] == "NEW") {
                    $sth = $this->db->prepare("CALL Add_Customer(:id,:customerName,:fleetOrgNumber,:licenseNumber,:vehicleDescription,:user_id,:machine,:ip_address,:action_type)");
                    $result['method'] = 'Add';
                    $store = array(':id' => $postf['customerId'],
                        ':customerName' => $postf['customerName'],
                        ':fleetOrgNumber' => $postf['fleetOrgNumber'],
                        ':licenseNumber' => $postf['licenseNumber'],
                        ':vehicleDescription' => $postf['vehicleDescription'],
                        ':user_id' => (int) $log['user_id'],
                        ':machine' => $log['machine'],
                        ':ip_address' => $log['ip_address'],
                        ':action_type' => 'Insert from Interface');
                } else {
                    $sth = $this->db->prepare("CALL Update_Customer(:id,:customerName,:fleetOrgNumber,:licenseNumber,:vehicleDescription,:user_id,:machine,:ip_address,:action_type)");
                    $result['method'] = 'Update';
                    $store = array(':id' => $postf['customerId'],
                        ':customerName' => $postf['customerName'],
                        ':fleetOrgNumber' => $postf['fleetOrgNumber'],
                        ':licenseNumber' => $postf['licenseNumber'],
                        ':vehicleDescription' => $postf['vehicleDescription'],
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
                $result['msg'] = "Customer Saved Successfully";
                Session::set('url', 'customer/search'); // set the current page to use in ajax load
                //header("Location: " . $this->_setting->url);
            } else {
                $result['mtype'] = "E";
                $result['msg'] = "Customer could not be saved";
            }
            echo json_encode($result);
            die();
        }
    }

    public function search_count_customers($param = '') {
        try {
            $form = new Form();

            $form->post('customerId')
                    ->post('customerName')
                    ->post('licenseNumber');

            $form->submit();
            //echo 'Form passed';
            $postf = $form->fetch();
        } catch (Exception $e) {
            echo $e->getMessage();
        }
        //print_r($postf);

        $sth = $this->db->prepare("CALL Search_Count_Customers(:id,:customerName,:licenseNumber)");
        $sth->execute(array(':id' => $postf['customerId'],
            ':customerName' => $postf['customerName'],
            ':licenseNumber' => $postf['licenseNumber']));
        $rec_num = $sth->fetchColumn();
        //print "records: " . $rec_num;
        return $rec_num;
    }

    public function search_customers($param = '', $sort = '') {
        try {
            $form = new Form();

            $form->post('customerId')
                    ->post('customerName')
                    ->post('licenseNumber');

            $form->submit();
            //echo 'Form passed';
            $postf = $form->fetch();
        } catch (Exception $e) {
            echo $e->getMessage();
        }
        //print_r($postf);

        $offset = ((int) $param - 1) * $this->_setting->limit;

        $sth = $this->db->prepare("CALL Search_Customers(:id,:customerName,:licenseNumber,:row,:limit,:sort)");
        $sth->execute(array(':id' => $postf['customerId'],
            ':customerName' => $postf['customerName'],
            ':licenseNumber' => $postf['licenseNumber'],
            ':row' => $offset,
            ':limit' => $this->_setting->limit,
            ':sort' => $sort));
        $data = $sth->fetchAll();

        return $data;
    }

    public function delete($param = '') {
        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {
            $result['mtype'] = "";
            $result['msg'] = "";

            $data = Auth::log_info();

            $sth = $this->db->prepare("CALL Delete_Customer(:id,:user_id,:machine,:ip_address,:action_type)");
            $sth->execute(array(':id' => (int) $param,
                ':user_id' => (int) $data['user_id'],
                ':machine' => $data['machine'],
                ':ip_address' => $data['ip_address'],
                ':action_type' => 'Delete from Interface'));
            $count = $sth->rowCount();
            if ($count > 0) {
                $result['mtype'] = "S";
                $result['msg'] = "Customer Deleted Successfully";
                Session::set('current_page', 'customer/search'); // set the current page to use in ajax load
                //header("Location: " . $this->_setting->url);
            } else {
                $result['mtype'] = "E";
                $result['msg'] = "Customer could not be deleted";
            }
            echo json_encode($result);
            die();
        }
    }

    public function get_customer($param = '') {
        $sth = $this->db->prepare("CALL Get_Customer_By_ID(:id)");
        $sth->execute(array(':id' => $param));
        $data = $sth->fetch();
        //print $param;
        //print_r($data);

        return $data;
    }

}
