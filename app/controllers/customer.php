<?php

/**
 * Description of customer
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class Customer extends Controller {

    public $cfg;

    function __construct() {
        global $REG;
        $this->cfg = $REG;
        parent::__construct();
        //print "Index Page";
    }

    function search($param = 1, $sort = '') {
        
        $rec_num = $this->model->search_count_customers($param);
        $data = $this->model->search_customers($param, $sort);


        $this->view->title = 'Customer';
        $this->view->data = array('description' => 'This page is the customer',
            'cfg' => $this->cfg,
            'records' => $data,
            'record_count' => $rec_num,
            'current_page' => (int) $param,
            'total_page' => $rec_num / $this->cfg->limit,
            'sort' => $sort);
        //$this->view->css = array('/signin/css/signin.css');
        //$this->view->render("header");
        $this->view->render("customer/index");
        //$this->view->render("footer");
    }

    function add($param = '') {


        $this->view->title = 'New Customer';
        $this->view->data = array('description' => 'This page is the customer', 
            'cfg' => $this->cfg);
        //$this->view->css = array('/signin/css/signin.css');
        //$this->view->render("header");
        $this->view->render("customer/maintain");
        //$this->view->render("footer");
    }

    function edit($param = '') {
        $customer = $this->model->get_customer($param);
        $this->view->title = 'Edit Customer';
        $this->view->data = array('description' => 'This page is the customer',
            'cfg' => $this->cfg,
            'customer' => $customer);
        //$this->view->css = array('/signin/css/signin.css');
        //$this->view->render("header");
        $this->view->render("customer/maintain");
        //$this->view->render("footer");
    }

    function delete($param = '') {
        $this->model->delete($param);
        $customer = $this->model->get_customer($param);

        $this->view->title = 'Delete Customer';
        $this->view->data = array('description' => 'This page is the customer',
            'cfg' => $this->cfg,
            'customer' => $customer);

        //$this->view->css = array('/signin/css/signin.css');
        //$this->view->render("header");
        $this->view->render("customer/details");
        //$this->view->render("footer");
    }

    function save($param = '') {
        $this->model->save($param);
    }

}
