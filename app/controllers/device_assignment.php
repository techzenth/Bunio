<?php

/**
 * Description of device_assignment
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class Device_Assignment extends Controller {

    public $cfg;

    function __construct() {
        global $REG;
        $this->cfg = $REG;
        parent::__construct();
        //print "Index Page";
    }

    function search($page = 1, $sort = '') {
        $rec_num = $this->model->search_count_device_assignment($page);
        $data = $this->model->search_device_assignment($page);

        $this->view->title = 'Device Assignment';
        $this->view->data = array('description' => 'This page is the device assignment',
            'cfg' => $this->cfg,
            'records' => $data,
            'record_count' => $rec_num,
            'current_page' => (int) $page,
            'total_page' => $rec_num / $this->cfg->limit,
            'sort' => $sort);
        //$this->view->css = array('/signin/css/signin.css');
        //$this->view->render("header");
        $this->view->render("device_assignment/index");
        //$this->view->render("footer");
    }
    
    function get_customers($param=''){
        $result = $this->model->get_customers($param);
        echo json_encode($result);
    }

    function assign($param = '', $param1='') {
        $this->model->assign($param);
        $data = $this->model->get_assignment($param,$param1);
        $customers = $this->model->get_all_customers();
        $devices = $this->model->get_all_devices();
        $technicians = $this->model->get_all_technicians();

        $this->view->title = 'Device Assignment - Assign';
        $this->view->data = array('description' => 'This page is the device assignment',
            'cfg' => $this->cfg,
            'assignment' => $data,
            'customers' => $customers,
            'devices' => $devices,
            'technicians' => $technicians);

        $this->view->render("device_assignment/assign");
    }

    function delete($id = '',$d_number='') {
        $this->model->delete($id,$d_number);
        $data = $this->model->get_assignment($id,$d_number);
        $this->view->title = 'Device Assignment - Delete';
        $this->view->data = array('description' => 'This page is the device assignment',
            'cfg' => $this->cfg,
            'assignment' => $data);

        $this->view->render("device_assignment/details");
    }

}
