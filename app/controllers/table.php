<?php

/**
 * Description of table
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class Table extends Controller {

    public $cfg;

    function __construct() {
        global $REG;
        $this->cfg = $REG;
        parent::__construct();

        //print "Index Page";
    }

    function device_status($param = '', $id = '') {
        $data = $this->model->device_status($param, $id);

        $this->view->title = 'Device Status';
        $this->view->data = array('description' => 'This page is the device status',
            'cfg' => $this->cfg,
            'records' => $data);

        $this->view->render("table/device_status");
    }

    function permission($param = '', $id = '') {
        $data = $this->model->permission($param, $id);

        $this->view->title = 'Permissions';
        $this->view->data = array('description' => 'This page is the permissions',
            'cfg' => $this->cfg,
            'records' => $data);
        //$this->view->css = array('/signin/css/signin.css');
        //$this->view->render("header");
        $this->view->render("table/permission");
        //$this->view->render("footer");
    }

    function role_permission($param = '', $id = '') {
        $data = $this->model->role_permission($param, $id);
        $roles = $this->model->get_all_user_roles();

        if ($param == 'add') {
            $permissions = $this->model->get_all_permissions();
            $this->view->title = 'Add Role Permission';
            $this->view->data = array('description' => 'This page is the role permissions',
                'cfg' => $this->cfg,
                'records' => $data,
                'roles' => $roles,
                'permissions' => $permissions);

            $this->view->render("table/role_permission/maintain");
        } else {
            $permissions = $this->model->get_all_permission_groups();

            $this->view->title = 'Role Permissions';
            $this->view->data = array('description' => 'This page is the role permissions',
                'cfg' => $this->cfg,
                'records' => $data,
                'roles' => $roles,
                'permissions' => $permissions);

            $this->view->render("table/role_permission/index");
        }
    }

    function technician($param = '', $id = '') {
        $data = $this->model->technician($param, $id);

        $this->view->title = 'Technicians';
        $this->view->data = array('description' => 'This page is the technicians',
            'cfg' => $this->cfg,
            'records' => $data);
        //$this->view->css = array('/signin/css/signin.css');
        //$this->view->render("header");
        $this->view->render("table/technician");
        //$this->view->render("footer");
    }

    function user_status($param = '', $id = '') {
        $data = $this->model->user_status($param, $id);

        $this->view->title = 'User Status';
        $this->view->data = array('description' => 'This page is the user status',
            'cfg' => $this->cfg,
            'records' => $data);
        //$this->view->css = array('/signin/css/signin.css');
        //$this->view->render("header");
        $this->view->render("table/user_status");
        //$this->view->render("footer");
    }

    function user_role($param = '', $id = '') {
        $data = $this->model->user_role($param, $id);

        $this->view->title = 'User Roles';
        $this->view->data = array('description' => 'This page is the user role',
            'cfg' => $this->cfg,
            'records' => $data);
        //$this->view->css = array('/signin/css/signin.css');
        //$this->view->render("header");
        $this->view->render("table/user_role");
        //$this->view->render("footer");
    }

}
