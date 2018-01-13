<?php

/**
 * Description of user
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class User extends Controller {

    public $cfg;

    function __construct() {
        global $REG;
        $this->cfg = $REG;
        parent::__construct();
    }

    function search($param = 1, $sort = '') {
        $rec_num = $this->model->search_count_users($param);
        $data = $this->model->search_users($param, $sort);
        $status = $this->model->get_all_user_status();
        $roles = $this->model->get_all_user_roles();

        $this->view->title = 'User Information';
        $this->view->data = array('description' => 'This page is the user',
            'cfg' => $this->cfg,
            'records' => $data,
            'record_count' => $rec_num,
            'current_page' => (int) $param,
            'total_page' => $rec_num / $this->cfg->limit,
            'sort' => $sort,
            'status' => $status,
            'roles' => $roles);
        //$this->view->css = array('/signin/css/signin.css');
        //$this->view->render("header");
        $this->view->render("user/index");
        //$this->view->render("footer");
    }

    function add($param = '') {

        $status = $this->model->get_all_user_status();
        $roles = $this->model->get_all_user_roles();

        $this->view->title = 'New User';
        $this->view->data = array('description' => 'This page is the user',
            'cfg' => $this->cfg,
            'status' => $status,
            'roles' => $roles);
        //$this->view->css = array('/signin/css/signin.css');
        //$this->view->render("header");
        $this->view->render("user/maintain");
        //$this->view->render("footer");
    }

    function edit($param = '') {

        $user = $this->model->get_user($param);
        $status = $this->model->get_all_user_status();
        $roles = $this->model->get_all_user_roles();

        $this->view->title = 'Edit User';
        $this->view->data = array('description' => 'This page is the user',
            'cfg' => $this->cfg,
            'user' => $user,
            'status' => $status,
            'roles' => $roles);
        //$this->view->css = array('/signin/css/signin.css');
        //$this->view->render("header");
        $this->view->render("user/maintain");
        //$this->view->render("footer");
    }

    function delete($param = '') {
        $this->model->delete($param);
        $user = $this->model->get_user($param);

        $this->view->title = 'Delete User';
        $this->view->data = array('description' => 'This page is the user',
            'cfg' => $this->cfg,
            'user' => $user);

        //$this->view->css = array('/signin/css/signin.css');
        //$this->view->render("header");
        $this->view->render("user/details");
        //$this->view->render("footer");
    }

    function save($param = '') {
        $this->model->save($param);
    }

}
