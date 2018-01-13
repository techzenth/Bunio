<?php


/**
 * Description of log_model
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class Log_Model extends Model {

    private $_setting;

    public function __construct() {
        global $REG;
        $this->_setting = $REG;
        parent::__construct();
    }

    public function search_count_logs($page = '') {
        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {
            try {
                $form = new Form();

                $form->post('tables');
                $form->submit();

                $postf = $form->fetch();
            } catch (Exception $e) {
                $result['mtype'] = 'E';
                $result['msg'] = $e->getMessage();
            }
            switch ($postf['tables']) {
                case 1:
                    return $this->count_customer_logs($page);
                case 2:
                    return $this->count_device_logs($page);
                case 3:
                    return $this->count_device_assignment_logs($page);
                default:
            }
        }
    }

    public function search_logs($page = '', $sort = '') {
        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {
            try {
                $form = new Form();

                $form->post('tables');
                $form->submit();

                $postf = $form->fetch();
            } catch (Exception $e) {
                echo $e->getMessage();
            }
            //print $postf['tables'];
            switch ($postf['tables']) {
                case 1:
                    return $this->customer_logs($page);
                case 2:
                    return $this->device_logs($page);
                case 3:
                    return $this->device_assignment_logs($page);
                default:
            }
        }
    }

    private function count_customer_logs($param = '') {
        $sth = $this->db->prepare("CALL View_Count_Customer_Logs()");
        $sth->execute();
        $rec_num = $sth->fetchColumn();
        //print "records: " . $rec_num;
        return $rec_num;
    }

    private function customer_logs($param = '') {
        $offset = ((int) $param - 1) * $this->_setting->limit;
        $sth = $this->db->prepare("CALL `View_Customer_Logs`(:row,:limit,:sort)"); // Call Search devices
        $sth->execute(array(':row' => $offset,
            ':limit' => $this->_setting->limit,
            ':sort' => $sort));
        $data = $sth->fetchAll();
        //print(json_encode($data));
        return $data;
    }

    private function count_device_logs($param = '') {
        $sth = $this->db->prepare("CALL View_Count_Device_Logs()");
        $sth->execute();
        $rec_num = $sth->fetchColumn();
        //print "records: " . $rec_num;
        return $rec_num;
    }

    private function device_logs($param = '') {
        $offset = ((int) $param - 1) * $this->_setting->limit;
        $sth = $this->db->prepare("CALL `View_Device_Logs`(:row,:limit,:sort)"); // Call Search devices
        $sth->execute(array(':row' => $offset,
            ':limit' => $this->_setting->limit,
            ':sort' => $sort));
        $data = $sth->fetchAll();
        //print(json_encode($data));
        return $data;
    }

    private function count_device_assignment_logs($param = '') {
        $sth = $this->db->prepare("CALL View_Count_Device_Assignment_Logs()");
        $sth->execute();
        $rec_num = $sth->fetchColumn();
        //print "records: " . $rec_num;
        return $rec_num;
    }

    private function device_assignment_logs($param = '') {
        $offset = ((int) $param - 1) * $this->_setting->limit;
        $sth = $this->db->prepare("CALL `View_Device_Assignment_Logs`(:row,:limit,:sort)"); // Call Search devices
        $sth->execute(array(':row' => $offset,
            ':limit' => $this->_setting->limit,
            ':sort' => $sort));
        $data = $sth->fetchAll();
        //print(json_encode($data));
        return $data;
    }

}
