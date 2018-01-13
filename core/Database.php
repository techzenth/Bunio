<?php

class Database extends PDO {

    private $_setting;

    public function __construct() {
        global $REG;
        $this->_setting = $REG;
        parent::__construct($this->_setting->db_type . ":host=" . $this->_setting->db_host . ";dbname=" . $this->_setting->db_name, $this->_setting->db_user, $this->_setting->db_pass);
        //print 'dbtest';
    }

    public function select($sql, $array, $fetchMode = PDO::FETCH_ASSOC) {
        $sth = $this->prepare($sql);

        foreach ($data as $key => $value) {
            $sth->bindValue(":$key", $value);
        }
        $sth->execute();
        return $sth->fetchAll($fetchMode);
    }

    public function insert($table, $data) {

        ksort($data);

        $fieldNames = implode(',', array_keys($data));
        $fieldValues = ':' . implode(',:', array_keys($data));

        $sth = $this->prepare("INSERT INTO $table ($fieldNames) VALUES ($fieldValues)");

        foreach ($data as $key => $value) {
            $sth->bindValue(":$key", $value);
        }

        $sth->execute();
    }

    public function update($table, $data, $where) {
        ksort($data);

        $fieldDetails = NULL;
        foreach ($data as $key => $value) {
            $fieldDetails .= "$key=:$key,";
        }
        $fieldDetails = rtrim($fieldDetails, ',');

        $sth = $this->prepare("UPDATE $table SET $fieldDetails WHERE $where");

        foreach ($data as $key => $value) {
            $sth->bindValue(":$key", $value);
        }

        $sth->execute();
    }

}
