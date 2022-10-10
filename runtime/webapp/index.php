<?php

// add a my sql connection class with singleton pattern
class DBConnection
{
    private static $instance = null;
    private $conn;
    private $host = 'localhost';
    private $user = 'root';
    private $pass = '';
    private $name = 'test';

    private function __construct()
    {
        $this->conn = new mysqli($this->host, $this->user, $this->pass, $this->name);
        if ($this->conn->connect_error) {
            die("Connection failed: " . $this->conn->connect_error);
        }
    }

    public static function getInstance()
    {
        if (self::$instance === null) {
            self::$instance = new DBConnection();
        }
        return self::$instance;
    }

    public function getConnection()
    {
        return $this->conn;
    }
}
