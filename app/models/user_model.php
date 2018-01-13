<?php

/**
 * Description of user_model
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class User_Model extends Model {

    private $_setting;

    public function __construct() {
        global $REG;
        $this->_setting = $REG;
        parent::__construct();
    }

    public function save($param) {
        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {

            $result["mtype"] = '';
            $result["msg"] = '';
            try {
                $form = new Form();

                $form->post('userId')
                        ->post('username')
                        ->val('minlength', 3)
                        ->post('password')
                        ->val('minlength', 6)
                        ->post('password_again')
                        ->post('user_status')
                        ->post('user_role');

                $form->submit();
                //echo 'Form passed';
                $postf = $form->fetch();
            } catch (Exception $e) {
               $result['msg'] = $e->getMessage();
            }
            //$result['$form'] = $postf;
            $password = Hash::create('md5', $postf['password'], $this->_setting->hash_pass_key);
            //$result['password'] = $password;
            $log = Auth::log_info();
            $result['log'] = $log;
            try {
                if ($postf['userId'] == "") {
                    $sth = $this->db->prepare("CALL Add_User(:username,:password,:status,:role,:user_id,:machine,:ip_address,:action_type)");
                    $result['method'] = 'Add';
                    $store = array(':username' => $postf['username'],
                        ':password' => $password,
                        ':status' => (int) $postf['user_status'],
                        ':role' => (int) $postf['user_role'],
                        ':user_id' => (int) $log['user_id'],
                        ':machine' => $log['machine'],
                        ':ip_address' => $log['ip_address'],
                        ':action_type' => 'Insert from Interface');
                } else {
                    $sth = $this->db->prepare("CALL `Update_User`(:id,:username,:password,:status,:role,:user_id,:machine,:ip_address,:action_type)");
                    $result['method'] = 'Update';
                    $store = array(':id' => (int) $postf['userId'],
                        ':username' => $postf['username'],
                        ':password' => $password,
                        ':status' => (int) $postf['user_status'],
                        ':role' => (int) $postf['user_role'],
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
                $result['msg'] = "User Saved Successfully";
                Session::set('url', 'user/search'); // set the current page to use in ajax load
                //header("Location: " . $this->_setting->url);
            } else {
                $result['mtype'] = "E";
                $result['msg'] = "User could not be saved";
            }
            echo json_encode($result);
            die();
        }
    }

    public function search_count_users($param='') {
        try {
            $form = new Form();

            $form->post('username')
                    ->post('user_status')
                    ->post('user_role');

            $form->submit();
            //echo 'Form passed';
            $postf = $form->fetch();
        } catch (Exception $e) {
            echo $e->getMessage();
        }
        //print_r($postf);

        $sth = $this->db->prepare("CALL Search_Count_Users(:username,:status,:role)");
        $sth->execute(array(':username' => $postf['username'],
            ':status' => (int) $postf['user_status'],
            ':role' => (int) $postf['user_role']));
        $rec_num = $sth->fetchColumn();
        //print "records: " . $rec_num;
        return $rec_num;
    }

    public function search_users($param='', $sort='') {
        try {
            $form = new Form();

            $form->post('username')
                    ->post('user_status')
                    ->post('user_role');

            $form->submit();
            //echo 'Form passed';
            $postf = $form->fetch();
        } catch (Exception $e) {
            echo $e->getMessage();
        }

        $offset = ((int) $param - 1) * $this->_setting->limit;
        //print "page: ".$page;

        $sth = $this->db->prepare("CALL Search_Users(:username,:status,:role,:row,:limit,:sort)"); // Call Search Users
        $sth->execute(array(':username' => $postf['username'],
            ':status' => (int) $postf['user_status'],
            ':role' => (int) $postf['user_role'],
            ':row' => $offset,
            ':limit' => $this->_setting->limit,
            ':sort' => $sort));
        $data = $sth->fetchAll();
Session::set('current_page', 'user/search'); // set the current page to use in ajax load
        return $data;
    }

    public function get_all_user_status($param = '') {

        $sth = $this->db->prepare("SELECT * FROM all_user_status");
        $sth->execute();
        $data = $sth->fetchAll();

        return $data;
    }

    public function get_all_user_roles($param = '') {

        $sth = $this->db->prepare("SELECT * FROM all_user_roles");
        $sth->execute();
        $data = $sth->fetchAll();

        return $data;
    }

    public function get_user($param = '') {
        $sth = $this->db->prepare("CALL Get_User_By_ID(:id)");
        $sth->execute(array(':id' => $param));
        $data = $sth->fetch();
        //print $param;
        //print_r($data);

        return $data;
    }

    public function delete($param) {
        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {
            $result['mtype'] = "";
            $result['msg'] = "";

            $data = Auth::log_info();

            $sth = $this->db->prepare("CALL Delete_User(:id,:user_id,:machine,:ip_address,:action_type)");
            $sth->execute(array(':id' => (int) $param,
                ':user_id' => (int) $data['user_id'],
                ':machine' => $data['machine'],
                ':ip_address' => $data['ip_address'],
                ':action_type' => 'Delete from Interface'));
            $count = $sth->rowCount();
            if ($count > 0) {
                $result['mtype'] = "S";
                $result['msg'] = "User Deleted Successfully";
                Session::set('current_page', 'user/search'); // set the current page to use in ajax load
                //header("Location: " . $this->_setting->url);
            } else {
                $result['mtype'] = "E";
                $result['msg'] = "User could not be deleted";
            }
            echo json_encode($result);
            die();
        }
    }

}
