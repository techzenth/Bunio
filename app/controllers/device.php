<?php

/**
 * Description of device
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class Device extends Controller {

    public $cfg;

    function __construct() {
        global $REG;
        $this->cfg = $REG;
        parent::__construct();
        //print "Index Page";
    }

    function search($page = 1, $sort = '') {
        $rec_num = $this->model->search_count_devices($page);
        $data = $this->model->search_devices($page, $sort);
        $status = $this->model->get_all_device_status();

        $this->view->title = 'Device';
        $this->view->data = array('description' => 'This page is the device',
            'cfg' => $this->cfg,
            'records' => $data,
            'record_count' => $rec_num,
            'current_page' => (int) $page,
            'total_page' => $rec_num / $this->cfg->limit,
            'sort' => $sort,
            'status' => $status);
        //$this->view->css = array('/signin/css/signin.css');
        //$this->view->render("header");
        $this->view->render("device/index");
        //$this->view->render("footer");
    }

    function add($param = '') {
        $status = $this->model->get_all_device_status();

        $this->view->title = 'New Device';
        $this->view->data = array('description' => 'This page is the device',
            'cfg' => $this->cfg,
            'status' => $status,
            'state' => 'NEW');

        $this->view->render("device/maintain");
    }

    function delete($id = '') {
        $this->model->delete($id);
        $data = $this->model->get_device($id);
        $this->view->title = 'Device - Delete';
        $this->view->data = array('description' => 'This page is the device',
            'cfg' => $this->cfg,
            'device' => $data);

        $this->view->render("device/details");
    }

    function edit($id = '') {
        $device = $this->model->get_device($id);
        $status = $this->model->get_all_device_status();

        $this->view->title = 'Edit Device';
        $this->view->data = array('description' => 'This page is the device',
            'cfg' => $this->cfg,
            'device' => $device,
            'status' => $status,
            'state' => 'EDIT');

        $this->view->render("device/maintain");
    }

    function save($param = '') {
        $this->model->save($param);
    }
    function count_notes($param=''){
        print $this->model->count_notes($param);
    }

}
