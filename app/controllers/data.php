<?php

/**
 * Description of data
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class Data extends Controller {

    public $cfg;

    function __construct() {
        global $REG;
        $this->cfg = $REG;
        parent::__construct();
        //print "Index Page";
    }

    function import($param = 'default', $page = 1, $sort = '') {
        //print $param;


        switch ($param) {
            case "details":
                $imported = $this->model->get_imported($page);

                $this->view->title = 'Import Details';
                $this->view->data = array('description' => 'This page is the imported',
                    'cfg' => $this->cfg,
                    'imported' => $imported);
                $this->view->render("data/details_import");

                break;
            case "proceed":
                $this->model->import_proceed();
                break;
            case "view":
                $this->view->title = 'View Imported Data';
                $rec_num = $this->model->view_count_imports($page);
                $data = $this->model->view_imports($page, $sort);
                $this->view->data = array('description' => 'This page is the device assignment',
                    'cfg' => $this->cfg, 'records' => $data,
                    'current_page' => (int) $page,
                    'total_page' => $rec_num / $this->cfg->limit,
                    'record_count' => $rec_num,
                    'sort' => $sort);

                $this->view->render("data/view_import");
                break;
            default:
                $this->view->title = 'Data Import';
                $types = array(0 => array('id' => 1,  'type' => 'Sim Activation'), 1 => array('id' => 2,  'type' => 'DigiTrak'));
                $this->model->import($param);
                $this->view->data = array('description' => 'This page is the device assignment',
                    'cfg' => $this->cfg,
                        'types' => $types);

                $this->view->render("data/import");
        }
    }

    function export($param = '') {

        $this->model->export();
        $types = array(0 => array('id' => 1,  'type' => 'Monthly'));
        $months = array(0 => array('id' => 1, 'month' => 'January'),
            1 => array('id' => 2, 'month' => 'Feburary'),
            2 => array('id' => 3, 'month' => 'March'));
        $status = $this->model->get_all_device_status();

        $this->view->title = 'Data Export';
        $this->view->data = array('description' => 'This page is the device assignment',
            'cfg' => $this->cfg, 'types' => $types, 'months' => $months, 'status' => $status);
        //$this->view->css = array('/signin/css/signin.css');
        //$this->view->render("header");
        $this->view->render("data/export");
        //$this->view->render("footer");
    }

}
