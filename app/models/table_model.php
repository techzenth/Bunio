<?php

/*
 * Here comes the text of your license
 * Each line should be prefixed with  * 
 */

/**
 * Description of table_model
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class Table_Model extends Model {

    private $_setting;

    public function __construct() {
        global $REG;
        $this->_setting = $REG;
        parent::__construct();
    }

    public function device_status($param = '', $id = '') {
        //print $param;
        //print $id;
        switch ($param) {
            case 'delete':
                $this->delete_device_status($param, $id);
                break;
            case 'edit':
                $this->edit_device_status($param, $id);
                break;
            case 'save':
                $this->save_device_status($param, $id);
                break;
            case 'search':
            default :
                return $this->search_device_status($param);
        }
    }

    private function delete_device_status($param = '', $id = '') {
        $log = Auth::log_info();
        $sth = $this->db->prepare("CALL Delete_Device_Status(:id,:user_id,:machine,:ip_address,:action_type)"); // Call Search Users
        $sth->execute(array(':id' => (int) $id,
            ':user_id' => (int) $log['user_id'],
            ':machine' => $log['machine'],
            ':ip_address' => $log['ip_address'],
            ':action_type' => 'Delete from Interface'));
        $count = $sth->rowCount();
        if ($count > 0) {
            $result['mtype'] = "S";
            $result['msg'] = "Device_Status Deleted Successfully";
            //Session::set('url', 'user/index'); // set the current page to use in ajax load
            //header("Location: " . $this->_setting->url);
        } else {
            $result['mtype'] = "E";
            $result['msg'] = "Device_Status could not be deleted";
        }
        echo json_encode($result);
        die();
    }

    private function edit_device_status($param = '', $id = '') {
        $sth = $this->db->prepare("CALL Get_Device_Status(:status)"); // Call Search Users
        $sth->execute(array(':status' => $id));
        $data = $sth->fetch();

        echo json_encode($data);
        die();
    }

    private function save_device_status($param = '', $id = '') {
        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {

            $result["mtype"] = '';
            $result["msg"] = '';
            try {
                $form = new Form();

                $form->post('device_status_name')
                        ->post('device_status_id');
                $form->submit();

                $postf = $form->fetch();
            } catch (Exception $e) {
                $result['mtype'] = 'E';
                $result['msg'] = $e->getMessage();
            }
            //$result['$form'] = $postf;
            $log = Auth::log_info();
            //$result['log'] = $log;
            if ($postf['device_status_id'] == "") {
                $sth = $this->db->prepare("CALL Add_Device_Status(:device_status,:user_id,:machine,:ip_address,:action_type)");
                $result['method'] = 'Add';
                $store = array(':device_status' => $postf['device_status_name'],
                    ':user_id' => (int) $log['user_id'],
                    ':machine' => $log['machine'],
                    ':ip_address' => $log['ip_address'],
                    ':action_type' => 'Insert from Interface');
            } else {
                $sth = $this->db->prepare("CALL Update_Device_Status(:id,:device_status,:user_id,:machine,:ip_address,:action_type)");
                $result['method'] = 'Update';
                $store = array(':id' => (int) $postf['device_status_id'],
                    ':device_status' => $postf['device_status_name'],
                    ':user_id' => (int) $log['user_id'],
                    ':machine' => $log['machine'],
                    ':ip_address' => $log['ip_address'],
                    ':action_type' => 'Update from Interface');
            }
            //$result['store'] = $store;
            $sth->execute($store);

            $count = $sth->rowCount();
            if ($count > 0) {
                $result['mtype'] = "S";
                $result['msg'] = "Device Status Saved Successfully";
                //Session::set('url', 'device/index'); // set the current page to use in ajax load
            } else {
                $result['mtype'] = "E";
                $result['msg'] = "Device Status could not be saved";
            }
            echo json_encode($result);
            die();
        }
    }

    private function search_device_status($param = '') {
        try {
            $form = new Form();

            $form->post('device_status');

            $form->submit();
            //echo 'Form passed';
            $postf = $form->fetch();
        } catch (Exception $e) {
            echo $e->getMessage();
        }

        $sth = $this->db->prepare("CALL `Search_Device_Status`(:device_status)"); // Call Search devices
        $sth->execute(array(':device_status' => $postf['device_status']));
        $data = $sth->fetchAll();
        //print(json_encode($data));
        return $data;
    }

    public function permission($param = '', $id = '') {
        //print $param;
        //print $id;
        switch ($param) {
            case 'delete':
                $this->delete_permission($param, $id);
                break;
            case 'edit':
                $this->edit_permission($param, $id);
                break;
            case 'save':
                $this->save_permission($param, $id);
                break;
            case 'search':
            default :
                return $this->search_permissions($param);
        }
    }

    private function delete_permission($param = '', $id = '') {
        $log = Auth::log_info();
        $sth = $this->db->prepare("CALL Delete_Permission(:permission,:user_id,:machine,:ip_address,:action_type)"); // Call Search Users
        $sth->execute(array(':permission' => $id,
            ':user_id' => (int) $log['user_id'],
            ':machine' => $log['machine'],
            ':ip_address' => $log['ip_address'],
            ':action_type' => 'Delete from Interface'));
        $count = $sth->rowCount();
        if ($count > 0) {
            $result['mtype'] = "S";
            $result['msg'] = "Permission Deleted Successfully";
            //Session::set('url', 'user/index'); // set the current page to use in ajax load
            //header("Location: " . $this->_setting->url);
        } else {
            $result['mtype'] = "E";
            $result['msg'] = "Permission could not be deleted";
        }
        echo json_encode($result);
        die();
    }

    private function edit_permission($param = '', $id = '') {
        $sth = $this->db->prepare("CALL Get_Permission(:permission)"); // Call Search Users
        $sth->execute(array(':permission' => $id));
        $data = $sth->fetch();

        echo json_encode($data);
        die();
    }

    private function save_permission($param = '', $id = '') {
        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {

            $result["mtype"] = '';
            $result["msg"] = '';
            try {
                $form = new Form();

                $form->post('permission_name')
                        ->post('permission_id')
                        ->post('permission_add')
                        ->post('permission_delete')
                        ->post('permission_edit')
                        ->post('permission_view');
                $form->submit();
                //echo 'Form passed';
                $postf = $form->fetch();
            } catch (Exception $e) {
                echo $e->getMessage();
            }
            //$result['$form'] = $postf;
            $log = Auth::log_info();
            $result['log'] = $log;
            if ($postf['permission_id'] == "") {
                $sth = $this->db->prepare("CALL Add_Permission(:permission,:add,:delete,:edit,:view,:user_id,:machine,:ip_address,:action_type)");
                $result['method'] = 'Add';
                $store = array(':permission' => $postf['permission_name'],
                    ':add' => (int) $postf['permission_add'],
                    ':delete' => (int) $postf['permission_delete'],
                    ':edit' => (int) $postf['permission_edit'],
                    ':view' => (int) $postf['permission_view'],
                    ':user_id' => (int) $log['user_id'],
                    ':machine' => $log['machine'],
                    ':ip_address' => $log['ip_address'],
                    ':action_type' => 'Insert from Interface');
            } else {
                $sth = $this->db->prepare("CALL Update_Permission(:id,:permission,:add,:delete,:edit,:view,:user_id,:machine,:ip_address,:action_type)");
                $result['method'] = 'Update';
                $store = array(':id' => $postf['permission_id'],
                    ':permission' => $postf['permission_name'],
                    ':add' => (int) $postf['permission_add'],
                    ':delete' => (int) $postf['permission_delete'],
                    ':edit' => (int) $postf['permission_edit'],
                    ':view' => (int) $postf['permission_view'],
                    ':user_id' => (int) $log['user_id'],
                    ':machine' => $log['machine'],
                    ':ip_address' => $log['ip_address'],
                    ':action_type' => 'Update from Interface');
            }
            //$result['store'] = $store;
            $sth->execute($store);

            $count = $sth->rowCount();
            if ($count > 0) {
                $result['mtype'] = "S";
                $result['msg'] = "Permission Saved Successfully";
                //Session::set('url', 'user/index'); // set the current page to use in ajax load
                //header("Location: " . $this->_setting->url);
            } else {
                $result['mtype'] = "E";
                $result['msg'] = "Permission could not be saved";
            }
            echo json_encode($result);
            die();
        }
    }

    private function search_permissions($param = '') {

        try {
            $form = new Form();

            $form->post('permission');

            $form->submit();
            //echo 'Form passed';
            $postf = $form->fetch();
        } catch (Exception $e) {
            echo $e->getMessage();
        }

        $sth = $this->db->prepare("CALL Search_Permissions(:permission)"); // Call Search Users
        $sth->execute(array(':permission' => $postf['permission']));
        $data = $sth->fetchAll();
        //print(json_encode($data));
        return $data;
    }

    public function role_permission($param = '', $id = '') {
        //print $param;
        //print $id;
        switch ($param) {
            case 'delete':
                $this->delete_role_permission($param, $id);
                break;
            case 'edit':
                $this->edit_role_permission($param, $id);
                break;
            case 'save':
                $this->save_role_permission($param, $id);
                break;
            case 'search':
            default :
                return $this->search_role_permissions($param);
        }
    }

    private function delete_role_permission($param = '', $id = '') {
        $log = Auth::log_info();
        $sth = $this->db->prepare("CALL Delete_Permission(:role_permission,:user_id,:machine,:ip_address,:action_type)"); // Call Search Users
        $sth->execute(array(':role_permission' => $id,
            ':user_id' => (int) $log['user_id'],
            ':machine' => $log['machine'],
            ':ip_address' => $log['ip_address'],
            ':action_type' => 'Delete from Interface'));
        $count = $sth->rowCount();
        if ($count > 0) {
            $result['mtype'] = "S";
            $result['msg'] = "Permission Deleted Successfully";
            //Session::set('url', 'user/index'); // set the current page to use in ajax load
            //header("Location: " . $this->_setting->url);
        } else {
            $result['mtype'] = "E";
            $result['msg'] = "Permission could not be deleted";
        }
        echo json_encode($result);
        die();
    }

    private function edit_role_permission($param = '', $id = '') {
        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {
            try {
                $form = new Form();

                $form->post('permission')
                        ->post('role')
                        ->post('right');

                $form->submit();
                //echo 'Form passed';
                $postf = $form->fetch();
            } catch (Exception $e) {
                echo $e->getMessage();
            }
            $result['$form'] = $postf;
            $sth = $this->db->prepare("CALL Set_Role_Permission(:role,:permission,:right)"); // Call Set Role Permissions
            $sth->execute(array(':role' => $postf['role'],
                ':permission' => $postf['permission'],
                ':right' => $postf['right']
            ));
            $count = $sth->rowCount();
            if ($count > 0) {
                $result['mtype'] = "S";
                $result['msg'] = "Role Permission Saved Successfully";
                //Session::set('url', 'user/index'); // set the current page to use in ajax load
                //header("Location: " . $this->_setting->url);
            } else {
                $result['mtype'] = "E";
                $result['msg'] = "Role Permission could not be saved";
            }
            echo json_encode($result);
            die();
        }
    }

    private function save_role_permission($param = '', $id = '') {
        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {

            $result["mtype"] = '';
            $result["msg"] = '';
            try {
                $form = new Form();

                $form->post('permissions')
                        ->post('roles');
                $form->submit();
                //echo 'Form passed';
                $postf = $form->fetch();
            } catch (Exception $e) {
                echo $e->getMessage();
            }
            //$result['$form'] = $postf;
            $log = Auth::log_info();
            //$result['log'] = $log;
            if ($postf['permission_id'] == "" && $postf['role_id'] == "") {
                $sth = $this->db->prepare("CALL Add_Role_Permission(:role,:permission,:user_id,:machine,:ip_address,:action_type)");
                $result['method'] = 'Add';
                $store = array(':role' => (int) $postf['roles'],
                    ':permission' => (int) $postf['permissions'],
                    ':user_id' => (int) $log['user_id'],
                    ':machine' => $log['machine'],
                    ':ip_address' => $log['ip_address'],
                    ':action_type' => 'Insert from Interface');
            } else {
                $sth = $this->db->prepare("CALL Update_Role_Permission(:id,:role_permission,:add,:delete,:edit,:view,:user_id,:machine,:ip_address,:action_type)");
                $result['method'] = 'Update';
                $store = array(':id' => $postf['role_permission_id'],
                    ':role_permission' => $postf['role_permission_name'],
                    ':add' => (int) $postf['role_permission_add'],
                    ':delete' => (int) $postf['role_permission_delete'],
                    ':edit' => (int) $postf['role_permission_edit'],
                    ':view' => (int) $postf['role_permission_view'],
                    ':user_id' => (int) $log['user_id'],
                    ':machine' => $log['machine'],
                    ':ip_address' => $log['ip_address'],
                    ':action_type' => 'Update from Interface');
            }
            //$result['store'] = $store;
            $sth->execute($store);

            $count = $sth->rowCount();
            if ($count > 0) {
                $result['mtype'] = "S";
                $result['msg'] = "Permission Saved Successfully";
                //Session::set('url', 'user/index'); // set the current page to use in ajax load
                //header("Location: " . $this->_setting->url);
            } else {
                $result['mtype'] = "E";
                $result['msg'] = "Permission could not be saved";
            }
            echo json_encode($result);
            die();
        }
    }

    private function search_role_permissions($param = '') {
        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {
            try {
                $form = new Form();

                $form->post('roles')
                        ->post('permissions');

                $form->submit();
                //echo 'Form passed';
                $postf = $form->fetch();
            } catch (Exception $e) {
                echo $e->getMessage();
            }

            $sth = $this->db->prepare("CALL Search_Role_Permissions(:role,:permission)"); // Call Search Users
            $sth->execute(array(':role' => (int) $postf['roles'],
                ':permission' => $postf['permissions']));
            $data = $sth->fetchAll();
            //print(json_encode($data));
            return $data;
        }
    }

    public function technician($param = '', $id = '') {
        //print $param;
        //print $id;
        switch ($param) {
            case 'delete':
                $this->delete_technician($param, $id);
                break;
            case 'edit':
                $this->edit_technician($param, $id);
                break;
            case 'save':
                $this->save_technician($param, $id);
                break;
            case 'search':
            default :
                return $this->search_technicians($param);
        }
    }

    private function delete_technician($param = '', $id = '') {
        $log = Auth::log_info();
        $sth = $this->db->prepare("CALL Delete_Technician(:id,:user_id,:machine,:ip_address,:action_type)"); // Call Search Users
        $sth->execute(array(':id' => $id,
            ':user_id' => (int) $log['user_id'],
            ':machine' => $log['machine'],
            ':ip_address' => $log['ip_address'],
            ':action_type' => 'Delete from Interface'));
        $count = $sth->rowCount();
        if ($count > 0) {
            $result['mtype'] = "S";
            $result['msg'] = "Technician Deleted Successfully";
            //Session::set('url', 'user/index'); // set the current page to use in ajax load
            //header("Location: " . $this->_setting->url);
        } else {
            $result['mtype'] = "E";
            $result['msg'] = "Delete could not be deleted";
        }
        echo json_encode($result);
        die();
    }

    private function edit_technician($param = '', $id = '') {
        $sth = $this->db->prepare("CALL Get_Technician(:id)"); // Call Search Users
        $sth->execute(array(':id' => $id));
        $data = $sth->fetch();

        echo json_encode($data);
        die();
    }

    private function save_technician($param = '', $id = '') {
        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {

            $result["mtype"] = '';
            $result["msg"] = '';
            try {
                $form = new Form();

                $form->post('technician_name')
                        ->post('technician_id');
                $form->submit();
                //echo 'Form passed';
                $postf = $form->fetch();
            } catch (Exception $e) {
                echo $e->getMessage();
            }
            //$result['$form'] = $postf;
            $log = Auth::log_info();
            //$result['log'] = $log;
            if ($postf['technician_id'] == "") {
                $sth = $this->db->prepare("CALL Add_Technician(:technician,:user_id,:machine,:ip_address,:action_type)");
                $result['method'] = 'Add';
                $store = array(':technician' => $postf['technician_name'],
                    ':user_id' => (int) $log['user_id'],
                    ':machine' => $log['machine'],
                    ':ip_address' => $log['ip_address'],
                    ':action_type' => 'Insert from Interface');
            } else {
                $sth = $this->db->prepare("CALL Update_Technician(:id,:technician,:user_id,:machine,:ip_address,:action_type)");
                $result['method'] = 'Update';
                $store = array(':id' => (int) $postf['technician_id'],
                    ':technician' => $postf['technician_name'],
                    ':user_id' => (int) $log['user_id'],
                    ':machine' => $log['machine'],
                    ':ip_address' => $log['ip_address'],
                    ':action_type' => 'Update from Interface');
            }
            $result['store'] = $store;
            $sth->execute($store);

            $count = $sth->rowCount();
            if ($count > 0) {
                $result['mtype'] = "S";
                $result['msg'] = "Technican Saved Successfully";
                //Session::set('url', 'user/index'); // set the current page to use in ajax load
                //header("Location: " . $this->_setting->url);
            } else {
                $result['mtype'] = "E";
                $result['msg'] = "Technician could not be saved";
            }
            echo json_encode($result);
            die();
        }
    }

    private function search_technicians($param = '') {
        try {
            $form = new Form();

            $form->post('technician');

            $form->submit();
            //echo 'Form passed';
            $postf = $form->fetch();
        } catch (Exception $e) {
            echo $e->getMessage();
        }

        $sth = $this->db->prepare("CALL Search_Technicians(:technician)"); // Call Search Users
        $sth->execute(array(':technician' => $postf['technician']));
        $data = $sth->fetchAll();
        //print(json_encode($data));
        return $data;
    }

    public function user_status($param = '', $id = '') {
        //print $param;
        //print $id;
        switch ($param) {
            case 'delete':
                $this->delete_user_status($param, $id);
                break;
            case 'edit':
                $this->edit_user_status($param, $id);
                break;
            case 'save':
                $this->save_user_status($param, $id);
                break;
            case 'search':
            default :
                return $this->search_user_status($param);
        }
    }

    private function delete_user_status($param = '', $id = '') {
        $log = Auth::log_info();
        $sth = $this->db->prepare("CALL Delete_User_Status(:id,:user_id,:machine,:ip_address,:action_type)"); // Call Search Users
        $sth->execute(array(':id' => $id,
            ':user_id' => (int) $log['user_id'],
            ':machine' => $log['machine'],
            ':ip_address' => $log['ip_address'],
            ':action_type' => 'Delete from Interface'));
        $count = $sth->rowCount();
        if ($count > 0) {
            $result['mtype'] = "S";
            $result['msg'] = "User_Status Deleted Successfully";
            //Session::set('url', 'user/index'); // set the current page to use in ajax load
            //header("Location: " . $this->_setting->url);
        } else {
            $result['mtype'] = "E";
            $result['msg'] = "User_Status could not be deleted";
        }
        echo json_encode($result);
        die();
    }

    private function edit_user_status($param = '', $id = '') {
        $sth = $this->db->prepare("CALL Get_User_Status(:id)"); // Call Search Users
        $sth->execute(array(':id' => $id));
        $data = $sth->fetch();

        echo json_encode($data);
        die();
    }

    private function save_user_status($param = '', $id = '') {
        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {

            $result["mtype"] = '';
            $result["msg"] = '';
            try {
                $form = new Form();

                $form->post('user_status_name')
                        ->post('user_status_id');
                $form->submit();
                //echo 'Form passed';
                $postf = $form->fetch();
            } catch (Exception $e) {
                echo $e->getMessage();
            }
            //$result['$form'] = $postf;
            $log = Auth::log_info();
            //$result['log'] = $log;
            if ($postf['user_status_id'] == "") {
                $sth = $this->db->prepare("CALL Add_User_Status(:user_status,:user_id,:machine,:ip_address,:action_type)");
                $result['method'] = 'Add';
                $store = array(':user_status' => $postf['user_status_name'],
                    ':user_id' => (int) $log['user_id'],
                    ':machine' => $log['machine'],
                    ':ip_address' => $log['ip_address'],
                    ':action_type' => 'Insert from Interface');
            } else {
                $sth = $this->db->prepare("CALL Update_User_Status(:id,:user_status,:user_id,:machine,:ip_address,:action_type)");
                $result['method'] = 'Update';
                $store = array(':id' => (int) $postf['user_status_id'],
                    ':user_status' => $postf['user_status_name'],
                    ':user_id' => (int) $log['user_id'],
                    ':machine' => $log['machine'],
                    ':ip_address' => $log['ip_address'],
                    ':action_type' => 'Update from Interface');
            }
            $result['store'] = $store;
            $sth->execute($store);

            $count = $sth->rowCount();
            if ($count > 0) {
                $result['mtype'] = "S";
                $result['msg'] = "User Status Saved Successfully";
                //Session::set('url', 'user/index'); // set the current page to use in ajax load
                //header("Location: " . $this->_setting->url);
            } else {
                $result['mtype'] = "E";
                $result['msg'] = "User Status could not be saved";
            }
            echo json_encode($result);
            die();
        }
    }

    private function search_user_status($param = '') {
        try {
            $form = new Form();

            $form->post('user_status');

            $form->submit();
            //echo 'Form passed';
            $postf = $form->fetch();
        } catch (Exception $e) {
            echo $e->getMessage();
        }

        $sth = $this->db->prepare("CALL `Search_User_Status`(:user_status)"); // Call Search Users
        $sth->execute(array(':user_status' => $postf['user_status']));
        $data = $sth->fetchAll();
        //print(json_encode($data));
        return $data;
    }

    public function user_role($param = '', $id = '') {
        //print $param;
        //print $id;
        switch ($param) {
            case 'delete':
                $this->delete_user_role($param, $id);
                break;
            case 'edit':
                $this->edit_user_role($param, $id);
                break;
            case 'save':
                $this->save_user_role($param, $id);
                break;
            case 'search':
            default :
                return $this->search_user_role($param);
        }
    }

    private function delete_user_role($param, $id) {
        $log = Auth::log_info();
        $sth = $this->db->prepare("CALL Delete_User_Role(:id,:user_id,:machine,:ip_address,:action_type)"); // Call Search Users
        $sth->execute(array(':id' => $id,
            ':user_id' => (int) $log['user_id'],
            ':machine' => $log['machine'],
            ':ip_address' => $log['ip_address'],
            ':action_type' => 'Delete from Interface'));
        $count = $sth->rowCount();
        if ($count > 0) {
            $result['mtype'] = "S";
            $result['msg'] = "User_Role Deleted Successfully";
            //Session::set('url', 'user/index'); // set the current page to use in ajax load
            //header("Location: " . $this->_setting->url);
        } else {
            $result['mtype'] = "E";
            $result['msg'] = "User_Role could not be deleted";
        }
        echo json_encode($result);
        die();
    }

    private function edit_user_role($param, $id) {
        $sth = $this->db->prepare("CALL Get_User_Role(:id)"); // Call Search Users
        $sth->execute(array(':id' => $id));
        $data = $sth->fetch();

        echo json_encode($data);
        die();
    }

    private function save_user_role($param, $id) {
        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {

            $result["mtype"] = '';
            $result["msg"] = '';
            try {
                $form = new Form();

                $form->post('user_role_name')
                        ->post('user_role_id');
                $form->submit();
                //echo 'Form passed';
                $postf = $form->fetch();
            } catch (Exception $e) {
                echo $e->getMessage();
            }
            //$result['$form'] = $postf;
            $log = Auth::log_info();
            //$result['log'] = $log;
            if ($postf['user_role_id'] == "") {
                $sth = $this->db->prepare("CALL Add_User_Role(:user_role,:user_id,:machine,:ip_address,:action_type)");
                $result['method'] = 'Add';
                $store = array(':user_role' => $postf['user_role_name'],
                    ':user_id' => (int) $log['user_id'],
                    ':machine' => $log['machine'],
                    ':ip_address' => $log['ip_address'],
                    ':action_type' => 'Insert from Interface');
            } else {
                $sth = $this->db->prepare("CALL Update_User_Role(:id,:user_role,:user_id,:machine,:ip_address,:action_type)");
                $result['method'] = 'Update';
                $store = array(':id' => (int) $postf['user_role_id'],
                    ':user_role' => $postf['user_role_name'],
                    ':user_id' => (int) $log['user_id'],
                    ':machine' => $log['machine'],
                    ':ip_address' => $log['ip_address'],
                    ':action_type' => 'Update from Interface');
            }
            $result['store'] = $store;
            $sth->execute($store);

            $count = $sth->rowCount();
            if ($count > 0) {
                $result['mtype'] = "S";
                $result['msg'] = "User Role Saved Successfully";
                //Session::set('url', 'user/index'); // set the current page to use in ajax load
                //header("Location: " . $this->_setting->url);
            } else {
                $result['mtype'] = "E";
                $result['msg'] = "User Role could not be saved";
            }
            echo json_encode($result);
            die();
        }
    }

    private function search_user_role($param = '') {
        try {
            $form = new Form();

            $form->post('user_role');

            $form->submit();
            //echo 'Form passed';
            $postf = $form->fetch();
        } catch (Exception $e) {
            echo $e->getMessage();
        }

        $sth = $this->db->prepare("CALL `Search_User_Role`(:user_role)"); // Call Search Users
        $sth->execute(array(':user_role' => $postf['user_role']));
        $data = $sth->fetchAll();
        //print(json_encode($data));
        return $data;
    }

    public function get_all_user_roles($param = '') {

        $sth = $this->db->prepare("SELECT * FROM all_user_roles");
        $sth->execute();
        $data = $sth->fetchAll();

        return $data;
    }

    public function get_all_permission_groups($param = '') {

        $sth = $this->db->prepare("SELECT * FROM all_permission_groups");
        $sth->execute();
        $data = $sth->fetchAll();

        return $data;
    }

    public function get_all_permissions($param = '') {

        $sth = $this->db->prepare("SELECT * FROM all_permissions");
        $sth->execute();
        $data = $sth->fetchAll();

        return $data;
    }

}
