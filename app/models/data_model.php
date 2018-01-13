<?php

/**
 * Description of data_model
 *
 * @author Andre Bonner <andre.s.bonner@gmail.com>
 */
class Data_Model extends Model {

    private $_setting;

    public function __construct() {
        global $REG;
        $this->_setting = $REG;
        parent::__construct();
    }

    public function import($param = '') {

        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {
//process the form data
            $type = $_POST['type'];
            $tmp_file = $_FILES["fileUpload"]["tmp_name"];
            //$target_file = basename($_FILES["fileUpload"]["name"]);
            $target_file = pathinfo($_FILES["fileUpload"]["name"], PATHINFO_FILENAME) . '-' . date('Y-m-d_h-m-s') . '.' . pathinfo($_FILES["fileUpload"]["name"], PATHINFO_EXTENSION);
            $upload_dir = "app/tmp"; // file upload dir
            //$result["upload_dir"] = $upload_dir;
            //$result["target_file"] = $target_file;
            //$result["tmp_file"] = $tmp_file;
            // You will probably want to first use file_exists() to make sure
            // there isn't already a file by the same name.
            $moved_file = $upload_dir . '/' . $target_file;

            if (move_uploaded_file($tmp_file, $moved_file)) {

                $result['Data'] = $this->upload_import2($moved_file, $type);
            } else {
                $error = $_FILES["fileUpload"]["error"];
                $result["mtype"] = 'E';
                //$result["error"] = $error;
                $result["msg"] = $this->_setting->upload_errors[$error];
            }
            echo json_encode($result, JSON_FORCE_OBJECT);
            die();
        }
    }

    private function upload_import2($moved_file, $type = 1) {


        $result = $this->readExcel($moved_file);
        // import process 1 : replicate

        return $result;
    }

    private function readExcel($inputFileName) {
        // instansiate PHPExcel Class
        //  Read your Excel workbook
        try {
            $inputFileType = PHPExcel_IOFactory::identify($inputFileName);
            $objReader = PHPExcel_IOFactory::createReader($inputFileType);
            $objPHPExcel = $objReader->load($inputFileName);
        } catch (Exception $e) {
            $result['mtype'] = 'E';
            $result['msg'] = 'Error loading file "' . pathinfo($inputFileName, PATHINFO_BASENAME) . '": ' . $e->getMessage();
            echo json_encode($result);
            die();
        }

        //  Get worksheet dimensions
        // $creator = $objPHPExcel->getProperties()->getCreator();
        $sheet = $objPHPExcel->getSheet(0);
        //$highestRow = $sheet->getHighestRow();
        $highestColumn = $sheet->getHighestColumn();
        $row = 1;
        $headerRowData = $sheet->rangeToArray('A' . $row . ':' . $highestColumn . $row, NULL, FALSE, FALSE);
        for ($row = 2; $row < 6; $row++) {
            $rowData = $sheet->rangeToArray('A' . $row . ':' . $highestColumn . $row, NULL, FALSE, FALSE);
            foreach ($headerRowData as $i => $heading_i) {
                $rowNewData[$heading_i] = $rowData[$i];
            }
            $data[] = $rowNewData;
        }
        $result['headerData'] = $headerRowData;
        $result['rowData'] = $rowData;
        //$result = $data;

        return $result;
    }

    private function upload_import($moved_file, $type) {


        $csv_headers = $this->_setting->csv_array[$type];

        // csv importer
        $importer = new CsvImporter($moved_file, true, ',');
        $data = $importer->get();
        //Session::set('debug', json_encode($data[150]));
        // @TODO: check if all index of the array exist
        // save file to database
        $this->db->beginTransaction();
        $sth = $this->db->prepare("Call Import_Data(:id,:device_version,:sim_card_number,:account,:account_description,:d_number,:imei,:msisdn,:billing_date,:lic_number,:payment_info,:replace_by)");
        $records = count($data);
        //$result['data_count'] = $records;

        for ($i = 0; $i < $records - 1; $i++) {
            if ($type == 1) {
                $sth->execute(array(':id' => $data[$i][$csv_headers[0]],
                    ':device_version' => $data[$i][$csv_headers[1]],
                    ':sim_card_number' => $data[$i][$csv_headers[2]],
                    ':account' => $data[$i][$csv_headers[3]],
                    ':account_description' => $data[$i][$csv_headers[4]],
                    ':d_number' => $data[$i][$csv_headers[5]],
                    ':imei' => $data[$i][$csv_headers[6]],
                    ':msisdn' => $data[$i][$csv_headers[7]],
                    ':billing_date' => $data[$i][$csv_headers[8]],
                    ':lic_number' => $data[$i][$csv_headers[9]],
                    ':payment_info' => $data[$i][$csv_headers[10]],
                    ':replace_by' => $data[$i][$csv_headers[11]]));
            } else {
                $sth->execute(array(':id' => $data[$i][$csv_headers[0]],
                    ':device_version' => $data[$i][$csv_headers[1]],
                    ':sim_card_number' => $data[$i][$csv_headers[2]],
                    ':account' => $data[$i][$csv_headers[3]],
                    ':account_description' => $data[$i][$csv_headers[4]],
                    ':d_number' => $data[$i][$csv_headers[5]],
                    ':imei' => $data[$i][$csv_headers[6]],
                    ':msisdn' => $data[$i][$csv_headers[7]],
                    ':billing_date' => $data[$i][$csv_headers[8]],
                    ':lic_number' => $data[$i][$csv_headers[9]],
                    ':payment_info' => $data[$i][$csv_headers[10]],
                    ':replace_by' => $data[$i][$csv_headers[11]]));
            }
        }
        $count = $sth->rowCount();
        $this->db->commit();
        if ($count > 0) {
            $alert['mtype'] = 'S';
            $alert['title'] = 'Data Import';
            $alert['msg'] = 'Import was successfully completed.  Would you like to process?';
            $alert['action'] = 'data/import/proceed';
            $alert['sticky'] = true;
            Session::set('alert', $alert);

            $result["mtype"] = 'S';
            $result["msg"] = 'Data File ' . ($i + 1) . ' imported successfully. Data has been imported';

            Session::set('url', 'data/import/view');
        } else {
            $result["mtype"] = 'W';
            $result["msg"] = 'Data could not be saved to database';
        }

        return $result;
    }

    public function view_count_imports($param = '') {
        $sth = $this->db->prepare("CALL View_Count_Import()");
        $sth->execute();
        $rec_num = $sth->fetchColumn();
        //print "records: " . $rec_num;
        return $rec_num;
    }

    public function view_imports($page = '', $sort = '') {
        $offset = ((int) $page - 1) * $this->_setting->limit;
        //print "page: ".$page;

        $sth = $this->db->prepare("CALL View_Import(:row,:limit,:sort)");
        $sth->execute(array(':row' => $offset,
            ':limit' => $this->_setting->limit,
            ':sort' => $sort));

        $data = $sth->fetchAll();
        //print_r($data);
        return $data;
    }

    public function import_proceed() {

        $log = Auth::log_info();

        $sth = $this->db->prepare("Call Import_to_Tables(:user_id,:machine,:ip_address,:action_type)");
        //$sth = $this->db->prepare("INSERT INTO devices (device_version,sim_card_number,d_number,imei,msisdn) VALUES(:device_version,:sim_card_number,:d_number,:imei,:msisdn)");

        $sth->execute(array(':user_id' => (int) $log['user_id'],
            ':machine' => $log['machine'],
            ':ip_address' => $log['ip_address'],
            ':action_type' => 'Import from Interface'
        ));

        $count = $sth->rowCount();
        if ($count > 0) {
            $alert['mtype'] = 'I';
            $alert['title'] = 'Data Import';
            $alert['msg'] = 'Import was successfully completed.';
            $alert['sticky'] = false;
            Session::set('alert', $alert);

            Session::set('url', 'device_assignment/search'); // set the current page to use in ajax load
        } else {
            $alert['mtype'] = 'E';
            $alert['title'] = 'Data Import';
            $alert['msg'] = 'Import was interupted.';
            $alert['sticky'] = false;
            Session::set('alert', $alert);
        }

        header("Location: " . $this->_setting->url);
    }

    public function export($param = '') {
        if (filter_input(INPUT_SERVER, "REQUEST_METHOD") == 'POST') {
            try {
                $form = new Form();
                $form->post('type')
                        ->post('month')
                        ->post('deviceStatus')
                        ->post('format');
                $postf = $form->fetch();
            } catch (Exception $e) {
                print $e->getMessage();
            }

            $sth = $this->db->prepare("Call Export_Data(:type,:month,:status)");
            $sth->execute(array(':type' => (int) $postf['type'],
                ':month' => (int) $postf['month'],
                ':status' => (int) $postf['deviceStatus']));
            $data = $sth->fetchAll();

            if (count($data) > 0) {


                $this->export_file($data);

                $alert['mtype'] = 'I';
                $alert['title'] = 'Export Test';
                $alert['msg'] = 'Export went well would you like a prize';
                Session::set('alert', $alert);
            }
            die();
        }
    }

    private function export_file($data) {
        header("Content-Type: application/vnd.ms-excel;");
        header("Content-Disposition: attachment; filename=export.xls");
        header("Pragma: no-cache");
        header("Expires: 0");


        print '<table border="1">';
        print '<tr><th>ID</th><th>Customer</th><th>Service</th><th>Device Number</th><th>Sim Number</th><th>IMEI</th><th>MSISDN</th><th>Install Date</th><th>Subscription Fee</th><th>Install Fee</th></tr>';
        foreach ($data as $row) {
            print '<tr>';
            print '<td>' . $row['id'] . '</td>';
            print '<td>' . $row['customer_name'] . '</td>';
            print '<td style="background-color: red">' . $row['services'] . '</td>';
            print '<td>' . $row['d_number'] . '</td>';
            print '<td>' . $row['sim_number'] . '</td>';
            print '<td>' . $row['imei'] . '</td>';
            print '<td>' . $row['msisdn'] . '</td>';
            print '<td>' . $row['vehicle_description'] . '</td>';
            print '<td>' . $row['installation_date'] . '</td>';
            print '<td>' . $row['subscription_fee'] . '</td>';
            print '<td>' . $row['installation_fee'] . '</td>';
            print '</tr>';
        }
        print '</table>';
    }

    public function get_imported($id = '') {
        $sth = $this->db->prepare("CALL Get_Imported(:id)");
        $sth->execute(array(':id' => $id));
        $data = $sth->fetch();
        //print $param;
        //print_r($data);

        return $data;
    }

    public function get_all_device_status() {
        $sth = $this->db->prepare("SELECT * FROM all_device_status");
        $sth->execute();
        $data = $sth->fetchAll();

        return $data;
    }

}
