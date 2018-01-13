<?php

/* * Auth.php
 *
 * This is the main web entry point for Predque.
 *
 * If you are reading this in your web browser, your server is probably
 * not configured correctly to run PHP applications!
 *
 * See the README, INSTALL, and UPGRADE files for basic setup instructions
 * and pointers to the online documentation.
 *
 * http://web.andrebonner.com/predque/
 *
 * ----------
 *
 * Copyright (C) 2001-2011 Andre Bonner and JREAM.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 * http://www.gnu.org/copyleft/gpl.html
 *
 * @file
 */

class Auth {

    // handle authentication
    public static function handleLogin() {
        global $REG;

        $logged = Session::get('bunio_loggedIn');
        if ($logged) {
            return true;
        } else {
            return false;
        }
    }

    public static function username() {
        $session = Session::get('bunio_user');
        return $session['username'];
    }
    public static function role() {
        $session = Session::get('bunio_user');
        return $session['role'];
    }
    public static function hasPermission($permission){
        $session = Session::get('bunio_perms');
        return isset($session[$permission]);
    }

    public static function log_info() {

        $user = Session::get('bunio_user');
        $log_info['user_id'] = $user['id'];
        $log_info['machine'] = getenv('COMPUTERNAME');
        // ip address
        if (!empty(filter_input(INPUT_SERVER, 'HTTP_CLIENT_IP'))) {
            $log_info['ip_address'] = filter_input(INPUT_SERVER, 'HTTP_CLIENT_IP');
        } elseif (!empty(filter_input(INPUT_SERVER, 'HTTP_X_FORWARDED_FOR'))) {
            $log_info['ip_address'] = filter_input(INPUT_SERVER, 'HTTP_X_FORWARDED_FOR');
        } else {
            $log_info['ip_address'] = filter_input(INPUT_SERVER, 'REMOTE_ADDR');
        }
        return $log_info;
    }

}
