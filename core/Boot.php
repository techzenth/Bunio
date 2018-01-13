<?php

/* * Boot.php
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


# Boot Class 

class Boot {

    /**
     * Initalizing Boot object Vars
     * */
    private $_url = null;
    private $_controller = null;
    private $_controllerPath = '/app/controllers/';
    private $_modelPath = 'app/models/';
    private $_errorFile = 'error.php';
    private $_defaultFile = 'index.php';

    public function init() {

        // Sets the protected $_url
        $this->_getUrl();

        // if no url is set load Default
        if (empty($this->_url[0]) || $this->_url[0] == 'index.php') {
            $this->_loadDefault();
            return false;
        }

        $this->_loadController();

        $this->_callMethod();
    }

    public function setControllerPath($path) {
        $this->_controllerPath = trim($path, '/') . '/';
    }

    public function setModelPath($path) {
        $this->_modelPath = trim($path, '/') . '/';
    }

    public function setErrorFile($file) {
        $this->_errorFile = trim($file, '/');
    }

    public function setDefaultFile($file) {
        $this->_defaultFile = trim($file, '/');
    }

    private function _getUrl() {
        $url = isset($_GET['var']) ? $_GET['var'] : null;
        $url = rtrim($url, '/');
        $url = filter_var($url, FILTER_SANITIZE_URL);
        $this->_url = explode('/', $url);
    }

    private function _loadDefault() {
        require $this->_controllerPath . $this->_defaultFile;
        $this->_controller = new Index();
        $this->_controller->index();
    }

    private function _loadController() {
        $file = 'app/controllers/' . $this->_url[0] . '.php';
        if (file_exists($file)) {
            require $file;
            $this->_controller = new $this->_url[0];
            $this->_controller->loadModel($this->_url[0], $this->_modelPath);
        } else {
            $this->_error();
            return false;
        }
    }

    private function _callMethod() {
        // calling methods
        $length = count($this->_url);
        if ($length > 1) {
            if (!method_exists($this->_controller, $this->_url[1])) {
                $this->_error();
                return false;
            }
        }
        switch ($length) {
            case 5:
                $this->_controller->{$this->_url[1]}($this->_url[2], $this->_url[3], $this->_url[4]);
                break;
            case 4:
                $this->_controller->{$this->_url[1]}($this->_url[2], $this->_url[3]);
                break;
            case 3:
                $this->_controller->{$this->_url[1]}($this->_url[2]);
                break;
            case 2:
                $this->_controller->{$this->_url[1]}();
                break;
            default:
                $this->_controller->index();
                break;
        }
    }

    /**
     * presenting errors
     * */
    private function _error() {
        require $this->_controllerPath . $this->_errorFile;
        $controller = new Error();
        $controller->index();
        exit;
    }

}
