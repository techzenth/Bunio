-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.7.9 - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             9.3.0.4984
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for bunio_vts
CREATE DATABASE IF NOT EXISTS `bunio_vts` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `bunio_vts`;


-- Dumping structure for procedure bunio_vts.Add_Customer
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Customer`(IN `p_id` INT(11), IN `p_customer_name` VARCHAR(100), IN `p_fleet_org_number` VARCHAR(100), IN `p_license_plate_number` VARCHAR(50), IN `p_vehicle_description` TEXT, IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Add Customer'
BEGIN

DECLARE c_count INT(11);

SELECT count(*) INTO c_count FROM `customers` WHERE customers.customer_name=p_customer_name;

IF c_count<=0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	INSERT INTO `customers` SET customers.id=p_id, customers.customer_name=p_customer_name, customers.fleet_org_number=p_fleet_org_number, customers.license_plate_number=p_license_plate_number, customers.vehicle_description=p_vehicle_description;
ELSE
	SET @msg = "Error";
	#SELECT @msg;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Add_Device
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Device`(IN `p_d_number` VARCHAR(50), IN `p_device_version` VARCHAR(50), IN `p_imei` VARCHAR(20), IN `p_msisdn` VARCHAR(20), IN `p_sim_number` VARCHAR(20), IN `p_status` INT(11), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Add Device'
BEGIN
DECLARE d_count INT(11);

SELECT count(*) INTO d_count FROM `devices` WHERE d_number = p_d_number;

IF d_count<=0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	INSERT INTO `devices` SET d_number=p_d_number, imei=p_imei, msisdn=p_msisdn, sim_number=p_sim_number, `status`=p_status;
ELSE
	SET @msg = "Error";
	#SELECT @msg;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Add_Device_Assignment
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Device_Assignment`(IN `p_customer_id` INT(11), IN `p_sim_number` VARCHAR(20), IN `p_d_number` VARCHAR(50), IN `p_install_date` DATE, IN `p_install_fee` DOUBLE, IN `p_subscribe_fee` DOUBLE, IN `p_additional_features` TEXT, IN `p_technician` INT(11), IN `p_job_description` TEXT, IN `p_services` VARCHAR(20), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Add Device Assignment'
BEGIN
	DECLARE da_count INT(11) DEFAULT 0;
	SELECT count(*) INTO da_count FROM device_assignments da WHERE da.customer_id = p_customer_id AND da.d_number = p_d_number;
	IF da_count<=0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
		INSERT INTO device_assignments SET customer_id = p_customer_id, d_number = p_d_number, installation_date = p_install_date, installation_fee = p_install_fee, subscription_fee = p_subscribe_fee, additional_features = p_additional_features, technician = p_technician, job_description = p_job_description, services = p_services;
		UPDATE devices SET sim_number = p_sim_number WHERE d_number=p_d_number;
	END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Add_Device_Status
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Device_Status`(IN `p_device_status` VARCHAR(50), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Add Device Status'
BEGIN
DECLARE ds_count INT(11) DEFAULT 0;

SELECT count(*) INTO ds_count FROM device_status WHERE device_status.`status` = p_device_status;
IF ds_count <=0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	INSERT INTO device_status SET device_status.`status` = p_device_status;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Add_Imei_Note
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Imei_Note`(IN `p_imei` VARCHAR(20), IN `p_note` TEXT, IN `p_expiry_date` DATE, IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Add Imei Note'
BEGIN
DECLARE in_count INT(11);
SELECT count(*) INTO in_count FROM imei_notes WHERE imei = p_imei;
SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	
INSERT INTO imei_notes SET imei = p_imei, note=p_note, expiry_date = p_expiry_date;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Add_Message
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Message`(IN `p_message` VARCHAR(255), IN `p_type` INT(11), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50), OUT `p_msg_id` INT(11))
    COMMENT 'Add_Message'
BEGIN
SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
INSERT INTO messages SET message=p_message, `type`=p_type;
SET p_msg_id = LAST_INSERT_ID();
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Add_Message_Link
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Message_Link`(IN `p_message_id` INT(11), IN `p_from_id` INT(11), IN `p_to_id` INT(11), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Add Message Link'
BEGIN
SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
INSERT INTO message_links SET message_id=p_message_id, from_id = p_from_id, to_id = p_to_id; 
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Add_Permission
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Permission`(IN `p_permission` VARCHAR(50), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Add Permission'
BEGIN
DECLARE p_count INT(11);
SELECT count(*) INTO p_count FROM permissions WHERE permissions.permission = p_permission;
IF p_count <= 0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	INSERT INTO permissions SET permissions.permission = p_permission, permissions.right = 1;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Add_Role_Permission
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Role_Permission`(IN `p_role` INT(11), IN `p_permission` INT(11), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Add Role Permission'
BEGIN

SELECT count(*) INTO @rp_count FROM role_permissions rp WHERE rp.permission = p_permission AND rp.role=p_role;
IF @rp_count<1 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	INSERT INTO role_permissions SET permission = p_permission, role=p_role;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Add_Technician
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Technician`(IN `p_technician` VARCHAR(50), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Add Technician'
BEGIN
DECLARE t_count INT(11);
SELECT count(*) INTO t_count FROM technicians WHERE technicians.technician = p_technician;
IF t_count<=0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	INSERT INTO technicians SET technicians.technician = p_technician;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Add_User
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_User`(IN `p_username` VARCHAR(20), IN `p_password` VARCHAR(150), IN `p_status` INT(11), IN `p_role` INT(11), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Add User'
BEGIN

DECLARE u_count INT(11);

SELECT count(*) INTO u_count FROM `users` WHERE username = p_username;

IF u_count<=0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	INSERT INTO `users` SET username=p_username, `password`=p_password, `status`=p_status, role=p_role;
ELSE
	SET @msg = "Error user already exist";
	SELECT @msg;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Add_User_Role
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_User_Role`(IN `p_user_role` VARCHAR(50), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Add User Role'
BEGIN
DECLARE ur_count INT(11) DEFAULT 0;

SELECT count(*) INTO ur_count FROM user_role WHERE user_role.`role` = p_user_role;
IF ur_count <=0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	INSERT INTO user_role SET user_role.`role` = p_user_role;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Add_User_Status
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_User_Status`(IN `p_user_status` VARCHAR(50), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Add User Status'
BEGIN
DECLARE us_count INT(11) DEFAULT 0;

SELECT count(*) INTO us_count FROM user_status WHERE user_status.`status` = p_user_status;
IF us_count <=0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	INSERT INTO user_status SET user_status.`status` = p_user_status;
END IF;
END//
DELIMITER ;


-- Dumping structure for view bunio_vts.all_available_devices
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `all_available_devices` (
	`d_number` VARCHAR(50) NOT NULL COLLATE 'latin1_swedish_ci',
	`imei` VARCHAR(20) NOT NULL COLLATE 'latin1_swedish_ci'
) ENGINE=MyISAM;


-- Dumping structure for view bunio_vts.all_customers
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `all_customers` (
	`id` INT(11) NOT NULL,
	`customer_name` VARCHAR(100) NULL COLLATE 'latin1_swedish_ci'
) ENGINE=MyISAM;


-- Dumping structure for view bunio_vts.all_devices
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `all_devices` (
	`d_number` VARCHAR(50) NOT NULL COLLATE 'latin1_swedish_ci',
	`imei` VARCHAR(20) NOT NULL COLLATE 'latin1_swedish_ci'
) ENGINE=MyISAM;


-- Dumping structure for view bunio_vts.all_device_status
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `all_device_status` (
	`id` INT(11) NOT NULL,
	`status` VARCHAR(50) NULL COLLATE 'latin1_swedish_ci'
) ENGINE=MyISAM;


-- Dumping structure for view bunio_vts.all_online_users
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `all_online_users` (
	`id` INT(11) NOT NULL,
	`username` VARCHAR(20) NOT NULL COLLATE 'latin1_swedish_ci',
	`name` VARCHAR(30) NOT NULL COLLATE 'latin1_swedish_ci'
) ENGINE=MyISAM;


-- Dumping structure for view bunio_vts.all_permissions
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `all_permissions` (
	`permission` VARCHAR(50) NULL COLLATE 'latin1_swedish_ci'
) ENGINE=MyISAM;


-- Dumping structure for view bunio_vts.all_permission_groups
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `all_permission_groups` (
	`permission` VARCHAR(50) NULL COLLATE 'latin1_swedish_ci'
) ENGINE=MyISAM;


-- Dumping structure for view bunio_vts.all_technicians
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `all_technicians` (
	`id` INT(11) NOT NULL,
	`technician` VARCHAR(50) NULL COLLATE 'latin1_swedish_ci'
) ENGINE=MyISAM;


-- Dumping structure for view bunio_vts.all_user_roles
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `all_user_roles` (
	`id` INT(11) NOT NULL,
	`role` VARCHAR(20) NOT NULL COLLATE 'latin1_swedish_ci'
) ENGINE=MyISAM;


-- Dumping structure for view bunio_vts.all_user_status
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `all_user_status` (
	`id` INT(11) NOT NULL,
	`status` VARCHAR(20) NOT NULL COLLATE 'latin1_swedish_ci'
) ENGINE=MyISAM;


-- Dumping structure for procedure bunio_vts.Check_Session
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Check_Session`(IN `p_session_id` VARCHAR(50))
    COMMENT 'Check Session'
BEGIN
DECLARE v_user_id INT(11);

	SELECT user_id INTO v_user_id FROM user_sessions WHERE session_id = p_session_id;
	IF v_user_id>0 THEN
		#SET @msg = "Session Exist"; 
		UPDATE user_sessions SET user_id=v_user_id WHERE session_id = p_session_id;
		#SELECT @msg;
		SELECT * FROM users WHERE id=v_user_id;
	ELSE
		SET @msg = "Error";
		#SELECT @msg;
	END IF;
END//
DELIMITER ;


-- Dumping structure for event bunio_vts.Clear_Sessions
DELIMITER //
CREATE DEFINER=`root`@`localhost` EVENT `Clear_Sessions` ON SCHEDULE EVERY 4 HOUR STARTS '2016-04-15 18:27:00' ENDS '2017-04-15 18:27:00' ON COMPLETION PRESERVE ENABLE COMMENT 'Clear Sessions' DO BEGIN

DELETE FROM user_sessions WHERE timestamp < DATE_ADD(NOW(),INTERVAL 20 MINUTE);
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Count_Imei_Notes
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Count_Imei_Notes`(IN `p_imei` VARCHAR(20))
    COMMENT 'Count Imei Notes'
BEGIN
SELECT COUNT(*) as notes_count
FROM imei_notes WHERE imei=p_imei;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Create_Session
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Create_Session`(IN `p_user_id` INT(11), IN `p_session_id` VARCHAR(50))
    COMMENT 'Create Session'
BEGIN
	DECLARE session_count INT(11);
	SELECT count(*) INTO session_count FROM user_sessions WHERE session_id =  p_session_id;
	IF session_count<1 THEN
		INSERT INTO `user_sessions` SET user_id=p_user_id, `session_id`=p_session_id;
	ELSE
		# dont create
		SET @msg = "Error";
	END IF;
END//
DELIMITER ;


-- Dumping structure for table bunio_vts.customers
CREATE TABLE IF NOT EXISTS `customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(100) DEFAULT NULL,
  `fleet_org_number` varchar(100) DEFAULT NULL,
  `license_plate_number` varchar(50) DEFAULT NULL,
  `vehicle_description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Customers';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.customers_log
CREATE TABLE IF NOT EXISTS `customers_log` (
  `id` int(11) NOT NULL,
  `customer_name` varchar(100) DEFAULT NULL,
  `fleet_org_number` varchar(100) DEFAULT NULL,
  `license_plate_number` varchar(50) DEFAULT NULL,
  `vehicle_description` varchar(100) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `machine` varchar(50) NOT NULL,
  `ip_address` varchar(50) NOT NULL,
  `action` varchar(20) NOT NULL,
  `action_type` varchar(50) NOT NULL,
  `log_date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Customers Log';

-- Data exporting was unselected.


-- Dumping structure for function bunio_vts.c_device_status
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `c_device_status`(`p_status` VARCHAR(50)) RETURNS int(11)
    NO SQL
BEGIN
SELECT COUNT(*) INTO @device_status_count
FROM device_status ds WHERE ds.`status`LIKE CONCAT('%',p_status,'%');
RETURN @device_status_count;
END//
DELIMITER ;


-- Dumping structure for function bunio_vts.c_imei_notes
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `c_imei_notes`(`p_imei` VARCHAR(50)) RETURNS int(11)
    COMMENT 'c imei notes'
BEGIN
SELECT COUNT(*) INTO @notes_count
FROM imei_notes WHERE imei=p_imei;
RETURN @notes_count;
END//
DELIMITER ;


-- Dumping structure for function bunio_vts.c_permissions
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `c_permissions`(`p_permission` VARCHAR(50)) RETURNS int(11)
    NO SQL
BEGIN
SELECT COUNT(*) INTO @permissions_count
FROM permissions WHERE SUBSTRING_INDEX(permission, '_', -1) LIKE p_permission;
RETURN @permissions_count;
END//
DELIMITER ;


-- Dumping structure for function bunio_vts.c_role_permissions
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `c_role_permissions`(`p_role_id` INT(11), `p_permission` VARCHAR(50)) RETURNS int(11)
    NO SQL
BEGIN
SELECT COUNT(*) INTO @permissions_count
FROM role_permissions WHERE SUBSTRING_INDEX(permission, '_', -1) LIKE p_permission AND role = p_role_id;
RETURN @permissions_count;
END//
DELIMITER ;


-- Dumping structure for function bunio_vts.c_technicians
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `c_technicians`(`p_technician` VARCHAR(50)) RETURNS int(11)
    NO SQL
BEGIN
SELECT COUNT(*) INTO @technicans_count
FROM technicians WHERE technicians.technician LIKE p_technician;
RETURN @technicans_count;
END//
DELIMITER ;


-- Dumping structure for function bunio_vts.c_user_roles
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `c_user_roles`(`p_role` VARCHAR(50)) RETURNS int(11)
    NO SQL
BEGIN
SELECT COUNT(*) INTO @roles_count
FROM user_role WHERE status LIKE p_status;
RETURN @roles_count;
END//
DELIMITER ;


-- Dumping structure for function bunio_vts.c_user_status
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `c_user_status`(`p_status` VARCHAR(50)) RETURNS int(11)
    NO SQL
BEGIN
SELECT COUNT(*) INTO @status_count
FROM user_status WHERE status LIKE p_status;
RETURN @status_count;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Delete_Customer
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Customer`(IN `p_id` INT(11), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Delete Customer'
BEGIN

DECLARE c_count INT(11);

SELECT count(*) INTO c_count FROM `customers` WHERE id = p_id;

IF c_count>0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	#SELECT @user_id, @machine, @ip_address, @action_type;
	DELETE FROM customers WHERE id=p_id;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Delete_Device
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Device`(IN `p_d_number` VARCHAR(50), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Delete Device'
BEGIN
DECLARE d_count INT(11);

SELECT count(*) INTO d_count FROM `devices` WHERE d_number = p_d_number;

IF d_count<=0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	DELETE FROM `devices` WHERE d_number=p_d_number;
ELSE
	SET @msg = "Error";
	#SELECT @msg;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Delete_Device_Assignment
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Device_Assignment`(IN `p_id` INT(11), IN `p_d_number` VARCHAR(50), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Delete Device Assignment'
BEGIN
DECLARE da_count INT(11);

SELECT count(*) INTO da_count FROM device_assignments WHERE customer_id = p_id AND d_number = p_d_number;

IF da_count>0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	DELETE FROM device_assignments WHERE customer_id=p_id AND d_number = p_d_number;
ELSE
	SET @msg = "Error";
	#SELECT @msg;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Delete_Device_Status
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Device_Status`(IN `p_id` INT(11), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Delete Device Status'
BEGIN
DECLARE ds_count INT(11) DEFAULT 0;

SELECT count(*) INTO ds_count FROM device_status WHERE device_status.id = p_id;
IF t_count>0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	#SELECT @user_id, @machine, @ip_address, @action_type;
	DELETE FROM device_status WHERE device_status.id=p_id;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Delete_Permission
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Permission`(IN `p_id` INT(11), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Delete Permission'
BEGIN

DECLARE p_count INT(11);

SELECT count(*) INTO p_count FROM permissions WHERE permissions.id = p_id;

IF p_count>0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
DELETE FROM permissions WHERE permissions.id =p_id;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Delete_Technician
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Technician`(IN `p_id` INT(11), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Delete Technician'
BEGIN
DECLARE t_count INT(11);

SELECT count(*) INTO t_count FROM technicians WHERE technicians.id = p_id;

IF t_count>0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	#SELECT @user_id, @machine, @ip_address, @action_type;
	DELETE FROM technicians WHERE technicians.id=p_id;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Delete_User
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_User`(IN `p_id` INT(11), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Delete User'
BEGIN

DECLARE u_count INT(11);

SELECT count(*) INTO u_count FROM `users` WHERE id = p_id;

IF u_count>0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
#	SELECT @user_id, @machine, @ip_address, @action_type;
	DELETE FROM users WHERE id=p_id;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Delete_User_Role
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_User_Role`(IN `p_id` INT(11), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Delete User Role'
BEGIN
DECLARE ur_count INT(11) DEFAULT 0;

SELECT count(*) INTO ur_count FROM user_roles WHERE user_roles.id = p_id;
IF ur_count>0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	#SELECT @user_id, @machine, @ip_address, @action_type;
	DELETE FROM user_role WHERE user_role.id=p_id;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Delete_User_Status
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_User_Status`(IN `p_id` INT(11), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Delete User Status'
BEGIN
DECLARE us_count INT(11) DEFAULT 0;

SELECT count(*) INTO us_count FROM user_status WHERE user_status.id = p_id;
IF t_count>0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	#SELECT @user_id, @machine, @ip_address, @action_type;
	DELETE FROM user_status WHERE user_status.id=p_id;
END IF;
END//
DELIMITER ;


-- Dumping structure for table bunio_vts.devices
CREATE TABLE IF NOT EXISTS `devices` (
  `d_number` varchar(50) NOT NULL,
  `device_version` varchar(50) DEFAULT NULL,
  `imei` varchar(20) NOT NULL,
  `msisdn` varchar(20) DEFAULT NULL,
  `sim_number` varchar(20) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`d_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Devices';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.devices_log
CREATE TABLE IF NOT EXISTS `devices_log` (
  `d_number` varchar(50) NOT NULL,
  `device_version` varchar(50) DEFAULT NULL,
  `imei` varchar(20) NOT NULL,
  `msisdn` varchar(20) DEFAULT NULL,
  `sim_number` varchar(20) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `machine` varchar(50) NOT NULL,
  `ip_address` varchar(50) NOT NULL,
  `action` varchar(20) NOT NULL,
  `action_type` varchar(50) NOT NULL,
  `log_date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Devices Log';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.device_assignments
CREATE TABLE IF NOT EXISTS `device_assignments` (
  `customer_id` int(11) NOT NULL,
  `d_number` varchar(50) NOT NULL,
  `installation_date` datetime DEFAULT NULL,
  `installation_fee` double DEFAULT NULL,
  `subscription_fee` double DEFAULT NULL,
  `additional_features` text,
  `technician` int(11) DEFAULT NULL,
  `job_description` text,
  `services` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Device Assignments';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.device_assignments_log
CREATE TABLE IF NOT EXISTS `device_assignments_log` (
  `customer_id` int(11) DEFAULT NULL,
  `d_number` varchar(50) DEFAULT NULL,
  `installation_date` datetime DEFAULT NULL,
  `installation_fee` double DEFAULT NULL,
  `subscription_fee` double DEFAULT NULL,
  `additional_features` text,
  `technician` int(11) DEFAULT NULL,
  `job_description` text,
  `services` varchar(50) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `machine` varchar(50) NOT NULL,
  `ip_address` varchar(50) NOT NULL,
  `action` varchar(20) NOT NULL,
  `action_type` varchar(50) NOT NULL,
  `log_date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Device Assignments Log';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.device_status
CREATE TABLE IF NOT EXISTS `device_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Device Status';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.device_status_log
CREATE TABLE IF NOT EXISTS `device_status_log` (
  `id` int(11) NOT NULL,
  `status` varchar(50) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `machine` varchar(50) NOT NULL,
  `ip_address` varchar(50) NOT NULL,
  `action` varchar(20) NOT NULL,
  `action_type` varchar(50) NOT NULL,
  `log_date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Device Status Log';

-- Data exporting was unselected.


-- Dumping structure for procedure bunio_vts.Export_Data
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Export_Data`(IN `p_type` INT(11), IN `p_month` INT(11), IN `p_device_status` INT(11))
    COMMENT 'Export Data'
BEGIN
SELECT c.id, c.customer_name, UCASE(da.services) as services, d.d_number, d.sim_number, d.imei, d.msisdn, c.vehicle_description, da.installation_date, da.subscription_fee, da.installation_fee FROM device_assignments da 
INNER JOIN devices d ON (d.d_number = da.d_number)
INNER JOIN customers c ON (c.id = da.customer_id)
WHERE IF(p_month IS NULL OR p_month <1,0=0, da.installation_date BETWEEN MAKEDATE(YEAR(NOW()),28*p_month) AND MAKEDATE(YEAR(NOW()),28*(p_month+1)))
AND IF(p_device_status IS NULL OR p_device_status<1,0=0, d.`status`=p_device_status);
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Get_Assignment_By_Customer_Device
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Assignment_By_Customer_Device`(IN `p_customer_id` INT(11), IN `p_d_number` VARCHAR(50))
    COMMENT 'Get Assignment By Customer Device'
BEGIN
SELECT da.customer_id, CONCAT(c.id, " ",c.customer_name) AS customer_info, d.sim_number, da.d_number, DATE_FORMAT(da.installation_date,'%Y-%m-%d') AS installation_date, da.installation_fee, da.subscription_fee, da.additional_features, da.technician, da.job_description, LCASE(da.services) AS services 
FROM device_assignments AS da 
INNER JOIN customers AS c ON(da.customer_id=c.id)
INNER JOIN devices AS d ON(d.d_number = da.d_number)
WHERE da.customer_id= p_customer_id AND da.d_number = p_d_number;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Get_Chat
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Chat`(IN `p_sender` INT(11), IN `p_receiver` INT(11))
    COMMENT 'Get_Chat'
BEGIN
SELECT m.message,ml.from_id,ml.to_id FROM messages m INNER JOIN message_links ml ON (m.id=ml.message_id)
INNER JOIN message_types mt ON (m.`type`=mt.id) WHERE mt.`type`='Chat';
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Get_Customer_By_ID
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Customer_By_ID`(IN `p_id` INT(11))
    COMMENT 'Get Customer By ID'
BEGIN
SELECT id, customer_name, fleet_org_number, license_plate_number, vehicle_description FROM customers WHERE id= p_id;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Get_Device_By_Number
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Device_By_Number`(IN `p_d_number` VARCHAR(20))
    COMMENT 'Get Device By Number'
BEGIN
#SET @d_number = NULL;
#SET @device_version = NULL;
#SET @imei = NULL;
#SET @
SELECT devices.d_number, devices.device_version, devices.imei, devices.msisdn, devices.sim_number, devices.`status`, c_imei_notes(devices.imei) as notes_count
#INTO @d_number, @device_version, @imei, @msisdn, @sim_number
FROM devices 
WHERE d_number=p_d_number;


END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Get_Device_Status
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Device_Status`(IN `p_id` INT(11))
    COMMENT 'Get Device Status'
BEGIN
	SELECT device_status.id, device_status.`status` FROM device_status WHERE device_status.id = p_id;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Get_Imported
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Imported`(IN `p_id` INT(11))
    COMMENT 'Get Imported'
BEGIN
SELECT import.id, import.device_version, import.sim_card_number, import.account, import.account_description, import.d_number, import.imei, import.msisdn, import.billing_date, import.lic_number, import.payment_info, import.replace_by FROM import
WHERE import.id = p_id;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Get_Message_Users
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Message_Users`(IN `p_id` INT(11))
    COMMENT 'Get Message Users'
BEGIN
SELECT * FROM all_online_users aou WHERE aou.id<>p_id;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Get_Permission
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Permission`(IN `p_id` INT(11))
    COMMENT 'Get Permission'
BEGIN
	SELECT permissions.id, permissions.permission
FROM permissions
WHERE permissions.`right`=1 AND permissions.id = p_id;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Get_Technician
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Technician`(IN `p_id` INT(11))
    COMMENT 'Get Technician'
BEGIN
	SELECT technicians.id, technicians.technician FROM technicians WHERE technicians.id = p_id;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Get_Users_Permission
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Users_Permission`(IN `p_role` INT(11))
    COMMENT 'Get Users Permission'
BEGIN
SELECT permissions.permission FROM role_permissions
INNER JOIN permissions ON (permissions.id=role_permissions.permission)
WHERE role_permissions.role = p_role AND role_permissions.right=1;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Get_User_By_ID
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_User_By_ID`(IN `p_id` INT(11))
    COMMENT 'Get User By ID'
BEGIN
	SELECT users.id, users.username, userprofile.name, users.`status` AS status_id, user_status.`status`, users.role AS role_id, user_roles.role, userprofile.allowemailnotification as notification  FROM `users` 
	INNER JOIN user_status ON(users.`status`=user_status.id)
	INNER JOIN user_roles ON(users.role=user_roles.id)
	LEFT JOIN userprofile ON (users.id=userprofile.user_id)
	WHERE users.id = p_id;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Get_User_Role
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_User_Role`(IN `p_id` INT(11))
    COMMENT 'Get User Role'
BEGIN
SELECT user_roles.id, user_roles.`role` FROM user_roles WHERE id=p_id;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Get_User_Status
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_User_Status`(IN `p_id` INT(11))
    COMMENT 'Get User Status'
BEGIN
SELECT user_status.id, user_status.`status` FROM user_status WHERE id=p_id;
END//
DELIMITER ;


-- Dumping structure for function bunio_vts.g_user_right
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `g_user_right`(`p_role_id` INT(11), `p_permission` VARCHAR(50)) RETURNS tinyint(4)
    NO SQL
BEGIN
SET @checked = 0;
SELECT role_permissions.right INTO @checked FROM role_permissions WHERE role = p_role_id AND permission = p_permission;
RETURN @checked;
END//
DELIMITER ;


-- Dumping structure for table bunio_vts.imei_notes
CREATE TABLE IF NOT EXISTS `imei_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `imei` varchar(50) DEFAULT NULL,
  `note` text,
  `expiry_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='IMEI Notes';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.imei_notes_log
CREATE TABLE IF NOT EXISTS `imei_notes_log` (
  `id` int(11) NOT NULL,
  `imei` varchar(20) DEFAULT NULL,
  `note` text,
  `expiry_date` datetime DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `machine` varchar(50) NOT NULL,
  `ip_address` varchar(50) NOT NULL,
  `action` varchar(20) NOT NULL,
  `action_type` varchar(50) NOT NULL,
  `log_date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='IMEI Notes Log';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.import
CREATE TABLE IF NOT EXISTS `import` (
  `id` int(11) DEFAULT NULL,
  `device_version` varchar(255) DEFAULT NULL,
  `sim_card_number` varchar(255) DEFAULT NULL,
  `account` varchar(255) DEFAULT NULL,
  `account_description` varchar(255) DEFAULT NULL,
  `d_number` varchar(255) DEFAULT NULL,
  `imei` varchar(255) DEFAULT NULL,
  `msisdn` varchar(255) DEFAULT NULL,
  `billing_date` varchar(255) DEFAULT NULL,
  `lic_number` varchar(255) DEFAULT NULL,
  `payment_info` varchar(255) DEFAULT NULL,
  `replace_by` varchar(255) DEFAULT NULL,
  `import_date` date DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Import';

-- Data exporting was unselected.


-- Dumping structure for procedure bunio_vts.Import_Data
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Import_Data`(IN `p_id` INT(11), IN `p_device_version` VARCHAR(255), IN `p_sim_card_number` VARCHAR(255), IN `p_account` VARCHAR(255), IN `p_account_description` VARCHAR(255), IN `p_d_number` VARCHAR(255), IN `p_imei` VARCHAR(255), IN `p_msisdn` VARCHAR(255), IN `p_billing_date` VARCHAR(255), IN `p_lic_number` VARCHAR(255), IN `p_payment_info` VARCHAR(255), IN `p_replace_by` VARCHAR(255))
    COMMENT 'Import Data'
BEGIN
INSERT INTO import SET import.id = p_id, import.device_version = p_device_version, import.sim_card_number = p_sim_card_number, import.account = p_account, import.account_description = p_account_description, import.d_number = p_d_number, import.imei = p_imei, import.msisdn = p_msisdn, import.billing_date = p_billing_date, import.lic_number= p_lic_number, import.payment_info = p_payment_info, import.replace_by = p_replace_by, import.import_date=CURRENT_DATE();
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Import_to_Tables
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Import_to_Tables`(IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Import to Tables'
BEGIN
SET @user_id = p_user_id;
SET @machine = p_machine;
SET @ip_address = p_ip_address;
SET @action_type = p_action_type;

#import Customers
INSERT IGNORE INTO customers (id, customer_name, license_plate_number)
SELECT id, account, lic_number FROM import GROUP BY id;

#import Devices
INSERT IGNORE INTO devices (device_version,sim_number,d_number,imei,msisdn,`status`) 
SELECT device_version,sim_card_number,d_number,imei,msisdn, '1' FROM import GROUP BY d_number;

#import Device_Assignments
INSERT IGNORE INTO device_assignments (customer_id,d_number,services)
SELECT id, d_number, account_description FROM import;

DELETE FROM import WHERE import.import_date=CURRENT_DATE();
END//
DELIMITER ;


-- Dumping structure for table bunio_vts.issuepriority
CREATE TABLE IF NOT EXISTS `issuepriority` (
  `issue_priority_id` int(11) NOT NULL AUTO_INCREMENT,
  `issue_priority_type` varchar(30) NOT NULL,
  PRIMARY KEY (`issue_priority_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.issues
CREATE TABLE IF NOT EXISTS `issues` (
  `issue_id` int(11) NOT NULL AUTO_INCREMENT,
  `issue_title` varchar(30) NOT NULL,
  `issue_description` varchar(150) NOT NULL,
  `issue_type` int(11) NOT NULL,
  `issue_priority` int(11) NOT NULL,
  `issue_createdby` int(11) NOT NULL,
  `issue_createdon` date NOT NULL,
  `issue_closedby` int(11) NOT NULL,
  `issue_closedon` date NOT NULL,
  `issue_resolutionsummary` varchar(150) NOT NULL,
  PRIMARY KEY (`issue_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='project issues';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.issuestatus
CREATE TABLE IF NOT EXISTS `issuestatus` (
  `issue_status_id` int(11) NOT NULL AUTO_INCREMENT,
  `issue_status_type` varchar(20) NOT NULL,
  PRIMARY KEY (`issue_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for procedure bunio_vts.Login_User
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Login_User`(IN `p_username` VARCHAR(50), IN `p_password` VARCHAR(150), IN `p_session_id` VARCHAR(150))
    COMMENT 'Login User'
BEGIN
DECLARE p_user_id INT(11);

SELECT id INTO p_user_id FROM `users` WHERE username = p_username AND `password` = p_password;

IF p_user_id>0 THEN
	#SET @user_id = p_user_id;
	#SET @machine = p_machine;
	#SET @ip_address = p_ip_address;
	#SET @action_type = p_action_type;
	SELECT users.id, users.username, userprofile.name, user_status.`status`, user_roles.role, users.role AS role_id INTO @id, @username, @name, @`status`, @role, @role_id  FROM `users` 
	INNER JOIN user_status ON(users.`status`=user_status.id)
	INNER JOIN user_roles ON(users.role=user_roles.id)
	LEFT JOIN userprofile ON (users.id=userprofile.user_id)
	WHERE username = p_username AND `password` = p_password;
	SELECT @id AS id,@username AS username, @name AS name ,@`status` AS `status`,@role AS role, @role_id AS role_id;
	
	CALL Create_Session(p_user_id, p_session_id);
ELSE
	SET @msg = "Error";
	#SELECT @msg;
END IF;
END//
DELIMITER ;


-- Dumping structure for table bunio_vts.messages
CREATE TABLE IF NOT EXISTS `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(255) DEFAULT NULL,
  `type` int(11) NOT NULL DEFAULT '0',
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_messages_message_types` (`type`),
  CONSTRAINT `FK_messages_message_types` FOREIGN KEY (`type`) REFERENCES `message_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Messages';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.message_links
CREATE TABLE IF NOT EXISTS `message_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message_id` int(11) DEFAULT '0',
  `from_id` int(11) DEFAULT '0',
  `to_id` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Message Links';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.message_types
CREATE TABLE IF NOT EXISTS `message_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Message Types';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.permissions
CREATE TABLE IF NOT EXISTS `permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permission` varchar(50) DEFAULT NULL,
  `right` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Permissions';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.permissions_log
CREATE TABLE IF NOT EXISTS `permissions_log` (
  `id` int(11) DEFAULT NULL,
  `permission` varchar(50) DEFAULT NULL,
  `right` tinyint(4) NOT NULL DEFAULT '0',
  `user_id` int(11) NOT NULL,
  `machine` varchar(50) NOT NULL,
  `ip_address` varchar(50) NOT NULL,
  `action` varchar(20) NOT NULL,
  `action_type` varchar(50) NOT NULL,
  `log_date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Permissions Log';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.projectaccess
CREATE TABLE IF NOT EXISTS `projectaccess` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `projectid` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `accesstype` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='access to projects';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.projects
CREATE TABLE IF NOT EXISTS `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `description` varchar(150) NOT NULL,
  `modifiedon` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='projects table';

-- Data exporting was unselected.


-- Dumping structure for procedure bunio_vts.Reset_Password
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Reset_Password`(IN `p_id` INT(11), IN `p_new_password` VARCHAR(150), IN `p_session` VARCHAR(150))
    COMMENT 'Reset Password'
BEGIN
DECLARE u_count INT(11);

SELECT id INTO u_count FROM `users` WHERE  users.id=p_id;
IF u_count>0 THEN
#	SET @user_id = p_id;
#	SET @machine = p_machine;
#	SET @ip_address = p_ip_address;
#	SET @action_type = p_action_type;
	UPDATE users SET users.`password` = p_new_password WHERE users.id=p_id;
END IF;
END//
DELIMITER ;


-- Dumping structure for table bunio_vts.roles
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Role of the system users';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.role_permissions
CREATE TABLE IF NOT EXISTS `role_permissions` (
  `role` int(11) DEFAULT NULL,
  `permission` int(11) DEFAULT NULL,
  `right` tinyint(4) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Role Permissions';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.role_permissions_log
CREATE TABLE IF NOT EXISTS `role_permissions_log` (
  `role` int(11) DEFAULT NULL,
  `permission` varchar(50) DEFAULT NULL,
  `right` tinyint(4) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `machine` varchar(50) NOT NULL,
  `ip_address` varchar(50) NOT NULL,
  `action` varchar(20) NOT NULL,
  `action_type` varchar(50) NOT NULL,
  `log_date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Role Permissions Log';

-- Data exporting was unselected.


-- Dumping structure for procedure bunio_vts.Search_Count_Customers
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Count_Customers`(IN `p_id` INT(11), IN `p_customer_name` VARCHAR(50), IN `p_license_number` VARCHAR(50))
    COMMENT 'Search Count Customers'
BEGIN
	SELECT COUNT(*) as customer_count  FROM customers 
	WHERE 0=0 
	AND IF(p_id IS NULL OR p_id="", 0=0, customers.id=p_id) 
	AND IF(p_customer_name IS NULL OR p_customer_name="", 0=0, customers.customer_name LIKE CONCAT("%",p_customer_name,"%"))
	AND IF(p_license_number IS NULL OR p_license_number="", 0=0, customers.license_plate_number LIKE CONCAT("%",p_license_number,"%"));
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Search_Count_Devices
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Count_Devices`(IN `p_imei` VARCHAR(20), IN `p_msisdn` VARCHAR(20), IN `p_sim_number` VARCHAR(20), IN `p_status` INT(11))
    COMMENT 'Search Count Devices'
BEGIN
SELECT count(*) as device_count FROM devices
WHERE 0=0 
AND IF(p_imei IS NULL OR p_imei = "", 0=0, imei LIKE CONCAT("%",p_imei,"%") )
AND IF(p_msisdn IS NULL OR p_msisdn = "", 0=0, msisdn LIKE CONCAT("%",p_msisdn,"%"))
AND IF(p_sim_number IS NULL OR p_sim_number="", 0=0, sim_number LIKE CONCAT("%",p_sim_number,"%"))
AND IF(p_status IS NULL OR p_status="", 0=0, `status` = p_status);

END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Search_Count_Device_Assignment
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Count_Device_Assignment`(IN `p_id` INT(11), IN `p_customer_name` VARCHAR(20), IN `p_imei` VARCHAR(20), IN `p_license_plate_number` VARCHAR(20))
    COMMENT 'Search Count Device Assignment'
BEGIN
SELECT count(*) AS device_assignment_count FROM device_assignments as da
INNER JOIN customers as c ON (c.id = da.customer_id)
INNER JOIN devices as d ON (da.d_number = d.d_number)
WHERE 0=0 
AND IF(p_id IS NULL OR p_id="", 0=0, da.customer_id=p_id)
AND IF(p_customer_name IS NULL OR p_customer_name="", 0=0, c.customer_name LIKE CONCAT("%",p_customer_name,"%"))
AND IF(p_imei IS NULL OR p_imei="", 0=0, d.imei=p_imei)
AND IF(p_license_plate_number IS NULL OR p_license_plate_number="", 0=0, c.license_plate_number LIKE CONCAT("%",p_license_plate_number,"%")); 
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Search_Count_Users
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Count_Users`(IN `p_username` VARCHAR(50), IN `p_status` INT(11), IN `p_role` INT(11))
    COMMENT 'Search Count Users'
BEGIN
	SELECT COUNT(*) as user_count  FROM `users` 
	INNER JOIN user_status ON(users.`status`=user_status.id)
	INNER JOIN user_roles ON(users.role=user_roles.id)
	WHERE 0=0 
	AND IF(p_username IS NULL OR p_username="", 0=0, users.username LIKE p_username)
	AND IF(p_status IS NULL OR p_status="", 0=0, users.`status` = p_status)
	AND IF(p_role IS NULL OR p_role="", 0=0, users.role = p_role);
	
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Search_Customers
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Customers`(IN `p_id` VARCHAR(10), IN `p_customer_name` VARCHAR(50), IN `p_license_number` VARCHAR(50), IN `p_row` INT(11), IN `p_limit` INT(11), IN `p_sort` VARCHAR(50))
    COMMENT 'Search Customers'
BEGIN
	SELECT customers.id, customers.customer_name, customers.fleet_org_number, customers.license_plate_number, customers.vehicle_description  FROM customers 
	WHERE 0=0
	AND IF(p_id IS NULL OR p_id="", 0=0, customers.id=p_id) 
	AND IF(p_customer_name IS NULL OR p_customer_name="", 0=0, customers.customer_name LIKE CONCAT("%",p_customer_name,"%"))
	AND IF(p_license_number IS NULL OR p_license_number="", 0=0, customers.license_plate_number LIKE CONCAT("%",p_license_number,"%"))
	#	ORDER BY IF(p_sort IS NULL OR p_sort="", customers.id, customers.customer_name)
	LIMIT p_row,p_limit;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Search_Devices
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Devices`(IN `p_imei` VARCHAR(20), IN `p_msisdn` VARCHAR(20), IN `p_sim_number` VARCHAR(20), IN `p_status` INT(11), IN `p_row` INT(11), IN `p_limit` INT(11), IN `p_sort` VARCHAR(50))
    COMMENT 'Search Devices'
BEGIN
SELECT devices.d_number, devices.imei, devices.msisdn, devices.sim_number,device_status.`status` FROM devices
INNER JOIN device_status ON (device_status.id = devices.`status`)
WHERE 0=0 
AND IF(p_imei IS NULL OR p_imei = "", 0=0, devices.imei LIKE CONCAT("%",p_imei,"%"))
AND IF(p_msisdn IS NULL OR p_msisdn = "", 0=0, devices.msisdn LIKE CONCAT("%",p_msisdn,"%"))
AND IF(p_sim_number IS NULL OR p_sim_number="", 0=0, devices.sim_number LIKE CONCAT("%",p_sim_number,"%"))
AND IF(p_status IS NULL OR p_status="", 0=0, devices.`status` = p_status)
#	ORDER BY IF(p_sort IS NULL OR p_sort="", devices.d_number, devices.imei)
 LIMIT p_row,p_limit;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Search_Device_Assignment
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Device_Assignment`(IN `p_id` INT(11), IN `p_customer_name` VARCHAR(50), IN `p_imei` VARCHAR(20), IN `p_license_plate_number` VARCHAR(20), IN `p_row` INT(11), IN `p_limit` INT(11), IN `p_sort` VARCHAR(20))
    COMMENT 'Search Device Assignment'
BEGIN
SELECT c.id, c.customer_name, d.d_number, d.imei, c.license_plate_number FROM customers as c
INNER JOIN device_assignments as da ON (c.id = da.customer_id)
INNER JOIN devices as d ON (da.d_number = d.d_number)
WHERE 0=0 
AND IF(p_id IS NULL OR p_id="", 0=0, c.id=p_id)
AND IF(p_customer_name IS NULL OR p_customer_name="", 0=0, c.customer_name LIKE concat(p_customer_name,"%"))
AND IF(p_imei IS NULL OR p_imei="", 0=0, d.imei=p_imei)
AND IF(p_license_plate_number IS NULL OR p_license_plate_number="", 0=0, c.license_plate_number LIKE concat(p_license_plate_number,"%"))
LIMIT p_row,p_limit; 
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Search_Device_Status
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Device_Status`(IN `p_device_status` VARCHAR(50))
    COMMENT 'Search Device Status'
BEGIN
SELECT device_status.id, device_status.`status` FROM device_status 
WHERE 0=0 AND IF(p_device_status <> "" OR p_device_status IS NOT NULL, device_status.`status` LIKE CONCAT("%",p_device_status,"%"),0=0);
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Search_Permissions
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Permissions`(IN `p_permission` VARCHAR(50))
    COMMENT 'Search Permissions'
BEGIN
	SELECT permissions.id,  permissions.permission, permissions.`right`
FROM permissions
WHERE permissions.`right` = 1 AND IF(p_permission IS NOT NULL AND p_permission<>'', permissions.permission LIKE CONCAT(p_permission,'%'), 0=0);
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Search_Permissions_Backup
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Permissions_Backup`(IN `p_permission` VARCHAR(50))
    COMMENT 'Search Permissions'
BEGIN
	SELECT SUBSTRING_INDEX(permissions.permission, '_', -1) AS permission,GROUP_CONCAT(CASE WHEN permissions.right = 1 THEN SUBSTRING_INDEX(permissions.permission,"_",1) ELSE NULL END ORDER BY permissions.permission ASC SEPARATOR'/') AS `type`
FROM permissions
WHERE permissions.right = 1 AND IF(p_permission IS NULL OR p_permission = "", 0=0, SUBSTRING_INDEX(permissions.permission, '_', -1) LIKE p_permission)
GROUP BY SUBSTRING_INDEX(permissions.permission, '_', -1);
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Search_Role_Permissions
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Role_Permissions`(IN `p_role` INT(11), IN `p_permission` VARCHAR(50))
    COMMENT 'Search Role Permissions'
BEGIN
SELECT role_permissions.role AS role_id, user_roles.role, role_permissions.permission AS permission_id, permissions.permission AS permission, role_permissions.right AS `type`
FROM role_permissions
INNER JOIN user_roles ON (user_roles.id = role_permissions.role)
INNER JOIN permissions ON (permissions.id = role_permissions.permission)
WHERE  IF(p_permission IS NULL OR p_permission = "", 0=0, SUBSTRING_INDEX(permissions.permission, '_', -1) = p_permission)
AND IF(p_role IS NULL OR p_role = "", 0=0,  role_permissions.role = p_role)

#HAVING role_permissions.`right`=1
;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Search_Role_Permissions_Backup
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Role_Permissions_Backup`(IN `p_role` INT(11), IN `p_permission` VARCHAR(50))
    COMMENT 'Search Role Permissions'
BEGIN
SELECT role_permissions.role AS role_id, user_roles.role, SUBSTRING_INDEX(role_permissions.permission,"_",-1) AS permission, GROUP_CONCAT(CASE WHEN role_permissions.right = 1 THEN SUBSTRING_INDEX(role_permissions.permission,"_",1) ELSE NULL END ORDER BY role_permissions.permission ASC SEPARATOR'/') AS `type`
FROM role_permissions
INNER JOIN user_roles ON (user_roles.id = role_permissions.role)
WHERE  IF(p_permission IS NULL OR p_permission = "", 0=0, SUBSTRING_INDEX(role_permissions.permission, '_', -1) = p_permission)
AND IF(p_role IS NULL OR p_role = "", 0=0,  role_permissions.role = p_role)
GROUP BY SUBSTRING_INDEX(role_permissions.permission, '_', -1) 
#HAVING role_permissions.`right`=1
;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Search_Technicians
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Technicians`(IN `p_technician` VARCHAR(50))
    COMMENT 'Search Technicians'
BEGIN
SELECT technicians.id, technicians.technician FROM technicians 
WHERE 0=0 AND IF(p_technician IS NOT NULL OR p_technician <> "", technicians.technician LIKE CONCAT("%",p_technician,"%"), 0=0);
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Search_Users
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Users`(IN `p_username` VARCHAR(50), IN `p_status` INT(11), IN `p_role` INT(11), IN `p_row` INT(11), IN `p_limit` INT(11), IN `p_sort` VARCHAR(5))
    COMMENT 'Search Users'
BEGIN
	SELECT users.id, users.username, user_status.`status`, user_roles.role FROM `users` 
	INNER JOIN user_status ON(user_status.id=users.`status`)
	INNER JOIN user_roles ON(user_roles.id=users.role)
	WHERE 0=0 
	AND IF(p_username IS NULL OR p_username="", 0=0, users.username LIKE CONCAT("%",p_username,"%"))
	AND IF(p_status IS NULL OR p_status="", 0=0, users.`status` = p_status)
	AND IF(p_role IS NULL OR p_role="", 0=0, users.role = p_role)
#	IF p_sort IS NULL THEN
#		ORDER BY users.id
#	ELSE
#		ORDER BY users.username ASC
#	END IF
#	ORDER BY IF(p_sort IS NULL OR p_sort="", users.id, users.username)	
	LIMIT p_row, p_limit;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Search_User_Role
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_User_Role`(IN `p_user_role` VARCHAR(50))
    COMMENT 'Search User Role'
BEGIN
SELECT user_roles.id, user_roles.role FROM user_roles 
WHERE 0=0 AND IF(p_user_role <> "" OR p_user_role IS NOT NULL, user_roles.role LIKE CONCAT("%",p_user_role,"%"),0=0);
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Search_User_Status
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_User_Status`(IN `p_user_status` VARCHAR(50))
    COMMENT 'Search User Status'
BEGIN
SELECT user_status.id, user_status.`status` FROM user_status 
WHERE 0=0 AND IF(p_user_status <> "" OR p_user_status IS NOT NULL, user_status.`status` LIKE CONCAT("%",p_user_status,"%"),0=0);
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Set_Role_Permission
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Set_Role_Permission`(IN `p_role_id` INT(11), IN `p_permission_id` INT(11), IN `p_right` TINYINT(4))
    COMMENT 'Set Role Permission'
BEGIN
SET @permission_count  = (SELECT COUNT(*) FROM role_permissions WHERE role = p_role_id AND permission = p_permission_id);
IF @permission_count>0 THEN
	UPDATE role_permissions SET role_permissions.`right` = p_right  WHERE role =  p_role_id AND  permission = p_permission_id;
END IF;
END//
DELIMITER ;


-- Dumping structure for table bunio_vts.technicians
CREATE TABLE IF NOT EXISTS `technicians` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `technician` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Technicians';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.technicians_log
CREATE TABLE IF NOT EXISTS `technicians_log` (
  `id` int(11) NOT NULL,
  `technician` varchar(50) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `machine` varchar(50) NOT NULL,
  `ip_address` varchar(50) NOT NULL,
  `action` varchar(20) NOT NULL,
  `action_type` varchar(50) NOT NULL,
  `log_date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Technicians Log';

-- Data exporting was unselected.


-- Dumping structure for procedure bunio_vts.Update_Customer
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Customer`(IN `p_id` INT(11), IN `p_customer_name` VARCHAR(100), IN `p_fleet_org_number` VARCHAR(100), IN `p_license_plate_number` VARCHAR(50), IN `p_vehicle_description` TEXT, IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Update Customer'
BEGIN
DECLARE c_count INT(11);

SELECT count(*) INTO c_count FROM `customers` WHERE id = p_id;

IF c_count>0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	UPDATE customers SET customers.customer_name=p_customer_name, customers.fleet_org_number=p_fleet_org_number, customers.license_plate_number=p_license_plate_number, customers.vehicle_description=p_vehicle_description WHERE customers.id = p_id;
ELSE
	SET @msg = "Error";
	#SELECT @msg;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Update_Device
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Device`(IN `p_d_number` VARCHAR(50), IN `p_device_version` VARCHAR(50), IN `p_imei` VARCHAR(20), IN `p_msisdn` VARCHAR(20), IN `p_sim_number` VARCHAR(20), IN `p_status` INT(11), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Update Device'
BEGIN
DECLARE d_count INT(11);

SELECT count(*) INTO d_count FROM `devices` WHERE d_number = p_d_number;

IF d_count>0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	UPDATE `devices` SET d_number=p_d_number, device_version=p_device_version, imei=p_imei, msisdn=p_msisdn, sim_number=p_sim_number, `status`=p_status WHERE d_number=p_d_number;
ELSE
	SET @msg = "Error";
	#SELECT @msg;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Update_Device_Assignment
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Device_Assignment`(IN `p_customer_id` INT(11), IN `p_sim_number` VARCHAR(20), IN `p_d_number` VARCHAR(50), IN `p_new_d_number` VARCHAR(50), IN `p_install_date` DATE, IN `p_install_fee` DOUBLE, IN `p_subscribe_fee` DOUBLE, IN `p_additional_features` TEXT, IN `p_technician` INT(11), IN `p_job_description` TEXT, IN `p_services` VARCHAR(20), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Update Device Assignment'
BEGIN
	DECLARE da_count INT(11) DEFAULT 0;
	SELECT count(*) INTO da_count FROM device_assignments WHERE customer_id = p_customer_id AND d_number = p_d_number;
	IF da_count>0 THEN
		SET @user_id = p_user_id;
		SET @machine = p_machine;
		SET @ip_address = p_ip_address;
		SET @action_type = p_action_type;
		UPDATE device_assignments SET customer_id = p_customer_id, d_number = p_new_d_number, installation_date = p_install_date, installation_fee = p_install_fee, subscription_fee = p_subscribe_fee, additional_features = TRIM(p_additional_features), technician = p_technician, job_description = TRIM(p_job_description), services = p_services WHERE customer_id = p_customer_id AND d_number = p_d_number;
		UPDATE devices d SET sim_number = p_sim_number WHERE d_number=p_new_d_number;
		SET @msg = "Updated Assignments";
		SELECT @msg;
	ELSE
		SET @msg = "Error";
	#SELECT @msg;
	END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Update_Device_Status
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Device_Status`(IN `p_id` INT(11), IN `p_device_status` VARCHAR(50), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Update Device Status'
BEGIN
DECLARE ds_count INT(11) DEFAULT 0;

SELECT count(*) INTO ds_count FROM device_status WHERE device_status.id = p_id;
IF ds_count > 0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	UPDATE device_status SET device_status.`status` = p_device_status WHERE device_status.id = p_id;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Update_Imei_Note
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Imei_Note`(IN `p_imei` VARCHAR(20), IN `p_id` INT(11), IN `p_note` TEXT, IN `p_expiry_date` DATE, IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Update_Imei_Note'
BEGIN

SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	
UPDATE imei_notes SET imei = p_imei, note=p_note, expiry_date = p_expiry_date WHERE imei=p_imei AND id = p_id;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Update_Permission
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Permission`(IN `p_id` VARCHAR(50), IN `p_permission` VARCHAR(50), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Update Permission'
BEGIN
DECLARE p_count INT(11);
SELECT count(*) INTO p_count FROM permissions WHERE permissions.id = p_id;
# SELECT p_count;
IF p_count > 0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	UPDATE permissions SET permissions.permission = p_permission, permissions.right = 1 WHERE permissions.id = p_id;
ELSE
	SET @msg ="Permissions could not be edited";
#	SELECT @msg;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Update_Role_Permission
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Role_Permission`(IN `p_permission` INT(11), IN `p_new_permission` INT(11), IN `p_role` INT(11), IN `p_new_role` INT(11))
    COMMENT 'Update Role Permission'
BEGIN

SELECT count(*) INTO @rp_count FROM role_permissions rp WHERE rp.permission = p_permission AND rp.role=p_role;
IF @rp_count>0 THEN
	UPDATE role_permissions SET permission = p_new_permission, role=p_new_role WHERE permission = p_permission AND role=p_role;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Update_Technician
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Technician`(IN `p_id` INT(11), IN `p_technician` VARCHAR(50), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Update Technician'
BEGIN
DECLARE t_count INT(11);
SELECT count(*) INTO t_count FROM technicians WHERE technicians.id=p_id;
IF t_count > 0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	UPDATE technicians SET technicians.technician = p_technician WHERE technicians.id = p_id;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Update_User
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_User`(IN `p_id` INT(11), IN `p_username` VARCHAR(50), IN `p_password` VARCHAR(150), IN `p_status` INT(11), IN `p_role` INT(11), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Update User'
BEGIN

DECLARE u_count INT(11);

SELECT count(*) INTO u_count FROM `users` WHERE id = p_id;

IF u_count>0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	UPDATE `users` SET username=p_username, `password`=p_password, `status`=p_status, role=p_role WHERE id = p_id;
ELSE
	SET @msg = "Error";
	SELECT @msg;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Update_User_Role
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_User_Role`(IN `p_id` INT(11), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Update User Role'
BEGIN
DECLARE ur_count INT(11) DEFAULT 0;

SELECT count(*) INTO ur_count FROM user_roles WHERE user_roles.id = p_id;
IF ur_count > 0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	UPDATE user_roles SET user_roles.`role` = p_user_role WHERE user_roles.id = p_id;
END IF;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.Update_User_Status
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_User_Status`(IN `p_id` INT(11), IN `p_user_status` VARCHAR(50), IN `p_user_id` INT(11), IN `p_machine` VARCHAR(50), IN `p_ip_address` VARCHAR(20), IN `p_action_type` VARCHAR(50))
    COMMENT 'Update User Status'
BEGIN
DECLARE us_count INT(11) DEFAULT 0;

SELECT count(*) INTO us_count FROM user_status WHERE user_status.id = p_id;
IF us_count > 0 THEN
	SET @user_id = p_user_id;
	SET @machine = p_machine;
	SET @ip_address = p_ip_address;
	SET @action_type = p_action_type;
	UPDATE user_status SET user_status.`status` = p_user_status WHERE user_status.id = p_id;
END IF;
END//
DELIMITER ;


-- Dumping structure for table bunio_vts.userprofile
CREATE TABLE IF NOT EXISTS `userprofile` (
  `user_id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `allowemailnotification` tinyint(1) NOT NULL,
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='the users profile';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `password` varchar(150) NOT NULL,
  `status` int(11) NOT NULL,
  `role` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Users';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.users_log
CREATE TABLE IF NOT EXISTS `users_log` (
  `id` int(11) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(150) NOT NULL,
  `status` int(11) NOT NULL,
  `role` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `machine` varchar(50) NOT NULL,
  `ip_address` varchar(50) NOT NULL,
  `action` varchar(20) NOT NULL,
  `action_type` varchar(50) NOT NULL,
  `log_date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Users Log';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.user_roles
CREATE TABLE IF NOT EXISTS `user_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='User Roles';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.user_sessions
CREATE TABLE IF NOT EXISTS `user_sessions` (
  `user_id` int(11) DEFAULT NULL,
  `session_id` varchar(150) DEFAULT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='User Sessions';

-- Data exporting was unselected.


-- Dumping structure for table bunio_vts.user_status
CREATE TABLE IF NOT EXISTS `user_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='User Status';

-- Data exporting was unselected.


-- Dumping structure for procedure bunio_vts.View_Count_Customer_Logs
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `View_Count_Customer_Logs`()
    COMMENT 'View_Count_Customer_Logs'
BEGIN
SELECT count(*) FROM customers_log AS cl
INNER JOIN users AS u ON (u.id = cl.user_id); 
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.View_Count_Device_Assignment_Logs
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `View_Count_Device_Assignment_Logs`()
    COMMENT 'View Count Device Assignment Logs'
BEGIN
SELECT count(*) FROM device_assignments_log AS dal
INNER JOIN users AS u ON (u.id = dal.user_id); 
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.View_Count_Device_Logs
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `View_Count_Device_Logs`()
    COMMENT 'View Count Device Logs'
BEGIN
SELECT count(*) FROM devices_log AS dl
INNER JOIN users AS u ON (u.id = dl.user_id); 
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.View_Count_Import
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `View_Count_Import`()
    COMMENT 'View Count Import'
BEGIN
SELECT count(*) AS i_count FROM import;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.View_Customer_Logs
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `View_Customer_Logs`(IN `p_row` INT(11), IN `p_limit` INT(11), IN `p_sort` VARCHAR(20))
    COMMENT 'View_Customer_Logs'
BEGIN
SELECT cl.id, u.username, cl.machine, cl.ip_address, cl.`action`, cl.action_type, cl.log_date FROM customers_log AS cl
INNER JOIN users AS u ON (u.id = cl.user_id)
LIMIT p_row,p_limit; 
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.View_Device_Assignment_Logs
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `View_Device_Assignment_Logs`(IN `p_row` INT(11), IN `p_limit` INT(11), IN `p_sort` VARCHAR(20))
    COMMENT 'View_Device_Assignment_Logs'
BEGIN
SELECT CONCAT (dal.customer_id , " ", dal.d_number) as id, u.username, dal.machine, dal.ip_address, dal.`action`, dal.action_type, dal.log_date FROM device_assignments_log AS dal
INNER JOIN users AS u ON (u.id = dal.user_id)
LIMIT p_row,p_limit;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.View_Device_Logs
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `View_Device_Logs`(IN `p_row` INT(11), IN `p_limit` INT(11), IN `p_sort` VARCHAR(20))
    COMMENT 'View Device Logs'
BEGIN
SELECT dl.d_number as id, u.username, dl.machine, dl.ip_address, dl.`action`, dl.action_type, dl.log_date FROM devices_log AS dl
INNER JOIN users AS u ON (u.id = dl.user_id)
LIMIT p_row,p_limit;
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.View_Imei_Notes
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `View_Imei_Notes`(IN `p_imei` VARCHAR(20))
    COMMENT 'View Imei Notes'
BEGIN
SELECT id, imei, note, expiry_date FROM imei_notes WHERE 0=0 AND IF(p_imei IS NULL OR p_imei="", 0=0, imei=p_imei);
END//
DELIMITER ;


-- Dumping structure for procedure bunio_vts.View_Import
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `View_Import`(IN `p_row` INT(11), IN `p_limit` INT(11), IN `p_sort` VARCHAR(20))
    COMMENT 'View_Import'
BEGIN
SELECT import.id, import.device_version, import.sim_card_number, import.account, import.account_description, import.d_number, import.imei, import.msisdn, import.billing_date, import.lic_number, import.payment_info, import.replace_by FROM import
LIMIT p_row,p_limit;
END//
DELIMITER ;


-- Dumping structure for trigger bunio_vts.after_customer_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_ALL_TABLES,NO_AUTO_CREATE_USER';
DELIMITER //
CREATE TRIGGER `after_customer_insert` AFTER INSERT ON `customers` FOR EACH ROW BEGIN
INSERT INTO `customers_log` SET id=NEW.id,customer_name=NEW.customer_name, `fleet_org_number`=NEW.fleet_org_number, `license_plate_number`=NEW.license_plate_number,vehicle_description=NEW.vehicle_description,user_id=@user_id,machine=@machine,ip_address=@ip_address, `action`='INSERT',action_type=@action_type,log_date= NOW(); 
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger bunio_vts.after_customer_update
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_ALL_TABLES,NO_AUTO_CREATE_USER';
DELIMITER //
CREATE TRIGGER `after_customer_update` AFTER UPDATE ON `customers` FOR EACH ROW BEGIN
INSERT INTO `customers_log` SET id=NEW.id,customer_name=NEW.customer_name, `fleet_org_number`=NEW.fleet_org_number, `license_plate_number`=NEW.license_plate_number,vehicle_description=NEW.vehicle_description,user_id=@user_id,machine=@machine,ip_address=@ip_address, `action`='UPDATE',action_type=@action_type,log_date= NOW();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger bunio_vts.after_device_assignments_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_ALL_TABLES,NO_AUTO_CREATE_USER';
DELIMITER //
CREATE TRIGGER `after_device_assignments_insert` AFTER INSERT ON `device_assignments` FOR EACH ROW BEGIN
INSERT INTO device_assignments_log SET customer_id = NEW.customer_id, d_number = NEW.d_number, installation_date = NEW.installation_date, installation_fee = NEW.installation_fee,
subscription_fee = NEW.subscription_fee, additional_features = NEW.additional_features, technician = NEW.technician, job_description = NEW.job_description, services = NEW.services,
user_id=@user_id,machine=@machine,ip_address=@ip_address, `action`='INSERT',action_type=@action_type,log_date= NOW();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger bunio_vts.after_device_assignments_update
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_ALL_TABLES,NO_AUTO_CREATE_USER';
DELIMITER //
CREATE TRIGGER `after_device_assignments_update` AFTER UPDATE ON `device_assignments` FOR EACH ROW BEGIN
INSERT INTO device_assignments_log SET customer_id = OLD.customer_id, d_number = OLD.d_number, installation_date = OLD.installation_date, installation_fee = OLD.installation_fee,
subscription_fee = OLD.subscription_fee, additional_features = OLD.additional_features, technician = OLD.technician, job_description = OLD.job_description, services = OLD.services,
user_id=@user_id,machine=@machine,ip_address=@ip_address, `action`='UPDATE',action_type=@action_type,log_date= NOW();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger bunio_vts.after_device_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_ALL_TABLES,NO_AUTO_CREATE_USER';
DELIMITER //
CREATE TRIGGER `after_device_insert` AFTER INSERT ON `devices` FOR EACH ROW BEGIN
INSERT INTO devices_log SET d_number=NEW.d_number, imei=NEW.imei, msisdn=NEW.msisdn, sim_number=NEW.sim_number, `status`=NEW.`status`,user_id=@user_id,machine=@machine,ip_address=@ip_address, `action`='INSERT',action_type=@action_type,log_date= NOW();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger bunio_vts.after_device_status_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_ALL_TABLES,NO_AUTO_CREATE_USER';
DELIMITER //
CREATE TRIGGER `after_device_status_insert` AFTER INSERT ON `device_status` FOR EACH ROW BEGIN
INSERT INTO device_status_log SET id=NEW.id ,`status` = NEW.`status`,user_id=@user_id,machine=@machine,ip_address=@ip_address, `action`='INSERT',action_type=@action_type,log_date= NOW();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger bunio_vts.after_device_status_update
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_ALL_TABLES,NO_AUTO_CREATE_USER';
DELIMITER //
CREATE TRIGGER `after_device_status_update` AFTER UPDATE ON `device_status` FOR EACH ROW BEGIN
INSERT INTO device_status_log SET id=NEW.id ,`status` = NEW.`status`,user_id=@user_id,machine=@machine,ip_address=@ip_address, `action`='UPDATE',action_type=@action_type,log_date= NOW();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger bunio_vts.after_device_update
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_ALL_TABLES,NO_AUTO_CREATE_USER';
DELIMITER //
CREATE TRIGGER `after_device_update` AFTER UPDATE ON `devices` FOR EACH ROW BEGIN
INSERT INTO devices_log SET d_number=NEW.d_number, imei=NEW.imei, msisdn=NEW.msisdn, sim_number=NEW.sim_number, `status`=NEW.`status`,user_id=@user_id,machine=@machine,ip_address=@ip_address, `action`='UPDATE',action_type=@action_type,log_date= NOW();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger bunio_vts.after_role_permissions_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_ALL_TABLES,NO_AUTO_CREATE_USER';
DELIMITER //
CREATE TRIGGER `after_role_permissions_insert` AFTER INSERT ON `role_permissions` FOR EACH ROW BEGIN
INSERT INTO role_permissions_log SET role = NEW.role, permission = NEW.permission, `right` = NEW.`right`, user_id=@user_id,machine=@machine,ip_address=@ip_address, `action`='INSERT',action_type=@action_type,log_date= NOW();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger bunio_vts.after_user_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_ALL_TABLES,NO_AUTO_CREATE_USER';
DELIMITER //
CREATE TRIGGER `after_user_insert` AFTER INSERT ON `users` FOR EACH ROW BEGIN
	INSERT INTO `users_log` SET id=NEW.id,username=NEW.username, `password`=NEW.password, `status`=NEW.status,role=NEW.role,user_id=@user_id,machine=@machine,ip_address=@ip_address, `action`='INSERT',action_type=@action_type,log_date= NOW(); 
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger bunio_vts.after_user_update
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_ALL_TABLES,NO_AUTO_CREATE_USER';
DELIMITER //
CREATE TRIGGER `after_user_update` AFTER UPDATE ON `users` FOR EACH ROW BEGIN
	INSERT INTO `users_log` SET id=NEW.id,username=NEW.username, `password`=NEW.password, `status`=NEW.status,role=NEW.role,user_id=@user_id,machine=@machine,ip_address=@ip_address, `action`='UPDATE',action_type=@action_type,log_date= NOW(); 
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger bunio_vts.before_customer_delete
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_ALL_TABLES,NO_AUTO_CREATE_USER';
DELIMITER //
CREATE TRIGGER `before_customer_delete` BEFORE DELETE ON `customers` FOR EACH ROW BEGIN
INSERT INTO `customers_log` SET id=OLD.id,customer_name=OLD.customer_name, `fleet_org_number`=OLD.fleet_org_number, `license_plate_number`=OLD.license_plate_number,vehicle_description=OLD.vehicle_description,user_id=@user_id,machine=@machine,ip_address=@ip_address, `action`='DELETE',action_type=@action_type,log_date= NOW();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger bunio_vts.before_device_assignments_delete
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_ALL_TABLES,NO_AUTO_CREATE_USER';
DELIMITER //
CREATE TRIGGER `before_device_assignments_delete` BEFORE DELETE ON `device_assignments` FOR EACH ROW BEGIN
INSERT INTO device_assignments_log SET customer_id = OLD.customer_id, d_number = OLD.d_number, installation_date = OLD.installation_date, installation_fee = OLD.installation_fee,
subscription_fee = OLD.subscription_fee, additional_features = OLD.additional_features, technician = OLD.technician, job_description = OLD.job_description, services = OLD.services,
user_id=@user_id,machine=@machine,ip_address=@ip_address, `action`='DELETE',action_type=@action_type,log_date= NOW();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger bunio_vts.before_device_delete
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_ALL_TABLES,NO_AUTO_CREATE_USER';
DELIMITER //
CREATE TRIGGER `before_device_delete` BEFORE DELETE ON `devices` FOR EACH ROW BEGIN
INSERT INTO devices_log SET d_number=OLD.d_number, imei=OLD.imei, msisdn=OLD.msisdn, sim_number=OLD.sim_number, `status`=OLD.`status`,user_id=@user_id,machine=@machine,ip_address=@ip_address, `action`='DELETE',action_type=@action_type,log_date= NOW();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger bunio_vts.before_device_status_delete
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_ALL_TABLES,NO_AUTO_CREATE_USER';
DELIMITER //
CREATE TRIGGER `before_device_status_delete` BEFORE DELETE ON `device_status` FOR EACH ROW BEGIN
INSERT INTO device_status_log SET id=OLD.id ,`status` = OLD.`status`,user_id=@user_id,machine=@machine,ip_address=@ip_address, `action`='DELETE',action_type=@action_type,log_date= NOW();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for trigger bunio_vts.before_user_delete
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_ALL_TABLES,NO_AUTO_CREATE_USER';
DELIMITER //
CREATE TRIGGER `before_user_delete` BEFORE DELETE ON `users` FOR EACH ROW BEGIN
	INSERT INTO `users_log` SET id=OLD.id,username=OLD.username, `password`=OLD.password, `status`=OLD.status,role=OLD.role,user_id=@user_id,machine=@machine,ip_address=@ip_address, `action`='DELETE',action_type=@action_type,log_date= NOW(); 
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping structure for view bunio_vts.all_available_devices
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `all_available_devices`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `all_available_devices` AS select `d`.`d_number` AS `d_number`,`d`.`imei` AS `imei` from (`devices` `d` left join `device_assignments` `da` on((`d`.`d_number` = `da`.`d_number`))) where isnull(`da`.`d_number`);


-- Dumping structure for view bunio_vts.all_customers
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `all_customers`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `all_customers` AS select `customers`.`id` AS `id`,`customers`.`customer_name` AS `customer_name` from `customers`;


-- Dumping structure for view bunio_vts.all_devices
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `all_devices`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `all_devices` AS select `devices`.`d_number` AS `d_number`,`devices`.`imei` AS `imei` from `devices`;


-- Dumping structure for view bunio_vts.all_device_status
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `all_device_status`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `all_device_status` AS select `device_status`.`id` AS `id`,`device_status`.`status` AS `status` from `device_status`;


-- Dumping structure for view bunio_vts.all_online_users
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `all_online_users`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `all_online_users` AS select distinct `u`.`id` AS `id`,`u`.`username` AS `username`,`up`.`name` AS `name` from ((`user_sessions` `us` join `users` `u` on((`us`.`user_id` = `u`.`id`))) join `userprofile` `up` on((`u`.`id` = `up`.`user_id`)));


-- Dumping structure for view bunio_vts.all_permissions
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `all_permissions`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `all_permissions` AS select `permissions`.`permission` AS `permission` from `permissions` where (`permissions`.`right` = 1);


-- Dumping structure for view bunio_vts.all_permission_groups
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `all_permission_groups`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `all_permission_groups` AS select substring_index(`permissions`.`permission`,'_',-(1)) AS `permission` from `permissions` group by substring_index(`permissions`.`permission`,'_',-(1));


-- Dumping structure for view bunio_vts.all_technicians
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `all_technicians`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `all_technicians` AS select `technicians`.`id` AS `id`,`technicians`.`technician` AS `technician` from `technicians`;


-- Dumping structure for view bunio_vts.all_user_roles
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `all_user_roles`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `all_user_roles` AS select `user_roles`.`id` AS `id`,`user_roles`.`role` AS `role` from `user_roles`;


-- Dumping structure for view bunio_vts.all_user_status
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `all_user_status`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `all_user_status` AS select `user_status`.`id` AS `id`,`user_status`.`status` AS `status` from `user_status`;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
