<?php

/* Account_Model.php */

class Account_Model extends Model {

    private $_setting;

    public function __construct() {
        global $REG;
        $this->_setting = $REG;
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
            $result['data'] = $data;
//            Session::set('bunio_user', $data);
//            Session::set('bunio_loggedIn', true);

            $result['mtype'] = 'S';
            $result['msg'] = 'User Session active ' . $sess_id;
        } else {
            $result['mtype'] = 'E';
            $result['msg'] = 'User Session does not exist';
        }
        echo json_encode($result);
        die;
    }

    public function reset($param = '') {
        if ($_SERVER['REQUEST_METHOD'] == 'POST') {

            $result['mtype'] = '';
            $result['msg'] = '';
            try {
                $form = new Form();

                $form->post('old-password')
                        ->post('new-password')
                        ->post('password-again');

                $form->submit();
                //echo 'Form passed';
                $postf = $form->fetch();

//                echo '<pre>';
//                print_r($postf);
//                echo '</pre>';
            } catch (Exception $e) {
                $result['mtype'] = 'E';
                $result['msg'] = $e->getMessage();
            }
            $log = Auth::log_info();
            $password = Hash::create('md5', $postf['new-password'], $this->_setting->hash_pass_key);
            //print $password;
            $result['password'] = $password;
            $sess_id = Session::id();
            $result['session'] = $sess_id;

            $sth = $this->db->prepare("CALL Reset_Password(:id,:password, :session)");
            $sth->execute(array(':id' => $log['user_id'], ':password' => $password, ':session' => $sess_id));

            $count = $sth->rowCount();
            if ($count > 0) {
                $result['mtype'] = 'S';
                $result['msg'] = 'Password changed successfully';
            } else {
                // no login
                $result['mtype'] = 'E';
                $result['msg'] = 'Reset could not be processed';
            }
            echo json_encode($result);
            die;
        }
    }

    public function signin($param = '') {

        if ($_SERVER['REQUEST_METHOD'] == 'POST') {

            $result['mtype'] = '';
            $result['msg'] = '';
            try {
                $form = new Form();

                $form->post('username')
                        ->val('minlength', 3)
                        ->post('password')
                        ->val('minlength', 6)
                        ->post('rememberme');

                $form->submit();
                //echo 'Form passed';
                $postf = $form->fetch();

//                echo '<pre>';
//                print_r($postf);
//                echo '</pre>';
            } catch (Exception $e) {
                $result['mtype'] = 'E';
                $result['msg'] = $e->getMessage();
            }

            $password = Hash::create('md5', $postf['password'], $this->_setting->hash_pass_key);
            //print $password;
            $result['password'] = $password;
            $sess_id = Session::id();
            $result['session'] = $sess_id;
            $result['rememberme'] = (int) $postf['rememberme'];

            $sth = $this->db->prepare("CALL Login_User(:username,:password, :session)");
            $sth->execute(array(':username' => $postf['username'], ':password' => $password, ':session' => $sess_id));

            $user = $sth->fetch();
            //$result['user'] = $user;
            // print_r($user);
            // print $user['role'];
            // die;  
            //$data = $sth->fetchAll();
            $count = $sth->rowCount();
            if ($count > 0) {
                if ($user['status'] === 'ACTIVE') {
                    // login
                    //$result['count'] = $this->sessionLogin($user);
                    Session::set('bunio_user', $user);
        Session::set('bunio_loggedIn', true);

        $sth = $this->db->prepare("CALL Get_Users_Permission(:role_id)");
        $sth->execute(array(':role_id' => $user['role_id']));
        $count = $sth->rowCount();
        while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
            $perms[$row['permission']] = true;
        }
        Session::set('bunio_perms', $perms);
        
                    //$result['sessionvalue'] = Session::get('bunio_perms');
                    ($postf['rememberme'] == null) ? setcookie('bunio_user', '', time() - 3600, '/Bunio') : setcookie('bunio_user', json_encode($data), time(), '/Bunio');
                    $result['mtype'] = 'S';
                    $result['msg'] = 'Login successfully, as ' . $user['role'];
                } else {
                    // user disabled
                    $result['mtype'] = 'E';
                    $result['msg'] = 'User is Disabled';
                }
            } else {
                // no login
                $result['mtype'] = 'E';
                $result['msg'] = 'Login could not be processed';
            }
            //header('location: ' . $this->_setting->url . 'index');
            //print $this->_setting->url; 
            echo json_encode($result);
            die();
        }
    }

    private function sessionLogin($user) {
        Session::set('bunio_user', $user);
        Session::set('bunio_loggedIn', true);

        $sth = $this->db->prepare("CALL Get_Users_Permission(:role_id)");
        $sth->execute(array(':role_id' => $user['role_id']));
        $count = $sth->rowCount();
        while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
            $perms[$row['permission']] = true;
        }
        Session::set('bunio_perms', $perms);
        
        return $count;
    }

    public function logout() {
        Session::destroy();
        if (isset($_COOKIE['bunio_user'])) {
            setcookie('bunio_user', '', time() - 3600, '/Bunio');
        }
        //Auth::handleLogin();
    }

}
