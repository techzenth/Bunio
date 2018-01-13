<?php

/* Form.php */

require 'Form/Val.php';

class Form {

    // immediate post item
    private $_currentItem = null;
    // stored post data
    private $_postData = array();
    // validator object
    private $_val = array();
    // form errors
    private $_error = array();

    public function __construct() {
        $this->_val = new Val();
    }

    public function post($field) {
        $this->_postData[$field] = filter_input(INPUT_POST, $field);
        $this->_currentItem = $field;

        return $this;
    }

    public function post_array($field) {

        $this->_postData[$field] = implode(",", $_POST[$field]);
        $this->_currentItem = $field;

        return $this;
    }

    public function fetch($fieldName = false) {
        if ($fieldName) {
            if (isset($this->_postData[$fieldName])) {
                return $this->_postData[$fieldName];
            } else {
                return false;
            }
        } else {
            return $this->_postData;
        }
    }

    public function val($typeOfValidator, $arg = null) {
        $request = filter_input(INPUT_SERVER, 'REQUEST_METHOD');
        if ($request != 'POST') {
            return $this;
        }
        if ($arg == null) {
            $error = $this->_val->{$typeOfValidator}($this->_postData[$this->_currentItem]);
        } else {
            $error = $this->_val->{$typeOfValidator}($this->_postData[$this->_currentItem], $arg);
        }
        if ($error) {
            $this->_error[$this->_currentItem] = $error;
        }
        return $this;
    }

    public function submit() {
        if (empty($this->_error)) {
            return true;
        } else {
            $str = '';
            foreach ($this->_error as $key => $value) {
                $str.=$key . '=>' . $value . "\n";
            }
            throw new Exception($str);
        }
    }

}
