<?php

class Session {

    public static function init() {
        session_start([
                    'cookie_lifetime' => 86400,
                    'read_and_close' => true,
        ]);
    }

    public static function id(){
        $sess_id = session_id();
        if(empty($sess_id)){
            session_start();
        }
        return session_id();
    }

    public static function set($key, $value) {
        session_start();
        $_SESSION[$key] = $value;
    }

    public static function get($key) {
        session_start();
        //$session = filter_input(INPUT_SESSION, $key);
        $session = $_SESSION[$key];
        if (isset($session)) {
            return $session;
        }
    }

    public static function destroy() {
        session_start();
        //unset($_SESSION['user']);
        //unset($_SESSION['loggedIn']);
        //session_unset();
        session_destroy();
        //$_SESSION = array();
    }

}
