<?php

/**
 * Description of imei_note
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class Imei_Note extends Controller {

    public $cfg;

    function __construct() {
        global $REG;
        $this->cfg = $REG;
        parent::__construct();
        //print "Index Page";
    }
    
    function view($imei=''){
        $data = $this->model->view_notes($imei);
        $this->view->title = 'IMEI Notes';
        $this->view->data = array('description' => 'This page is the imei notes',
            'cfg' => $this->cfg,
            'records' => $data,
            'imei' => $imei);
        
         $this->view->render("imei_note/view");
    }
    
    function add($imei=''){
        $this->view->title = 'New Imei Note';
        $this->view->data = array('description' => 'This page is the imei note',
            'cfg' => $this->cfg,
            'state' => 'NEW',
            'imei' => $imei);
        
        $this->view->render("imei_note/maintain");
    }
    
    function edit($imei='',$id=''){
        $this->view->title = 'Edit Imei Note';
        $this->view->data = array('description' => 'This page is the imei note',
            'cfg' => $this->cfg,
            'state' => 'EDIT',
            'imei' => $imei,
            'id'=>$id);
        
        $this->view->render("imei_note/maintain");
    }
    
    function save($id='') {
        $this->model->save($id);
    }
}
