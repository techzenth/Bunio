<?php

/**
 * Description of log
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class Log extends Controller {

    public $cfg;

    function __construct() {
        global $REG;
        $this->cfg = $REG;
        parent::__construct();
        //print "Index Page";
    }

    function view($page = 1, $sort = '') {

        $rec_num = $this->model->search_count_logs($page);
        $data = $this->model->search_logs($page, $sort);
        $tables = array(0 => array('id' => 1, 'table' => 'Customer'),1 => array('id' => 2, 'table' => 'Device'), 2 => array('id' => 3, 'table' => 'Device Assignment'));

        $this->view->title = 'Logs';
        $this->view->data = array('description' => 'This page is the log',
            'cfg' => $this->cfg,
            'tables' => $tables,
            'records' => $data,
            'record_count' => $rec_num,
            'current_page' => (int) $page,
            'total_page' => $rec_num / $this->cfg->limit,
            'sort' => $sort);
        
        $this->view->render("log/index");
       
    }

}
