<?php

class CsvImporter {

    private $fp;
    private $parse_header;
    private $header;
    private $delimiter;
    private $length;
    private $enclosure;
    private $escape;

    //-------------------------------------------------------------------- 
    function __construct($file_name, $parse_header = false, $delimiter = "\t", $length = 600) {
        $this->fp = fopen($file_name, "r");
        $this->parse_header = $parse_header;
        $this->delimiter = $delimiter;
        $this->length = $length;
        //$this->lines = $this->get_lines();
        //Session::set('debug',  $this->lines);
        $this->enclosure = '"';
        $this->escape = "\\";

        if ($this->parse_header) {
            $this->header = fgetcsv($this->fp, $this->length, $this->delimiter, $this->enclosure, $this->escape);
        }
    }

    //-------------------------------------------------------------------- 
    function __destruct() {
        if ($this->fp) {
            fclose($this->fp);
        }
    }

    //-------------------------------------------------------------------- 
    function get($max_lines = 0) {
        //if $max_lines is set to 0, then get all the data 

        $data = array();

        if ($max_lines > 0)
            $line_count = 0;
        else
            $line_count = -1; // so loop limit is ignored 

        while ($line_count < $max_lines && ($row = fgetcsv($this->fp, $this->length, $this->delimiter)) !== FALSE) {
            if(is_null($row) && count($row)==1)
                continue;
            if ($this->parse_header) {
                foreach ($this->header as $i => $heading_i) {
                    $row_new[$heading_i] = $row[$i];
                }
                $data[] = $row_new;
            } else {
                $data[] = $row;
            }

            if ($max_lines > 0)
                $line_count++;
        }
        return $data;
    }

    //-------------------------------------------------------------------- 

    private function get_lines() {
        $lines = 0;

        while (!feof($this->fp)) {
            $lines += substr_count(fread($this->fp, 8192), "\n");
        }

        return $lines;
    }

}
