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
) ENGINE=InnoDB AUTO_INCREMENT=6939 DEFAULT CHARSET=latin1 COMMENT='Customers';

-- Dumping data for table bunio_vts.customers: ~560 rows (approximately)
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` (`id`, `customer_name`, `fleet_org_number`, `license_plate_number`, `vehicle_description`) VALUES
	(4832, 'AERO SALES', NULL, '8762 GL9', NULL),
	(4835, 'AISHA TODD', NULL, '8759 DW', NULL),
	(4837, 'Akeem Adam', NULL, '3058 GE', NULL),
	(4840, 'Albert Dixon', NULL, 'CE 5470', NULL),
	(4841, 'Albert Dixon', NULL, '3294 FQ', NULL),
	(4842, 'Albertha Rookwood-Nelson', NULL, '7065 FM', NULL),
	(4845, 'ALCOA', NULL, '5030 EQ', NULL),
	(4849, 'Alecia English', NULL, '1367 FS', NULL),
	(4852, 'Alicia Armstrong', NULL, '2995 GA', NULL),
	(4853, 'TRULY NOLEN', NULL, '6494 EU', NULL),
	(4854, 'Allan Morgan', NULL, '9770 GH', NULL),
	(4858, 'Allison Wishart-Reynolds', NULL, '3132 GJ', NULL),
	(4863, 'Althea Alexander', NULL, '9364 FK', NULL),
	(4865, 'EARLE MCEWAN', NULL, '3130 EU', NULL),
	(4866, 'Altius Williams', NULL, '9447 ED', NULL),
	(4870, 'Amber Stewart', NULL, '7305 FA', NULL),
	(4871, 'Amber Stewart', NULL, '7960 FU', NULL),
	(4894, 'Andrea & James McNish', NULL, '3528 FU', NULL),
	(4896, 'Andrea Bryson', NULL, '3323 FT', NULL),
	(4900, 'Andrea McNish', NULL, '2417 GC', NULL),
	(4905, 'ANDREA WILLIAMS', NULL, '3023 FH', NULL),
	(4911, 'ANDREW FRANK', NULL, 'CE 5341', NULL),
	(4915, 'Angela Bisasor', NULL, '6623 EH', NULL),
	(4922, 'Ann Hutchinson', NULL, '4381 GK', NULL),
	(4927, 'Annette Clarke-Thomas', NULL, '3314 FR', NULL),
	(4934, '24 Hour Response - Anthony Parker', NULL, 'CG 4108', NULL),
	(4935, '24 Hour Response - Anthony Williams', NULL, '9351 FS', NULL),
	(4936, '24 HOUR RESPONSE - ANTOINETTE BROOKS', NULL, '2200 ES', NULL),
	(4942, '24 Hour Response - Arnold Vassell', NULL, '5660 PA', NULL),
	(4943, '24 Hour Response - Arrow Construction', NULL, '0289 FT', NULL),
	(4944, '24 Hour Response - Arrow Construction', NULL, '5986 FS', NULL),
	(4945, '24 Hour Response - Arrow Construction', NULL, '2129 FS', NULL),
	(4946, '24 Hour Response - Arrow Construction', NULL, '9591 GF', NULL),
	(4955, '24 Hour Response - Audrey Hanson', NULL, '2647 FS', NULL),
	(4964, '24 Hour Response - Azariah Reid', NULL, '5866 PF', NULL),
	(4967, '24 Hour Response - Balie Denniston', NULL, '5635 FG', NULL),
	(4968, '24 Hour Response - Barbara Hew', NULL, '1731 EF', NULL),
	(4969, '24 Hour Response - Barbara Noel', NULL, '3331 GD', NULL),
	(4981, '24 Hour Response - BC&F Auto Glass', NULL, '5192 GA', NULL),
	(4983, '24 Hour Response - Benedict Ranger', NULL, '4485 FZ', NULL),
	(4985, '24 Hour Response - Beril Bennett', NULL, '1330 GE', NULL),
	(4989, '24 Hour Response - Bertram Browne', NULL, '7544 FP', NULL),
	(4996, '24 Hour Response - Beverley Ramsoram', NULL, '0404 FU', NULL),
	(5001, '24 Hour Response - Beverly Porteous', NULL, '0981 FR', NULL),
	(5003, '24 Hour Response - Bible Society of the West Indies', NULL, '3402 GA', NULL),
	(5005, '24 Hour Response - Blain Nesbitt', NULL, '369 GE', NULL),
	(5007, 'Blossom Darby', NULL, '3581 GH', NULL),
	(5014, '24 Hour Response - BRIAN RHULE', NULL, '0662 GF', NULL),
	(5016, '24 Hour Response - Bruce Williams', NULL, '1234 FX', NULL),
	(5022, '24 Hour Response - C2M2C2 Evaluation Consulting', NULL, '7282 GK', NULL),
	(5023, '24 HOUR RESPONSE - Caleen Thompson', NULL, 'CJ 2281', NULL),
	(5029, '24 Hour Response - Camille Coore', NULL, '7892 ET', NULL),
	(5032, '24 Hour Response - Camol Lyons', NULL, '6507 GJ', NULL),
	(5034, '24 Hour Response - Candice Chung', NULL, '3284 FT', NULL),
	(5038, '24 Hour Response - Carese Murphy', NULL, '7256 GF', NULL),
	(5039, 'Caribbean Broilers', NULL, 'TEMP', NULL),
	(5040, 'Caribbean Broilers', NULL, 'TEMP', NULL),
	(5041, 'Caribbean Broilers', NULL, '2612 CD', NULL),
	(5043, '24 Hour Response - Caribbean Christian Publication', NULL, '0644 GE', NULL),
	(5055, '24 Hour Response - Robert Ramdeen', NULL, '5595 DX', NULL),
	(5058, '24 Hour Response - CAROL DALLING', NULL, '2741 GM', NULL),
	(5059, '24 Hour Response - Carol Gardener', NULL, '3175 GA', NULL),
	(5061, '24 Hour Response - Carol Thompson-Walker', NULL, '1811 FP', NULL),
	(5068, '24 Hour Response - Carolyn Tie', NULL, '1312 FW', NULL),
	(5072, '24 Hour Response - Catherine Davis', NULL, '9879 GL', NULL),
	(5073, '24 Hour Response - Catherine Kennedy', NULL, '2487 FZ', NULL),
	(5076, 'Cavanor Auto Rentals #1', NULL, '8784 GK', NULL),
	(5077, '24 Hour Response - Cavel Francis', NULL, '2794 FD', NULL),
	(5079, '24 Hour Response - Cecil July', NULL, '5687 FF', NULL),
	(5082, '24 Hour Response - Cecile Russell', NULL, '9669 FJ', NULL),
	(5083, '24 Hour Response - Cedric Dixon', NULL, 'CG 1959', NULL),
	(5090, '24 Hour Response - Charissa Clemetson', NULL, '6454 GB', NULL),
	(5091, '24 Hour Response - Charlene Bennett', NULL, '2354 FV', NULL),
	(5092, '24 HOUR RESPONSE - CHARLENE BREVITT-ROSE', NULL, '6809 GF', NULL),
	(5093, '24 HOUR RESPONSE - CHARLES CLARKE', NULL, '5360 PF', NULL),
	(5094, '24 Hour Response - Charles Downer', NULL, '7422 H', NULL),
	(5103, '24 Hour Response - Cheryl Ergas', NULL, '7897 GG', NULL),
	(5108, '24 HOUR RESPONSE - Chevine Edwards', NULL, 'TEMP', NULL),
	(5109, '24 Hour Response - Christian Tavares-Finson', NULL, '1934 GK', NULL),
	(5117, '24 Hour Response - Christine Hudson/K Churchhill Neita Co.', NULL, '5410 DG', NULL),
	(5131, '24 Hour Response - Chully Williams', NULL, '3040 GA', NULL),
	(5132, '24 Hour Response - Chully Williams/Carol Williams', NULL, '7055 GA', NULL),
	(5133, '24 Hour Response - Claire Brown', NULL, '3390 GA', NULL),
	(5134, '24 Hour Response - Claire Fernandes/Rema Wilson', NULL, 'TEMP', NULL),
	(5148, '24 Hour Response - Claudette Brown', NULL, '4190 FQ', NULL),
	(5151, '24 Hour Response - Claudette Lewis', NULL, '8829 GL', NULL),
	(5155, '24 Hour Response - Claudia Barnes', NULL, '2711 GJ', NULL),
	(5158, '24 Hour Response - Claudia Mundle', NULL, '', NULL),
	(5159, '24 Hour Response - Claudia Mundle', NULL, '', NULL),
	(5160, '24 Hour Response - Claudia Mundle', NULL, '', NULL),
	(5161, '24 Hour Response - Claudia Mundle', NULL, '', NULL),
	(5162, '24 Hour Response - Claudia Woung', NULL, '6510 FC', NULL),
	(5163, '24 Hour Response - Claudile Sydial', NULL, '5957 GE', NULL),
	(5164, '24 Hour Response - Claudine McLeish/Wezley Richards', NULL, '5702 GD', NULL),
	(5168, '24 Hour Response - Clifton Mesquita', NULL, '2400 GH', NULL),
	(5171, '24 Hour Response - Clover Barnes', NULL, '5498 FG', NULL),
	(5176, '24 HOUR RESPONSE - COLLIN BRAMWELL', NULL, '7956 BV', NULL),
	(5190, '24 HOUR RESPONSE - CPTC', NULL, 'CJ 1893', NULL),
	(5191, '24 HOUR RESPONSE - CPTC', NULL, 'CJ 1982', NULL),
	(5203, '24 Hour Response - Cynthia Marchand', NULL, '7988 GL', NULL),
	(5207, '24 Hour Response - Dahlia Sparks', NULL, '4001 FJ', NULL),
	(5211, '24 Hour Response - Damion & Heather Chin', NULL, '5683 FG', NULL),
	(5212, '24 Hour Response - Damion Clunie', NULL, 'CJ 8205', NULL),
	(5216, 'ROENNA LOPEZ', NULL, '6860 GM', NULL),
	(5219, '24 Hour Response - Danielle & Leon Jarrett', NULL, '3394 EJ', NULL),
	(5220, '24 Hour Response - Danielle Patterson', NULL, '5521 GF', NULL),
	(5222, '24 Hour Response - Daphne Gilbert', NULL, '6320 EF', NULL),
	(5227, '24 Hour Response - Dave Dawes', NULL, 'PF 9090', NULL),
	(5231, '24 Hour Response - David & Michael Levien', NULL, 'PF 5180', NULL),
	(5232, '24 Hour Response - David & Michael Levien', NULL, '7688 CJ', NULL),
	(5233, '24 Hour Response - David Bernard', NULL, '9860 PF', NULL),
	(5235, '24 Hour Response - David Stamp', NULL, '9609 GM', NULL),
	(5239, '24 Hour Response - David/Carmen Levy', NULL, '4829 FN', NULL),
	(5241, '24 HOUR RESPONSE - DAWN DICKENSON', NULL, '3189 FJ', NULL),
	(5244, '24 Hour Response - Debbie Ottey-Golding', NULL, '2761 GF', NULL),
	(5248, '24 Hour Response - Debra Valentine', NULL, '1989 FN', NULL),
	(5249, '24 Hour Response - Delano Virgo', NULL, '4361 CG', NULL),
	(5251, '24 Hour Response - Delroy Dawson', NULL, '9470 GJ', NULL),
	(5253, '24 HOUR RESPONSE - DELROY SHEARER', NULL, '7561 EV', NULL),
	(5255, '24 Hour Response - Denise Adams', NULL, '8544 GL', NULL),
	(5261, '24 Hour Response - Denmark Laing', NULL, '7685 FU', NULL),
	(5264, '24 Hour Response - Dennis Williams', NULL, '8566 FJ', NULL),
	(5265, '24 Hour Response - Denzil Davis', NULL, '3289 GE', NULL),
	(5270, '24 Hour Response - Derrick Blair', NULL, 'PG 0502', NULL),
	(5282, '24 HOUR RESPONSE - Desmond Gordon', NULL, '1434 EW', NULL),
	(5294, '24 Hour Response - Devon Wright/Southdale Hardware', NULL, '6890 FD', NULL),
	(5299, '24 Hour Response - Diana Facey', NULL, '6177 FD', NULL),
	(5301, '24 Hour Response - Diane Allen', NULL, '3707 FW', NULL),
	(5311, '24 Hour Response - Ditty Tucker', NULL, '7455 GD', NULL),
	(5313, '24 Hour Response - Dominique Rose', NULL, '', NULL),
	(5318, '24 Hour Response - Donald Tracey', NULL, '8080 GJ', NULL),
	(5319, '24 Hour Response - Donna Bignall', NULL, '0844 FU', NULL),
	(5320, '24 Hour Response - Donna Brown', NULL, '5774 CH', NULL),
	(5331, '24 Hour Response - Dorcy E. Whyte', NULL, '5033 AZ', NULL),
	(5334, '24 Hour Response - Doreen Yvonne Carty', NULL, '4776 BF', NULL),
	(5335, '24 Hour Response - Doreth McBean', NULL, '2410 GL', NULL),
	(5346, '24 Hour Response - Dr Paul Wright', NULL, '7472 ER', NULL),
	(5347, '24 Hour Response - Dr Roger Irvine', NULL, '9938 FN', NULL),
	(5348, '24 Hour Response - Dr Roger Irvine', NULL, '6399 FC', NULL),
	(5349, '24 Hour Response - Dr Trevor & Shirley Golding', NULL, '1415 EA', NULL),
	(5350, '24 Hour Response - Dr Trevor & Shirley Golding', NULL, '5852 EN', NULL),
	(5356, '24 Hour Response - Dudley Barrett', NULL, '1099 GD', NULL),
	(5357, '24 Hour Response - Dunncox', NULL, '7213 FB', NULL),
	(5358, '24 Hour Response - Dunncox', NULL, '0402 DJ', NULL),
	(5360, '24 Hour Response - Dunncox - Bike', NULL, '7982 H', NULL),
	(5361, '24 Hour Response - Dunncox - Jerome Lee', NULL, '6926 DW', NULL),
	(5364, '24 Hour Response - Duraseal/Jasetta Lambert', NULL, '7785 GG', NULL),
	(5366, '24 HOUR RESPONSE - DWAYNE BRAMWELL', NULL, '5603 GD', NULL),
	(5385, '24 Hour Response - Elizabeth Lopez-Mullings', NULL, '2208 DX', NULL),
	(5386, '24 Hour Response - Elizabeth White', NULL, '9606 FU', NULL),
	(5394, '24 Hour Response - Enrico Murray', NULL, '7264 FL', NULL),
	(5402, '24 HOUR RESPONSE - ERMINE CLARKSON', NULL, '7057BY', NULL),
	(5409, '24 Hour Response - Esric Halsall', NULL, '0123 FG', NULL),
	(5411, '24 Hour Response - Ethel Halliman-Watson', NULL, '2628 EP', NULL),
	(5415, '24 Hour Response - Eurodent Dental/Bogdan Simanden', NULL, '0454 FL', NULL),
	(5418, '24 Hour Response - Everett Lewis', NULL, '2612 DR', NULL),
	(5420, '24 Hour Response - Everette Martin', NULL, '4677 DY', NULL),
	(5426, '24 Hour Response - Everybody\'s Pharmacy/Stephen Watson', NULL, '7541 CG', NULL),
	(5427, '24 Hour Response - Everybody\'s Pharmacy/Stephen Watson', NULL, '9763 FX', NULL),
	(5428, '24 Hour Response - Everything Fresh', NULL, '1241 GL', NULL),
	(5429, '24 HOUR RESPONSE - EVERYTHING FRESH LIMITED', NULL, '9459 CJ', NULL),
	(5440, '24 HOUR RESPONSE - Felipe Diaz', NULL, '6320 GM', NULL),
	(5441, '24 Hour Response - Ferdinand Page', NULL, '8126 FU', NULL),
	(5444, '24 Hour Response - Fiona Griffiths', NULL, '8647 GL', NULL),
	(5458, '24 HOUR RESPONSE - GABSEAN LIMITED', NULL, '9548 GE', NULL),
	(5459, '24 Hour Response - GABSEAN LIMITED', NULL, '8438 CE', NULL),
	(5465, '24 Hour Response - Garfield Forbes', NULL, '5976 GA', NULL),
	(5466, '24 Hour Response - Garfield McGhie', NULL, '7466 EC', NULL),
	(5468, '24 Hour Response - Garfield Virgin', NULL, 'VIRGIN', NULL),
	(5469, '24 HOUR RESPONSE - GARNET & CATHERINE MALCOLM', NULL, '1432 FN', NULL),
	(5471, '24 Hour Response - Garnett Reid', NULL, '2703 FF', NULL),
	(5478, '24 Hour Response - Gary Mew', NULL, '9460 CJ', NULL),
	(5480, '24 Hour Response - Gary Young', NULL, '5628 DD', NULL),
	(5482, '24 Hour Response - Gavin Hayles', NULL, '8114 FV', NULL),
	(5484, '24 Hour Response - Gem McCleary', NULL, '5894 GD', NULL),
	(5486, '24 Hour Response - Gene Dundas', NULL, '1557 EW', NULL),
	(5489, '24 Hour Response - George Belnavis', NULL, '2374 FM', NULL),
	(5490, '24 Hour Response - George Belnavis', NULL, '2096 GH', NULL),
	(5498, '24 Hour Response - Gerald Murray', NULL, '6974 GD', NULL),
	(5500, '24 HOUR RESPONSE - GILBER SUCKOO', NULL, '4578 GG', NULL),
	(5507, '24 Hour Response - Gladstone Shaw', NULL, '4333 GK', NULL),
	(5509, '24 Hour Response - Glendon Darby', NULL, 'PE 8915', NULL),
	(5510, 'Global Media services', NULL, '7147 CJ', NULL),
	(5515, '24 Hour Response - Gloria King', NULL, '1224 FT', NULL),
	(5519, 'Gopaul Boodraj', NULL, '7353 GG', NULL),
	(5522, '24 Hour Response - Grace Muir-Hector', NULL, '0901 FE', NULL),
	(5524, '24 Hour Response - Grafton Mitchell', NULL, '0221 GJ', NULL),
	(5527, '24 Hour Response - Gregory Henderson', NULL, '9846 GL', NULL),
	(5528, '24 Hour Response - Gregory Little', NULL, '1017 GN', NULL),
	(5535, '24 Hour Response - Gussie Clarke', NULL, '9305 FV', NULL),
	(5538, '24 HOUR RESPONSE - GWENDOLYN SHAW', NULL, '2076 ER', NULL),
	(5548, '24 Hour Response - Heather Lawson', NULL, '9487 FC', NULL),
	(5549, '24 HOUR RESPONSE - HEATHER SEIXAS', NULL, '3782 GE', NULL),
	(5550, '24 Hour Response - Heather Sherriff', NULL, '9194 GA', NULL),
	(5551, '24 HOUR RESPONSE - HECTOR JARRETT', NULL, '9776 GE', NULL),
	(5553, '24 Hour Response - Heidi Marcanik', NULL, '0283 GJ', NULL),
	(5554, '24 Hour Response - Henry Earl Smith', NULL, '8756 FW', NULL),
	(5558, '24 Hour Response - Herma & Jermaine Brown', NULL, '4133 DV', NULL),
	(5561, '24 Hour Response - Hezron Desroy Cameron', NULL, '8530 FD', NULL),
	(5563, '24 HOUR RESPONSE - HONG LIU', NULL, 'CJ 5666', NULL),
	(5567, '24 Hour Response - Horace Edwards', NULL, '1102 DB', NULL),
	(5569, '24 Hour Response - House of Tranquility', NULL, '8551 FB', NULL),
	(5571, '24 Hour Response - House of Tranquility', NULL, '8367 EC', NULL),
	(5573, '24 Hour Response - Howard Clarke', NULL, '1276 PA', NULL),
	(5574, '24 Hour Response - Howard McCarthy', NULL, '3327 GA', NULL),
	(5576, '24 Hour Response - Hugh Croskery', NULL, '6574 GJ', NULL),
	(5587, '24 Hour Response - Ian Leslie', NULL, '0371 FQ', NULL),
	(5588, '24 HOUR RESPONSE - IAN LESLIE', NULL, '3526 GJ', NULL),
	(5595, '24 Hour Response - IDB', NULL, '31D038', NULL),
	(5598, '24 Hour Response - Ina Haase', NULL, '2807 GJ', NULL),
	(5599, '24 Hour Response - Inavhoe Ricketts Ltd', NULL, '2711 FY', NULL),
	(5608, '24 Hour Response - Internal Business/Bernard Lilly', NULL, '8602 EM', NULL),
	(5611, '24 Hour Response - Ishmael Davis', NULL, '1802 EE', NULL),
	(5612, '24 Hour Response - Island Grill', NULL, 'TEMP', NULL),
	(5616, '24 Hour Response - Ivor Beckford', NULL, '0649 GE', NULL),
	(5623, '24 Hour Response - Jacinth Hamilton-Edwards', NULL, '4885 FX', NULL),
	(5624, '24 Hour Response - Jacinth Hamilton-Edwards', NULL, '3363 GA', NULL),
	(5625, '24 Hour Response - Jackilyn Lawrence', NULL, '8613 GD', NULL),
	(5626, '24 Hour Response - Jacqueline Cameron', NULL, '3053 GM', NULL),
	(5627, '24 Hour Response - Jacqueline Cleghorn', NULL, '9912 GB', NULL),
	(5632, '24 Hour Response - Jamaica AIDS Support for Life', NULL, '0752 DF', NULL),
	(5633, '24 Hour Response - Jamaica Plumbing Supplies', NULL, '5628 FZ', NULL),
	(5635, '24 Hour RESPONSE - JAMAICA WATER TREATMENT', NULL, '4362 CF', NULL),
	(5639, '24 Hour Response - Janet Conie', NULL, '8987 LG', NULL),
	(5649, '24 Hour Response - Janice Rosemarie Taylor', NULL, '9716 FU', NULL),
	(5650, '24 HOUR RESPONSE - JANICE WILSON', NULL, '5953 GC', NULL),
	(5655, '24 Hour Response - Jannet Fairweather', NULL, '3477 FM', NULL),
	(5656, '24 Hour Response - Janneth Baker', NULL, '0657 GB', NULL),
	(5659, '24 Hour Response - Jason Wright', NULL, '7771 FR', NULL),
	(5663, 'JAVIED MEDICAL', NULL, '5105 CG', NULL),
	(5666, '24 Hour Response - Jeanette Watson', NULL, '3208 FV', NULL),
	(5667, '24 Hour Response - Jeffrey Grant', NULL, 'PE 9165', NULL),
	(5669, '24 Hour Response - Jenelle Morris', NULL, '6042 GA', NULL),
	(5675, '24 Hour Response - Jennifer Lovelace', NULL, '9242 FT', NULL),
	(5677, '24 HOUR RESPONSE - Jennifer Williams (Queens High)', NULL, '2156 GB', NULL),
	(5680, '24 Hour Response - Jerico Hanson', NULL, '1417FR', NULL),
	(5681, 'Jermaine Campbell', NULL, '3643 PG', NULL),
	(5686, '24 Hour Response - Jianping Ye', NULL, '5766 CH', NULL),
	(5691, '24 Hour Response - Joan Neita', NULL, '5565 DY', NULL),
	(5703, '24 HOUR RESPONSE - JOHN ORELUE', NULL, '9919 FZ', NULL),
	(5707, '24 Hour Response - Joseph Liu', NULL, '3052 GB', NULL),
	(5712, '24 Hour Response - Joy Schloss', NULL, '9716 GP', NULL),
	(5713, '24 Hour Response - Joyce McCalla-Campbell', NULL, '3500 GA', NULL),
	(5715, '24 Hour Response - Joyce Deidrick', NULL, '6832 FD', NULL),
	(5718, '24 Hour Response - JR Group (JR Wellington)', NULL, '9477 FJ', NULL),
	(5719, '24 Hour Response - Juanita Reid', NULL, '0120 GD', NULL),
	(5723, '24 Hour Response - Julie Ranchandani', NULL, '3656', NULL),
	(5733, '24 Hour Response - Kahina Trawick', NULL, '8177 GK', NULL),
	(5736, '24 Hour Response - Kandi King', NULL, '3795 GE', NULL),
	(5744, '24 Hour Response - Karen Fagan', NULL, '1070 GD', NULL),
	(5745, '24 HOUR RESPONSE - KAREN MRYIE', NULL, '6161 EG', NULL),
	(5761, '24 HOUR RESPONSE - Kathryn Thompson', NULL, '7804 FU', NULL),
	(5766, '24 Hour Response - Kaydian Gordon', NULL, '3820 FP', NULL),
	(5767, '24 Hour Response - Kayon Roberts', NULL, '1758 GD', NULL),
	(5770, '24 Hour Response - Keith Cole', NULL, '3491 GF', NULL),
	(5779, '24 Hour Response - Kenroy Reivers', NULL, '9988GJ', NULL),
	(5786, '24 Hour Response - Kerry Anthony Walker', NULL, '8072 GA', NULL),
	(5788, '24 Hour Response - Kevin Butler (Jan\'s School of Catering)', NULL, '5435 FH', NULL),
	(5789, '24 Hour Response - Kevin Butler (Jan\'s School of Catering)', NULL, '9806 GC', NULL),
	(5797, '24 HOUR RESPONSE - KEVIN MILLS', NULL, '6652 FB', NULL),
	(5799, '24 Hour Response - Kevon Brown', NULL, '6848 GK', NULL),
	(5800, '24 Hour Response - Kevon Brown', NULL, '2583 GL', NULL),
	(5804, '24 Hour Response - Kimberlene Ferguson', NULL, '7272 GC', NULL),
	(5805, '24 Hour Response - Kimberly McGregor', NULL, '2938 EV', NULL),
	(5815, 'MEDIA BOOK LTD', NULL, '0385 GF', NULL),
	(5816, '24 Hour Response - Kristina Vaughan', NULL, '8415 FZ', NULL),
	(5817, '24 HOUR RESPONSE - Kwame Boafo', NULL, '0513 GJ', NULL),
	(5818, '24 HOUR RESPONSE - KWAME BOAFO', NULL, '3047GJ', NULL),
	(5831, '24 Hour Response - Laura Kerr/Ian and Kathy Kerr', NULL, '9399 FN', NULL),
	(5833, '24 Hour Response - Lawrence Electrical/Leslene Lawrence', NULL, '2767 FD', NULL),
	(5834, '24 Hour Response - Lawrence Electrical/Leslene Lawrence', NULL, '5792 FL', NULL),
	(5836, '24 Hour Response - Le Mau Wang', NULL, '3415 GD', NULL),
	(5842, '24 Hour Response - Leah Brown', NULL, '0504 DJ', NULL),
	(5848, '24 Hour Response - Lennox Turner', NULL, '9485 FU', NULL),
	(5851, '24 Hour Response - Leonie Forbes', NULL, '6324 FE', NULL),
	(5869, '24 Hour Response - Lincoln Bennett', NULL, '8475 PB', NULL),
	(5875, '24 Hour Response - Lithographic Printers/Dianne Duquesnay', NULL, '8238 ER', NULL),
	(5878, '24 Hour Response - Lloyd & Carol Hibbert', NULL, '8135 FZ', NULL),
	(5880, '24 Hour Response - Lloyd Hibbert', NULL, '8735 GE', NULL),
	(5881, '24 Hour Response - Lloyd Hibbert', NULL, '8786 GE', NULL),
	(5897, '24 Hour Response - Lorna Smith', NULL, '0909 FH', NULL),
	(5898, '24 Hour Response - Lorna Smith', NULL, '9657 FV', NULL),
	(5901, '24 HOUR RESPONSE - LORRAINE BLAIR-BAKER', NULL, '3634 GF', NULL),
	(5905, '24 Hour Response - Lorraine Reid', NULL, '0542 GK', NULL),
	(5906, '24 Hour Response - Lorraine Robinson', NULL, '9873 FZ', NULL),
	(5911, '24 Hour Response - Lovely Richards', NULL, '4647 EW', NULL),
	(5912, '24 Hour Response - Lucien Tomlinson', NULL, '5033 FW', NULL),
	(5917, '24 Hour Response - Lynval Lawrence', NULL, '5122 FN', NULL),
	(5919, '24 Hour Response - Mabel Gordon', NULL, '4949 GK', NULL),
	(5923, '24 Hour Response - Main Events', NULL, '3899 GL', NULL),
	(5924, '24 Hour Response - Maisie Kennedy-Griffiths', NULL, '3450 GB', NULL),
	(5927, '24 Hour Response - Malcolm Caines', NULL, '0413 FM', NULL),
	(5928, '24 Hour Response - Malcolm Caines', NULL, '9408 FZ', NULL),
	(5938, '24 Hour Response - Marcia Grey', NULL, '5557 FS', NULL),
	(5939, '24 HOUR RESPONSE - MARCIA HARFORD', NULL, '6645 EF', NULL),
	(5945, '24 Hour Response - Marcia Miller', NULL, '9735 DR', NULL),
	(5947, '24 Hour Response - MARCIA REYNOLDS', NULL, '7396 FW', NULL),
	(5950, '24 Hour Response - Marcia Sibbles', NULL, '7941 FZ', NULL),
	(5952, '24 Hour Response - Marcia Wiles', NULL, '0685 EX', NULL),
	(5953, '24 Hour Response - Marcus Handal', NULL, '9413 DP', NULL),
	(5954, '24 Hour Response - Margaret Steele', NULL, '3268 FR', NULL),
	(5963, '24 HOUR RESPONSE - MARJORIE BROWN', NULL, '4195 DR', NULL),
	(5969, '24 Hour Response - Mark Collins', NULL, '3039 PE', NULL),
	(5971, '24 HOUR RESPONSE - MARK COLLINS', NULL, '0065 PF', NULL),
	(5973, '24 Hour Response - Mark Harrison', NULL, '8182 FZ', NULL),
	(5985, '24 Hour Response - Marlon Elliott', NULL, '9108 FW', NULL),
	(5991, '24 Hour Response - Marsha Chambers', NULL, '2441 GE', NULL),
	(5995, '24 Hour Response - Martin Gabriel', NULL, '3675 GA', NULL),
	(6009, '24 Hour Response - Maurice Clacken', NULL, 'CH 7610', NULL),
	(6013, '24 Hour Response - Mavis James', NULL, '5935 CH', NULL),
	(6019, '24 Hour Response - Maxroy Ellis', NULL, '8826 PD', NULL),
	(6021, '24 Hour Response - MDRN International Ltd', NULL, 'TEMP', NULL),
	(6026, '24 Hour Response - Meggan Sherwood', NULL, 'CH 9884', NULL),
	(6027, '24 Hour Response - Melanie Graham', NULL, '5439 DR', NULL),
	(6030, '24 Hour Response - Melissa Brown', NULL, 'PD 9436', NULL),
	(6039, '24 Hour Response - Merkel Schloss', NULL, '6594 FZ', NULL),
	(6047, '24 Hour Response - Michael Anglin', NULL, '0225 GD', NULL),
	(6049, '24 HOUR RESPONSE - MICHAEL CAMPBELL', NULL, '7364 GB', NULL),
	(6056, '24 Hour Response - Michael and Andrea Levien', NULL, '9314 DJ', NULL),
	(6061, '24 Hour Response - Michael St Robert Sharpe', NULL, '7704 GE', NULL),
	(6066, '24 Hour Response - Michelle Bhoorasingh', NULL, '0921 GC', NULL),
	(6072, '24 Hour Response - Michelle Titus', NULL, '6416 GE', NULL),
	(6074, '24 Hour Response - Micro-Financing Solutions Limited', NULL, '0420 GJ', NULL),
	(6076, '24 Hour Response - Milade Azan', NULL, '3001 FF', NULL),
	(6077, '24 Hour Response - Milade Azan', NULL, '8604 EK', NULL),
	(6085, '24 Hour Response - Milton Walker', NULL, '2173 GA', NULL),
	(6099, '24 Hour Response - Monica Higgins', NULL, '9324 FK', NULL),
	(6100, '24 Hour Response - Monica Shakespeare', NULL, '8695 FN', NULL),
	(6101, '24 Hour Response - MONIQUE COHEN', NULL, '5460 ET', NULL),
	(6105, '24 Hour Response - Mortimer Taylor', NULL, '6891 FD', NULL),
	(6106, '24 Hour Response - Mr & Mrs Mark Younis', NULL, '8842 FZ', NULL),
	(6107, '24 Hour Response - Mrs Arthurs', NULL, '4233 EU', NULL),
	(6115, '24 HOUR RESPONSE - NADINE THOMPSON', NULL, '6030 GG', NULL),
	(6125, '24 Hour Response - Natalie Hart', NULL, '5066 GE', NULL),
	(6135, '24 Hour Response - Neil Grant', NULL, '2295 PG', NULL),
	(6138, '24 Hour Response - Neurosurgical Division', NULL, '9148 GJ', NULL),
	(6145, '24 Hour Response - Nicarno McFarlane', NULL, '3289 GF', NULL),
	(6153, '24 Hour Response - Nickiesha Williams', NULL, '0136 EJ', NULL),
	(6158, '24 Hour Response - Nicole Fennell', NULL, '0533 GM', NULL),
	(6175, '24 Hour Response - Nordia Phillips', NULL, '8111 GG', NULL),
	(6183, '24 Hour Response - Norman Lloyd', NULL, '1007 GK', NULL),
	(6188, '24 Hour Response - Oasis Health Care', NULL, '0012 FD', NULL),
	(6189, '24 Hour Response - Odell Powell', NULL, '5759 FN', NULL),
	(6202, '24 Hour Response - Oneil James', NULL, '1603 PE', NULL),
	(6206, '24 Hour Response - O\'Queive Gayle', NULL, '5409 GG', NULL),
	(6220, '24 Hour Response - Orville Walker', NULL, 'PF 0868', NULL),
	(6228, '24 Hour Response - Owen McMorris', NULL, '5948 FW', NULL),
	(6229, '24 Hour Response - Owen Munroe', NULL, '7012 EP', NULL),
	(6230, '24 Hour Response - Owen Tugman', NULL, '5238 FJ', NULL),
	(6232, '24 Hour Response - Padan Manning', NULL, '2375 GN', NULL),
	(6233, '24 Hour Response - Pamela Benka-Coker', NULL, '0170 FC', NULL),
	(6240, '24 Hour Response - Papine High School', NULL, '2582 FH', NULL),
	(6242, '24 Hour Response - Parsha Allen', NULL, '9776 GD', NULL),
	(6254, '24 HOUR RESPONSE - PATRICIA SCOTT', NULL, '1157 FP', NULL),
	(6255, '24 Hour Response - Patricia Wilson', NULL, '4459 GL', NULL),
	(6258, '24 HOUR RESPONSE - PATRICK GALLIMORE', NULL, '7814 GM', NULL),
	(6266, 'DONOVAN SMITH', NULL, '2686 GQ', NULL),
	(6276, '24 Hour Response - Paul Wright', NULL, '3570 FG', NULL),
	(6277, '24 Hour Response - Paulette Banton', NULL, '8024 GG', NULL),
	(6278, '24 Hour Response - Paulette Bardowell', NULL, '9301 FS', NULL),
	(6284, '24 Hour Response - Paulette Jumpp-Barnaby', NULL, '7588 GD', NULL),
	(6294, '24 Hour Response - Pauline Henry-Curtis', NULL, '2846 FS', NULL),
	(6299, '24 HOUR RESPONSE - PAULINE SCOTT-BLAIR', NULL, '9562 GF', NULL),
	(6302, '24 Hour Response - Pearline Elliott', NULL, '2370 FB', NULL),
	(6307, '24 Hour Response - People\'s Leather Supplies', NULL, '3943 FW', NULL),
	(6308, '24 Hour Response - Periwinkle Publishers Ja Ltd', NULL, '1325 CK', NULL),
	(6309, '24 Hour Response - Perry\'s Manufacturing', NULL, '0887 GL', NULL),
	(6311, '24 Hour Response - Petagay Blair', NULL, '7211 FW', NULL),
	(6316, '24 Hour Response - Peter Chin', NULL, '2422 FX', NULL),
	(6317, '24 Hour Response - Peter Espeut', NULL, '0068 EJ', NULL),
	(6326, '24 HOUR RESPONSE - POLYFOODS', NULL, '5076 CD', NULL),
	(6328, '24 Hour Response - Price Smart/Tara Kisto', NULL, '0695 FP', NULL),
	(6335, '24 Hour Response - RAJENDRA/RENU NARINE', NULL, '4178 GF', NULL),
	(6339, '24 Hour Response - Ramona Nelson', NULL, '3721 GE', NULL),
	(6344, '24 Hour Response - Raymond Martin', NULL, '2562 FX', NULL),
	(6353, '24 Hour Response - Renic Coke', NULL, '0155 FT', NULL),
	(6357, '24 Hour Response - Rhonda Adams', NULL, '2763FE', NULL),
	(6362, '24 Hour Response - Richard Nevers', NULL, '2081 GB', NULL),
	(6375, 'DFL IMPORTERS - Robert Decasseres', NULL, '6787 CB', NULL),
	(6379, 'GARCO CONSTRUCTION', NULL, 'RODINE', NULL),
	(6380, '24 Hour Response - Nyameke Richards', NULL, '4397 GM', NULL),
	(6381, '24 Hour Response - Robert Xu', NULL, '1648 CG', NULL),
	(6386, '24 Hour Response - Roger Roberts', NULL, '2351GB', NULL),
	(6389, '24 Hour Response - Rohan Hibbert', NULL, '2665 FT', NULL),
	(6392, 'Roman Catholic Arch-Bishop of Kingston', NULL, '0766 GE', NULL),
	(6394, 'Roman Catholic Arch-Bishop of Kingston', NULL, '7778 GD', NULL),
	(6395, 'Roman Catholic Arch-Bishop of Kingston', NULL, '2299 GB', NULL),
	(6396, 'Roman Catholic Arch-Bishop of Kingston', NULL, '1107 FW', NULL),
	(6397, 'Roman Catholic Arch-Bishop of Kingston', NULL, '0514 FE', NULL),
	(6398, 'Roman Catholic Arch-Bishop of Kingston', NULL, '5315 EH', NULL),
	(6399, 'Roman Catholic Arch-Bishop of Kingston', NULL, '2312 FU', NULL),
	(6401, 'Roman Catholic Arch-Bishop of Kingston', NULL, '1221 FQ', NULL),
	(6402, 'Roman Catholic Arch-Bishop of Kingston', NULL, '3726 ES', NULL),
	(6403, 'Roman Catholic Arch-Bishop of Kingston', NULL, '0760 EX', NULL),
	(6404, 'Roman Catholic Arch-Bishop of Kingston', NULL, '1606 EX', NULL),
	(6406, 'Roman Catholic Arch-Bishop of Kingston', NULL, '0457 FR', NULL),
	(6408, 'Roman Catholic Arch-Bishop of Kingston', NULL, '2103 GC', NULL),
	(6409, 'Roman Catholic Arch-Bishop of Kingston', NULL, '8284 FC', NULL),
	(6410, 'Roman Catholic Arch-Bishop of Kingston', NULL, '9122 FW', NULL),
	(6411, 'Roman Catholic Arch-Bishop of Kingston', NULL, '3983 FA', NULL),
	(6413, 'Roman Catholic Arch-Bishop of Kingston', NULL, '3708 FX', NULL),
	(6414, 'Roman Catholic Arch-Bishop of Kingston', NULL, '1672 ES', NULL),
	(6415, 'Roman Catholic Arch-Bishop of Kingston', NULL, '2241 FZ', NULL),
	(6416, 'Roman Catholic Arch-Bishop of Kingston', NULL, '2988 EC', NULL),
	(6417, 'Roman Catholic Arch-Bishop of Kingston', NULL, '8538 FZ', NULL),
	(6419, 'Roman Catholic Arch-Bishop of Kingston', NULL, '5895 GC', NULL),
	(6420, 'Roman Catholic Arch-Bishop of Kingston / St Richards Church', NULL, '3201 GB', NULL),
	(6423, '24 Hour Response - Ronald Frue', NULL, '8428 GL', NULL),
	(6427, '24 Hour Response - Rose Mitchell', NULL, '4864 GH', NULL),
	(6433, '24 Hour Response - Rosemarie Richards', NULL, '1351 GE', NULL),
	(6449, '24 Hour Response - Ruth Chen', NULL, '5688 GC', NULL),
	(6452, '24 Hour Response - Ryan Peralto', NULL, '4237 EA', NULL),
	(6460, '24 Hour Response - Samuel Chambers', NULL, '3086 EK', NULL),
	(6462, '24 HOUR RESPONSE - SAMUEL PARKS', NULL, '9882 GG', NULL),
	(6465, '24 HOUR RESPONSE - SANDRA (ADMA) SCOTT', NULL, '7128 GA', NULL),
	(6468, '24 HOUR RESPONSE - SANDRA JARVIS', NULL, '5811 FQ', NULL),
	(6469, '24 HOUR RESPONSE - SANDRA JOHNSON', NULL, '2339 GE', NULL),
	(6481, '24 Hour Response - Seaport Logistics', NULL, '0214 CH', NULL),
	(6485, '24 Hour Response - Shakira Lindsay', NULL, '0122 EV', NULL),
	(6488, '24 Hour Response - Shane Miller', NULL, '7293 GM', NULL),
	(6490, '24 Hour Response - Shanna Miller', NULL, '8585 GL', NULL),
	(6493, '24 HOUR RESPONSE - SHARLENE LYLE', NULL, '8443 GG', NULL),
	(6498, '24 Hour Response - Sharon Bolton', NULL, '8793 GJ', NULL),
	(6503, '24 Hour Response - Sharon Ellington', NULL, '0966 FX', NULL),
	(6509, '24 Hour Response - Sharon McKinley', NULL, '2203 ER', NULL),
	(6517, '24 Hour Response - Sheldon\'s Auto Parts', NULL, '6113 FY', NULL),
	(6518, '24 Hour Response - Sheldon\'s Auto Parts', NULL, 'CG 3635', NULL),
	(6519, '24 Hour Response - Shellian Manyan and Cassia Hinds', NULL, '9731 FW', NULL),
	(6524, '24 Hour Response - Sheralyn Pottinger', NULL, '1408 FX', NULL),
	(6540, '24 Hour Response - Shevawn Murdock', NULL, 'GF 0282', NULL),
	(6542, '24 Hour Response - Shipping Association', NULL, '5323 EH', NULL),
	(6549, '24 Hour Response - Shipping Association - Frances Yeo', NULL, '1864 GK', NULL),
	(6551, '24 HOUR RESPONSE - SHIRLEY WILSON', NULL, '1803 GE', NULL),
	(6555, '24 Hour Response - Silvena Brown', NULL, '4801 FZ', NULL),
	(6556, '24 Hour Response - Simion Robinson', NULL, '9848 EM', NULL),
	(6557, '24 Hour Response - Simon Frederick', NULL, '2714 GB', NULL),
	(6566, '24 Hour Response - Sofier Scott', NULL, '0425 GL', NULL),
	(6567, '24 HOUR RESPONSE - SOLAR DIREK', NULL, '6753 GL', NULL),
	(6575, '24 Hour Response - Sophia Chang', NULL, '6410 DY', NULL),
	(6580, 'TANIQUE GREEN', NULL, '9173 GP', NULL),
	(6587, '24 Hour Response - Stacy-Ann Lamb', NULL, 'temp4001', NULL),
	(6592, '24 Hour Response - Stephen Hill', NULL, '7807 GB', NULL),
	(6593, '24 Hour Response - Stephen Kitchin', NULL, '3240 GF', NULL),
	(6597, '24 Hour Response - Stewart  Auto', NULL, '5364 GC', NULL),
	(6601, '24 Hour Response - Summer Lopez', NULL, '0425 GH', NULL),
	(6602, '24 Hour Response - Sunwoo International', NULL, 'CF 9677', NULL),
	(6603, '24 Hour Response - Super Valu Home Centre', NULL, '2087 GA', NULL),
	(6604, '24 Hour Response - Superfair Hotel/Tony James', NULL, 'PB 0118', NULL),
	(6607, '24 Hour Response - Susan Mclean-Chin', NULL, '0775 FQ', NULL),
	(6608, '24 Hour Response - Susan McLean-Chin', NULL, '1752 CG', NULL),
	(6609, '24 Hour Response - Susanne Fredricks', NULL, '7998 FH', NULL),
	(6610, '24 HOUR RESPONSE - SUZANNE DAVIS', NULL, '8623 FN', NULL),
	(6617, '24 HOUR RESPONSE - SWANTE LINDQUIST', NULL, '2561 GN', NULL),
	(6621, '24 HOUR RESPONSE - Tahnee Taylor', NULL, '0919 GN', NULL),
	(6622, '24 Hour Response - Talbert Weir', NULL, '8884 GJ', NULL),
	(6626, '24 Hour Response - Tamara Malcolm', NULL, '8028 FV', NULL),
	(6629, '24 Hour Response - Tamele Althea Heslop', NULL, '4585 GG', NULL),
	(6631, '24 Hour Response - Tamiko Palmer', NULL, '1761 GH', NULL),
	(6633, '24 Hour Response - Tanese Smith', NULL, '5725 FG', NULL),
	(6642, '24 Hour Response - Tashanna Davis', NULL, '8341 GC', NULL),
	(6649, '24 Hour Response - Tenskey Trading', NULL, '2447 FV', NULL),
	(6650, '24 Hour Response - Teresa Martinez', NULL, '6087 FZ', NULL),
	(6651, '24 Hour Response - Terrence Brooks', NULL, '9158 DV', NULL),
	(6655, '24 Hour Response - The Salvation Army', NULL, '9225 GL', NULL),
	(6656, '24 Hour Response - Theisea Malcolm - Allison', NULL, '8897GE', NULL),
	(6659, '24 Hour Response - Therese Pasmore', NULL, '4110 FQ', NULL),
	(6665, '24 Hour Response - Tina Whyte', NULL, '8278 EM', NULL),
	(6666, '24 Hour Response - Tka Briscoe', NULL, '3899 GB', NULL),
	(6667, '24 Hour Response - TODD JOHNSON', NULL, '7403 GD', NULL),
	(6668, '24 HOUR RESPONSE - TOMLINA TOMLINSON', NULL, '3510 GM', NULL),
	(6670, 'TOP BRANDS', NULL, '8493 CH', NULL),
	(6675, '24 Hour Response - Trevor Williams', NULL, '7196 EQ', NULL),
	(6676, '24 Hour Response - Trevor Williams', NULL, '6914 GE', NULL),
	(6680, '24 Hour Response - Troy Hudson', NULL, '9225 FV', NULL),
	(6684, '24 HOUR RESPONSE - TYRON KERR', NULL, '2236 ER', NULL),
	(6685, '24 Hour Response - Tyrone Bennett', NULL, '9489 GJ', NULL),
	(6691, '24 Hour Response - Valda Facey', NULL, '9981 FD', NULL),
	(6693, '24 Hour Response - Valerie Pagon', NULL, '9718 FW', NULL),
	(6695, '24 Hour Response - Valerie Scott', NULL, '9308 FV', NULL),
	(6704, '24 Hour Response - Vaughn Bignal', NULL, '6715 GF', NULL),
	(6711, '24 Hour Response - Verman Mighty', NULL, '7061 FZ', NULL),
	(6717, '24 Hour Response - Veronica McFarlane', NULL, '3762 GB', NULL),
	(6720, '24 Hour Response - Veronica Stone', NULL, '2495 FV', NULL),
	(6725, '24 Hour Response - Victor Vassell', NULL, '1999 FX', NULL),
	(6731, '24 Hour Response - Vinella Hurge', NULL, '7018 FL', NULL),
	(6741, '24 Hour Response - Wadsworth McAnuff', NULL, '0469 GJ', NULL),
	(6744, '24 Hour Response - Warren Grizzle', NULL, '5788 GJ', NULL),
	(6746, '24 Hour Response - Wayne Bloomfield', NULL, '0542 GN', NULL),
	(6752, '24 Hour Response - Wendy Gardner', NULL, '1150 FS', NULL),
	(6758, '24 Hour Response - Willard Brown', NULL, '2653 FH', NULL),
	(6766, '24 Hour Response - Winsome Leon', NULL, '0015 EZ', NULL),
	(6770, '24 Hour Response - Winston Burnett', NULL, '2612 PP', NULL),
	(6773, '24 Hour Response - Winston Reid', NULL, '4561 GE', NULL),
	(6778, '24 Hour Response - Winston Walker', NULL, '9471 GB', NULL),
	(6786, '24 Hour Response - Yolanda Silvera', NULL, '4652 FX', NULL),
	(6787, '24 Hour Response - Yolanda Silvera', NULL, '7928 FJ', NULL),
	(6788, '24 Hour Response - Yolande Edwards', NULL, '8203 FD', NULL),
	(6790, '24 Hour Response - Yong Yan', NULL, '5726 FM', NULL),
	(6792, '24 Hour Response - Yu Zhong Li', NULL, '9878 CH', NULL),
	(6794, '24 Hour Response - Yumiko Gabe', NULL, '0612 EW', NULL),
	(6809, '24 Hour Response - Andrea Powell', NULL, '2700 GB', NULL),
	(6810, '24 HOUR RESPONSE - DALSEEN WALTERS', NULL, '5375 GL', NULL),
	(6811, '24 Hour Response - Devon Tavares', NULL, '1361 GE', NULL),
	(6817, '24 Hour Response - Lascelle Grant', NULL, '4131 GD', NULL),
	(6822, '24 Hour Response - Richard and Janet Sinclair', NULL, '7569 GE', NULL),
	(6823, '24 Hour Response - Thelmar\'s Pharmacy', NULL, '5446 CH', NULL),
	(6825, '24 HOUR RESPONSE - ZARIA MALCOLM', NULL, '3699 GB', NULL),
	(6830, '24 HOUR RESPONSE - Garfield Virgin', NULL, '8969 GL', NULL),
	(6834, '24 HOUR RESPONSE - SHELDON MURRAY', NULL, '0467 GN', NULL),
	(6846, 'DANEM ENGINEERING', NULL, '7531 GK', NULL),
	(6851, '3D Distributors', NULL, 'CG 0257', NULL),
	(6853, 'A & L Transport and Tours Limited', NULL, '2018 GB', NULL),
	(6854, 'A & L Transport and Tours Limited', NULL, 'PF 2645', NULL),
	(6855, 'A & L Transport and Tours Limited', NULL, 'CJ 6646', NULL),
	(6857, 'A.A. Laquis Limited', NULL, '8745 CG', NULL),
	(6863, 'Adrian Lyn', NULL, '3181 FH', NULL),
	(6864, 'Adrian Lyn', NULL, '3684 GH', NULL),
	(6866, 'Advance Farm Technologies', NULL, '2755 CG', NULL),
	(6870, 'Advanced Farm Technologies - Ian Fulton', NULL, '7907 CG', NULL),
	(6871, 'Advanced Farm Technology', NULL, '6307 CJ', NULL),
	(6872, 'Aero Sales & Equipment', NULL, 'CF 5380', NULL),
	(6873, 'Aero Sales & Equipment', NULL, '7287 CG', NULL),
	(6875, 'Aero Sales 2006', NULL, 'CF 7455', NULL),
	(6876, 'Aero Sales 2006', NULL, '9822 CS', NULL),
	(6877, 'Aero Sales 2006', NULL, '2267 GK', NULL),
	(6878, 'Aerosales', NULL, '6035 CG', NULL),
	(6879, 'Aerosales', NULL, '0533 CF', NULL),
	(6880, 'Aerosales', NULL, '0208 CG', NULL),
	(6885, 'Albra Distributors', NULL, '7799 CG', NULL),
	(6886, 'Albra Distributors', NULL, '4279 CE', NULL),
	(6889, 'All Island Construction & Equip', NULL, '1691 SS', NULL),
	(6891, 'Ammars Limited', NULL, '2100 GE', NULL),
	(6893, 'Andre Fray', NULL, '7883 GL', NULL),
	(6894, 'Andre Lawrence', NULL, '2633 GD', NULL),
	(6897, 'ANDREW MAIS', NULL, '7740 GE', NULL),
	(6898, 'ANDREW MAIS', NULL, '9573 GF', NULL),
	(6900, 'ANDREW THOMAS', NULL, '6093 GL', NULL),
	(6903, 'Andri Campbell', NULL, '4438 PD', NULL),
	(6905, 'ANGELLA LAHOE', NULL, '9142 GL', NULL),
	(6908, 'Annalecia Braithwaite', NULL, '6031 FY', NULL),
	(6911, 'Arrow Construction', NULL, 'CJ 1522', NULL),
	(6912, 'Arrow Construction', NULL, '7775 GL', NULL),
	(6913, 'Arrow Construction', NULL, '9137 GK', NULL),
	(6914, 'Arthur Haye', NULL, '8936 GH', NULL),
	(6916, 'Ashman Foods', NULL, 'CJ 2181', NULL),
	(6917, 'Atara Osullivan', NULL, '3411 FU', NULL),
	(6918, 'Atlantic Industrial Electric Supply Co Ltd', NULL, 'CJ 5721', NULL),
	(6920, 'Auto Mania', NULL, 'CH 3956', NULL),
	(6921, 'Auto Mania', NULL, '8122 CG', NULL),
	(6922, 'Auto Mania', NULL, '0428 CK', NULL),
	(6924, 'Ayesha Singh/Don Creary', NULL, '4920 FB', NULL),
	(6927, 'Bank of Jamaica', NULL, 'CH 7336', NULL),
	(6928, 'Bank of Jamaica', NULL, '0024 DR', NULL),
	(6929, 'Bank of Jamaica', NULL, '6506 FG', NULL),
	(6931, 'Bank of Jamaica', NULL, '0025 DR', NULL),
	(6932, 'Bank of Jamaica', NULL, '3373 EZ', NULL),
	(6933, 'Bank of Jamaica', NULL, '6277 GD', NULL),
	(6934, 'Bank of Jamaica', NULL, '6505 FG', NULL),
	(6937, 'Bank of Jamaica', NULL, '2737 EK', NULL),
	(6938, 'Bank of Jamaica', NULL, '2288 EW', NULL);
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;


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

-- Dumping data for table bunio_vts.customers_log: 1,110 rows
/*!40000 ALTER TABLE `customers_log` DISABLE KEYS */;
INSERT INTO `customers_log` (`id`, `customer_name`, `fleet_org_number`, `license_plate_number`, `vehicle_description`, `user_id`, `machine`, `ip_address`, `action`, `action_type`, `log_date`) VALUES
	(187, 'JAMAICA CUSTOMS', NULL, '30 32 96', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(188, 'JAMAICA CUSTOMS', NULL, '7269 G', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(189, 'JAMAICA CUSTOMS', NULL, '5927 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(192, 'JA BISCUIT CO', NULL, '2692 CJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(193, 'JA BISCUIT CO', NULL, '9433 CK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(195, 'GARBAGE DISPOSAL & SANITATION LTD', NULL, '2719 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(196, 'GARBAGE DISPOSAL & SANITATION LTD', NULL, '6014 CA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(197, 'GARBAGE DISPOSAL & SANITATION LTD', NULL, '5875 CA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(198, 'GARBAGE DISPOSAL & SANITATION LTD', NULL, '5060 CD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4832, 'AERO SALES', NULL, '8762 GL9', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4835, 'AISHA TODD', NULL, '8759 DW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4837, 'Akeem Adam', NULL, '3058 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4840, 'Albert Dixon', NULL, 'CE 5470', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4841, 'Albert Dixon', NULL, '3294 FQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4842, 'Albertha Rookwood-Nelson', NULL, '7065 FM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4845, 'ALCOA', NULL, '5030 EQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4849, 'Alecia English', NULL, '1367 FS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4852, 'Alicia Armstrong', NULL, '2995 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4853, 'TRULY NOLEN', NULL, '6494 EU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4854, 'Allan Morgan', NULL, '9770 GH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4858, 'Allison Wishart-Reynolds', NULL, '3132 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4863, 'Althea Alexander', NULL, '9364 FK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4865, 'EARLE MCEWAN', NULL, '3130 EU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4866, 'Altius Williams', NULL, '9447 ED', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4870, 'Amber Stewart', NULL, '7305 FA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4871, 'Amber Stewart', NULL, '7960 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4894, 'Andrea & James McNish', NULL, '3528 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4896, 'Andrea Bryson', NULL, '3323 FT', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4900, 'Andrea McNish', NULL, '2417 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4905, 'ANDREA WILLIAMS', NULL, '3023 FH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4911, 'ANDREW FRANK', NULL, 'CE 5341', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4915, 'Angela Bisasor', NULL, '6623 EH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4922, 'Ann Hutchinson', NULL, '4381 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4927, 'Annette Clarke-Thomas', NULL, '3314 FR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4934, '24 Hour Response - Anthony Parker', NULL, 'CG 4108', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4935, '24 Hour Response - Anthony Williams', NULL, '9351 FS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4936, '24 HOUR RESPONSE - ANTOINETTE BROOKS', NULL, '2200 ES', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4942, '24 Hour Response - Arnold Vassell', NULL, '5660 PA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4943, '24 Hour Response - Arrow Construction', NULL, '0289 FT', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4944, '24 Hour Response - Arrow Construction', NULL, '5986 FS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4945, '24 Hour Response - Arrow Construction', NULL, '2129 FS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4946, '24 Hour Response - Arrow Construction', NULL, '9591 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4955, '24 Hour Response - Audrey Hanson', NULL, '2647 FS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4964, '24 Hour Response - Azariah Reid', NULL, '5866 PF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4967, '24 Hour Response - Balie Denniston', NULL, '5635 FG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4968, '24 Hour Response - Barbara Hew', NULL, '1731 EF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4969, '24 Hour Response - Barbara Noel', NULL, '3331 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4981, '24 Hour Response - BC&F Auto Glass', NULL, '5192 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4983, '24 Hour Response - Benedict Ranger', NULL, '4485 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4985, '24 Hour Response - Beril Bennett', NULL, '1330 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4989, '24 Hour Response - Bertram Browne', NULL, '7544 FP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4996, '24 Hour Response - Beverley Ramsoram', NULL, '0404 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5001, '24 Hour Response - Beverly Porteous', NULL, '0981 FR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5003, '24 Hour Response - Bible Society of the West Indies', NULL, '3402 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5005, '24 Hour Response - Blain Nesbitt', NULL, '369 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5007, 'Blossom Darby', NULL, '3581 GH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5014, '24 Hour Response - BRIAN RHULE', NULL, '0662 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5016, '24 Hour Response - Bruce Williams', NULL, '1234 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5022, '24 Hour Response - C2M2C2 Evaluation Consulting', NULL, '7282 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5023, '24 HOUR RESPONSE - Caleen Thompson', NULL, 'CJ 2281', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5029, '24 Hour Response - Camille Coore', NULL, '7892 ET', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5032, '24 Hour Response - Camol Lyons', NULL, '6507 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5034, '24 Hour Response - Candice Chung', NULL, '3284 FT', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5038, '24 Hour Response - Carese Murphy', NULL, '7256 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5039, 'Caribbean Broilers', NULL, 'TEMP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5040, 'Caribbean Broilers', NULL, 'TEMP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5041, 'Caribbean Broilers', NULL, '2612 CD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5043, '24 Hour Response - Caribbean Christian Publication', NULL, '0644 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5055, '24 Hour Response - Robert Ramdeen', NULL, '5595 DX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5058, '24 Hour Response - CAROL DALLING', NULL, '2741 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5059, '24 Hour Response - Carol Gardener', NULL, '3175 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5061, '24 Hour Response - Carol Thompson-Walker', NULL, '1811 FP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5068, '24 Hour Response - Carolyn Tie', NULL, '1312 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5072, '24 Hour Response - Catherine Davis', NULL, '9879 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5073, '24 Hour Response - Catherine Kennedy', NULL, '2487 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5076, 'Cavanor Auto Rentals #1', NULL, '8784 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5077, '24 Hour Response - Cavel Francis', NULL, '2794 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5079, '24 Hour Response - Cecil July', NULL, '5687 FF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5082, '24 Hour Response - Cecile Russell', NULL, '9669 FJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5083, '24 Hour Response - Cedric Dixon', NULL, 'CG 1959', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5090, '24 Hour Response - Charissa Clemetson', NULL, '6454 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5091, '24 Hour Response - Charlene Bennett', NULL, '2354 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5092, '24 HOUR RESPONSE - CHARLENE BREVITT-ROSE', NULL, '6809 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5093, '24 HOUR RESPONSE - CHARLES CLARKE', NULL, '5360 PF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5094, '24 Hour Response - Charles Downer', NULL, '7422 H', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5103, '24 Hour Response - Cheryl Ergas', NULL, '7897 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5108, '24 HOUR RESPONSE - Chevine Edwards', NULL, 'TEMP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5109, '24 Hour Response - Christian Tavares-Finson', NULL, '1934 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5117, '24 Hour Response - Christine Hudson/K Churchhill Neita Co.', NULL, '5410 DG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5131, '24 Hour Response - Chully Williams', NULL, '3040 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5132, '24 Hour Response - Chully Williams/Carol Williams', NULL, '7055 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5133, '24 Hour Response - Claire Brown', NULL, '3390 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5134, '24 Hour Response - Claire Fernandes/Rema Wilson', NULL, 'TEMP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5148, '24 Hour Response - Claudette Brown', NULL, '4190 FQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5151, '24 Hour Response - Claudette Lewis', NULL, '8829 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5155, '24 Hour Response - Claudia Barnes', NULL, '2711 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5158, '24 Hour Response - Claudia Mundle', NULL, '', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5159, '24 Hour Response - Claudia Mundle', NULL, '', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5160, '24 Hour Response - Claudia Mundle', NULL, '', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5161, '24 Hour Response - Claudia Mundle', NULL, '', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5162, '24 Hour Response - Claudia Woung', NULL, '6510 FC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5163, '24 Hour Response - Claudile Sydial', NULL, '5957 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5164, '24 Hour Response - Claudine McLeish/Wezley Richards', NULL, '5702 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5168, '24 Hour Response - Clifton Mesquita', NULL, '2400 GH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5171, '24 Hour Response - Clover Barnes', NULL, '5498 FG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5176, '24 HOUR RESPONSE - COLLIN BRAMWELL', NULL, '7956 BV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5190, '24 HOUR RESPONSE - CPTC', NULL, 'CJ 1893', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5191, '24 HOUR RESPONSE - CPTC', NULL, 'CJ 1982', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5203, '24 Hour Response - Cynthia Marchand', NULL, '7988 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5207, '24 Hour Response - Dahlia Sparks', NULL, '4001 FJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5211, '24 Hour Response - Damion & Heather Chin', NULL, '5683 FG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5212, '24 Hour Response - Damion Clunie', NULL, 'CJ 8205', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5216, 'ROENNA LOPEZ', NULL, '6860 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5219, '24 Hour Response - Danielle & Leon Jarrett', NULL, '3394 EJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5220, '24 Hour Response - Danielle Patterson', NULL, '5521 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5222, '24 Hour Response - Daphne Gilbert', NULL, '6320 EF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5227, '24 Hour Response - Dave Dawes', NULL, 'PF 9090', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5231, '24 Hour Response - David & Michael Levien', NULL, 'PF 5180', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5232, '24 Hour Response - David & Michael Levien', NULL, '7688 CJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5233, '24 Hour Response - David Bernard', NULL, '9860 PF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5235, '24 Hour Response - David Stamp', NULL, '9609 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5239, '24 Hour Response - David/Carmen Levy', NULL, '4829 FN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5241, '24 HOUR RESPONSE - DAWN DICKENSON', NULL, '3189 FJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5244, '24 Hour Response - Debbie Ottey-Golding', NULL, '2761 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5248, '24 Hour Response - Debra Valentine', NULL, '1989 FN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5249, '24 Hour Response - Delano Virgo', NULL, '4361 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5251, '24 Hour Response - Delroy Dawson', NULL, '9470 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5253, '24 HOUR RESPONSE - DELROY SHEARER', NULL, '7561 EV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5255, '24 Hour Response - Denise Adams', NULL, '8544 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5261, '24 Hour Response - Denmark Laing', NULL, '7685 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5264, '24 Hour Response - Dennis Williams', NULL, '8566 FJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5265, '24 Hour Response - Denzil Davis', NULL, '3289 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5270, '24 Hour Response - Derrick Blair', NULL, 'PG 0502', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5282, '24 HOUR RESPONSE - Desmond Gordon', NULL, '1434 EW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5294, '24 Hour Response - Devon Wright/Southdale Hardware', NULL, '6890 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5299, '24 Hour Response - Diana Facey', NULL, '6177 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5301, '24 Hour Response - Diane Allen', NULL, '3707 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5311, '24 Hour Response - Ditty Tucker', NULL, '7455 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5313, '24 Hour Response - Dominique Rose', NULL, '', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5318, '24 Hour Response - Donald Tracey', NULL, '8080 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5319, '24 Hour Response - Donna Bignall', NULL, '0844 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5320, '24 Hour Response - Donna Brown', NULL, '5774 CH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5331, '24 Hour Response - Dorcy E. Whyte', NULL, '5033 AZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5334, '24 Hour Response - Doreen Yvonne Carty', NULL, '4776 BF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5335, '24 Hour Response - Doreth McBean', NULL, '2410 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5346, '24 Hour Response - Dr Paul Wright', NULL, '7472 ER', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5347, '24 Hour Response - Dr Roger Irvine', NULL, '9938 FN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5348, '24 Hour Response - Dr Roger Irvine', NULL, '6399 FC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5349, '24 Hour Response - Dr Trevor & Shirley Golding', NULL, '1415 EA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5350, '24 Hour Response - Dr Trevor & Shirley Golding', NULL, '5852 EN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5356, '24 Hour Response - Dudley Barrett', NULL, '1099 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5357, '24 Hour Response - Dunncox', NULL, '7213 FB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5358, '24 Hour Response - Dunncox', NULL, '0402 DJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5360, '24 Hour Response - Dunncox - Bike', NULL, '7982 H', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5361, '24 Hour Response - Dunncox - Jerome Lee', NULL, '6926 DW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5364, '24 Hour Response - Duraseal/Jasetta Lambert', NULL, '7785 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5366, '24 HOUR RESPONSE - DWAYNE BRAMWELL', NULL, '5603 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5385, '24 Hour Response - Elizabeth Lopez-Mullings', NULL, '2208 DX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5386, '24 Hour Response - Elizabeth White', NULL, '9606 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5394, '24 Hour Response - Enrico Murray', NULL, '7264 FL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5402, '24 HOUR RESPONSE - ERMINE CLARKSON', NULL, '7057BY', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5409, '24 Hour Response - Esric Halsall', NULL, '0123 FG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5411, '24 Hour Response - Ethel Halliman-Watson', NULL, '2628 EP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5415, '24 Hour Response - Eurodent Dental/Bogdan Simanden', NULL, '0454 FL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5418, '24 Hour Response - Everett Lewis', NULL, '2612 DR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5420, '24 Hour Response - Everette Martin', NULL, '4677 DY', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5426, '24 Hour Response - Everybody\'s Pharmacy/Stephen Watson', NULL, '7541 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5427, '24 Hour Response - Everybody\'s Pharmacy/Stephen Watson', NULL, '9763 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5428, '24 Hour Response - Everything Fresh', NULL, '1241 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5429, '24 HOUR RESPONSE - EVERYTHING FRESH LIMITED', NULL, '9459 CJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5440, '24 HOUR RESPONSE - Felipe Diaz', NULL, '6320 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5441, '24 Hour Response - Ferdinand Page', NULL, '8126 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5444, '24 Hour Response - Fiona Griffiths', NULL, '8647 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5458, '24 HOUR RESPONSE - GABSEAN LIMITED', NULL, '9548 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5459, '24 Hour Response - GABSEAN LIMITED', NULL, '8438 CE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5465, '24 Hour Response - Garfield Forbes', NULL, '5976 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5466, '24 Hour Response - Garfield McGhie', NULL, '7466 EC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5468, '24 Hour Response - Garfield Virgin', NULL, 'VIRGIN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5469, '24 HOUR RESPONSE - GARNET & CATHERINE MALCOLM', NULL, '1432 FN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5471, '24 Hour Response - Garnett Reid', NULL, '2703 FF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5478, '24 Hour Response - Gary Mew', NULL, '9460 CJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5480, '24 Hour Response - Gary Young', NULL, '5628 DD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5482, '24 Hour Response - Gavin Hayles', NULL, '8114 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5484, '24 Hour Response - Gem McCleary', NULL, '5894 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5486, '24 Hour Response - Gene Dundas', NULL, '1557 EW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5489, '24 Hour Response - George Belnavis', NULL, '2374 FM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5490, '24 Hour Response - George Belnavis', NULL, '2096 GH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5498, '24 Hour Response - Gerald Murray', NULL, '6974 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5500, '24 HOUR RESPONSE - GILBER SUCKOO', NULL, '4578 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5507, '24 Hour Response - Gladstone Shaw', NULL, '4333 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5509, '24 Hour Response - Glendon Darby', NULL, 'PE 8915', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5510, 'Global Media services', NULL, '7147 CJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5515, '24 Hour Response - Gloria King', NULL, '1224 FT', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5519, 'Gopaul Boodraj', NULL, '7353 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5522, '24 Hour Response - Grace Muir-Hector', NULL, '0901 FE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5524, '24 Hour Response - Grafton Mitchell', NULL, '0221 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5527, '24 Hour Response - Gregory Henderson', NULL, '9846 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5528, '24 Hour Response - Gregory Little', NULL, '1017 GN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5535, '24 Hour Response - Gussie Clarke', NULL, '9305 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5538, '24 HOUR RESPONSE - GWENDOLYN SHAW', NULL, '2076 ER', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5548, '24 Hour Response - Heather Lawson', NULL, '9487 FC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5549, '24 HOUR RESPONSE - HEATHER SEIXAS', NULL, '3782 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5550, '24 Hour Response - Heather Sherriff', NULL, '9194 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5551, '24 HOUR RESPONSE - HECTOR JARRETT', NULL, '9776 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5553, '24 Hour Response - Heidi Marcanik', NULL, '0283 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5554, '24 Hour Response - Henry Earl Smith', NULL, '8756 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5558, '24 Hour Response - Herma & Jermaine Brown', NULL, '4133 DV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5561, '24 Hour Response - Hezron Desroy Cameron', NULL, '8530 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5563, '24 HOUR RESPONSE - HONG LIU', NULL, 'CJ 5666', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5567, '24 Hour Response - Horace Edwards', NULL, '1102 DB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5569, '24 Hour Response - House of Tranquility', NULL, '8551 FB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5571, '24 Hour Response - House of Tranquility', NULL, '8367 EC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5573, '24 Hour Response - Howard Clarke', NULL, '1276 PA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5574, '24 Hour Response - Howard McCarthy', NULL, '3327 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5576, '24 Hour Response - Hugh Croskery', NULL, '6574 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5587, '24 Hour Response - Ian Leslie', NULL, '0371 FQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5588, '24 HOUR RESPONSE - IAN LESLIE', NULL, '3526 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5595, '24 Hour Response - IDB', NULL, '31D038', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5598, '24 Hour Response - Ina Haase', NULL, '2807 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5599, '24 Hour Response - Inavhoe Ricketts Ltd', NULL, '2711 FY', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5608, '24 Hour Response - Internal Business/Bernard Lilly', NULL, '8602 EM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5611, '24 Hour Response - Ishmael Davis', NULL, '1802 EE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5612, '24 Hour Response - Island Grill', NULL, 'TEMP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5616, '24 Hour Response - Ivor Beckford', NULL, '0649 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5623, '24 Hour Response - Jacinth Hamilton-Edwards', NULL, '4885 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5624, '24 Hour Response - Jacinth Hamilton-Edwards', NULL, '3363 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5625, '24 Hour Response - Jackilyn Lawrence', NULL, '8613 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5626, '24 Hour Response - Jacqueline Cameron', NULL, '3053 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5627, '24 Hour Response - Jacqueline Cleghorn', NULL, '9912 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5632, '24 Hour Response - Jamaica AIDS Support for Life', NULL, '0752 DF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5633, '24 Hour Response - Jamaica Plumbing Supplies', NULL, '5628 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5635, '24 Hour RESPONSE - JAMAICA WATER TREATMENT', NULL, '4362 CF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5639, '24 Hour Response - Janet Conie', NULL, '8987 LG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5649, '24 Hour Response - Janice Rosemarie Taylor', NULL, '9716 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5650, '24 HOUR RESPONSE - JANICE WILSON', NULL, '5953 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5655, '24 Hour Response - Jannet Fairweather', NULL, '3477 FM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5656, '24 Hour Response - Janneth Baker', NULL, '0657 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5659, '24 Hour Response - Jason Wright', NULL, '7771 FR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5663, 'JAVIED MEDICAL', NULL, '5105 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5666, '24 Hour Response - Jeanette Watson', NULL, '3208 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5667, '24 Hour Response - Jeffrey Grant', NULL, 'PE 9165', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5669, '24 Hour Response - Jenelle Morris', NULL, '6042 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5675, '24 Hour Response - Jennifer Lovelace', NULL, '9242 FT', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5677, '24 HOUR RESPONSE - Jennifer Williams (Queens High)', NULL, '2156 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5680, '24 Hour Response - Jerico Hanson', NULL, '1417FR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5681, 'Jermaine Campbell', NULL, '3643 PG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5686, '24 Hour Response - Jianping Ye', NULL, '5766 CH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5691, '24 Hour Response - Joan Neita', NULL, '5565 DY', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5703, '24 HOUR RESPONSE - JOHN ORELUE', NULL, '9919 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5707, '24 Hour Response - Joseph Liu', NULL, '3052 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5712, '24 Hour Response - Joy Schloss', NULL, '9716 GP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5713, '24 Hour Response - Joyce McCalla-Campbell', NULL, '3500 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5715, '24 Hour Response - Joyce Deidrick', NULL, '6832 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5718, '24 Hour Response - JR Group (JR Wellington)', NULL, '9477 FJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5719, '24 Hour Response - Juanita Reid', NULL, '0120 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5723, '24 Hour Response - Julie Ranchandani', NULL, '3656', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5733, '24 Hour Response - Kahina Trawick', NULL, '8177 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5736, '24 Hour Response - Kandi King', NULL, '3795 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5744, '24 Hour Response - Karen Fagan', NULL, '1070 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5745, '24 HOUR RESPONSE - KAREN MRYIE', NULL, '6161 EG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5761, '24 HOUR RESPONSE - Kathryn Thompson', NULL, '7804 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5766, '24 Hour Response - Kaydian Gordon', NULL, '3820 FP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5767, '24 Hour Response - Kayon Roberts', NULL, '1758 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5770, '24 Hour Response - Keith Cole', NULL, '3491 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5779, '24 Hour Response - Kenroy Reivers', NULL, '9988GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5786, '24 Hour Response - Kerry Anthony Walker', NULL, '8072 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5788, '24 Hour Response - Kevin Butler (Jan\'s School of Catering)', NULL, '5435 FH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5789, '24 Hour Response - Kevin Butler (Jan\'s School of Catering)', NULL, '9806 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5797, '24 HOUR RESPONSE - KEVIN MILLS', NULL, '6652 FB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5799, '24 Hour Response - Kevon Brown', NULL, '6848 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5800, '24 Hour Response - Kevon Brown', NULL, '2583 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5804, '24 Hour Response - Kimberlene Ferguson', NULL, '7272 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5805, '24 Hour Response - Kimberly McGregor', NULL, '2938 EV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5815, 'MEDIA BOOK LTD', NULL, '0385 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5816, '24 Hour Response - Kristina Vaughan', NULL, '8415 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5817, '24 HOUR RESPONSE - Kwame Boafo', NULL, '0513 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5818, '24 HOUR RESPONSE - KWAME BOAFO', NULL, '3047GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5831, '24 Hour Response - Laura Kerr/Ian and Kathy Kerr', NULL, '9399 FN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5833, '24 Hour Response - Lawrence Electrical/Leslene Lawrence', NULL, '2767 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5834, '24 Hour Response - Lawrence Electrical/Leslene Lawrence', NULL, '5792 FL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5836, '24 Hour Response - Le Mau Wang', NULL, '3415 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5842, '24 Hour Response - Leah Brown', NULL, '0504 DJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5848, '24 Hour Response - Lennox Turner', NULL, '9485 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5851, '24 Hour Response - Leonie Forbes', NULL, '6324 FE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5869, '24 Hour Response - Lincoln Bennett', NULL, '8475 PB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5875, '24 Hour Response - Lithographic Printers/Dianne Duquesnay', NULL, '8238 ER', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5878, '24 Hour Response - Lloyd & Carol Hibbert', NULL, '8135 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5880, '24 Hour Response - Lloyd Hibbert', NULL, '8735 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5881, '24 Hour Response - Lloyd Hibbert', NULL, '8786 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5897, '24 Hour Response - Lorna Smith', NULL, '0909 FH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5898, '24 Hour Response - Lorna Smith', NULL, '9657 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5901, '24 HOUR RESPONSE - LORRAINE BLAIR-BAKER', NULL, '3634 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5905, '24 Hour Response - Lorraine Reid', NULL, '0542 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5906, '24 Hour Response - Lorraine Robinson', NULL, '9873 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5911, '24 Hour Response - Lovely Richards', NULL, '4647 EW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5912, '24 Hour Response - Lucien Tomlinson', NULL, '5033 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5917, '24 Hour Response - Lynval Lawrence', NULL, '5122 FN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5919, '24 Hour Response - Mabel Gordon', NULL, '4949 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5923, '24 Hour Response - Main Events', NULL, '3899 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5924, '24 Hour Response - Maisie Kennedy-Griffiths', NULL, '3450 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5927, '24 Hour Response - Malcolm Caines', NULL, '0413 FM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5928, '24 Hour Response - Malcolm Caines', NULL, '9408 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5938, '24 Hour Response - Marcia Grey', NULL, '5557 FS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5939, '24 HOUR RESPONSE - MARCIA HARFORD', NULL, '6645 EF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5945, '24 Hour Response - Marcia Miller', NULL, '9735 DR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5947, '24 Hour Response - MARCIA REYNOLDS', NULL, '7396 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5950, '24 Hour Response - Marcia Sibbles', NULL, '7941 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5952, '24 Hour Response - Marcia Wiles', NULL, '0685 EX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5953, '24 Hour Response - Marcus Handal', NULL, '9413 DP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5954, '24 Hour Response - Margaret Steele', NULL, '3268 FR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5963, '24 HOUR RESPONSE - MARJORIE BROWN', NULL, '4195 DR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5969, '24 Hour Response - Mark Collins', NULL, '3039 PE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5971, '24 HOUR RESPONSE - MARK COLLINS', NULL, '0065 PF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5973, '24 Hour Response - Mark Harrison', NULL, '8182 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5985, '24 Hour Response - Marlon Elliott', NULL, '9108 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5991, '24 Hour Response - Marsha Chambers', NULL, '2441 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(5995, '24 Hour Response - Martin Gabriel', NULL, '3675 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6009, '24 Hour Response - Maurice Clacken', NULL, 'CH 7610', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6013, '24 Hour Response - Mavis James', NULL, '5935 CH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6019, '24 Hour Response - Maxroy Ellis', NULL, '8826 PD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6021, '24 Hour Response - MDRN International Ltd', NULL, 'TEMP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6026, '24 Hour Response - Meggan Sherwood', NULL, 'CH 9884', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6027, '24 Hour Response - Melanie Graham', NULL, '5439 DR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6030, '24 Hour Response - Melissa Brown', NULL, 'PD 9436', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6039, '24 Hour Response - Merkel Schloss', NULL, '6594 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6047, '24 Hour Response - Michael Anglin', NULL, '0225 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6049, '24 HOUR RESPONSE - MICHAEL CAMPBELL', NULL, '7364 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6056, '24 Hour Response - Michael and Andrea Levien', NULL, '9314 DJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6061, '24 Hour Response - Michael St Robert Sharpe', NULL, '7704 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6066, '24 Hour Response - Michelle Bhoorasingh', NULL, '0921 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6072, '24 Hour Response - Michelle Titus', NULL, '6416 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6074, '24 Hour Response - Micro-Financing Solutions Limited', NULL, '0420 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6076, '24 Hour Response - Milade Azan', NULL, '3001 FF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6077, '24 Hour Response - Milade Azan', NULL, '8604 EK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6085, '24 Hour Response - Milton Walker', NULL, '2173 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6099, '24 Hour Response - Monica Higgins', NULL, '9324 FK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6100, '24 Hour Response - Monica Shakespeare', NULL, '8695 FN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6101, '24 Hour Response - MONIQUE COHEN', NULL, '5460 ET', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6105, '24 Hour Response - Mortimer Taylor', NULL, '6891 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6106, '24 Hour Response - Mr & Mrs Mark Younis', NULL, '8842 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6107, '24 Hour Response - Mrs Arthurs', NULL, '4233 EU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6115, '24 HOUR RESPONSE - NADINE THOMPSON', NULL, '6030 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6125, '24 Hour Response - Natalie Hart', NULL, '5066 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6135, '24 Hour Response - Neil Grant', NULL, '2295 PG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6138, '24 Hour Response - Neurosurgical Division', NULL, '9148 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6145, '24 Hour Response - Nicarno McFarlane', NULL, '3289 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6153, '24 Hour Response - Nickiesha Williams', NULL, '0136 EJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6158, '24 Hour Response - Nicole Fennell', NULL, '0533 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6175, '24 Hour Response - Nordia Phillips', NULL, '8111 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6183, '24 Hour Response - Norman Lloyd', NULL, '1007 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6188, '24 Hour Response - Oasis Health Care', NULL, '0012 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6189, '24 Hour Response - Odell Powell', NULL, '5759 FN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6202, '24 Hour Response - Oneil James', NULL, '1603 PE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6206, '24 Hour Response - O\'Queive Gayle', NULL, '5409 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6220, '24 Hour Response - Orville Walker', NULL, 'PF 0868', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6228, '24 Hour Response - Owen McMorris', NULL, '5948 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6229, '24 Hour Response - Owen Munroe', NULL, '7012 EP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6230, '24 Hour Response - Owen Tugman', NULL, '5238 FJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6232, '24 Hour Response - Padan Manning', NULL, '2375 GN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6233, '24 Hour Response - Pamela Benka-Coker', NULL, '0170 FC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6240, '24 Hour Response - Papine High School', NULL, '2582 FH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6242, '24 Hour Response - Parsha Allen', NULL, '9776 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6254, '24 HOUR RESPONSE - PATRICIA SCOTT', NULL, '1157 FP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6255, '24 Hour Response - Patricia Wilson', NULL, '4459 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6258, '24 HOUR RESPONSE - PATRICK GALLIMORE', NULL, '7814 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6266, 'DONOVAN SMITH', NULL, '2686 GQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6276, '24 Hour Response - Paul Wright', NULL, '3570 FG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6277, '24 Hour Response - Paulette Banton', NULL, '8024 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6278, '24 Hour Response - Paulette Bardowell', NULL, '9301 FS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6284, '24 Hour Response - Paulette Jumpp-Barnaby', NULL, '7588 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6294, '24 Hour Response - Pauline Henry-Curtis', NULL, '2846 FS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6299, '24 HOUR RESPONSE - PAULINE SCOTT-BLAIR', NULL, '9562 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6302, '24 Hour Response - Pearline Elliott', NULL, '2370 FB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6307, '24 Hour Response - People\'s Leather Supplies', NULL, '3943 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6308, '24 Hour Response - Periwinkle Publishers Ja Ltd', NULL, '1325 CK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6309, '24 Hour Response - Perry\'s Manufacturing', NULL, '0887 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6311, '24 Hour Response - Petagay Blair', NULL, '7211 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6316, '24 Hour Response - Peter Chin', NULL, '2422 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6317, '24 Hour Response - Peter Espeut', NULL, '0068 EJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6326, '24 HOUR RESPONSE - POLYFOODS', NULL, '5076 CD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6328, '24 Hour Response - Price Smart/Tara Kisto', NULL, '0695 FP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6335, '24 Hour Response - RAJENDRA/RENU NARINE', NULL, '4178 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6339, '24 Hour Response - Ramona Nelson', NULL, '3721 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6344, '24 Hour Response - Raymond Martin', NULL, '2562 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6353, '24 Hour Response - Renic Coke', NULL, '0155 FT', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6357, '24 Hour Response - Rhonda Adams', NULL, '2763FE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6362, '24 Hour Response - Richard Nevers', NULL, '2081 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6375, 'DFL IMPORTERS - Robert Decasseres', NULL, '6787 CB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6379, 'GARCO CONSTRUCTION', NULL, 'RODINE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6380, '24 Hour Response - Nyameke Richards', NULL, '4397 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6381, '24 Hour Response - Robert Xu', NULL, '1648 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6386, '24 Hour Response - Roger Roberts', NULL, '2351GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6389, '24 Hour Response - Rohan Hibbert', NULL, '2665 FT', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6392, 'Roman Catholic Arch-Bishop of Kingston', NULL, '0766 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6394, 'Roman Catholic Arch-Bishop of Kingston', NULL, '7778 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6395, 'Roman Catholic Arch-Bishop of Kingston', NULL, '2299 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6396, 'Roman Catholic Arch-Bishop of Kingston', NULL, '1107 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6397, 'Roman Catholic Arch-Bishop of Kingston', NULL, '0514 FE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6398, 'Roman Catholic Arch-Bishop of Kingston', NULL, '5315 EH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6399, 'Roman Catholic Arch-Bishop of Kingston', NULL, '2312 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6401, 'Roman Catholic Arch-Bishop of Kingston', NULL, '1221 FQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6402, 'Roman Catholic Arch-Bishop of Kingston', NULL, '3726 ES', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6403, 'Roman Catholic Arch-Bishop of Kingston', NULL, '0760 EX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6404, 'Roman Catholic Arch-Bishop of Kingston', NULL, '1606 EX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6406, 'Roman Catholic Arch-Bishop of Kingston', NULL, '0457 FR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6408, 'Roman Catholic Arch-Bishop of Kingston', NULL, '2103 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6409, 'Roman Catholic Arch-Bishop of Kingston', NULL, '8284 FC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6410, 'Roman Catholic Arch-Bishop of Kingston', NULL, '9122 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6411, 'Roman Catholic Arch-Bishop of Kingston', NULL, '3983 FA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6413, 'Roman Catholic Arch-Bishop of Kingston', NULL, '3708 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6414, 'Roman Catholic Arch-Bishop of Kingston', NULL, '1672 ES', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6415, 'Roman Catholic Arch-Bishop of Kingston', NULL, '2241 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6416, 'Roman Catholic Arch-Bishop of Kingston', NULL, '2988 EC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6417, 'Roman Catholic Arch-Bishop of Kingston', NULL, '8538 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6419, 'Roman Catholic Arch-Bishop of Kingston', NULL, '5895 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6420, 'Roman Catholic Arch-Bishop of Kingston / St Richards Church', NULL, '3201 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6423, '24 Hour Response - Ronald Frue', NULL, '8428 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6427, '24 Hour Response - Rose Mitchell', NULL, '4864 GH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6433, '24 Hour Response - Rosemarie Richards', NULL, '1351 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6449, '24 Hour Response - Ruth Chen', NULL, '5688 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6452, '24 Hour Response - Ryan Peralto', NULL, '4237 EA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6460, '24 Hour Response - Samuel Chambers', NULL, '3086 EK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6462, '24 HOUR RESPONSE - SAMUEL PARKS', NULL, '9882 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6465, '24 HOUR RESPONSE - SANDRA (ADMA) SCOTT', NULL, '7128 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6468, '24 HOUR RESPONSE - SANDRA JARVIS', NULL, '5811 FQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6469, '24 HOUR RESPONSE - SANDRA JOHNSON', NULL, '2339 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6481, '24 Hour Response - Seaport Logistics', NULL, '0214 CH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6485, '24 Hour Response - Shakira Lindsay', NULL, '0122 EV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6488, '24 Hour Response - Shane Miller', NULL, '7293 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6490, '24 Hour Response - Shanna Miller', NULL, '8585 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6493, '24 HOUR RESPONSE - SHARLENE LYLE', NULL, '8443 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6498, '24 Hour Response - Sharon Bolton', NULL, '8793 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6503, '24 Hour Response - Sharon Ellington', NULL, '0966 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6509, '24 Hour Response - Sharon McKinley', NULL, '2203 ER', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6517, '24 Hour Response - Sheldon\'s Auto Parts', NULL, '6113 FY', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6518, '24 Hour Response - Sheldon\'s Auto Parts', NULL, 'CG 3635', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6519, '24 Hour Response - Shellian Manyan and Cassia Hinds', NULL, '9731 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6524, '24 Hour Response - Sheralyn Pottinger', NULL, '1408 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6540, '24 Hour Response - Shevawn Murdock', NULL, 'GF 0282', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6542, '24 Hour Response - Shipping Association', NULL, '5323 EH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6549, '24 Hour Response - Shipping Association - Frances Yeo', NULL, '1864 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6551, '24 HOUR RESPONSE - SHIRLEY WILSON', NULL, '1803 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6555, '24 Hour Response - Silvena Brown', NULL, '4801 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6556, '24 Hour Response - Simion Robinson', NULL, '9848 EM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6557, '24 Hour Response - Simon Frederick', NULL, '2714 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6566, '24 Hour Response - Sofier Scott', NULL, '0425 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6567, '24 HOUR RESPONSE - SOLAR DIREK', NULL, '6753 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6575, '24 Hour Response - Sophia Chang', NULL, '6410 DY', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6580, 'TANIQUE GREEN', NULL, '9173 GP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6587, '24 Hour Response - Stacy-Ann Lamb', NULL, 'temp4001', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6592, '24 Hour Response - Stephen Hill', NULL, '7807 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6593, '24 Hour Response - Stephen Kitchin', NULL, '3240 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6597, '24 Hour Response - Stewart  Auto', NULL, '5364 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6601, '24 Hour Response - Summer Lopez', NULL, '0425 GH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6602, '24 Hour Response - Sunwoo International', NULL, 'CF 9677', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6603, '24 Hour Response - Super Valu Home Centre', NULL, '2087 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6604, '24 Hour Response - Superfair Hotel/Tony James', NULL, 'PB 0118', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6607, '24 Hour Response - Susan Mclean-Chin', NULL, '0775 FQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6608, '24 Hour Response - Susan McLean-Chin', NULL, '1752 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6609, '24 Hour Response - Susanne Fredricks', NULL, '7998 FH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6610, '24 HOUR RESPONSE - SUZANNE DAVIS', NULL, '8623 FN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6617, '24 HOUR RESPONSE - SWANTE LINDQUIST', NULL, '2561 GN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6621, '24 HOUR RESPONSE - Tahnee Taylor', NULL, '0919 GN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6622, '24 Hour Response - Talbert Weir', NULL, '8884 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6626, '24 Hour Response - Tamara Malcolm', NULL, '8028 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6629, '24 Hour Response - Tamele Althea Heslop', NULL, '4585 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6631, '24 Hour Response - Tamiko Palmer', NULL, '1761 GH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6633, '24 Hour Response - Tanese Smith', NULL, '5725 FG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6642, '24 Hour Response - Tashanna Davis', NULL, '8341 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6649, '24 Hour Response - Tenskey Trading', NULL, '2447 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6650, '24 Hour Response - Teresa Martinez', NULL, '6087 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6651, '24 Hour Response - Terrence Brooks', NULL, '9158 DV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6655, '24 Hour Response - The Salvation Army', NULL, '9225 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6656, '24 Hour Response - Theisea Malcolm - Allison', NULL, '8897GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6659, '24 Hour Response - Therese Pasmore', NULL, '4110 FQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6665, '24 Hour Response - Tina Whyte', NULL, '8278 EM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6666, '24 Hour Response - Tka Briscoe', NULL, '3899 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6667, '24 Hour Response - TODD JOHNSON', NULL, '7403 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6668, '24 HOUR RESPONSE - TOMLINA TOMLINSON', NULL, '3510 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6670, 'TOP BRANDS', NULL, '8493 CH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6675, '24 Hour Response - Trevor Williams', NULL, '7196 EQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6676, '24 Hour Response - Trevor Williams', NULL, '6914 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6680, '24 Hour Response - Troy Hudson', NULL, '9225 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6684, '24 HOUR RESPONSE - TYRON KERR', NULL, '2236 ER', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6685, '24 Hour Response - Tyrone Bennett', NULL, '9489 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6691, '24 Hour Response - Valda Facey', NULL, '9981 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6693, '24 Hour Response - Valerie Pagon', NULL, '9718 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6695, '24 Hour Response - Valerie Scott', NULL, '9308 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6704, '24 Hour Response - Vaughn Bignal', NULL, '6715 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6711, '24 Hour Response - Verman Mighty', NULL, '7061 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6717, '24 Hour Response - Veronica McFarlane', NULL, '3762 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6720, '24 Hour Response - Veronica Stone', NULL, '2495 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6725, '24 Hour Response - Victor Vassell', NULL, '1999 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6731, '24 Hour Response - Vinella Hurge', NULL, '7018 FL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6741, '24 Hour Response - Wadsworth McAnuff', NULL, '0469 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6744, '24 Hour Response - Warren Grizzle', NULL, '5788 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6746, '24 Hour Response - Wayne Bloomfield', NULL, '0542 GN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6752, '24 Hour Response - Wendy Gardner', NULL, '1150 FS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6758, '24 Hour Response - Willard Brown', NULL, '2653 FH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6766, '24 Hour Response - Winsome Leon', NULL, '0015 EZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6770, '24 Hour Response - Winston Burnett', NULL, '2612 PP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6773, '24 Hour Response - Winston Reid', NULL, '4561 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6778, '24 Hour Response - Winston Walker', NULL, '9471 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6786, '24 Hour Response - Yolanda Silvera', NULL, '4652 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6787, '24 Hour Response - Yolanda Silvera', NULL, '7928 FJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6788, '24 Hour Response - Yolande Edwards', NULL, '8203 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6790, '24 Hour Response - Yong Yan', NULL, '5726 FM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6792, '24 Hour Response - Yu Zhong Li', NULL, '9878 CH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6794, '24 Hour Response - Yumiko Gabe', NULL, '0612 EW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6809, '24 Hour Response - Andrea Powell', NULL, '2700 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6810, '24 HOUR RESPONSE - DALSEEN WALTERS', NULL, '5375 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6811, '24 Hour Response - Devon Tavares', NULL, '1361 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6817, '24 Hour Response - Lascelle Grant', NULL, '4131 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6822, '24 Hour Response - Richard and Janet Sinclair', NULL, '7569 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6823, '24 Hour Response - Thelmar\'s Pharmacy', NULL, '5446 CH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6825, '24 HOUR RESPONSE - ZARIA MALCOLM', NULL, '3699 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6830, '24 HOUR RESPONSE - Garfield Virgin', NULL, '8969 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6834, '24 HOUR RESPONSE - SHELDON MURRAY', NULL, '0467 GN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6846, 'DANEM ENGINEERING', NULL, '7531 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6851, '3D Distributors', NULL, 'CG 0257', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6853, 'A & L Transport and Tours Limited', NULL, '2018 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6854, 'A & L Transport and Tours Limited', NULL, 'PF 2645', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6855, 'A & L Transport and Tours Limited', NULL, 'CJ 6646', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6857, 'A.A. Laquis Limited', NULL, '8745 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6863, 'Adrian Lyn', NULL, '3181 FH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6864, 'Adrian Lyn', NULL, '3684 GH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6866, 'Advance Farm Technologies', NULL, '2755 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6870, 'Advanced Farm Technologies - Ian Fulton', NULL, '7907 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6871, 'Advanced Farm Technology', NULL, '6307 CJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6872, 'Aero Sales & Equipment', NULL, 'CF 5380', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6873, 'Aero Sales & Equipment', NULL, '7287 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6875, 'Aero Sales 2006', NULL, 'CF 7455', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6876, 'Aero Sales 2006', NULL, '9822 CS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6877, 'Aero Sales 2006', NULL, '2267 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6878, 'Aerosales', NULL, '6035 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6879, 'Aerosales', NULL, '0533 CF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6880, 'Aerosales', NULL, '0208 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6885, 'Albra Distributors', NULL, '7799 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6886, 'Albra Distributors', NULL, '4279 CE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6889, 'All Island Construction & Equip', NULL, '1691 SS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6891, 'Ammars Limited', NULL, '2100 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6893, 'Andre Fray', NULL, '7883 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6894, 'Andre Lawrence', NULL, '2633 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6897, 'ANDREW MAIS', NULL, '7740 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6898, 'ANDREW MAIS', NULL, '9573 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6900, 'ANDREW THOMAS', NULL, '6093 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6903, 'Andri Campbell', NULL, '4438 PD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6905, 'ANGELLA LAHOE', NULL, '9142 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6908, 'Annalecia Braithwaite', NULL, '6031 FY', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(6911, 'Arrow Construction', NULL, 'CJ 1522', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:55'),
	(4832, 'AERO SALES', NULL, '8762 GL9', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4835, 'AISHA TODD', NULL, '8759 DW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4837, 'Akeem Adam', NULL, '3058 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4840, 'Albert Dixon', NULL, 'CE 5470', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4841, 'Albert Dixon', NULL, '3294 FQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4842, 'Albertha Rookwood-Nelson', NULL, '7065 FM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4845, 'ALCOA', NULL, '5030 EQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4849, 'Alecia English', NULL, '1367 FS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4852, 'Alicia Armstrong', NULL, '2995 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4853, 'TRULY NOLEN', NULL, '6494 EU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4854, 'Allan Morgan', NULL, '9770 GH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4858, 'Allison Wishart-Reynolds', NULL, '3132 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4863, 'Althea Alexander', NULL, '9364 FK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4865, 'EARLE MCEWAN', NULL, '3130 EU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4866, 'Altius Williams', NULL, '9447 ED', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4870, 'Amber Stewart', NULL, '7305 FA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4871, 'Amber Stewart', NULL, '7960 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4894, 'Andrea & James McNish', NULL, '3528 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4896, 'Andrea Bryson', NULL, '3323 FT', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4900, 'Andrea McNish', NULL, '2417 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4905, 'ANDREA WILLIAMS', NULL, '3023 FH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4911, 'ANDREW FRANK', NULL, 'CE 5341', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4915, 'Angela Bisasor', NULL, '6623 EH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4922, 'Ann Hutchinson', NULL, '4381 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4927, 'Annette Clarke-Thomas', NULL, '3314 FR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4934, '24 Hour Response - Anthony Parker', NULL, 'CG 4108', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4935, '24 Hour Response - Anthony Williams', NULL, '9351 FS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4936, '24 HOUR RESPONSE - ANTOINETTE BROOKS', NULL, '2200 ES', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4942, '24 Hour Response - Arnold Vassell', NULL, '5660 PA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4943, '24 Hour Response - Arrow Construction', NULL, '0289 FT', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4944, '24 Hour Response - Arrow Construction', NULL, '5986 FS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4945, '24 Hour Response - Arrow Construction', NULL, '2129 FS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4946, '24 Hour Response - Arrow Construction', NULL, '9591 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4955, '24 Hour Response - Audrey Hanson', NULL, '2647 FS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4964, '24 Hour Response - Azariah Reid', NULL, '5866 PF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4967, '24 Hour Response - Balie Denniston', NULL, '5635 FG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4968, '24 Hour Response - Barbara Hew', NULL, '1731 EF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4969, '24 Hour Response - Barbara Noel', NULL, '3331 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4981, '24 Hour Response - BC&F Auto Glass', NULL, '5192 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4983, '24 Hour Response - Benedict Ranger', NULL, '4485 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4985, '24 Hour Response - Beril Bennett', NULL, '1330 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4989, '24 Hour Response - Bertram Browne', NULL, '7544 FP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(4996, '24 Hour Response - Beverley Ramsoram', NULL, '0404 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5001, '24 Hour Response - Beverly Porteous', NULL, '0981 FR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5003, '24 Hour Response - Bible Society of the West Indies', NULL, '3402 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5005, '24 Hour Response - Blain Nesbitt', NULL, '369 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5007, 'Blossom Darby', NULL, '3581 GH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5014, '24 Hour Response - BRIAN RHULE', NULL, '0662 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5016, '24 Hour Response - Bruce Williams', NULL, '1234 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5022, '24 Hour Response - C2M2C2 Evaluation Consulting', NULL, '7282 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5023, '24 HOUR RESPONSE - Caleen Thompson', NULL, 'CJ 2281', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5029, '24 Hour Response - Camille Coore', NULL, '7892 ET', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5032, '24 Hour Response - Camol Lyons', NULL, '6507 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5034, '24 Hour Response - Candice Chung', NULL, '3284 FT', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5038, '24 Hour Response - Carese Murphy', NULL, '7256 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5039, 'Caribbean Broilers', NULL, 'TEMP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5040, 'Caribbean Broilers', NULL, 'TEMP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5041, 'Caribbean Broilers', NULL, '2612 CD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5043, '24 Hour Response - Caribbean Christian Publication', NULL, '0644 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5055, '24 Hour Response - Robert Ramdeen', NULL, '5595 DX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5058, '24 Hour Response - CAROL DALLING', NULL, '2741 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5059, '24 Hour Response - Carol Gardener', NULL, '3175 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5061, '24 Hour Response - Carol Thompson-Walker', NULL, '1811 FP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5068, '24 Hour Response - Carolyn Tie', NULL, '1312 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5072, '24 Hour Response - Catherine Davis', NULL, '9879 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5073, '24 Hour Response - Catherine Kennedy', NULL, '2487 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5076, 'Cavanor Auto Rentals #1', NULL, '8784 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5077, '24 Hour Response - Cavel Francis', NULL, '2794 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5079, '24 Hour Response - Cecil July', NULL, '5687 FF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5082, '24 Hour Response - Cecile Russell', NULL, '9669 FJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5083, '24 Hour Response - Cedric Dixon', NULL, 'CG 1959', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5090, '24 Hour Response - Charissa Clemetson', NULL, '6454 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5091, '24 Hour Response - Charlene Bennett', NULL, '2354 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5092, '24 HOUR RESPONSE - CHARLENE BREVITT-ROSE', NULL, '6809 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5093, '24 HOUR RESPONSE - CHARLES CLARKE', NULL, '5360 PF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5094, '24 Hour Response - Charles Downer', NULL, '7422 H', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5103, '24 Hour Response - Cheryl Ergas', NULL, '7897 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5108, '24 HOUR RESPONSE - Chevine Edwards', NULL, 'TEMP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5109, '24 Hour Response - Christian Tavares-Finson', NULL, '1934 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5117, '24 Hour Response - Christine Hudson/K Churchhill Neita Co.', NULL, '5410 DG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5131, '24 Hour Response - Chully Williams', NULL, '3040 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5132, '24 Hour Response - Chully Williams/Carol Williams', NULL, '7055 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5133, '24 Hour Response - Claire Brown', NULL, '3390 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5134, '24 Hour Response - Claire Fernandes/Rema Wilson', NULL, 'TEMP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5148, '24 Hour Response - Claudette Brown', NULL, '4190 FQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5151, '24 Hour Response - Claudette Lewis', NULL, '8829 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5155, '24 Hour Response - Claudia Barnes', NULL, '2711 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5158, '24 Hour Response - Claudia Mundle', NULL, '', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5159, '24 Hour Response - Claudia Mundle', NULL, '', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5160, '24 Hour Response - Claudia Mundle', NULL, '', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5161, '24 Hour Response - Claudia Mundle', NULL, '', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5162, '24 Hour Response - Claudia Woung', NULL, '6510 FC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5163, '24 Hour Response - Claudile Sydial', NULL, '5957 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5164, '24 Hour Response - Claudine McLeish/Wezley Richards', NULL, '5702 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5168, '24 Hour Response - Clifton Mesquita', NULL, '2400 GH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5171, '24 Hour Response - Clover Barnes', NULL, '5498 FG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5176, '24 HOUR RESPONSE - COLLIN BRAMWELL', NULL, '7956 BV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5190, '24 HOUR RESPONSE - CPTC', NULL, 'CJ 1893', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5191, '24 HOUR RESPONSE - CPTC', NULL, 'CJ 1982', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5203, '24 Hour Response - Cynthia Marchand', NULL, '7988 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5207, '24 Hour Response - Dahlia Sparks', NULL, '4001 FJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5211, '24 Hour Response - Damion & Heather Chin', NULL, '5683 FG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5212, '24 Hour Response - Damion Clunie', NULL, 'CJ 8205', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5216, 'ROENNA LOPEZ', NULL, '6860 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5219, '24 Hour Response - Danielle & Leon Jarrett', NULL, '3394 EJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5220, '24 Hour Response - Danielle Patterson', NULL, '5521 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5222, '24 Hour Response - Daphne Gilbert', NULL, '6320 EF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5227, '24 Hour Response - Dave Dawes', NULL, 'PF 9090', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5231, '24 Hour Response - David & Michael Levien', NULL, 'PF 5180', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5232, '24 Hour Response - David & Michael Levien', NULL, '7688 CJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5233, '24 Hour Response - David Bernard', NULL, '9860 PF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5235, '24 Hour Response - David Stamp', NULL, '9609 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5239, '24 Hour Response - David/Carmen Levy', NULL, '4829 FN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5241, '24 HOUR RESPONSE - DAWN DICKENSON', NULL, '3189 FJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5244, '24 Hour Response - Debbie Ottey-Golding', NULL, '2761 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5248, '24 Hour Response - Debra Valentine', NULL, '1989 FN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5249, '24 Hour Response - Delano Virgo', NULL, '4361 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5251, '24 Hour Response - Delroy Dawson', NULL, '9470 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5253, '24 HOUR RESPONSE - DELROY SHEARER', NULL, '7561 EV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5255, '24 Hour Response - Denise Adams', NULL, '8544 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5261, '24 Hour Response - Denmark Laing', NULL, '7685 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5264, '24 Hour Response - Dennis Williams', NULL, '8566 FJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5265, '24 Hour Response - Denzil Davis', NULL, '3289 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5270, '24 Hour Response - Derrick Blair', NULL, 'PG 0502', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5282, '24 HOUR RESPONSE - Desmond Gordon', NULL, '1434 EW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5294, '24 Hour Response - Devon Wright/Southdale Hardware', NULL, '6890 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5299, '24 Hour Response - Diana Facey', NULL, '6177 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5301, '24 Hour Response - Diane Allen', NULL, '3707 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5311, '24 Hour Response - Ditty Tucker', NULL, '7455 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5313, '24 Hour Response - Dominique Rose', NULL, '', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5318, '24 Hour Response - Donald Tracey', NULL, '8080 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5319, '24 Hour Response - Donna Bignall', NULL, '0844 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5320, '24 Hour Response - Donna Brown', NULL, '5774 CH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5331, '24 Hour Response - Dorcy E. Whyte', NULL, '5033 AZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5334, '24 Hour Response - Doreen Yvonne Carty', NULL, '4776 BF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5335, '24 Hour Response - Doreth McBean', NULL, '2410 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5346, '24 Hour Response - Dr Paul Wright', NULL, '7472 ER', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5347, '24 Hour Response - Dr Roger Irvine', NULL, '9938 FN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5348, '24 Hour Response - Dr Roger Irvine', NULL, '6399 FC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5349, '24 Hour Response - Dr Trevor & Shirley Golding', NULL, '1415 EA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5350, '24 Hour Response - Dr Trevor & Shirley Golding', NULL, '5852 EN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5356, '24 Hour Response - Dudley Barrett', NULL, '1099 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5357, '24 Hour Response - Dunncox', NULL, '7213 FB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5358, '24 Hour Response - Dunncox', NULL, '0402 DJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5360, '24 Hour Response - Dunncox - Bike', NULL, '7982 H', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5361, '24 Hour Response - Dunncox - Jerome Lee', NULL, '6926 DW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5364, '24 Hour Response - Duraseal/Jasetta Lambert', NULL, '7785 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5366, '24 HOUR RESPONSE - DWAYNE BRAMWELL', NULL, '5603 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5385, '24 Hour Response - Elizabeth Lopez-Mullings', NULL, '2208 DX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5386, '24 Hour Response - Elizabeth White', NULL, '9606 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5394, '24 Hour Response - Enrico Murray', NULL, '7264 FL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5402, '24 HOUR RESPONSE - ERMINE CLARKSON', NULL, '7057BY', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5409, '24 Hour Response - Esric Halsall', NULL, '0123 FG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5411, '24 Hour Response - Ethel Halliman-Watson', NULL, '2628 EP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5415, '24 Hour Response - Eurodent Dental/Bogdan Simanden', NULL, '0454 FL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5418, '24 Hour Response - Everett Lewis', NULL, '2612 DR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5420, '24 Hour Response - Everette Martin', NULL, '4677 DY', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5426, '24 Hour Response - Everybody\'s Pharmacy/Stephen Watson', NULL, '7541 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5427, '24 Hour Response - Everybody\'s Pharmacy/Stephen Watson', NULL, '9763 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5428, '24 Hour Response - Everything Fresh', NULL, '1241 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5429, '24 HOUR RESPONSE - EVERYTHING FRESH LIMITED', NULL, '9459 CJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5440, '24 HOUR RESPONSE - Felipe Diaz', NULL, '6320 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5441, '24 Hour Response - Ferdinand Page', NULL, '8126 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5444, '24 Hour Response - Fiona Griffiths', NULL, '8647 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5458, '24 HOUR RESPONSE - GABSEAN LIMITED', NULL, '9548 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5459, '24 Hour Response - GABSEAN LIMITED', NULL, '8438 CE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5465, '24 Hour Response - Garfield Forbes', NULL, '5976 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5466, '24 Hour Response - Garfield McGhie', NULL, '7466 EC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5468, '24 Hour Response - Garfield Virgin', NULL, 'VIRGIN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5469, '24 HOUR RESPONSE - GARNET & CATHERINE MALCOLM', NULL, '1432 FN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5471, '24 Hour Response - Garnett Reid', NULL, '2703 FF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5478, '24 Hour Response - Gary Mew', NULL, '9460 CJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5480, '24 Hour Response - Gary Young', NULL, '5628 DD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5482, '24 Hour Response - Gavin Hayles', NULL, '8114 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5484, '24 Hour Response - Gem McCleary', NULL, '5894 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5486, '24 Hour Response - Gene Dundas', NULL, '1557 EW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5489, '24 Hour Response - George Belnavis', NULL, '2374 FM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5490, '24 Hour Response - George Belnavis', NULL, '2096 GH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5498, '24 Hour Response - Gerald Murray', NULL, '6974 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5500, '24 HOUR RESPONSE - GILBER SUCKOO', NULL, '4578 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5507, '24 Hour Response - Gladstone Shaw', NULL, '4333 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5509, '24 Hour Response - Glendon Darby', NULL, 'PE 8915', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5510, 'Global Media services', NULL, '7147 CJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5515, '24 Hour Response - Gloria King', NULL, '1224 FT', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5519, 'Gopaul Boodraj', NULL, '7353 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5522, '24 Hour Response - Grace Muir-Hector', NULL, '0901 FE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5524, '24 Hour Response - Grafton Mitchell', NULL, '0221 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5527, '24 Hour Response - Gregory Henderson', NULL, '9846 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5528, '24 Hour Response - Gregory Little', NULL, '1017 GN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5535, '24 Hour Response - Gussie Clarke', NULL, '9305 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5538, '24 HOUR RESPONSE - GWENDOLYN SHAW', NULL, '2076 ER', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5548, '24 Hour Response - Heather Lawson', NULL, '9487 FC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5549, '24 HOUR RESPONSE - HEATHER SEIXAS', NULL, '3782 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5550, '24 Hour Response - Heather Sherriff', NULL, '9194 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5551, '24 HOUR RESPONSE - HECTOR JARRETT', NULL, '9776 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5553, '24 Hour Response - Heidi Marcanik', NULL, '0283 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5554, '24 Hour Response - Henry Earl Smith', NULL, '8756 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5558, '24 Hour Response - Herma & Jermaine Brown', NULL, '4133 DV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5561, '24 Hour Response - Hezron Desroy Cameron', NULL, '8530 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5563, '24 HOUR RESPONSE - HONG LIU', NULL, 'CJ 5666', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5567, '24 Hour Response - Horace Edwards', NULL, '1102 DB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5569, '24 Hour Response - House of Tranquility', NULL, '8551 FB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5571, '24 Hour Response - House of Tranquility', NULL, '8367 EC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5573, '24 Hour Response - Howard Clarke', NULL, '1276 PA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5574, '24 Hour Response - Howard McCarthy', NULL, '3327 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5576, '24 Hour Response - Hugh Croskery', NULL, '6574 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5587, '24 Hour Response - Ian Leslie', NULL, '0371 FQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5588, '24 HOUR RESPONSE - IAN LESLIE', NULL, '3526 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5595, '24 Hour Response - IDB', NULL, '31D038', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5598, '24 Hour Response - Ina Haase', NULL, '2807 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5599, '24 Hour Response - Inavhoe Ricketts Ltd', NULL, '2711 FY', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5608, '24 Hour Response - Internal Business/Bernard Lilly', NULL, '8602 EM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5611, '24 Hour Response - Ishmael Davis', NULL, '1802 EE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5612, '24 Hour Response - Island Grill', NULL, 'TEMP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5616, '24 Hour Response - Ivor Beckford', NULL, '0649 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5623, '24 Hour Response - Jacinth Hamilton-Edwards', NULL, '4885 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5624, '24 Hour Response - Jacinth Hamilton-Edwards', NULL, '3363 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5625, '24 Hour Response - Jackilyn Lawrence', NULL, '8613 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5626, '24 Hour Response - Jacqueline Cameron', NULL, '3053 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5627, '24 Hour Response - Jacqueline Cleghorn', NULL, '9912 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5632, '24 Hour Response - Jamaica AIDS Support for Life', NULL, '0752 DF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5633, '24 Hour Response - Jamaica Plumbing Supplies', NULL, '5628 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5635, '24 Hour RESPONSE - JAMAICA WATER TREATMENT', NULL, '4362 CF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5639, '24 Hour Response - Janet Conie', NULL, '8987 LG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5649, '24 Hour Response - Janice Rosemarie Taylor', NULL, '9716 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5650, '24 HOUR RESPONSE - JANICE WILSON', NULL, '5953 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5655, '24 Hour Response - Jannet Fairweather', NULL, '3477 FM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5656, '24 Hour Response - Janneth Baker', NULL, '0657 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5659, '24 Hour Response - Jason Wright', NULL, '7771 FR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5663, 'JAVIED MEDICAL', NULL, '5105 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5666, '24 Hour Response - Jeanette Watson', NULL, '3208 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5667, '24 Hour Response - Jeffrey Grant', NULL, 'PE 9165', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5669, '24 Hour Response - Jenelle Morris', NULL, '6042 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5675, '24 Hour Response - Jennifer Lovelace', NULL, '9242 FT', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5677, '24 HOUR RESPONSE - Jennifer Williams (Queens High)', NULL, '2156 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5680, '24 Hour Response - Jerico Hanson', NULL, '1417FR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5681, 'Jermaine Campbell', NULL, '3643 PG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5686, '24 Hour Response - Jianping Ye', NULL, '5766 CH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5691, '24 Hour Response - Joan Neita', NULL, '5565 DY', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5703, '24 HOUR RESPONSE - JOHN ORELUE', NULL, '9919 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5707, '24 Hour Response - Joseph Liu', NULL, '3052 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5712, '24 Hour Response - Joy Schloss', NULL, '9716 GP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5713, '24 Hour Response - Joyce McCalla-Campbell', NULL, '3500 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5715, '24 Hour Response - Joyce Deidrick', NULL, '6832 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5718, '24 Hour Response - JR Group (JR Wellington)', NULL, '9477 FJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5719, '24 Hour Response - Juanita Reid', NULL, '0120 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5723, '24 Hour Response - Julie Ranchandani', NULL, '3656', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5733, '24 Hour Response - Kahina Trawick', NULL, '8177 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5736, '24 Hour Response - Kandi King', NULL, '3795 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5744, '24 Hour Response - Karen Fagan', NULL, '1070 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5745, '24 HOUR RESPONSE - KAREN MRYIE', NULL, '6161 EG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5761, '24 HOUR RESPONSE - Kathryn Thompson', NULL, '7804 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5766, '24 Hour Response - Kaydian Gordon', NULL, '3820 FP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5767, '24 Hour Response - Kayon Roberts', NULL, '1758 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5770, '24 Hour Response - Keith Cole', NULL, '3491 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5779, '24 Hour Response - Kenroy Reivers', NULL, '9988GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5786, '24 Hour Response - Kerry Anthony Walker', NULL, '8072 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5788, '24 Hour Response - Kevin Butler (Jan\'s School of Catering)', NULL, '5435 FH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5789, '24 Hour Response - Kevin Butler (Jan\'s School of Catering)', NULL, '9806 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5797, '24 HOUR RESPONSE - KEVIN MILLS', NULL, '6652 FB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5799, '24 Hour Response - Kevon Brown', NULL, '6848 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5800, '24 Hour Response - Kevon Brown', NULL, '2583 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5804, '24 Hour Response - Kimberlene Ferguson', NULL, '7272 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5805, '24 Hour Response - Kimberly McGregor', NULL, '2938 EV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5815, 'MEDIA BOOK LTD', NULL, '0385 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5816, '24 Hour Response - Kristina Vaughan', NULL, '8415 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5817, '24 HOUR RESPONSE - Kwame Boafo', NULL, '0513 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5818, '24 HOUR RESPONSE - KWAME BOAFO', NULL, '3047GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5831, '24 Hour Response - Laura Kerr/Ian and Kathy Kerr', NULL, '9399 FN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5833, '24 Hour Response - Lawrence Electrical/Leslene Lawrence', NULL, '2767 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5834, '24 Hour Response - Lawrence Electrical/Leslene Lawrence', NULL, '5792 FL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5836, '24 Hour Response - Le Mau Wang', NULL, '3415 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5842, '24 Hour Response - Leah Brown', NULL, '0504 DJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5848, '24 Hour Response - Lennox Turner', NULL, '9485 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5851, '24 Hour Response - Leonie Forbes', NULL, '6324 FE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5869, '24 Hour Response - Lincoln Bennett', NULL, '8475 PB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5875, '24 Hour Response - Lithographic Printers/Dianne Duquesnay', NULL, '8238 ER', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5878, '24 Hour Response - Lloyd & Carol Hibbert', NULL, '8135 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5880, '24 Hour Response - Lloyd Hibbert', NULL, '8735 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5881, '24 Hour Response - Lloyd Hibbert', NULL, '8786 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5897, '24 Hour Response - Lorna Smith', NULL, '0909 FH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5898, '24 Hour Response - Lorna Smith', NULL, '9657 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5901, '24 HOUR RESPONSE - LORRAINE BLAIR-BAKER', NULL, '3634 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5905, '24 Hour Response - Lorraine Reid', NULL, '0542 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5906, '24 Hour Response - Lorraine Robinson', NULL, '9873 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5911, '24 Hour Response - Lovely Richards', NULL, '4647 EW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5912, '24 Hour Response - Lucien Tomlinson', NULL, '5033 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5917, '24 Hour Response - Lynval Lawrence', NULL, '5122 FN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5919, '24 Hour Response - Mabel Gordon', NULL, '4949 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5923, '24 Hour Response - Main Events', NULL, '3899 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5924, '24 Hour Response - Maisie Kennedy-Griffiths', NULL, '3450 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5927, '24 Hour Response - Malcolm Caines', NULL, '0413 FM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5928, '24 Hour Response - Malcolm Caines', NULL, '9408 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5938, '24 Hour Response - Marcia Grey', NULL, '5557 FS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5939, '24 HOUR RESPONSE - MARCIA HARFORD', NULL, '6645 EF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5945, '24 Hour Response - Marcia Miller', NULL, '9735 DR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5947, '24 Hour Response - MARCIA REYNOLDS', NULL, '7396 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5950, '24 Hour Response - Marcia Sibbles', NULL, '7941 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5952, '24 Hour Response - Marcia Wiles', NULL, '0685 EX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5953, '24 Hour Response - Marcus Handal', NULL, '9413 DP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5954, '24 Hour Response - Margaret Steele', NULL, '3268 FR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5963, '24 HOUR RESPONSE - MARJORIE BROWN', NULL, '4195 DR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5969, '24 Hour Response - Mark Collins', NULL, '3039 PE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5971, '24 HOUR RESPONSE - MARK COLLINS', NULL, '0065 PF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5973, '24 Hour Response - Mark Harrison', NULL, '8182 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5985, '24 Hour Response - Marlon Elliott', NULL, '9108 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5991, '24 Hour Response - Marsha Chambers', NULL, '2441 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(5995, '24 Hour Response - Martin Gabriel', NULL, '3675 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6009, '24 Hour Response - Maurice Clacken', NULL, 'CH 7610', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6013, '24 Hour Response - Mavis James', NULL, '5935 CH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6019, '24 Hour Response - Maxroy Ellis', NULL, '8826 PD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6021, '24 Hour Response - MDRN International Ltd', NULL, 'TEMP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6026, '24 Hour Response - Meggan Sherwood', NULL, 'CH 9884', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6027, '24 Hour Response - Melanie Graham', NULL, '5439 DR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6030, '24 Hour Response - Melissa Brown', NULL, 'PD 9436', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6039, '24 Hour Response - Merkel Schloss', NULL, '6594 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6047, '24 Hour Response - Michael Anglin', NULL, '0225 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6049, '24 HOUR RESPONSE - MICHAEL CAMPBELL', NULL, '7364 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6056, '24 Hour Response - Michael and Andrea Levien', NULL, '9314 DJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6061, '24 Hour Response - Michael St Robert Sharpe', NULL, '7704 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6066, '24 Hour Response - Michelle Bhoorasingh', NULL, '0921 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6072, '24 Hour Response - Michelle Titus', NULL, '6416 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6074, '24 Hour Response - Micro-Financing Solutions Limited', NULL, '0420 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6076, '24 Hour Response - Milade Azan', NULL, '3001 FF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6077, '24 Hour Response - Milade Azan', NULL, '8604 EK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6085, '24 Hour Response - Milton Walker', NULL, '2173 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6099, '24 Hour Response - Monica Higgins', NULL, '9324 FK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6100, '24 Hour Response - Monica Shakespeare', NULL, '8695 FN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6101, '24 Hour Response - MONIQUE COHEN', NULL, '5460 ET', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6105, '24 Hour Response - Mortimer Taylor', NULL, '6891 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6106, '24 Hour Response - Mr & Mrs Mark Younis', NULL, '8842 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6107, '24 Hour Response - Mrs Arthurs', NULL, '4233 EU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6115, '24 HOUR RESPONSE - NADINE THOMPSON', NULL, '6030 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6125, '24 Hour Response - Natalie Hart', NULL, '5066 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6135, '24 Hour Response - Neil Grant', NULL, '2295 PG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6138, '24 Hour Response - Neurosurgical Division', NULL, '9148 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6145, '24 Hour Response - Nicarno McFarlane', NULL, '3289 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6153, '24 Hour Response - Nickiesha Williams', NULL, '0136 EJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6158, '24 Hour Response - Nicole Fennell', NULL, '0533 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6175, '24 Hour Response - Nordia Phillips', NULL, '8111 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6183, '24 Hour Response - Norman Lloyd', NULL, '1007 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6188, '24 Hour Response - Oasis Health Care', NULL, '0012 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6189, '24 Hour Response - Odell Powell', NULL, '5759 FN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6202, '24 Hour Response - Oneil James', NULL, '1603 PE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6206, '24 Hour Response - O\'Queive Gayle', NULL, '5409 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6220, '24 Hour Response - Orville Walker', NULL, 'PF 0868', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6228, '24 Hour Response - Owen McMorris', NULL, '5948 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6229, '24 Hour Response - Owen Munroe', NULL, '7012 EP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6230, '24 Hour Response - Owen Tugman', NULL, '5238 FJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6232, '24 Hour Response - Padan Manning', NULL, '2375 GN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6233, '24 Hour Response - Pamela Benka-Coker', NULL, '0170 FC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6240, '24 Hour Response - Papine High School', NULL, '2582 FH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6242, '24 Hour Response - Parsha Allen', NULL, '9776 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6254, '24 HOUR RESPONSE - PATRICIA SCOTT', NULL, '1157 FP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6255, '24 Hour Response - Patricia Wilson', NULL, '4459 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6258, '24 HOUR RESPONSE - PATRICK GALLIMORE', NULL, '7814 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6266, 'DONOVAN SMITH', NULL, '2686 GQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6276, '24 Hour Response - Paul Wright', NULL, '3570 FG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6277, '24 Hour Response - Paulette Banton', NULL, '8024 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6278, '24 Hour Response - Paulette Bardowell', NULL, '9301 FS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6284, '24 Hour Response - Paulette Jumpp-Barnaby', NULL, '7588 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6294, '24 Hour Response - Pauline Henry-Curtis', NULL, '2846 FS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6299, '24 HOUR RESPONSE - PAULINE SCOTT-BLAIR', NULL, '9562 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6302, '24 Hour Response - Pearline Elliott', NULL, '2370 FB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6307, '24 Hour Response - People\'s Leather Supplies', NULL, '3943 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6308, '24 Hour Response - Periwinkle Publishers Ja Ltd', NULL, '1325 CK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6309, '24 Hour Response - Perry\'s Manufacturing', NULL, '0887 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6311, '24 Hour Response - Petagay Blair', NULL, '7211 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6316, '24 Hour Response - Peter Chin', NULL, '2422 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6317, '24 Hour Response - Peter Espeut', NULL, '0068 EJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6326, '24 HOUR RESPONSE - POLYFOODS', NULL, '5076 CD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6328, '24 Hour Response - Price Smart/Tara Kisto', NULL, '0695 FP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6335, '24 Hour Response - RAJENDRA/RENU NARINE', NULL, '4178 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6339, '24 Hour Response - Ramona Nelson', NULL, '3721 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6344, '24 Hour Response - Raymond Martin', NULL, '2562 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6353, '24 Hour Response - Renic Coke', NULL, '0155 FT', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6357, '24 Hour Response - Rhonda Adams', NULL, '2763FE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6362, '24 Hour Response - Richard Nevers', NULL, '2081 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6375, 'DFL IMPORTERS - Robert Decasseres', NULL, '6787 CB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6379, 'GARCO CONSTRUCTION', NULL, 'RODINE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6380, '24 Hour Response - Nyameke Richards', NULL, '4397 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6381, '24 Hour Response - Robert Xu', NULL, '1648 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6386, '24 Hour Response - Roger Roberts', NULL, '2351GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6389, '24 Hour Response - Rohan Hibbert', NULL, '2665 FT', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6392, 'Roman Catholic Arch-Bishop of Kingston', NULL, '0766 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6394, 'Roman Catholic Arch-Bishop of Kingston', NULL, '7778 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6395, 'Roman Catholic Arch-Bishop of Kingston', NULL, '2299 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6396, 'Roman Catholic Arch-Bishop of Kingston', NULL, '1107 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6397, 'Roman Catholic Arch-Bishop of Kingston', NULL, '0514 FE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6398, 'Roman Catholic Arch-Bishop of Kingston', NULL, '5315 EH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6399, 'Roman Catholic Arch-Bishop of Kingston', NULL, '2312 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6401, 'Roman Catholic Arch-Bishop of Kingston', NULL, '1221 FQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6402, 'Roman Catholic Arch-Bishop of Kingston', NULL, '3726 ES', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6403, 'Roman Catholic Arch-Bishop of Kingston', NULL, '0760 EX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6404, 'Roman Catholic Arch-Bishop of Kingston', NULL, '1606 EX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6406, 'Roman Catholic Arch-Bishop of Kingston', NULL, '0457 FR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6408, 'Roman Catholic Arch-Bishop of Kingston', NULL, '2103 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6409, 'Roman Catholic Arch-Bishop of Kingston', NULL, '8284 FC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6410, 'Roman Catholic Arch-Bishop of Kingston', NULL, '9122 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6411, 'Roman Catholic Arch-Bishop of Kingston', NULL, '3983 FA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6413, 'Roman Catholic Arch-Bishop of Kingston', NULL, '3708 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6414, 'Roman Catholic Arch-Bishop of Kingston', NULL, '1672 ES', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6415, 'Roman Catholic Arch-Bishop of Kingston', NULL, '2241 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6416, 'Roman Catholic Arch-Bishop of Kingston', NULL, '2988 EC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6417, 'Roman Catholic Arch-Bishop of Kingston', NULL, '8538 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6419, 'Roman Catholic Arch-Bishop of Kingston', NULL, '5895 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6420, 'Roman Catholic Arch-Bishop of Kingston / St Richards Church', NULL, '3201 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6423, '24 Hour Response - Ronald Frue', NULL, '8428 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6427, '24 Hour Response - Rose Mitchell', NULL, '4864 GH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6433, '24 Hour Response - Rosemarie Richards', NULL, '1351 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6449, '24 Hour Response - Ruth Chen', NULL, '5688 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6452, '24 Hour Response - Ryan Peralto', NULL, '4237 EA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6460, '24 Hour Response - Samuel Chambers', NULL, '3086 EK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6462, '24 HOUR RESPONSE - SAMUEL PARKS', NULL, '9882 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6465, '24 HOUR RESPONSE - SANDRA (ADMA) SCOTT', NULL, '7128 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6468, '24 HOUR RESPONSE - SANDRA JARVIS', NULL, '5811 FQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6469, '24 HOUR RESPONSE - SANDRA JOHNSON', NULL, '2339 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6481, '24 Hour Response - Seaport Logistics', NULL, '0214 CH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6485, '24 Hour Response - Shakira Lindsay', NULL, '0122 EV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6488, '24 Hour Response - Shane Miller', NULL, '7293 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6490, '24 Hour Response - Shanna Miller', NULL, '8585 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6493, '24 HOUR RESPONSE - SHARLENE LYLE', NULL, '8443 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6498, '24 Hour Response - Sharon Bolton', NULL, '8793 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6503, '24 Hour Response - Sharon Ellington', NULL, '0966 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6509, '24 Hour Response - Sharon McKinley', NULL, '2203 ER', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6517, '24 Hour Response - Sheldon\'s Auto Parts', NULL, '6113 FY', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6518, '24 Hour Response - Sheldon\'s Auto Parts', NULL, 'CG 3635', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6519, '24 Hour Response - Shellian Manyan and Cassia Hinds', NULL, '9731 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6524, '24 Hour Response - Sheralyn Pottinger', NULL, '1408 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6540, '24 Hour Response - Shevawn Murdock', NULL, 'GF 0282', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6542, '24 Hour Response - Shipping Association', NULL, '5323 EH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6549, '24 Hour Response - Shipping Association - Frances Yeo', NULL, '1864 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6551, '24 HOUR RESPONSE - SHIRLEY WILSON', NULL, '1803 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6555, '24 Hour Response - Silvena Brown', NULL, '4801 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6556, '24 Hour Response - Simion Robinson', NULL, '9848 EM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6557, '24 Hour Response - Simon Frederick', NULL, '2714 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6566, '24 Hour Response - Sofier Scott', NULL, '0425 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6567, '24 HOUR RESPONSE - SOLAR DIREK', NULL, '6753 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6575, '24 Hour Response - Sophia Chang', NULL, '6410 DY', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6580, 'TANIQUE GREEN', NULL, '9173 GP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6587, '24 Hour Response - Stacy-Ann Lamb', NULL, 'temp4001', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6592, '24 Hour Response - Stephen Hill', NULL, '7807 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6593, '24 Hour Response - Stephen Kitchin', NULL, '3240 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6597, '24 Hour Response - Stewart  Auto', NULL, '5364 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6601, '24 Hour Response - Summer Lopez', NULL, '0425 GH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6602, '24 Hour Response - Sunwoo International', NULL, 'CF 9677', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6603, '24 Hour Response - Super Valu Home Centre', NULL, '2087 GA', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6604, '24 Hour Response - Superfair Hotel/Tony James', NULL, 'PB 0118', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6607, '24 Hour Response - Susan Mclean-Chin', NULL, '0775 FQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6608, '24 Hour Response - Susan McLean-Chin', NULL, '1752 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6609, '24 Hour Response - Susanne Fredricks', NULL, '7998 FH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6610, '24 HOUR RESPONSE - SUZANNE DAVIS', NULL, '8623 FN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6617, '24 HOUR RESPONSE - SWANTE LINDQUIST', NULL, '2561 GN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6621, '24 HOUR RESPONSE - Tahnee Taylor', NULL, '0919 GN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6622, '24 Hour Response - Talbert Weir', NULL, '8884 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6626, '24 Hour Response - Tamara Malcolm', NULL, '8028 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6629, '24 Hour Response - Tamele Althea Heslop', NULL, '4585 GG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6631, '24 Hour Response - Tamiko Palmer', NULL, '1761 GH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6633, '24 Hour Response - Tanese Smith', NULL, '5725 FG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6642, '24 Hour Response - Tashanna Davis', NULL, '8341 GC', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6649, '24 Hour Response - Tenskey Trading', NULL, '2447 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6650, '24 Hour Response - Teresa Martinez', NULL, '6087 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6651, '24 Hour Response - Terrence Brooks', NULL, '9158 DV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6655, '24 Hour Response - The Salvation Army', NULL, '9225 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6656, '24 Hour Response - Theisea Malcolm - Allison', NULL, '8897GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6659, '24 Hour Response - Therese Pasmore', NULL, '4110 FQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6665, '24 Hour Response - Tina Whyte', NULL, '8278 EM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6666, '24 Hour Response - Tka Briscoe', NULL, '3899 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6667, '24 Hour Response - TODD JOHNSON', NULL, '7403 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6668, '24 HOUR RESPONSE - TOMLINA TOMLINSON', NULL, '3510 GM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6670, 'TOP BRANDS', NULL, '8493 CH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6675, '24 Hour Response - Trevor Williams', NULL, '7196 EQ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6676, '24 Hour Response - Trevor Williams', NULL, '6914 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6680, '24 Hour Response - Troy Hudson', NULL, '9225 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6684, '24 HOUR RESPONSE - TYRON KERR', NULL, '2236 ER', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6685, '24 Hour Response - Tyrone Bennett', NULL, '9489 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6691, '24 Hour Response - Valda Facey', NULL, '9981 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6693, '24 Hour Response - Valerie Pagon', NULL, '9718 FW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6695, '24 Hour Response - Valerie Scott', NULL, '9308 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6704, '24 Hour Response - Vaughn Bignal', NULL, '6715 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6711, '24 Hour Response - Verman Mighty', NULL, '7061 FZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6717, '24 Hour Response - Veronica McFarlane', NULL, '3762 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6720, '24 Hour Response - Veronica Stone', NULL, '2495 FV', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6725, '24 Hour Response - Victor Vassell', NULL, '1999 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6731, '24 Hour Response - Vinella Hurge', NULL, '7018 FL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6741, '24 Hour Response - Wadsworth McAnuff', NULL, '0469 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6744, '24 Hour Response - Warren Grizzle', NULL, '5788 GJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6746, '24 Hour Response - Wayne Bloomfield', NULL, '0542 GN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6752, '24 Hour Response - Wendy Gardner', NULL, '1150 FS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6758, '24 Hour Response - Willard Brown', NULL, '2653 FH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6766, '24 Hour Response - Winsome Leon', NULL, '0015 EZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6770, '24 Hour Response - Winston Burnett', NULL, '2612 PP', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6773, '24 Hour Response - Winston Reid', NULL, '4561 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6778, '24 Hour Response - Winston Walker', NULL, '9471 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6786, '24 Hour Response - Yolanda Silvera', NULL, '4652 FX', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6787, '24 Hour Response - Yolanda Silvera', NULL, '7928 FJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6788, '24 Hour Response - Yolande Edwards', NULL, '8203 FD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6790, '24 Hour Response - Yong Yan', NULL, '5726 FM', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6792, '24 Hour Response - Yu Zhong Li', NULL, '9878 CH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6794, '24 Hour Response - Yumiko Gabe', NULL, '0612 EW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6809, '24 Hour Response - Andrea Powell', NULL, '2700 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6810, '24 HOUR RESPONSE - DALSEEN WALTERS', NULL, '5375 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6811, '24 Hour Response - Devon Tavares', NULL, '1361 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6817, '24 Hour Response - Lascelle Grant', NULL, '4131 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6822, '24 Hour Response - Richard and Janet Sinclair', NULL, '7569 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6823, '24 Hour Response - Thelmar\'s Pharmacy', NULL, '5446 CH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6825, '24 HOUR RESPONSE - ZARIA MALCOLM', NULL, '3699 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6830, '24 HOUR RESPONSE - Garfield Virgin', NULL, '8969 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6834, '24 HOUR RESPONSE - SHELDON MURRAY', NULL, '0467 GN', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6846, 'DANEM ENGINEERING', NULL, '7531 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6851, '3D Distributors', NULL, 'CG 0257', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6853, 'A & L Transport and Tours Limited', NULL, '2018 GB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6854, 'A & L Transport and Tours Limited', NULL, 'PF 2645', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6855, 'A & L Transport and Tours Limited', NULL, 'CJ 6646', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6857, 'A.A. Laquis Limited', NULL, '8745 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6863, 'Adrian Lyn', NULL, '3181 FH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6864, 'Adrian Lyn', NULL, '3684 GH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6866, 'Advance Farm Technologies', NULL, '2755 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6870, 'Advanced Farm Technologies - Ian Fulton', NULL, '7907 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6871, 'Advanced Farm Technology', NULL, '6307 CJ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6872, 'Aero Sales & Equipment', NULL, 'CF 5380', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6873, 'Aero Sales & Equipment', NULL, '7287 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6875, 'Aero Sales 2006', NULL, 'CF 7455', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6876, 'Aero Sales 2006', NULL, '9822 CS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6877, 'Aero Sales 2006', NULL, '2267 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6878, 'Aerosales', NULL, '6035 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6879, 'Aerosales', NULL, '0533 CF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6880, 'Aerosales', NULL, '0208 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6885, 'Albra Distributors', NULL, '7799 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6886, 'Albra Distributors', NULL, '4279 CE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6889, 'All Island Construction & Equip', NULL, '1691 SS', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6891, 'Ammars Limited', NULL, '2100 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6893, 'Andre Fray', NULL, '7883 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6894, 'Andre Lawrence', NULL, '2633 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6897, 'ANDREW MAIS', NULL, '7740 GE', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6898, 'ANDREW MAIS', NULL, '9573 GF', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6900, 'ANDREW THOMAS', NULL, '6093 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6903, 'Andri Campbell', NULL, '4438 PD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6905, 'ANGELLA LAHOE', NULL, '9142 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6908, 'Annalecia Braithwaite', NULL, '6031 FY', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6911, 'Arrow Construction', NULL, 'CJ 1522', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6912, 'Arrow Construction', NULL, '7775 GL', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6913, 'Arrow Construction', NULL, '9137 GK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6914, 'Arthur Haye', NULL, '8936 GH', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6916, 'Ashman Foods', NULL, 'CJ 2181', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6917, 'Atara Osullivan', NULL, '3411 FU', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6918, 'Atlantic Industrial Electric Supply Co Ltd', NULL, 'CJ 5721', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6920, 'Auto Mania', NULL, 'CH 3956', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6921, 'Auto Mania', NULL, '8122 CG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6922, 'Auto Mania', NULL, '0428 CK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6924, 'Ayesha Singh/Don Creary', NULL, '4920 FB', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6927, 'Bank of Jamaica', NULL, 'CH 7336', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6928, 'Bank of Jamaica', NULL, '0024 DR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6929, 'Bank of Jamaica', NULL, '6506 FG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6931, 'Bank of Jamaica', NULL, '0025 DR', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6932, 'Bank of Jamaica', NULL, '3373 EZ', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6933, 'Bank of Jamaica', NULL, '6277 GD', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6934, 'Bank of Jamaica', NULL, '6505 FG', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6937, 'Bank of Jamaica', NULL, '2737 EK', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06'),
	(6938, 'Bank of Jamaica', NULL, '2288 EW', NULL, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:06');
/*!40000 ALTER TABLE `customers_log` ENABLE KEYS */;


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

-- Dumping data for table bunio_vts.devices: ~560 rows (approximately)
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices` (`d_number`, `device_version`, `imei`, `msisdn`, `sim_number`, `status`) VALUES
	('', 'FL1850.', '353239002532593', '18765794806', '890105009000176795', 1),
	('D14283797', 'FL1250.', '353239002531173', '18765796465', '890105009000175778', 1),
	('D14283829', 'FL1250.', '353239002531231', '18765796523', '890105009000175761', 1),
	('D14283840', 'FL1250.', '353239002531140', '18765797367', '890105009000175751', 1),
	('D14283877', '', '353239002251913', '18765795456', '890105009000175717', 1),
	('D14283891', 'FL1250.', '353239002252408', '18765795109', '890105009000175705', 1),
	('D14283985', 'FL1850V2.', '353239002251418', '18765795366', '890105009000175666', 1),
	('D14284067', 'FL1850.', '353239002247374', '18765779094', '890105009000175622', 1),
	('D14284079', 'FL1850V2.', '353239002250246', '18765795023', '890105009000175614', 1),
	('D14284084', 'FL1250.', '353239002252507', '18765795365', '890105009000175610', 1),
	('D14286575', 'FL1850V2.', '353239002532494', '18765798814', '890105009000176789', 1),
	('D14286616', 'FL1850V2.', '353239002532361', '18765794606', '890105009000176771', 1),
	('D14286618', 'FL1250.', '353239002235494', '18765794905', '890105009000176767', 1),
	('D14286633', 'FL1250.', '353239002235098', '18765794972', '890105009000176757', 1),
	('D14286691', 'FL1850.', '353239002251137', '18765798016', '890105009000176695', 1),
	('D14286784', 'FL1250.', '353239002253232', '18765794916', '890105009000176650', 1),
	('D14286805', 'FL1250.', '353239002266671', '18765794503', '890105009000176639', 1),
	('D14286816', 'FL1850V2.', '353239002263678', '18765796751', '890105009000176633', 1),
	('D14286848', 'FL1250.', '353239002251251', '18765798952', '890105009000176614', 1),
	('D14286905', '', '353239002536388', '18765797629', '890105009000176744', 1),
	('D14286925', '', '353239002532213', '18765798845', '890105009000176733', 1),
	('D14286952', 'FL1250.', '353239002252010', '18765795176', '890105009000176716', 1),
	('D14969741', 'FL1250.', '353239006022476', '18765642657', '890105005000194371', 1),
	('D14969755', 'FL1250.', '353239006257338', '18765643317', '890105005000194385', 1),
	('D14969756', 'FL1250.', '353239006257551', '18765649905', '890105005000194386', 1),
	('D14969780', 'FL1850V2.', '353239006258120', '18765645907', '890105005000194410', 1),
	('D14969788', 'FL1850V2.', '353239006257353', '18765642133', '890105005000194418', 1),
	('D14969813', 'FL1250.', '353239006256546', '18765642773', '890105005000194443', 1),
	('D14969818', 'FL1850V2.', '353239006255654', '18765645239', '890105005000194448', 1),
	('D14969829', 'FL1850.', '353239006252586', '18765641775', '890105005000194459', 1),
	('D14969857', 'FL1250.', '353239006253873', '18765643204', '890105005000194487', 1),
	('D14969868', '', '011104000564390', '18765648236', '890105005000194498', 1),
	('D14969881', 'FL1850V2.', '353239006255035', '18765642068', '890105005000194511', 1),
	('D14969905', '', '353239006018425', '18763711597', '890105005000194535', 1),
	('D14969930', 'FL1250.', '353239006019928', '18765643297', '890105005000194560', 1),
	('D14969936', 'FL1250.', '353239006023763', '18765648683', '890105005000194566', 1),
	('D14969947', 'FL1250.', '353239006022245', '18765642343', '890105005000194577', 1),
	('D14969956', 'FL1250.', '353239006257379', '18765642303', '890105005000194586', 1),
	('D14969962', 'FL1850.', '353239006255068', '18765640598', '890105005000194592', 1),
	('D14969970', 'FL1250.', '353239006252875', '18765642389', '890105005000194600', 1),
	('D14969972', 'FL1850.', '353239006256355', '18765643286', '890105005000194602', 1),
	('D14969973', 'FL1850V2.', '353239006256009', '18765644015', '890105005000194603', 1),
	('D14969974', 'FL1250.', '353239006258831', '18765643243', '890105005000194604', 1),
	('D14969977', 'FL1250.', '353239006251497', '18765642029', '890105005000194607', 1),
	('D14970503', '', '353239006021635', '18765643621', '890105005000197133', 1),
	('D14970513', 'FL1850.', '353239006018524', '18765643009', '890105005000197143', 1),
	('D14970541', 'FL1250.', '353239006023482', '18765643087', '890105005000197171', 1),
	('D14970555', 'FL1850V2.', '353239006251893', '18764474650', '890105005000197185', 1),
	('D14970563', 'FL1850.', '353239006256439', '18765641035', '890105005000197193', 1),
	('D14970574', 'FL1250.', '353239006200031', '18765641135', '890105005000197204', 1),
	('D14970585', 'FL1250.', '353239006257411', '18765649904', '890105005000197215', 1),
	('D14970610', 'FL1850V2.', '353239006019662', '18765641612', '890105005000197240', 1),
	('D14970618', 'FL1250.', '353239006018888', '18765643384', '890105005000197248', 1),
	('D14970659', 'FL1250.', '353239006038118', '18765642185', '890105005000197289', 1),
	('D14970664', 'FL1250.', '353239006041211', '18765642414', '890105005000197294', 1),
	('D14970667', 'FL1250.', '353239006022740', '18765642078', '890105005000197297', 1),
	('D14970710', 'FL1250.', '353239006021320', '18765641762', '890105005000197340', 1),
	('D14970712', 'FL1850.', '353239006022732', '18765643094', '890105005000197342', 1),
	('D14970723', 'FL1850V2.', '353239006020686', '18763689957', '890105005000197353', 1),
	('D14970725', 'FL1850.', '353239006020512', '18765643221', '890105005000197355', 1),
	('D15025084', 'FL1250.', '011104000565546', '18763826235', '890105006000202729', 1),
	('D15025093', 'FL1850V2.', '011104000564184', '18765646457', '890105006000202738', 1),
	('D15163533', 'FL1250.', '011104000561438', '18763830815', '890105006000206114', 1),
	('D15163577', 'FL1250.', '011104000570645', '18768819657', '890105006000206158', 1),
	('D15163738', '', '011104000561487', '18763612604', '890105006000206319', 1),
	('D15163746', '', '011104000561859', '18768782572', '890105006000206327', 1),
	('D15163749', 'FL1250.', '011104000566189', '18763814287', '890105006000206330', 1),
	('D15163752', 'FL1850.', '011104000565538', '18768697668', '890105006000206333', 1),
	('D15163758', 'FL1250.', '011104000562261', '18763836813', '890105006000206339', 1),
	('D15163761', 'FL1250.', '011104000565694', '18765773453', '890105006000206342', 1),
	('D15163766', '', '011104000566510', '18763660106', '890105006000206347', 1),
	('D15163767', 'FL1850.', '011104000566775', '18765641783', '890105006000206348', 1),
	('D15163772', 'FL1250.', '353239006021338', '18765884649', '890105006000206353', 1),
	('D15164893', 'FL1250.', '011104000565835', '18768819372', '890105006000206723', 1),
	('D15164902', 'FL1250.', '011104000565983', '18768819646', '890105006000206732', 1),
	('D15164903', 'FL1850.', '011104000560240', '18765644012', '890105006000206733', 1),
	('D15164924', 'FL1850V2.', '011104000558087', '18768775159', '890105006000206754', 1),
	('D15166584', 'FL1200.', '011104000561503', '18765642498', '890105006000204665', 1),
	('D15166593', 'FL1850V2.', '011104000561776', '18763823370', '890105006000204674', 1),
	('D15166597', 'FL1250.', '011104000561842', '18768696276', '890105006000204678', 1),
	('D15166601', 'FL1250.', '011104000570744', '18765649382', '890105006000204682', 1),
	('D15166610', 'FL1850.', '011104000566817', '18765645265', '890105006000204691', 1),
	('D15166628', '', '011104000562436', '18765644606', '890105006000204709', 1),
	('D15166630', 'FL1850V2.', '011104000562550', '18765644985', '890105006000204711', 1),
	('D15166798', 'FL1250.', '011104000564135', '18768819762', '890105006000204879', 1),
	('D15166812', 'FL1850V2.', '011104000566742', '18765090522', '890105006000204893', 1),
	('D15166828', 'FL1200.', '011104000563665', '18765649720', '890105006000204909', 1),
	('D15166941', 'FL1250.', '011104000564150', '18763835388', '890105006000205022', 1),
	('D15166951', 'FL1850V2.', '011104000561750', '18765645201', '890105006000205032', 1),
	('D15166953', 'FL1850V2.', '353239006021239', '18763835396', '890105006000205034', 1),
	('D15166959', 'FL1850.', '353239006021502', '18763835094', '890105006000205040', 1),
	('D15166970', '', '011104000564499', '18768819762', '890105006000205051', 1),
	('D15166973', 'FL1850.', '011104000564523', '18763825167', '890105006000205054', 1),
	('D15166974', 'FL1250.', '011104000564093', '18765647391', '890105006000205055', 1),
	('D15166991', 'FL1850.', '011104000563806', '18765778853', '890105006000205072', 1),
	('D15166994', '', '011104000563780', '18765794572', '890105006000205075', 1),
	('D15166998', 'FL1850V2.', '011104000570165', '18765649683', '890105006000205079', 1),
	('D15375826', 'FL1250.', '353239006018953', '18765644818', '890105001000210812', 1),
	('D15469731', 'FL1250.', '011104005121212', '18765643048', '890105001000215349', 1),
	('D15469743', 'FL1850V2.', '011104005431249', '18764411072', '890105001000215361', 1),
	('D15470300', '', '011104000562378', '18768697317', '890105001000214418', 1),
	('D15470302', 'FL1850.', '011104000562485', '18768696088', '890105001000214420', 1),
	('D15470323', 'FL1200.', '011104000562170', '18765644567', '890105001000214441', 1),
	('D15470328', 'FL1250.', '011104000565801', '18763826366', '890105001000214446', 1),
	('D15470339', 'FL1200.', '011104000563889', '18763834951', '890105001000214458', 1),
	('D15470342', 'FL1250.', '011104000738697', '18768786527', '890105001000214460', 1),
	('D15470477', 'FL1850.', '011104000566528', '18763825024', '890105001000214595', 1),
	('D15470480', 'FL1250.', '011104000546488', '18765649817', '890105001000214598', 1),
	('D15470492', 'FL1250.', '011104000565561', '18764692193', '890105001000214610', 1),
	('D15470494', 'FL1850.', '011104000565371', '18763835918', '890105001000214612', 1),
	('D16087173', 'FL1200.', '011104000729332', '18765611283', '890105001000237398', 1),
	('D16087179', 'FL1850V2.', '011104000729324', '18765780534', '890105001000237403', 1),
	('D16087182', 'FL1850.', '011104005119125', '18763826507', '890105001000237405', 1),
	('D16087184', 'FL1250.', '011104005119075', '18765624893', '890105001000237407', 1),
	('D16087199', 'FL1850V2.', '011104000732708', '18764665435', '890105001000237415', 1),
	('D16087208', '', '011104000731031', '18762769661', '890105001000237421', 1),
	('D16087212', 'FL1850.', '011104000731023', '18765781015', '890105001000237424', 1),
	('D16087214', '', '011104000732815', '18765781011', '890105001000237426', 1),
	('D16087220', 'FL1200.', '011104000731064', '18765781014', '890105001000237431', 1),
	('D16087223', 'FL1250.', '011104000729357', '217', '890105001000237433', 1),
	('D16087225', 'FL1200.', '011104005131567', '18763811727', '890105001000237435', 1),
	('D16087235', 'FL1250.', '011104005122491', '18762986605', '890105001000237442', 1),
	('D16087246', 'FL1200.', '011104005114746', '18765781016', '890105001000237447', 1),
	('D16087251', 'FL1200.', '011104005131583', '18765620578', '890105001000237451', 1),
	('D16087263', 'FL1250.', '011104005131666', '18765781013', '890105001000237460', 1),
	('D16087265', 'FL1250.', '011104000732781', '18764815731', '890105001000237462', 1),
	('D16087268', 'FL1250.', '011104005131658', '18764401690', '890105001000237464', 1),
	('D16087277', 'FL1850.', '011104005122327', '18763811048', '890105001000237472', 1),
	('D16087287', 'FL1850.', '011104005122558', '18768817636', '890105001000237480', 1),
	('D16087292', 'FL1850.', '011104005121105', '18762766748', '890105001000237484', 1),
	('D16087296', 'FL1850V2.', '011104000669801', '18763829626', '890105001000237487', 1),
	('D16087327', 'FL1850V2.', '011104000669819', '18762826533', '890105001000237509', 1),
	('D16087332', 'FL1850V2.', '011104005120842', '18762769432', '890105001000237513', 1),
	('D16087336', 'FL1250.', '011104005114555', '18762767195', '890105001000237516', 1),
	('D16087337', 'FL1850.', '011104005114589', '18763830677', '890105001000237517', 1),
	('D16087343', 'FL1250.', '011104005127714', '18762769424', '890105001000237523', 1),
	('D16087347', 'FL1200.', '011104005121345', '18762767185', '890105001000237526', 1),
	('D16087380', 'FL1850.', '011104000660834', '18762765902', '890105001000237550', 1),
	('D16087407', 'FL1250.', '357852035973877', '18762985584', '890105001000237569', 1),
	('D16087417', '', '011104005114373', '18762930982', '890105001000237576', 1),
	('D16087421', '', '011104005114308', '18762823399', '890105001000237579', 1),
	('D16087430', 'FL1250.', '011104005120784', '18763614340', '890105001000237585', 1),
	('D16087483', 'FL1200.', '011104000740842', '18765648869', '890105001000237621', 1),
	('D16087496', 'FL1850V2.', '011104005130445', '18762769357', '890105001000237631', 1),
	('D16087499', '', '011104000669777', '18765779772', '890105001000237633', 1),
	('D16087505', 'FL1250.', '011104000670023', '18762985988', '890105001000237636', 1),
	('D16121513', '', '011104005117525', '18762767728', '890105001000242138', 1),
	('D16121527', '', '011104005117905', '18764635151', '890105001000242152', 1),
	('D16121540', 'FL1200.', '011104005117640', '18764692637', '890105001000242165', 1),
	('D16121543', 'FL1250.', '011104005129892', '18762766465', '890105001000242168', 1),
	('D16121550', 'FL1850.', '011104005129835', '18763725377', '890105001000242175', 1),
	('D16121555', 'FL1850.', '011104005117756', '18763728718', '890105001000242180', 1),
	('D16121558', 'FL1850.', '011104005129686', '18764406768', '890105001000242183', 1),
	('D16121559', '', '011104005129827', '18762767109', '890105001000242184', 1),
	('D16121570', 'FL1250.', '011104005120453', '18762827445', '890105001000242195', 1),
	('D16121583', 'FL1250.', '011104005127656', '18768755958', '890105001000242208', 1),
	('D16121584', '', '011104005127623', '18764514012', '890105001000242209', 1),
	('D16121585', 'FL1850.', '011104005127482', '18762823820', '890105001000242210', 1),
	('D16121587', 'FL1250.', '011104005114662', '18762797451', '890105001000242212', 1),
	('D16121590', 'FL1850V2.', '011104005114779', '18764690053', '890105001000242215', 1),
	('D16121595', 'FL1200.', '011104005114654', '18764454182', '890105001000242220', 1),
	('D16121600', 'FL1250.', '011104005114639', '18762986513', '890105001000242225', 1),
	('D16121615', '', '011104005118697', '18763832099', '890105001000242240', 1),
	('D16121629', 'FL1850.', '011104005118630', '18762883754', '890105001000242254', 1),
	('D16121636', 'FL1200.', '011104005120024', '18768816769', '890105001000242261', 1),
	('D16121638', 'FL1850.', '011104005122418', '18762997007', '890105001000242263', 1),
	('D16121642', 'FL1850.', '011104005119687', '18764521640', '890105001000242267', 1),
	('D16121650', 'FL1250.', '011104005120040', '18762768780', '890105001000242275', 1),
	('D16121652', 'FL1850V2.', '011104005119810', '18768754798', '890105001000242277', 1),
	('D16121657', 'FL1850.', '011104005122459', '18768819011', '890105001000242282', 1),
	('D16121658', 'FL1250.', '011104005119786', '18763829200', '890105001000242283', 1),
	('D16121659', 'FL1850.', '011104005122145', '18768816046', '890105001000242284', 1),
	('D16121664', 'FL1850.', '011104000670015', '18763938120', '890105001000242289', 1),
	('D16121683', 'FL1850.', '011104005120123', '18762767282', '890105001000242308', 1),
	('D16121695', 'FL1250.', '011104005114811', '18762768401', '890105001000242320', 1),
	('D16121715', 'FL1850.', '011104005118952', '18762769399', '890105001000242340', 1),
	('D16121716', 'FL1850V2.', '011104000729282', '18764082568', '890105001000242341', 1),
	('D16121720', '', '011104000729274', '18768755723', '890105001000242345', 1),
	('D16121729', 'FL1200.', '011104005119083', '18764785438', '890105001000242354', 1),
	('D16121731', 'FL1250.', '011104000729449', '18765731659', '890105001000242356', 1),
	('D16121733', 'FL1850', '011104000725710', '18762987210', '890105001000242358', 1),
	('D16121744', 'FL1250.', '011104000564762', '18763714660', '890105001000242369', 1),
	('D16121746', 'FL1850V2.', '011104005122434', '18763832523', '890105001000242371', 1),
	('D16121750', '', '011104005120818', '18768755964', '890105001000242375', 1),
	('D16121751', 'FL1850.', '011104005120958', '18763727724', '890105001000242376', 1),
	('D16121753', 'FL1250.', '011104005122129', '18764690315', '890105001000242378', 1),
	('D16121756', 'FL1250.', '011104005121238', '18763814260', '890105001000242381', 1),
	('D17220893', 'FL1250.', '011104005471542', '18764319816', '890105009000291761', 1),
	('D17220928', 'FL1250.', '011104005474975', '18764323047', '890105009000291781', 1),
	('D17220975', 'FL1850.', '011104005133373', '18764218961', '890105009000291802', 1),
	('D17220982', 'FL1850V2.', '011104005261059', '18763991795', '890105009000291808', 1),
	('D17220983', 'FL1850.', '011104005260721', '18762986781', '890105009000291809', 1),
	('D17220998', 'FL1850V2.', '011104005256216', '18764884423', '890105009000291824', 1),
	('D17221002', 'FL1250.', '011104005256604', '18764768343', '890105009000291828', 1),
	('D17221004', 'FL1250.', '011104005256398', '18764893443', '890105009000291830', 1),
	('D17221009', 'FL1250.', '011104005256778', '18764764058', '890105009000291835', 1),
	('D17221014', 'FL1850.', '011104005260945', '18768790699', '890105009000291840', 1),
	('D17221132', 'FL1250.', '357852036006164', '18763714562', '890105009000291857', 1),
	('D17221155', 'FL1850.', '357852036020785', '18764591095', '890105009000291874', 1),
	('D17221156', 'FL1850V2.', '357852036006529', '18764387377', '890105009000291875', 1),
	('D17221172', 'FL1250.', '357852035414864', '18768410522', '890105009000291880', 1),
	('D17221183', 'FL1850V2.', '357852035959082', '18764048294', '890105009000291885', 1),
	('D17221191', 'FL1200.', '357852036020330', '18764075545', '890105009000291889', 1),
	('D17221249', 'FL1250.', '357852036007691', '18762833624', '890105009000291910', 1),
	('D17221281', 'FL1250.', '357852035972432', '18763614179', '890105009000291930', 1),
	('D17221303', 'FL1850V2.', '357852035434847', '18764488214', '890105009000291941', 1),
	('D17221309', 'FL1250.', '357852035414369', '18762986388', '890105009000291944', 1),
	('D17221754', 'FL1850V2.', '011104005435489', '18764690587', '890105009000289857', 1),
	('D17221756', 'FL1250.', '011104005435356', '18764469915', '890105009000289859', 1),
	('D17221761', 'FL1850.', '011104005435414', '18764021994', '890105009000289864', 1),
	('D17221767', 'FL1850.', '011104005435463', '18762816703', '890105009000289870', 1),
	('D17221769', 'FL1850V2.', '011104005435422', '18763614503', '890105009000289872', 1),
	('D17221777', 'FL1850.', '011104005259673', '18763614502', '890105009000289880', 1),
	('D17221788', 'FL1850V2.', '011104005431140', '18763682276', '890105009000289891', 1),
	('D17221792', 'FL1850.', '011104005431082', '18764457210', '890105009000289895', 1),
	('D17221799', 'FL1850.', '011104005430894', '18764469721', '890105009000289902', 1),
	('D17221815', 'FL1250.', '011104005431603', '18762812916', '890105009000289918', 1),
	('D17221819', '', '011104005431686', '18764708108', '890105009000289922', 1),
	('D17221822', 'FL1850.', '011104005431793', '18762812208', '890105009000289925', 1),
	('D17221831', 'FL1250.', '011104005431538', '18764458214', '890105009000289934', 1),
	('D17221848', 'FL1850V2.', '357852036018631', '18765831446', '890105009000289751', 1),
	('D17221849', '', '357852036011214', '18763613527', '890105009000289752', 1),
	('D17221855', 'FL1200.', '357852036013749', '18764225274', '890105009000289758', 1),
	('D17221859', 'FL1850.', '357852036020835', '18762994487', '890105009000289762', 1),
	('D17221883', 'FL1250.', '357852035969206', '18764224791', '890105009000289786', 1),
	('D17221885', 'FL1200.', '357852035968117', '18768689193', '890105009000289788', 1),
	('D17221892', 'FL1250.', '357852035968141', '18764103654', '890105009000289795', 1),
	('D17221894', 'FL1850.', '357852035969214', '18762986165', '890105009000289797', 1),
	('D17221897', 'FL1850V2.', '011104005256505', '18763614440', '890105009000289800', 1),
	('D17221902', 'FL1850V2.', '011104005256638', '18764456025', '890105009000289805', 1),
	('D17221917', 'FL1250.', '011104005256224', '18762814937', '890105009000289820', 1),
	('D17221920', 'FL1850.', '011104005255259', '18763614687', '890105009000289823', 1),
	('D17221939', 'FL1850.', '011104005254922', '18763614916', '890105009000289842', 1),
	('D17221947', 'FL1850V2.', '357852035433252', '18764324574', '890105009000289950', 1),
	('D17221948', 'FL1850.', '357852035409740', '18764328947', '890105009000289951', 1),
	('D17221961', 'FL1850.', '357852035412645', '18764465675', '890105009000289964', 1),
	('D17221967', 'FL1250.', '357852035409724', '18764708047', '890105009000289970', 1),
	('D17221974', 'FL1250.', '357852035958514', '18762754196', '890105009000289977', 1),
	('D17221978', 'FL1250.', '357852035409088', '18764334324', '890105009000289981', 1),
	('D17221982', 'FL1850.', '357852035409096', '18764328678', '890105009000289985', 1),
	('D17221987', 'FL1850V2.', '357852035992281', '18764065658', '890105009000289990', 1),
	('D17221991', 'FL1850.', '357852036013079', '18764222767', '890105009000289994', 1),
	('D17221994', 'FL1850.', '357852035409161', '18765090925', '890105009000289997', 1),
	('D17221995', '', '357852035433195', '18764219463', '890105009000289998', 1),
	('D17222001', 'FL1850.', '357852035414898', '18768673621', '890105009000290004', 1),
	('D17222013', 'FL1850.', '357852036006859', '18763613975', '890105009000290014', 1),
	('D17222015', '', '357852036024365', '18764354747', '890105009000290015', 1),
	('D17222019', 'FL1850.', '357852036006115', '18762997267', '890105009000290018', 1),
	('D17222021', 'FL1850.', '357852036007683', '18764867876', '890105009000290020', 1),
	('D17222023', 'FL1250.', '357852036006503', '18762985240', '890105009000290021', 1),
	('D17222025', 'FL1250.', '357852036006917', '18764149344', '890105009000290022', 1),
	('D17222030', 'FL1200.', '357852036007360', '18764675511', '890105009000290025', 1),
	('D17222038', 'FL1850.', '357852035958530', '18764052180', '890105009000290029', 1),
	('D17222040', 'FL1250.', '357852036010976', '18762830658', '890105009000290030', 1),
	('D17222056', 'FL1850.', '357852036006081', '18764048760', '890105009000290036', 1),
	('D17222069', 'FL1250.', '357852036006594', '18762950498', '890105009000290043', 1),
	('D17222072', '', '357852035993834', '18764781945', '890105009000290045', 1),
	('D17222075', 'FL1850V2.', '357852035998783', '18764252866', '890105009000290046', 1),
	('D17222085', 'FL1200.', '357852036021502', '18763660057', '890105009000290052', 1),
	('D17222091', 'FL1850.', '357852035974131', '18764074708', '890105009000290056', 1),
	('D17222116', 'FL1850V2.', '357852035973133', '18765796227', '890105009000290071', 1),
	('D17222140', 'FL1850.', '357852035998866', '18768928317', '890105009000290081', 1),
	('D17222146', 'FL1850.', '357852035998718', '18764653295', '890105009000290086', 1),
	('D17222147', 'FL1850V2.', '357852036020744', '18762827572', '890105009000290087', 1),
	('D17222158', 'FL1850V2.', '357852035990087', '18763612112', '890105009000290098', 1),
	('D17222196', 'FL1250.', '011104005256679', '18763612725', '890105009000290120', 1),
	('D17222198', 'FL1200.', '011104005256984', '18763698336', '890105009000290121', 1),
	('D17222200', 'FL1850V2.', '011104005258238', '18763613461', '890105009000290122', 1),
	('D17222209', '', '011104005256497', '18764690973', '890105009000290127', 1),
	('D17239190', 'FL1250.', '357852036006800', '18763710978', '890105009000286651', 1),
	('D17239192', 'FL1850.', '357852035417099', '18764329195', '890105009000286653', 1),
	('D17239196', '', '357852035414583', '18764337382', '890105009000286657', 1),
	('D17239200', '', '357852035414559', '18764222307', '890105009000286661', 1),
	('D17239208', 'FL1850V2.', '357852035973885', '18763710787', '890105009000286669', 1),
	('D17239215', 'FL1850V2.', '357852035417008', '18764336797', '890105009000286676', 1),
	('D17239220', 'FL1850.', '357852035982209', '18764122455', '890105009000286681', 1),
	('D17239230', 'FL1250.', '357852035417115', '18764897283', '890105009000286691', 1),
	('D17239233', 'FL1850.', '357852035968075', '18763711584', '890105009000286694', 1),
	('D17239249', 'FL1250.', '357852035432858', '18764080577', '890105009000286710', 1),
	('D17239257', 'FL1850.', '357852035410896', '18764479680', '890105009000286718', 1),
	('D17239287', 'FL1850.', '357852035433260', '18764149680', '890105009000286748', 1),
	('D17239307', 'FL1850.', '357852035410938', '18764024410', '890105009000286568', 1),
	('D17239316', 'FL1850V2.', '357852035433757', '18762834684', '890105009000286577', 1),
	('D17239319', '', '357852035433765', '18768492050', '890105009000286580', 1),
	('D17809526', 'FL1250.', '358696044592643', '18764393997', '890105003000327753', 1),
	('D17809540', 'FL1250.', '358696044581760', '18764288467', '890105003000327764', 1),
	('D17809548', 'FL1250.', '358696044562489', '18762864728', '890105003000327771', 1),
	('D17809549', 'FL1250.', '358696044531914', '18764691214', '890105003000327772', 1),
	('D17809556', 'FL1250.', '358696044581752', '18765645246', '890105003000327779', 1),
	('D17809559', '', '358696044621756', '18764021068', '890105003000327781', 1),
	('D17809570', '', '358696044593393', '18763826432', '890105003000327788', 1),
	('D17809573', '', '358696044593468', '18764363163', '890105003000327791', 1),
	('D17809574', 'FL1200.', '358696044593476', '18764424140', '890105003000327792', 1),
	('D17809576', '', '358696044586413', '18763814289', '890105003000327794', 1),
	('D17809602', 'FL1850.', '358696044622119', '18764280411', '890105003000327802', 1),
	('D17809619', 'FL1850.', '358696044580010', '18765641769', '890105003000327819', 1),
	('D17809621', '', '358696044579434', '18763615722', '890105003000327821', 1),
	('D17809636', 'FL1250.', '358696044585167', '18764304359', '890105003000327836', 1),
	('D17809637', 'FL1850.', '358696044592684', '18764284409', '890105003000327837', 1),
	('D17809647', 'FL1850.', '358696044592668', '18764020903', '890105003000327847', 1),
	('D17809649', 'FL1850.', '358696044580986', '18762798108', '890105003000327849', 1),
	('D17835397', 'FL1250.', '358696044577776', '18764520851', '890105004000343160', 1),
	('D17835407', 'FL1250.', '358696044621798', '18763596131', '890105004000343170', 1),
	('D17835409', 'FL1850V2.', '358696044599838', '18764468100', '890105004000343172', 1),
	('D17835411', 'FL1850V2.', '358696044599762', '18765773518', '890105004000343174', 1),
	('D17835437', 'FL1850.', '358696044577859', '18765645223', '890105004000343185', 1),
	('D17835502', 'FL1250.', '358696044582297', '18762985564', '890105004000343212', 1),
	('D17835521', 'FL1850V2.', '358696044599655', '18762956342', '890105004000343231', 1),
	('D17835533', 'FL1850V2.', '358696044591793', '18764211667', '890105004000343243', 1),
	('D17835571', '', '358696044594037', '18768780172', '890105004000343251', 1),
	('D17835713', 'FL1850.', '358696044580150', '18763824691', '890105004000343367', 1),
	('D17835715', 'FL1850.', '358696044580127', '18765647857', '890105004000343369', 1),
	('D17835725', 'FL1250.', '358696044599770', '18764364935', '890105004000343379', 1),
	('D17835727', 'FL1850V2.', '358696044599804', '18764172028', '890105004000343381', 1),
	('D17835735', '', '358696044576067', '18764403879', '890105004000343389', 1),
	('D17835737', 'FL1850.', '358696044579731', '18765778906', '890105004000343391', 1),
	('D17835739', 'FL1250.', '358696044586652', '18764528819', '890105004000343392', 1),
	('D17835744', 'FL1250.', '358696044593757', '18768780614', '890105004000343394', 1),
	('D17835755', 'FL1850.', '358696044582206', '18763712671', '890105004000343397', 1),
	('D17835762', '', '358696044591611', '18764693059', '890105004000343400', 1),
	('D17835788', 'FL1850.', '358696044579202', '18764708226', '890105004000343418', 1),
	('D17835790', 'FL1850.', '358696044600099', '18765090332', '890105004000343420', 1),
	('D17835797', 'FL1250.', '358696044598822', '18763824154', '890105004000343427', 1),
	('D17835803', 'FL1850.', '358696044582891', '18765641517', '890105004000343433', 1),
	('D17835809', 'FL1850V2.', '358696044586397', '18768816848', '890105004000343437', 1),
	('D17837402', 'FL1850.', '358696044575929', '18768780160', '890105004000344257', 1),
	('D17837425', 'FL1250.', '358696044587932', '18764292245', '890105004000344268', 1),
	('D17837430', 'FL1250.', '358696044591561', '18762857515', '890105004000344271', 1),
	('D17837435', 'FL1250.', '358696044576695', '18768780408', '890105004000344276', 1),
	('D17837437', 'FL1200.', '357852035973844', '18764394607', '890105004000344278', 1),
	('D17837452', 'FL1250.', '358696044586660', '18762867219', '890105004000344291', 1),
	('D17837457', 'FL1250.', '358696044579590', '18764691924', '890105004000344293', 1),
	('D17837465', 'FL1250.', '358696044579608', '18765642478', '890105004000344296', 1),
	('D17837468', 'FL1250.', '358696044581240', '18768780433', '890105004000344298', 1),
	('D17837496', 'FL1850.', '358696044591512', '18763811283', '890105004000344308', 1),
	('D17837499', 'FL1250.', '358696044592007', '18764468413', '890105004000344309', 1),
	('D17837519', 'FL1250.', '358696044591942', '18768816857', '890105004000344317', 1),
	('D17837539', 'FL1850V2.', '358696044586496', '18764692691', '890105004000344326', 1),
	('D17837543', '', '358696044587890', '18765642709', '890105004000344330', 1),
	('D17837547', 'FL1250.', '358696044576059', '18765646823', '890105004000344334', 1),
	('D17837549', 'FL1250.', '358696044580028', '18764480571', '890105004000344336', 1),
	('D17837553', 'FL1250.', '358696044621343', '18768489386', '890105004000344340', 1),
	('D17837554', 'FL1850V2.', '358696044587064', '18764308912', '890105004000344341', 1),
	('D17837555', 'FL1250.', '358696044587056', '18764370936', '890105004000344342', 1),
	('D17837601', 'FL1200.', '358696044575960', '18763622393', '890105004000344363', 1),
	('D17837605', 'FL1250.', '358696044582883', '18764435738', '890105004000344365', 1),
	('D17837607', '', '358696044576968', '18762986612', '890105004000344366', 1),
	('D17837609', 'FL1850.', '357852036001637', '18764292333', '890105004000344367', 1),
	('D17837626', 'FL1850.', '358696044585118', '18764394489', '890105004000344374', 1),
	('D17837638', 'FL1250.', '358696044579905', '18765773521', '890105004000344380', 1),
	('D17837640', 'FL1250.', '358696044579814', '18764194152', '890105004000344382', 1),
	('D17837647', 'FL1250.', '358696044599564', '18763828153', '890105004000344389', 1),
	('D17837685', 'FL1250.', '358696044575994', '18763833156', '890105004000344415', 1),
	('D17837693', 'FL1250.', '358696044579335', '18762985894', '890105004000344420', 1),
	('D17837697', 'FL1850V2.', '358696044579194', '18765773545', '890105004000344422', 1),
	('D17837706', 'FL1250.', '358696044526005', '18764507103', '890105004000344427', 1),
	('D17837724', 'FL1850V2.', '358696044508300', '18762985769', '890105004000344434', 1),
	('D17837738', 'FL1200.', '358696044556846', '18762864360', '890105004000344440', 1),
	('D17837761', 'FL1850V2.', '358696044582289', '18764634113', '890105004000344448', 1),
	('D17837764', 'FL1250.', '358696044582255', '18765647746', '890105004000344451', 1),
	('D17943915', 'FL1250.', '011104005624900', '18765645376', '890105005000349762', 1),
	('D17943920 ', 'FL1250.', '011104005625063', '18762909718', '890105005000349767', 1),
	('D17943926 ', 'FL1250.', '011104005625022', '18765798445', '890105005000349773', 1),
	('D17943936 ', 'FL1250.', '011104005623084', '18762896739', '890105005000349783', 1),
	('D17943945 ', 'FL1250.', '011104005623472', '18762909685', '890105005000349792', 1),
	('D17943947 ', 'FL1850.', '011104005638777', '18764038483', '890105005000349794', 1),
	('D18503596', 'FL1850.', '351802057713020', '18764616032', '890105007000375506', 1),
	('D18503605', 'FL1250.', '351802057708657', '18762806204', '890105007000375515', 1),
	('D18503609', 'FL1200.', '351802057680864', '18762985168', '890105007000375519', 1),
	('D18503625', 'FL1850.', '353301050251664', '18762986995', '890105007000375535', 1),
	('D18504252', 'FL1850V2.', '353301050274096', '18764613554', '890105007000376162', 1),
	('D18504254', 'FL1250.', '353301050286330', '18764691033', '890105007000376164', 1),
	('D18504274', '', '353301050285050', '18763829564', '890105007000376184', 1),
	('D18504586', 'FL1250.', '011104005256323', '18762816397', '890105007000376496', 1),
	('D18595017 ', '', '351802057680930', '18765722795', '890105002000398487', 1),
	('D18595024 ', 'FL1850.', '351802057699070', '18764854714', '890105002000398494', 1),
	('D18595034 ', '', '351802057674859', '18768534352', '890105002000398504', 1),
	('D18595971', 'FL1250.', '353301055492412', '18765893256', '890105007000377433', 1),
	('D18596033 ', '', '353301054314013', '18764379774', '890105007000377495', 1),
	('D18596037 ', 'FL1250.', '353301054325530', '18764635347', '890105007000377499', 1),
	('D18680349', 'FL1850V2.', '353301058212130', '18765090863 ', '890105002000399178', 1),
	('D18680366', '', '353301058202388', '18765090450', '890105002000399195', 1),
	('D18680371', 'FL1250.', '353301058203824', '18764404503', '890105002000399200', 1),
	('D18680375', 'FL1250.', '353301058204160', ' 18762785804', '890105002000399204', 1),
	('D18680382', '', '353301058203808', ' 18765090445', '890105002000399211', 1),
	('D18680387', 'FL1850.', '353301054325597', '18762826024', '890105002000399216', 1),
	('D18680411', 'FL1850V2.', '353301054313890', '18764410302', '890105002000399240', 1),
	('D18680424', 'FL1850V3.', '353301054313817', '18764737616', '890105002000399253', 1),
	('D18680433', 'FL1850V3.', '353301054311886', '18764413392', '890105002000399262', 1),
	('D18680440', 'FL1250.', '353301058321113', '18763671869', '890105002000399269', 1),
	('D18680452', 'FL1850V2.', '353301058200572', '18764027974', '890105002000399281', 1),
	('D18680476', 'FL1250.', '353301054262709', ' 18762791984', '890105002000399305', 1),
	('D18680483', '', '353301058204475', ' 18762792331', '890105002000399312', 1),
	('D18683159', 'FL1250.', '355233052759246', '18764361425', '890105002000401988', 1),
	('D18683200', '', '355233052759105', '18768781205', '890105002000402029', 1),
	('D18683201', '', '355233052748975', '18768775326', '890105002000402030', 1),
	('D18683213', '', '355233052746920', '18768781225', '890105002000402042', 1),
	('D18683277', 'FL1850V3.', '355233050925369', '18763792683', '890105002000402106', 1),
	('D18683279', 'FL1850V3.', '355233050891066', '18768781214', '890105002000402108', 1),
	('D18683286', 'FL1250.', '355233052758263', '18764292558', '890105002000402115', 1),
	('D18683291', 'FL1250.', '355233052758313', '18765773692', '890105002000402120', 1),
	('D18683314', 'FL1250.', '355233052714068', '18768780132', '890105002000402143', 1),
	('D18683317', 'FL1250.', '355233052758230', '18763989272', '890105002000402146', 1),
	('D18683321', 'FL1250', '355233054152606', '18764023391', '890105002000402150', 1),
	('D18683339', 'FL1850V3', '355233050925724', '18768781220', '890105002000402168', 1),
	('D18683349', 'FL1850V3.', '355233050890308', '18762959695', '890105002000402178', 1),
	('D18683383', 'FL1850V3.', '355233050924271', '18764302068', '890105002000402212', 1),
	('D18683394', 'FL1250.', '355233052747209', '18768781163', '890105002000402223', 1),
	('D18683408', '', '355233052741137', '18768781139', '890105002000402237', 1),
	('D18683416', '', '355233052707856', '18768781147', '890105002000402246', 1),
	('D18683853', 'FL1850V3', '355233054076912', '18763835975', '890105002000402682', 1),
	('D18683874', 'FL1850V3', '355233050923836', '18762760770', '890105002000402703', 1),
	('D18683935', 'FL1250', '355233052748454', '18763888793', '890105002000402764', 1),
	('D18683947', 'FL1850V3.', '355233050924263', '18764546842', '890105002000402776', 1),
	('D18683959', 'FL1250', '355233052714910', '18762868950', '890105002000402788', 1),
	('D18683963', 'FL1250', '355233052748405', '18762908064', '890105002000402792', 1),
	('D18683980', 'FL1250', '355233052760905', '18762764807', '890105002000402809', 1),
	('D18683993', 'FL1850V3', '355233054124001', '18762767706', '890105002000402822', 1),
	('D18684008', 'FL1850V3', '355233054131535', '18762843190', '890105002000402837', 1),
	('D18684014', 'FL1850V3', '355233054124043', '18764705450', '890105002000402843', 1),
	('D18684016', 'FL1850V3', '355233054076540', '18764136954', '890105002000402845', 1),
	('D18684018', 'FL1850V3', '355233054129513', '18764384364', '890105002000402847', 1),
	('D18684019', 'FL1850V3', '355233054128309', '18763526018', '890105002000402848', 1),
	('D18684187', 'FL1250', '355233052714399', '18764524654', '890105002000403016', 1),
	('D18684208', 'FL1250', '355233054157803', '18763739332', '890105002000403037', 1),
	('D18684221', 'FL1250', '355233054157050', '18764525139', '890105002000403050', 1),
	('D18684565', 'FL1850V3', '355233054125131', '18765643008', '890105005000403400', 1),
	('D18684570', 'FL1850V3', '355233054128366', '18762759065', '890105005000403405', 1),
	('D18684586', 'FL1850V3', '355233054131345', '18764540908', '890105005000403420', 1),
	('D18684641', 'FL1250', '355233054157357', '18764050450', '890105005000403475', 1),
	('D18684651', 'FL1250', '355233054146574', '18763739114', '890105005000403485', 1),
	('D18684657', 'FL1250', '355233054146525', '18763640809', '890105005000403491', 1),
	('D18899159', 'FL1250.', '355233053464366', '18762911030', '890105005000404586', 1),
	('D18899164', 'FL1250.', '355233053466429', '18763986035', '890105005000404591', 1),
	('D18899170', 'FL1250.', '355233053467237', '18764488014', '890105005000404597', 1),
	('D18899178', 'FL1250.', '355233053466742', '18762950493', '890105005000404605', 1),
	('D18899187', 'FL1250.', '355233053464358', '18762932080', '890105005000404614', 1),
	('D18899200', 'FL1250.', '355233053529614', '18765643832', '890105005000404621', 1),
	('D18899220', 'FL1250.', '355233053464556', '18765644904', '890105005000404632', 1),
	('D18899225', 'FL1250.', '355233053527188', '18762950140', '890105005000404635', 1),
	('D18899242', 'FL1250.', '355233053527196', '18762986672', '890105005000404645', 1),
	('D18899246', 'FL1250.', '355233053511869', '18765641546', '890105005000404647', 1),
	('D18899261', 'FL1250.', '355233053467906', '18764320636', '890105005000404654', 1),
	('D18899263', 'FL1250.', '355233053467955', '18764413072', '890105005000404655', 1),
	('D18899363', 'FL1250.', '355233053467021', '18764487479', '890105005000404700', 1),
	('D18899399', 'FL1250.', '355233053511729', '18764012439', '890105005000404719', 1),
	('D18899480', 'FL1850V3.', '355233050924040', '18763689415', '890105005000404747', 1),
	('D18900883', 'FL1250', '357207055746697', '18763836744', '890105005000405021', 1),
	('D18900889', 'FL1250', '357207055737423', '18764690420', '890105005000405027', 1),
	('D18900928', 'FL1250', '357207055746531', '18768817244', '890105005000405066', 1),
	('D18997155', 'FL1850', '355233054126451', '18763711247', '890105011000417156', 1),
	('D18997159', 'FL1850', '355233054127525', '18764477252', '890105011000417160', 1),
	('D18997174', 'FL1250', '355233054147424', '18764174430', '890105011000417175', 1),
	('D18997177', 'FL1250', '355233054156672', '18763612676', '890105011000417178', 1),
	('D18997206', 'FL1250', '355233054147648', '18763825248', '890105011000416909', 1),
	('D18997218', 'FL1250', '355233054146657', '18764855549', '890105011000416921', 1),
	('D18997219', 'FL1250', '355233054148620', '18764276561', '890105011000416922', 1),
	('D18997222', 'FL1250', '355233054154768', '18764865998', '890105011000416925', 1),
	('D18997223', 'FL1250', '355233054157761', '18764279011', '890105011000416926', 1),
	('D18997225', 'FL1850', '355233054126543', '18762470468', '890105011000416928', 1),
	('D18997257', 'FL1850', '355233054126535', '18764298798', '890105011000416960', 1),
	('D18997260', 'FL1850', '355233054124019', '18762799105', '890105011000416963', 1),
	('D18997299', 'FL1250', '355233054157787', '18764357276', '890105011000417002', 1),
	('D18997310', 'FL1850', '355233050923802', '18762470481', '890105011000417013', 1),
	('D18997331', 'FL1250', '355233054147457', '18764372169', '890105011000417034', 1),
	('D18997333', 'FL1250', '355233054154875', '18764277696', '890105011000417036', 1),
	('D18997344', 'FL1250', '355233054154818', '18764279384', '890105011000417047', 1),
	('D18997377', 'FL1250', '355233053511828', '18764279316', '890105011000417080', 1),
	('D18997384', 'FL1250', '355233054146558', '18763814129', '890105011000417087', 1),
	('D18997386', 'FL1250', '355233054148646', '18764293160', '890105011000417089', 1),
	('D18997395', 'FL1850', '355233054124530', '18768781014', '890105011000417098', 1),
	('D18997402', 'FL1850', '355233054126493', '18765773066', '890105011000417105', 1),
	('D18997408', 'FL1850', '355233054130040', '18763825979', '890105011000417111', 1),
	('D18997418', 'FL1850', '355233054126477', '18762470482', '890105011000417121', 1),
	('D18997433', 'FL1850', '355233054127426', '18763612622', '890105011000417136', 1),
	('D19034796', 'FL250', '357207057440646', '18763671719', '890105011000417789', 1),
	('D19034862', 'Fl1250', '357207057544900', '18765797085', '890105011000417804', 1),
	('D19034867', 'FL1250', '357207057438848', '18768782669', '890105011000417809', 1),
	('D19034882', 'FL1250', '357207057440331', '18765798839', '890105011000417812', 1),
	('D19034884', 'FL1250', '357207057440604', '18768784239', '890105011000417813', 1),
	('D19034963', 'FL1250', '357207057544447', '18765641989', '890105011000417827', 1),
	('D19034988', 'FL1850', '357207056421357', '18765799130', '890105011000417836', 1),
	('D19035061', 'FL1850', '357207055746762', '18765779150', '890105011000417840', 1),
	('D19035125', 'FL1850', '355233054110117', '18765797192', '890105011000417843', 1),
	('D19035197', 'FL1250', '357207055736763', '18765778992', '890105011000417881', 1),
	('D19035395', 'FL1850', '357207056421316', '18765644957', '890105011000417895', 1),
	('D19035491', 'FL1250', '357207057440497', '18765798516', '890105011000417918', 1),
	('D19035517', 'FL1250', '357207057637712', '18765798945', '890105011000417925', 1),
	('D19035521', 'FL1250', '357207057437402', '18765645266', '890105011000417929', 1),
	('D19035523', 'FL1250', '357207057543613', '18765797614', '890105011000417931', 1),
	('D19035525', 'FL1250', '357207057594582', '18765797564', '890105011000417933', 1),
	('D19035577', 'FL1250', '357207057543605', '18763575643', '890105011000417983', 1),
	('D19039162', 'FL1850', '357207056407547', '18764198436', '890105011000421503', 1),
	('D19039167', 'FL1850', '357207056431265', '18764205332', '890105011000421508', 1),
	('D19039170', 'FL1850', '357207056407885', '18763748363', '890105011000421511', 1),
	('D19039176', 'FL1850', '357207056407281', '18762875645', '890105011000421517', 1),
	('D19039208', 'FL1850', '357207056421407', '18765640825', '890105011000421530', 1),
	('D19039211', 'FL1850', '355233054111990', '18765641260', '890105011000421532', 1),
	('D19039332', 'FL1850', '355233050924115', '18768815609', '890105011000421571', 1),
	('D19039400', 'FL1850', '355233050924560', '18765773190', '890105011000421588', 1),
	('D19039408', 'FL1250', '357207057637266', '18765795523', '890105011000421589', 1),
	('D19039412', 'FL1250', '357207057440547', '18762776206', '890105011000421593', 1),
	('D19039414', 'FL1250', '357207057456170', '18768784226', '890105011000421595', 1),
	('D19039420', 'FL1250', '357207057546145', '18765796283', '890105011000421601', 1),
	('D19039438', 'FL1250', '357207057544967', '18765796236', '890105011000421617', 1),
	('D19039442', 'FL1250', '357207057546137', '18765798891', '890105011000421621', 1),
	('D19039465', 'FL1250', '357207057440679', '18768784336', '890105011000421636', 1),
	('D19039505', 'FL1850', '355233050925096', '18768816952', '890105011000421641', 1),
	('D19039520', 'FL1850', '355233050924446', '18764690939', '890105011000421648', 1),
	('D19039535', 'FL1850', '355233054111925', '18765799172', '890105011000421663', 1),
	('D19039543', 'FL1850', '355233050924503', '18768815591', '890105011000421671', 1),
	('D19039545', 'FL1850', '355233050924529', '18763925739', '890105011000421673', 1),
	('D19039552', 'FL1250', '357207055745137', '18765798660', '890105011000421675', 1),
	('D19039555', 'fl1250', '357207055737308', '18765640457', '890105011000421677', 1),
	('D19039557', 'FL1250', '357207055746218', '18765799143', '890105011000421678', 1),
	('D19039559', 'FL1250', '357207057636599', '18768782644', '890105011000421679', 1),
	('D19039576', 'FL1250', '357207055737324', '18765799150', '890105011000421685', 1),
	('D19041109', 'FL1250', '357207057544512', '18768976257', '890105011000422242', 1),
	('D19041113', 'FL1250', '357207057436891', '18763591816', '890105011000422244', 1),
	('D19041140', 'FL1850', '355233054119902', '18765799235', '890105011000422262', 1),
	('D19041153', 'FL1250', '357207056407315', '18768782643', '890105011000422272', 1),
	('D19041197', 'FL1850', '355233054111248', '18765798620', '890105011000422285', 1),
	('D19041820', 'Fl1850', '357207056410871', '18765797238', '890105011000424471', 1),
	('D19041825', 'FL1250', '357207057436925', '18765798786', '890105011000424476', 1),
	('D19041829', 'FL1250', '357207056407349', '18765798651', '890105011000424480', 1),
	('D19041833', 'FL1850', '357207056408057', '18764692450', '890105011000424484', 1),
	('D19100599', 'FL1250', '357207055746267', '18762986713', '890105011000427485', 1),
	('D19100754', 'FL1250', '355233054160898', '18764506354', '890105011000427588', 1),
	('D19100765', 'FL1250', '355233054147259', '18768787344', '890105011000427599', 1),
	('D19100773', 'FL1250', '355233054157381', '18762985374', '890105011000427607', 1),
	('D19100778', 'FL1250', '357207056397581', '18764692063', '890105011000427612', 1),
	('D19100802', 'FL1250', '357207055744452', '18763827566', '890105011000427636', 1),
	('D19100803', 'FL1250', '357207055744494', '18763710870', '890105011000427637', 1),
	('D19100823', 'FL1850', '355233054123532', '18763833818', '890105011000427648', 1),
	('D19100838', 'FL1850', '355233054123789', '18764505857', '890105011000427656', 1),
	('D19100845', 'FL1850', '355233054045479', '18768696306', '890105011000427660', 1),
	('D19100850', 'FL1250', '355233054122708', '18763812786', '890105011000427661', 1),
	('D19100860', 'FL1850', '355233054121577', '18764691737', '890105011000427668', 1),
	('D19100879', '', '355233054122658', '18764505536', '890105011000427679', 1),
	('D19100911', 'FL1850', '355233054123797', '18764708297', '890105011000427700', 1),
	('D19100934', 'FL1850', '355233054121619', '18765773048', '890105011000427717', 1),
	('D19100942', '', '355233054121247', '18762942320', '890105011000427724', 1),
	('D19100956', 'FL1250', '355233054123466', '18765773282', '890105011000427734', 1),
	('D19100985', 'FL1250', '357207055712772', '18762934485', '890105011000427745', 1),
	('D19100994', 'FL1250', '357207055747315', '18763814061', '890105011000427750', 1),
	('D19101016', 'FL1250', '357207055744486', '18765773362', '890105011000427761', 1),
	('D19101018', 'FL1250', '357207055744171', '18765773213', '890105011000427762', 1),
	('D19101021', 'FL1250', '357207055747323', '18764090536', '890105011000427763', 1),
	('D19101037', 'FL1250', '357207055747307', '18764010060', '890105011000427772', 1),
	('D19101048', 'FL 1250', '357207056410319', '18763614882', '890105011000427779', 1),
	('D19101051', 'FL1850', '357207055712707', '18763831353', '890105011000427782', 1),
	('D19103171', 'FL1250', '357207057595449', '18765799148', '890105011000429823', 1),
	('D19103184', 'FL1250', '357207057637134', '18762767671', '890105011000429833', 1),
	('D19107952', 'FL1250', '357207057637464', '18768782628', '890105001000433393', 1),
	('D19107956', 'FL1250', '357207057435596', '18768784263', '890105001000433396', 1),
	('D19107960', '1250', '357207057637647', '18765798473', '890105001000433399', 1),
	('D19108059', 'FL1250', '357207057636581', '18765799259', '890105001000433478', 1),
	('D19110369', 'FL1250', '357207057636052', '18765798513', '890105001000439664', 1),
	('D19110418', 'FL1250', '357207057661670', '18768781449', '890105001000439713', 1),
	('D19110422', 'FL1250', '357207057545055', '18765798666', '890105001000439717', 1);
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;


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

-- Dumping data for table bunio_vts.devices_log: 1,113 rows
/*!40000 ALTER TABLE `devices_log` DISABLE KEYS */;
INSERT INTO `devices_log` (`d_number`, `device_version`, `imei`, `msisdn`, `sim_number`, `status`, `user_id`, `machine`, `ip_address`, `action`, `action_type`, `log_date`) VALUES
	('', NULL, '353239002532593', '18765794806', '890105009000176795', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D10453146', NULL, '354725067058952', '18765523960', '890105006000458899', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D10453181', NULL, '354725066916978', '18765523909', '890105006000458934', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D10457855', NULL, '352431061122173', '18765523916', '890105008000497336', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D10461230', NULL, '358683061322963', '18765799412', '890105008000501340', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14283797', NULL, '353239002531173', '18765796465', '890105009000175778', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14283829', NULL, '353239002531231', '18765796523', '890105009000175761', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14283840', NULL, '353239002531140', '18765797367', '890105009000175751', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14283877', NULL, '353239002251913', '18765795456', '890105009000175717', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14283891', NULL, '353239002252408', '18765795109', '890105009000175705', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14283985', NULL, '353239002251418', '18765795366', '890105009000175666', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14284067', NULL, '353239002247374', '18765779094', '890105009000175622', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14284079', NULL, '353239002250246', '18765795023', '890105009000175614', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14284084', NULL, '353239002252507', '18765795365', '890105009000175610', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14286575', NULL, '353239002532494', '18765798814', '890105009000176789', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14286616', NULL, '353239002532361', '18765794606', '890105009000176771', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14286633', NULL, '353239002235098', '18765794972', '890105009000176757', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14286691', NULL, '353239002251137', '18765798016', '890105009000176695', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14286784', NULL, '353239002253232', '18765794916', '890105009000176650', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14286805', NULL, '353239002266671', '18765794503', '890105009000176639', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14286816', NULL, '353239002263678', '18765796751', '890105009000176633', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14286848', NULL, '353239002251251', '18765798952', '890105009000176614', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14286905', NULL, '353239002536388', '18765797629', '890105009000176744', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14286925', NULL, '353239002532213', '18765798845', '890105009000176733', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14286952', NULL, '353239002252010', '18765795176', '890105009000176716', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14969741', NULL, '353239006022476', '18765642657', '890105005000194371', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14969756', NULL, '353239006257551', '18765649905', '890105005000194386', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14969780', NULL, '353239006258120', '18765645907', '890105005000194410', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14969788', NULL, '353239006257353', '18765642133', '890105005000194418', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14969813', NULL, '353239006256546', '18765642773', '890105005000194443', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14969818', NULL, '353239006255654', '18765645239', '890105005000194448', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14969829', NULL, '353239006252586', '18765641775', '890105005000194459', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14969868', NULL, '011104000564390', '18765648236', '890105005000194498', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14969881', NULL, '353239006255035', '18765642068', '890105005000194511', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14969905', NULL, '353239006018425', '18763711597', '890105005000194535', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14969936', NULL, '353239006023763', '18765648683', '890105005000194566', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14969947', NULL, '353239006022245', '18765642343', '890105005000194577', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14969962', NULL, '353239006255068', '18765640598', '890105005000194592', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14969970', NULL, '353239006252875', '18765642389', '890105005000194600', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14969973', NULL, '353239006256009', '18765644015', '890105005000194603', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14969974', NULL, '353239006258831', '18765643243', '890105005000194604', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14969977', NULL, '353239006251497', '18765642029', '890105005000194607', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14970503', NULL, '353239006021635', '18765643621', '890105005000197133', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14970513', NULL, '353239006018524', '18765643009', '890105005000197143', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14970555', NULL, '353239006251893', '18764474650', '890105005000197185', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14970563', NULL, '353239006256439', '18765641035', '890105005000197193', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14970574', NULL, '353239006200031', '18765641135', '890105005000197204', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14970585', NULL, '353239006257411', '18765649904', '890105005000197215', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14970610', NULL, '353239006019662', '18765641612', '890105005000197240', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14970659', NULL, '353239006038118', '18765642185', '890105005000197289', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14970664', NULL, '353239006041211', '18765642414', '890105005000197294', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14970667', NULL, '353239006022740', '18765642078', '890105005000197297', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14970712', NULL, '353239006022732', '18765643094', '890105005000197342', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14970723', NULL, '353239006020686', '18763689957', '890105005000197353', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D14970725', NULL, '353239006020512', '18765643221', '890105005000197355', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15025084', NULL, '011104000565546', '18763826235', '890105006000202729', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15025093', NULL, '011104000564184', '18765646457', '890105006000202738', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15163533', NULL, '011104000561438', '18763830815', '890105006000206114', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15163577', NULL, '011104000570645', '18768819657', '890105006000206158', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15163738', NULL, '011104000561487', '18763612604', '890105006000206319', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15163746', NULL, '011104000561859', '18768782572', '890105006000206327', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15163749', NULL, '011104000566189', '18763814287', '890105006000206330', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15163752', NULL, '011104000565538', '18768697668', '890105006000206333', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15163758', NULL, '011104000562261', '18763836813', '890105006000206339', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15163761', NULL, '011104000565694', '18765773453', '890105006000206342', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15163766', NULL, '011104000566510', '18763660106', '890105006000206347', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15163767', NULL, '011104000566775', '18765641783', '890105006000206348', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15164893', NULL, '011104000565835', '18768819372', '890105006000206723', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15164902', NULL, '011104000565983', '18768819646', '890105006000206732', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15164903', NULL, '011104000560240', '18765644012', '890105006000206733', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15164924', NULL, '011104000558087', '18768775159', '890105006000206754', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15166584', NULL, '011104000561503', '18765642498', '890105006000204665', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15166593', NULL, '011104000561776', '18763823370', '890105006000204674', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15166601', NULL, '011104000570744', '18765649382', '890105006000204682', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15166610', NULL, '011104000566817', '18765645265', '890105006000204691', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15166628', NULL, '011104000562436', '18765644606', '890105006000204709', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15166630', NULL, '011104000562550', '18765644985', '890105006000204711', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15166798', NULL, '011104000564135', '18768819762', '890105006000204879', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15166812', NULL, '011104000566742', '18765090522', '890105006000204893', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15166828', NULL, '011104000563665', '18765649720', '890105006000204909', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15166941', NULL, '011104000564150', '18763835388', '890105006000205022', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15166951', NULL, '011104000561750', '18765645201', '890105006000205032', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15166953', NULL, '353239006021239', '18763835396', '890105006000205034', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15166959', NULL, '353239006021502', '18763835094', '890105006000205040', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15166970', NULL, '011104000564499', '18768819762', '890105006000205051', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15166973', NULL, '011104000564523', '18763825167', '890105006000205054', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15166974', NULL, '011104000564093', '18765647391', '890105006000205055', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15166991', NULL, '011104000563806', '18765778853', '890105006000205072', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15166994', NULL, '011104000563780', '18765794572', '890105006000205075', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15166998', NULL, '011104000570165', '18765649683', '890105006000205079', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15375826', NULL, '353239006018953', '18765644818', '890105001000210812', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15469731', NULL, '011104005121212', '18765643048', '890105001000215349', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15469743', NULL, '011104005431249', '18764411072', '890105001000215361', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15470300', NULL, '011104000562378', '18768697317', '890105001000214418', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15470302', NULL, '011104000562485', '18768696088', '890105001000214420', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15470323', NULL, '011104000562170', '18765644567', '890105001000214441', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15470328', NULL, '011104000565801', '18763826366', '890105001000214446', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15470339', NULL, '011104000563889', '18763834951', '890105001000214458', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15470477', NULL, '011104000566528', '18763825024', '890105001000214595', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15470480', NULL, '011104000546488', '18765649817', '890105001000214598', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15470492', NULL, '011104000565561', '18764692193', '890105001000214610', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D15470494', NULL, '011104000565371', '18763835918', '890105001000214612', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087173', NULL, '011104000729332', '18765611283', '890105001000237398', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087179', NULL, '011104000729324', '18765780534', '890105001000237403', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087182', NULL, '011104005119125', '18763826507', '890105001000237405', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087184', NULL, '011104005119075', '18765624893', '890105001000237407', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087199', NULL, '011104000732708', '18764665435', '890105001000237415', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087208', NULL, '011104000731031', '18762769661', '890105001000237421', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087212', NULL, '011104000731023', '18765781015', '890105001000237424', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087214', NULL, '011104000732815', '18765781011', '890105001000237426', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087220', NULL, '011104000731064', '18765781014', '890105001000237431', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087223', NULL, '011104000729357', '217', '890105001000237433', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087225', NULL, '011104005131567', '18763811727', '890105001000237435', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087235', NULL, '011104005122491', '18762986605', '890105001000237442', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087246', NULL, '011104005114746', '18765781016', '890105001000237447', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087251', NULL, '011104005131583', '18765620578', '890105001000237451', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087263', NULL, '011104005131666', '18765781013', '890105001000237460', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087265', NULL, '011104000732781', '18764815731', '890105001000237462', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087268', NULL, '011104005131658', '18764401690', '890105001000237464', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087277', NULL, '011104005122327', '18763811048', '890105001000237472', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087287', NULL, '011104005122558', '18768817636', '890105001000237480', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087292', NULL, '011104005121105', '18762766748', '890105001000237484', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087296', NULL, '011104000669801', '18763829626', '890105001000237487', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087327', NULL, '011104000669819', '18762826533', '890105001000237509', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087332', NULL, '011104005120842', '18762769432', '890105001000237513', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087336', NULL, '011104005114555', '18762767195', '890105001000237516', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087337', NULL, '011104005114589', '18763830677', '890105001000237517', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087343', NULL, '011104005127714', '18762769424', '890105001000237523', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087347', NULL, '011104005121345', '18762767185', '890105001000237526', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087380', NULL, '011104000660834', '18762765902', '890105001000237550', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087407', NULL, '357852035973877', '18762985584', '890105001000237569', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087417', NULL, '011104005114373', '18762930982', '890105001000237576', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087421', NULL, '011104005114308', '18762823399', '890105001000237579', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087430', NULL, '011104005120784', '18763614340', '890105001000237585', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087483', NULL, '011104000740842', '18765648869', '890105001000237621', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087496', NULL, '011104005130445', '18762769357', '890105001000237631', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087499', NULL, '011104000669777', '18765779772', '890105001000237633', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16087505', NULL, '011104000670023', '18762985988', '890105001000237636', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121513', NULL, '011104005117525', '18762767728', '890105001000242138', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121527', NULL, '011104005117905', '18764635151', '890105001000242152', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121540', NULL, '011104005117640', '18764692637', '890105001000242165', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121543', NULL, '011104005129892', '18762766465', '890105001000242168', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121550', NULL, '011104005129835', '18763725377', '890105001000242175', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121555', NULL, '011104005117756', '18763728718', '890105001000242180', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121558', NULL, '011104005129686', '18764406768', '890105001000242183', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121559', NULL, '011104005129827', '18762767109', '890105001000242184', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121570', NULL, '011104005120453', '18762827445', '890105001000242195', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121583', NULL, '011104005127656', '18768755958', '890105001000242208', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121584', NULL, '011104005127623', '18764514012', '890105001000242209', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121585', NULL, '011104005127482', '18762823820', '890105001000242210', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121587', NULL, '011104005114662', '18762797451', '890105001000242212', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121590', NULL, '011104005114779', '18764690053', '890105001000242215', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121595', NULL, '011104005114654', '18764454182', '890105001000242220', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121600', NULL, '011104005114639', '18762986513', '890105001000242225', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121615', NULL, '011104005118697', '18763832099', '890105001000242240', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121629', NULL, '011104005118630', '18762883754', '890105001000242254', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121636', NULL, '011104005120024', '18768816769', '890105001000242261', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121638', NULL, '011104005122418', '18762997007', '890105001000242263', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121642', NULL, '011104005119687', '18764521640', '890105001000242267', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121650', NULL, '011104005120040', '18762768780', '890105001000242275', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121652', NULL, '011104005119810', '18768754798', '890105001000242277', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121657', NULL, '011104005122459', '18768819011', '890105001000242282', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121658', NULL, '011104005119786', '18763829200', '890105001000242283', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121659', NULL, '011104005122145', '18768816046', '890105001000242284', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121664', NULL, '011104000670015', '18763938120', '890105001000242289', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121683', NULL, '011104005120123', '18762767282', '890105001000242308', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121695', NULL, '011104005114811', '18762768401', '890105001000242320', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121715', NULL, '011104005118952', '18762769399', '890105001000242340', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121716', NULL, '011104000729282', '18764082568', '890105001000242341', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121720', NULL, '011104000729274', '18768755723', '890105001000242345', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121729', NULL, '011104005119083', '18764785438', '890105001000242354', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121731', NULL, '011104000729449', '18765731659', '890105001000242356', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121733', NULL, '011104000725710', '18762987210', '890105001000242358', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121744', NULL, '011104000564762', '18763714660', '890105001000242369', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121746', NULL, '011104005122434', '18763832523', '890105001000242371', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121750', NULL, '011104005120818', '18768755964', '890105001000242375', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121751', NULL, '011104005120958', '18763727724', '890105001000242376', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121753', NULL, '011104005122129', '18764690315', '890105001000242378', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D16121756', NULL, '011104005121238', '18763814260', '890105001000242381', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17220893', NULL, '011104005471542', '18764319816', '890105009000291761', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17220928', NULL, '011104005474975', '18764323047', '890105009000291781', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17220975', NULL, '011104005133373', '18764218961', '890105009000291802', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17220982', NULL, '011104005261059', '18763991795', '890105009000291808', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17220983', NULL, '011104005260721', '18762986781', '890105009000291809', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17220998', NULL, '011104005256216', '18764884423', '890105009000291824', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221002', NULL, '011104005256604', '18764768343', '890105009000291828', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221009', NULL, '011104005256778', '18764764058', '890105009000291835', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221014', NULL, '011104005260945', '18768790699', '890105009000291840', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221132', NULL, '357852036006164', '18763714562', '890105009000291857', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221155', NULL, '357852036020785', '18764591095', '890105009000291874', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221156', NULL, '357852036006529', '18764387377', '890105009000291875', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221172', NULL, '357852035414864', '18768410522', '890105009000291880', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221183', NULL, '357852035959082', '18764048294', '890105009000291885', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221191', NULL, '357852036020330', '18764075545', '890105009000291889', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221249', NULL, '357852036007691', '18762833624', '890105009000291910', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221281', NULL, '357852035972432', '18763614179', '890105009000291930', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221303', NULL, '357852035434847', '18764488214', '890105009000291941', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221309', NULL, '357852035414369', '18762986388', '890105009000291944', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221754', NULL, '011104005435489', '18764690587', '890105009000289857', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221756', NULL, '011104005435356', '18764469915', '890105009000289859', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221761', NULL, '011104005435414', '18764021994', '890105009000289864', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221767', NULL, '011104005435463', '18762816703', '890105009000289870', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221769', NULL, '011104005435422', '18763614503', '890105009000289872', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221777', NULL, '011104005259673', '18763614502', '890105009000289880', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221788', NULL, '011104005431140', '18763682276', '890105009000289891', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221792', NULL, '011104005431082', '18764457210', '890105009000289895', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221799', NULL, '011104005430894', '18764469721', '890105009000289902', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221815', NULL, '011104005431603', '18762812916', '890105009000289918', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221819', NULL, '011104005431686', '18764708108', '890105009000289922', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221822', NULL, '011104005431793', '18762812208', '890105009000289925', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221831', NULL, '011104005431538', '18764458214', '890105009000289934', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221848', NULL, '357852036018631', '18765831446', '890105009000289751', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221849', NULL, '357852036011214', '18763613527', '890105009000289752', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221855', NULL, '357852036013749', '18764225274', '890105009000289758', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221859', NULL, '357852036020835', '18762994487', '890105009000289762', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221883', NULL, '357852035969206', '18764224791', '890105009000289786', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221885', NULL, '357852035968117', '18768689193', '890105009000289788', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221892', NULL, '357852035968141', '18764103654', '890105009000289795', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221894', NULL, '357852035969214', '18762986165', '890105009000289797', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221897', NULL, '011104005256505', '18763614440', '890105009000289800', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221902', NULL, '011104005256638', '18764456025', '890105009000289805', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221917', NULL, '011104005256224', '18762814937', '890105009000289820', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221920', NULL, '011104005255259', '18763614687', '890105009000289823', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221939', NULL, '011104005254922', '18763614916', '890105009000289842', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221947', NULL, '357852035433252', '18764324574', '890105009000289950', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221948', NULL, '357852035409740', '18764328947', '890105009000289951', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221961', NULL, '357852035412645', '18764465675', '890105009000289964', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221967', NULL, '357852035409724', '18764708047', '890105009000289970', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221974', NULL, '357852035958514', '18762754196', '890105009000289977', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221978', NULL, '357852035409088', '18764334324', '890105009000289981', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221982', NULL, '357852035409096', '18764328678', '890105009000289985', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221987', NULL, '357852035992281', '18764065658', '890105009000289990', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221991', NULL, '357852036013079', '18764222767', '890105009000289994', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221994', NULL, '357852035409161', '18765090925', '890105009000289997', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17221995', NULL, '357852035433195', '18764219463', '890105009000289998', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222001', NULL, '357852035414898', '18768673621', '890105009000290004', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222013', NULL, '357852036006859', '18763613975', '890105009000290014', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222015', NULL, '357852036024365', '18764354747', '890105009000290015', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222019', NULL, '357852036006115', '18762997267', '890105009000290018', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222021', NULL, '357852036007683', '18764867876', '890105009000290020', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222023', NULL, '357852036006503', '18762985240', '890105009000290021', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222025', NULL, '357852036006917', '18764149344', '890105009000290022', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222030', NULL, '357852036007360', '18764675511', '890105009000290025', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222038', NULL, '357852035958530', '18764052180', '890105009000290029', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222040', NULL, '357852036010976', '18762830658', '890105009000290030', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222056', NULL, '357852036006081', '18764048760', '890105009000290036', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222069', NULL, '357852036006594', '18762950498', '890105009000290043', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222072', NULL, '357852035993834', '18764781945', '890105009000290045', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222075', NULL, '357852035998783', '18764252866', '890105009000290046', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222085', NULL, '357852036021502', '18763660057', '890105009000290052', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222091', NULL, '357852035974131', '18764074708', '890105009000290056', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222116', NULL, '357852035973133', '18765796227', '890105009000290071', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222140', NULL, '357852035998866', '18768928317', '890105009000290081', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222146', NULL, '357852035998718', '18764653295', '890105009000290086', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222147', NULL, '357852036020744', '18762827572', '890105009000290087', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222158', NULL, '357852035990087', '18763612112', '890105009000290098', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222196', NULL, '011104005256679', '18763612725', '890105009000290120', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222198', NULL, '011104005256984', '18763698336', '890105009000290121', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222200', NULL, '011104005258238', '18763613461', '890105009000290122', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222209', NULL, '011104005256497', '18764690973', '890105009000290127', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17239190', NULL, '357852036006800', '18763710978', '890105009000286651', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17239192', NULL, '357852035417099', '18764329195', '890105009000286653', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17239196', NULL, '357852035414583', '18764337382', '890105009000286657', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17239200', NULL, '357852035414559', '18764222307', '890105009000286661', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17239208', NULL, '357852035973885', '18763710787', '890105009000286669', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17239215', NULL, '357852035417008', '18764336797', '890105009000286676', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17239220', NULL, '357852035982209', '18764122455', '890105009000286681', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17239230', NULL, '357852035417115', '18764897283', '890105009000286691', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17239233', NULL, '357852035968075', '18763711584', '890105009000286694', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17239249', NULL, '357852035432858', '18764080577', '890105009000286710', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17239257', NULL, '357852035410896', '18764479680', '890105009000286718', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17239287', NULL, '357852035433260', '18764149680', '890105009000286748', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17239307', NULL, '357852035410938', '18764024410', '890105009000286568', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17239316', NULL, '357852035433757', '18762834684', '890105009000286577', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17239319', NULL, '357852035433765', '18768492050', '890105009000286580', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17809526', NULL, '358696044592643', '18764393997', '890105003000327753', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17809540', NULL, '358696044581760', '18764288467', '890105003000327764', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17809548', NULL, '358696044562489', '18762864728', '890105003000327771', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17809549', NULL, '358696044531914', '18764691214', '890105003000327772', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17809556', NULL, '358696044581752', '18765645246', '890105003000327779', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17809559', NULL, '358696044621756', '18764021068', '890105003000327781', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17809570', NULL, '358696044593393', '18763826432', '890105003000327788', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17809573', NULL, '358696044593468', '18764363163', '890105003000327791', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17809574', NULL, '358696044593476', '18764424140', '890105003000327792', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17809576', NULL, '358696044586413', '18763814289', '890105003000327794', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17809602', NULL, '358696044622119', '18764280411', '890105003000327802', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17809619', NULL, '358696044580010', '18765641769', '890105003000327819', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17809621', NULL, '358696044579434', '18763615722', '890105003000327821', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17809636', NULL, '358696044585167', '18764304359', '890105003000327836', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17809637', NULL, '358696044592684', '18764284409', '890105003000327837', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17809647', NULL, '358696044592668', '18764020903', '890105003000327847', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17809649', NULL, '358696044580986', '18762798108', '890105003000327849', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835397', NULL, '358696044577776', '18764520851', '890105004000343160', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835407', NULL, '358696044621798', '18763596131', '890105004000343170', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835409', NULL, '358696044599838', '18764468100', '890105004000343172', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835411', NULL, '358696044599762', '18765773518', '890105004000343174', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835437', NULL, '358696044577859', '18765645223', '890105004000343185', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835502', NULL, '358696044582297', '18762985564', '890105004000343212', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835521', NULL, '358696044599655', '18762956342', '890105004000343231', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835533', NULL, '358696044591793', '18764211667', '890105004000343243', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835571', NULL, '358696044594037', '18768780172', '890105004000343251', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835713', NULL, '358696044580150', '18763824691', '890105004000343367', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835715', NULL, '358696044580127', '18765647857', '890105004000343369', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835725', NULL, '358696044599770', '18764364935', '890105004000343379', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835727', NULL, '358696044599804', '18764172028', '890105004000343381', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835735', NULL, '358696044576067', '18764403879', '890105004000343389', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835737', NULL, '358696044579731', '18765778906', '890105004000343391', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835739', NULL, '358696044586652', '18764528819', '890105004000343392', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835744', NULL, '358696044593757', '18768780614', '890105004000343394', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835755', NULL, '358696044582206', '18763712671', '890105004000343397', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835762', NULL, '358696044591611', '18764693059', '890105004000343400', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835788', NULL, '358696044579202', '18764708226', '890105004000343418', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835790', NULL, '358696044600099', '18765090332', '890105004000343420', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835797', NULL, '358696044598822', '18763824154', '890105004000343427', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835803', NULL, '358696044582891', '18765641517', '890105004000343433', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17835809', NULL, '358696044586397', '18768816848', '890105004000343437', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837402', NULL, '358696044575929', '18768780160', '890105004000344257', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837425', NULL, '358696044587932', '18764292245', '890105004000344268', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837430', NULL, '358696044591561', '18762857515', '890105004000344271', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837435', NULL, '358696044576695', '18768780408', '890105004000344276', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837437', NULL, '357852035973844', '18764394607', '890105004000344278', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837452', NULL, '358696044586660', '18762867219', '890105004000344291', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837457', NULL, '358696044579590', '18764691924', '890105004000344293', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837465', NULL, '358696044579608', '18765642478', '890105004000344296', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837468', NULL, '358696044581240', '18768780433', '890105004000344298', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837496', NULL, '358696044591512', '18763811283', '890105004000344308', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837499', NULL, '358696044592007', '18764468413', '890105004000344309', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837519', NULL, '358696044591942', '18768816857', '890105004000344317', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837539', NULL, '358696044586496', '18764692691', '890105004000344326', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837543', NULL, '358696044587890', '18765642709', '890105004000344330', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837547', NULL, '358696044576059', '18765646823', '890105004000344334', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837549', NULL, '358696044580028', '18764480571', '890105004000344336', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837553', NULL, '358696044621343', '18768489386', '890105004000344340', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837554', NULL, '358696044587064', '18764308912', '890105004000344341', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837555', NULL, '358696044587056', '18764370936', '890105004000344342', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837601', NULL, '358696044575960', '18763622393', '890105004000344363', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837605', NULL, '358696044582883', '18764435738', '890105004000344365', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837607', NULL, '358696044576968', '18762986612', '890105004000344366', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837609', NULL, '357852036001637', '18764292333', '890105004000344367', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837626', NULL, '358696044585118', '18764394489', '890105004000344374', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837638', NULL, '358696044579905', '18765773521', '890105004000344380', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837640', NULL, '358696044579814', '18764194152', '890105004000344382', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837647', NULL, '358696044599564', '18763828153', '890105004000344389', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837693', NULL, '358696044579335', '18762985894', '890105004000344420', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837697', NULL, '358696044579194', '18765773545', '890105004000344422', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837706', NULL, '358696044526005', '18764507103', '890105004000344427', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837724', NULL, '358696044508300', '18762985769', '890105004000344434', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837738', NULL, '358696044556846', '18762864360', '890105004000344440', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17837761', NULL, '358696044582289', '18764634113', '890105004000344448', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17943915', NULL, '011104005624900', '18765645376', '890105005000349762', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17943920 ', NULL, '011104005625063', '18762909718', '890105005000349767', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17943926 ', NULL, '011104005625022', '18765798445', '890105005000349773', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17943936 ', NULL, '011104005623084', '18762896739', '890105005000349783', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17943945 ', NULL, '011104005623472', '18762909685', '890105005000349792', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17943947 ', NULL, '011104005638777', '18764038483', '890105005000349794', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18503596', NULL, '351802057713020', '18764616032', '890105007000375506', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18503605', NULL, '351802057708657', '18762806204', '890105007000375515', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18503609', NULL, '351802057680864', '18762985168', '890105007000375519', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18503625', NULL, '353301050251664', '18762986995', '890105007000375535', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18504252', NULL, '353301050274096', '18764613554', '890105007000376162', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18504254', NULL, '353301050286330', '18764691033', '890105007000376164', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18504274', NULL, '353301050285050', '18763829564', '890105007000376184', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18504586', NULL, '011104005256323', '18762816397', '890105007000376496', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18595017 ', NULL, '351802057680930', '18765722795', '890105002000398487', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18595024 ', NULL, '351802057699070', '18764854714', '890105002000398494', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18595034 ', NULL, '351802057674859', '18768534352', '890105002000398504', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18595971', NULL, '353301055492412', '18765893256', '890105007000377433', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18596033 ', NULL, '353301054314013', '18764379774', '890105007000377495', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18596037 ', NULL, '353301054325530', '18764635347', '890105007000377499', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18680349', NULL, '353301058212130', '18765090863 ', '890105002000399178', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18680366', NULL, '353301058202388', '18765090450', '890105002000399195', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18680371', NULL, '353301058203824', '18764404503', '890105002000399200', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18680375', NULL, '353301058204160', ' 18762785804', '890105002000399204', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18680382', NULL, '353301058203808', ' 18765090445', '890105002000399211', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18680387', NULL, '353301054325597', '18762826024', '890105002000399216', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18680411', NULL, '353301054313890', '18764410302', '890105002000399240', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18680424', NULL, '353301054313817', '18764737616', '890105002000399253', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18680433', NULL, '353301054311886', '18764413392', '890105002000399262', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18680440', NULL, '353301058321113', '18763671869', '890105002000399269', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18680452', NULL, '353301058200572', '18764027974', '890105002000399281', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18680476', NULL, '353301054262709', ' 18762791984', '890105002000399305', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18680483', NULL, '353301058204475', ' 18762792331', '890105002000399312', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683200', NULL, '355233052759105', '18768781205', '890105002000402029', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683201', NULL, '355233052748975', '18768775326', '890105002000402030', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683213', NULL, '355233052746920', '18768781225', '890105002000402042', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683277', NULL, '355233050925369', '18763792683', '890105002000402106', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683279', NULL, '355233050891066', '18768781214', '890105002000402108', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683286', NULL, '355233052758263', '18764292558', '890105002000402115', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683291', NULL, '355233052758313', '18765773692', '890105002000402120', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683314', NULL, '355233052714068', '18768780132', '890105002000402143', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683317', NULL, '355233052758230', '18763989272', '890105002000402146', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683321', NULL, '355233054152606', '18764023391', '890105002000402150', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683339', NULL, '355233050925724', '18768781220', '890105002000402168', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683349', NULL, '355233050890308', '18762959695', '890105002000402178', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683383', NULL, '355233050924271', '18764302068', '890105002000402212', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683394', NULL, '355233052747209', '18768781163', '890105002000402223', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683408', NULL, '355233052741137', '18768781139', '890105002000402237', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683416', NULL, '355233052707856', '18768781147', '890105002000402246', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683853', NULL, '355233054076912', '18763835975', '890105002000402682', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683874', NULL, '355233050923836', '18762760770', '890105002000402703', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683935', NULL, '355233052748454', '18763888793', '890105002000402764', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683947', NULL, '355233050924263', '18764546842', '890105002000402776', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683959', NULL, '355233052714910', '18762868950', '890105002000402788', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683963', NULL, '355233052748405', '18762908064', '890105002000402792', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683980', NULL, '355233052760905', '18762764807', '890105002000402809', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18683993', NULL, '355233054124001', '18762767706', '890105002000402822', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18684008', NULL, '355233054131535', '18762843190', '890105002000402837', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18684014', NULL, '355233054124043', '18764705450', '890105002000402843', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18684016', NULL, '355233054076540', '18764136954', '890105002000402845', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18684018', NULL, '355233054129513', '18764384364', '890105002000402847', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18684019', NULL, '355233054128309', '18763526018', '890105002000402848', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18684187', NULL, '355233052714399', '18764524654', '890105002000403016', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18684208', NULL, '355233054157803', '18763739332', '890105002000403037', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18684221', NULL, '355233054157050', '18764525139', '890105002000403050', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18684565', NULL, '355233054125131', '18765643008', '890105005000403400', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18684570', NULL, '355233054128366', '18762759065', '890105005000403405', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18684586', NULL, '355233054131345', '18764540908', '890105005000403420', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18684641', NULL, '355233054157357', '18764050450', '890105005000403475', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18684651', NULL, '355233054146574', '18763739114', '890105005000403485', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18684657', NULL, '355233054146525', '18763640809', '890105005000403491', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18899159', NULL, '355233053464366', '18762911030', '890105005000404586', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18899164', NULL, '355233053466429', '18763986035', '890105005000404591', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18899170', NULL, '355233053467237', '18764488014', '890105005000404597', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18899178', NULL, '355233053466742', '18762950493', '890105005000404605', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18899187', NULL, '355233053464358', '18762932080', '890105005000404614', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18899200', NULL, '355233053529614', '18765643832', '890105005000404621', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18899220', NULL, '355233053464556', '18765644904', '890105005000404632', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18899225', NULL, '355233053527188', '18762950140', '890105005000404635', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18899242', NULL, '355233053527196', '18762986672', '890105005000404645', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18899246', NULL, '355233053511869', '18765641546', '890105005000404647', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18899261', NULL, '355233053467906', '18764320636', '890105005000404654', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18899263', NULL, '355233053467955', '18764413072', '890105005000404655', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18899363', NULL, '355233053467021', '18764487479', '890105005000404700', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18899399', NULL, '355233053511729', '18764012439', '890105005000404719', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18899455', NULL, '355233050924610', '18762835593', '890105005000404735', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18899480', NULL, '355233050924040', '18763689415', '890105005000404747', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18899488', NULL, '355233050925484', '18762836733', '890105005000404751', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18900883', NULL, '357207055746697', '18763836744', '890105005000405021', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18900889', NULL, '357207055737423', '18764690420', '890105005000405027', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18900928', NULL, '357207055746531', '18768817244', '890105005000405066', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997155', NULL, '355233054126451', '18763711247', '890105011000417156', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997159', NULL, '355233054127525', '18764477252', '890105011000417160', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997174', NULL, '355233054147424', '18764174430', '890105011000417175', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997177', NULL, '355233054156672', '18763612676', '890105011000417178', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997218', NULL, '355233054146657', '18764855549', '890105011000416921', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997219', NULL, '355233054148620', '18764276561', '890105011000416922', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997222', NULL, '355233054154768', '18764865998', '890105011000416925', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997223', NULL, '355233054157761', '18764279011', '890105011000416926', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997225', NULL, '355233054126543', '18762470468', '890105011000416928', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997257', NULL, '355233054126535', '18764298798', '890105011000416960', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997260', NULL, '355233054124019', '18762799105', '890105011000416963', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997299', NULL, '355233054157787', '18764357276', '890105011000417002', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997310', NULL, '355233050923802', '18762470481', '890105011000417013', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997331', NULL, '355233054147457', '18764372169', '890105011000417034', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997333', NULL, '355233054154875', '18764277696', '890105011000417036', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997344', NULL, '355233054154818', '18764279384', '890105011000417047', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997377', NULL, '355233053511828', '18764279316', '890105011000417080', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997384', NULL, '355233054146558', '18763814129', '890105011000417087', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997386', NULL, '355233054148646', '18764293160', '890105011000417089', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997395', NULL, '355233054124530', '18768781014', '890105011000417098', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997402', NULL, '355233054126493', '18765773066', '890105011000417105', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997418', NULL, '355233054126477', '18762470482', '890105011000417121', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D18997433', NULL, '355233054127426', '18763612622', '890105011000417136', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19034796', NULL, '357207057440646', '18763671719', '890105011000417789', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19034862', NULL, '357207057544900', '18765797085', '890105011000417804', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19034867', NULL, '357207057438848', '18768782669', '890105011000417809', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19034882', NULL, '357207057440331', '18765798839', '890105011000417812', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19034884', NULL, '357207057440604', '18768784239', '890105011000417813', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19034963', NULL, '357207057544447', '18765641989', '890105011000417827', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19034988', NULL, '357207056421357', '18765799130', '890105011000417836', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19035061', NULL, '357207055746762', '18765779150', '890105011000417840', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19035125', NULL, '355233054110117', '18765797192', '890105011000417843', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19035197', NULL, '357207055736763', '18765778992', '890105011000417881', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19035395', NULL, '357207056421316', '18765644957', '890105011000417895', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19035491', NULL, '357207057440497', '18765798516', '890105011000417918', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19035517', NULL, '357207057637712', '18765798945', '890105011000417925', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19035521', NULL, '357207057437402', '18765645266', '890105011000417929', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19035523', NULL, '357207057543613', '18765797614', '890105011000417931', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19035525', NULL, '357207057594582', '18765797564', '890105011000417933', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19035577', NULL, '357207057543605', '18763575643', '890105011000417983', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039162', NULL, '357207056407547', '18764198436', '890105011000421503', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039167', NULL, '357207056431265', '18764205332', '890105011000421508', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039170', NULL, '357207056407885', '18763748363', '890105011000421511', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039176', NULL, '357207056407281', '18762875645', '890105011000421517', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039208', NULL, '357207056421407', '18765640825', '890105011000421530', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039211', NULL, '355233054111990', '18765641260', '890105011000421532', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039332', NULL, '355233050924115', '18768815609', '890105011000421571', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039400', NULL, '355233050924560', '18765773190', '890105011000421588', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039408', NULL, '357207057637266', '18765795523', '890105011000421589', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039412', NULL, '357207057440547', '18762776206', '890105011000421593', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039414', NULL, '357207057456170', '18768784226', '890105011000421595', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039420', NULL, '357207057546145', '18765796283', '890105011000421601', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039438', NULL, '357207057544967', '18765796236', '890105011000421617', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039442', NULL, '357207057546137', '18765798891', '890105011000421621', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039465', NULL, '357207057440679', '18768784336', '890105011000421636', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039505', NULL, '355233050925096', '18768816952', '890105011000421641', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039520', NULL, '355233050924446', '18764690939', '890105011000421648', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039535', NULL, '355233054111925', '18765799172', '890105011000421663', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039543', NULL, '355233050924503', '18768815591', '890105011000421671', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039545', NULL, '355233050924529', '18763925739', '890105011000421673', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039552', NULL, '357207055745137', '18765798660', '890105011000421675', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039555', NULL, '357207055737308', '18765640457', '890105011000421677', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039557', NULL, '357207055746218', '18765799143', '890105011000421678', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039559', NULL, '357207057636599', '18768782644', '890105011000421679', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19039576', NULL, '357207055737324', '18765799150', '890105011000421685', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19041109', NULL, '357207057544512', '18768976257', '890105011000422242', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19041113', NULL, '357207057436891', '18763591816', '890105011000422244', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19041140', NULL, '355233054119902', '18765799235', '890105011000422262', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19041153', NULL, '357207056407315', '18768782643', '890105011000422272', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19041197', NULL, '355233054111248', '18765798620', '890105011000422285', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19041820', NULL, '357207056410871', '18765797238', '890105011000424471', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19041825', NULL, '357207057436925', '18765798786', '890105011000424476', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19041829', NULL, '357207056407349', '18765798651', '890105011000424480', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19041833', NULL, '357207056408057', '18764692450', '890105011000424484', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19100599', NULL, '357207055746267', '18762986713', '890105011000427485', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19100754', NULL, '355233054160898', '18764506354', '890105011000427588', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19100765', NULL, '355233054147259', '18768787344', '890105011000427599', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19100773', NULL, '355233054157381', '18762985374', '890105011000427607', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19100778', NULL, '357207056397581', '18764692063', '890105011000427612', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19100802', NULL, '357207055744452', '18763827566', '890105011000427636', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19100803', NULL, '357207055744494', '18763710870', '890105011000427637', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19100823', NULL, '355233054123532', '18763833818', '890105011000427648', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19100838', NULL, '355233054123789', '18764505857', '890105011000427656', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19100850', NULL, '355233054122708', '18763812786', '890105011000427661', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19100860', NULL, '355233054121577', '18764691737', '890105011000427668', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19100879', NULL, '355233054122658', '18764505536', '890105011000427679', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19100911', NULL, '355233054123797', '18764708297', '890105011000427700', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19100934', NULL, '355233054121619', '18765773048', '890105011000427717', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19100942', NULL, '355233054121247', '18762942320', '890105011000427724', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19100956', NULL, '355233054123466', '18765773282', '890105011000427734', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19100985', NULL, '357207055712772', '18762934485', '890105011000427745', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19100994', NULL, '357207055747315', '18763814061', '890105011000427750', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19101016', NULL, '357207055744486', '18765773362', '890105011000427761', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19101018', NULL, '357207055744171', '18765773213', '890105011000427762', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19101021', NULL, '357207055747323', '18764090536', '890105011000427763', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19101037', NULL, '357207055747307', '18764010060', '890105011000427772', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19101048', NULL, '357207056410319', '18763614882', '890105011000427779', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19101051', NULL, '357207055712707', '18763831353', '890105011000427782', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19103171', NULL, '357207057595449', '18765799148', '890105011000429823', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19103184', NULL, '357207057637134', '18762767671', '890105011000429833', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19107673', NULL, '359394051189227', '18765536184', '890105001000433239', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19107952', NULL, '357207057637464', '18768782628', '890105001000433393', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19107956', NULL, '357207057435596', '18768784263', '890105001000433396', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19107960', NULL, '357207057637647', '18765798473', '890105001000433399', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19108059', NULL, '357207057636581', '18765799259', '890105001000433478', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19110369', NULL, '357207057636052', '18765798513', '890105001000439664', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19110418', NULL, '357207057661670', '18768781449', '890105001000439713', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19110422', NULL, '357207057545055', '18765798666', '890105001000439717', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D19999805', NULL, '358683060832285', '18765796769', '890105010000537174', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D20000981', NULL, '358683061187473', '18765782312', '890105010000538722', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	('D17222001', NULL, '357852035414898', '18768673621', '890105009000290004', 1, 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-06-10 22:01:21'),
	('D18683279', NULL, '355233050891066', '18768781214', '890105002000402108', 1, 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-06-11 20:16:53'),
	('D18683279', NULL, '355233050891066', '18768781214', '890105002000402108', 1, 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-06-11 20:20:16'),
	('', NULL, '353239002532593', '18765794806', '890105009000176795', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14283797', NULL, '353239002531173', '18765796465', '890105009000175778', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14283829', NULL, '353239002531231', '18765796523', '890105009000175761', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14283840', NULL, '353239002531140', '18765797367', '890105009000175751', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14283877', NULL, '353239002251913', '18765795456', '890105009000175717', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14283891', NULL, '353239002252408', '18765795109', '890105009000175705', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14283985', NULL, '353239002251418', '18765795366', '890105009000175666', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14284067', NULL, '353239002247374', '18765779094', '890105009000175622', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14284079', NULL, '353239002250246', '18765795023', '890105009000175614', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14284084', NULL, '353239002252507', '18765795365', '890105009000175610', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14286575', NULL, '353239002532494', '18765798814', '890105009000176789', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14286616', NULL, '353239002532361', '18765794606', '890105009000176771', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14286618', NULL, '353239002235494', '18765794905', '890105009000176767', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14286633', NULL, '353239002235098', '18765794972', '890105009000176757', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14286691', NULL, '353239002251137', '18765798016', '890105009000176695', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14286784', NULL, '353239002253232', '18765794916', '890105009000176650', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14286805', NULL, '353239002266671', '18765794503', '890105009000176639', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14286816', NULL, '353239002263678', '18765796751', '890105009000176633', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14286848', NULL, '353239002251251', '18765798952', '890105009000176614', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14286905', NULL, '353239002536388', '18765797629', '890105009000176744', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14286925', NULL, '353239002532213', '18765798845', '890105009000176733', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14286952', NULL, '353239002252010', '18765795176', '890105009000176716', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969741', NULL, '353239006022476', '18765642657', '890105005000194371', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969755', NULL, '353239006257338', '18765643317', '890105005000194385', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969756', NULL, '353239006257551', '18765649905', '890105005000194386', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969780', NULL, '353239006258120', '18765645907', '890105005000194410', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969788', NULL, '353239006257353', '18765642133', '890105005000194418', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969813', NULL, '353239006256546', '18765642773', '890105005000194443', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969818', NULL, '353239006255654', '18765645239', '890105005000194448', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969829', NULL, '353239006252586', '18765641775', '890105005000194459', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969857', NULL, '353239006253873', '18765643204', '890105005000194487', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969868', NULL, '011104000564390', '18765648236', '890105005000194498', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969881', NULL, '353239006255035', '18765642068', '890105005000194511', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969905', NULL, '353239006018425', '18763711597', '890105005000194535', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969930', NULL, '353239006019928', '18765643297', '890105005000194560', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969936', NULL, '353239006023763', '18765648683', '890105005000194566', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969947', NULL, '353239006022245', '18765642343', '890105005000194577', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969956', NULL, '353239006257379', '18765642303', '890105005000194586', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969962', NULL, '353239006255068', '18765640598', '890105005000194592', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969970', NULL, '353239006252875', '18765642389', '890105005000194600', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969972', NULL, '353239006256355', '18765643286', '890105005000194602', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969973', NULL, '353239006256009', '18765644015', '890105005000194603', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969974', NULL, '353239006258831', '18765643243', '890105005000194604', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14969977', NULL, '353239006251497', '18765642029', '890105005000194607', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14970503', NULL, '353239006021635', '18765643621', '890105005000197133', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14970513', NULL, '353239006018524', '18765643009', '890105005000197143', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14970541', NULL, '353239006023482', '18765643087', '890105005000197171', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14970555', NULL, '353239006251893', '18764474650', '890105005000197185', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14970563', NULL, '353239006256439', '18765641035', '890105005000197193', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14970574', NULL, '353239006200031', '18765641135', '890105005000197204', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14970585', NULL, '353239006257411', '18765649904', '890105005000197215', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14970610', NULL, '353239006019662', '18765641612', '890105005000197240', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14970618', NULL, '353239006018888', '18765643384', '890105005000197248', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14970659', NULL, '353239006038118', '18765642185', '890105005000197289', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14970664', NULL, '353239006041211', '18765642414', '890105005000197294', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14970667', NULL, '353239006022740', '18765642078', '890105005000197297', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14970710', NULL, '353239006021320', '18765641762', '890105005000197340', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14970712', NULL, '353239006022732', '18765643094', '890105005000197342', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14970723', NULL, '353239006020686', '18763689957', '890105005000197353', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D14970725', NULL, '353239006020512', '18765643221', '890105005000197355', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15025084', NULL, '011104000565546', '18763826235', '890105006000202729', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15025093', NULL, '011104000564184', '18765646457', '890105006000202738', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15163533', NULL, '011104000561438', '18763830815', '890105006000206114', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15163577', NULL, '011104000570645', '18768819657', '890105006000206158', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15163738', NULL, '011104000561487', '18763612604', '890105006000206319', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15163746', NULL, '011104000561859', '18768782572', '890105006000206327', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15163749', NULL, '011104000566189', '18763814287', '890105006000206330', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15163752', NULL, '011104000565538', '18768697668', '890105006000206333', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15163758', NULL, '011104000562261', '18763836813', '890105006000206339', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15163761', NULL, '011104000565694', '18765773453', '890105006000206342', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15163766', NULL, '011104000566510', '18763660106', '890105006000206347', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15163767', NULL, '011104000566775', '18765641783', '890105006000206348', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15163772', NULL, '353239006021338', '18765884649', '890105006000206353', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15164893', NULL, '011104000565835', '18768819372', '890105006000206723', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15164902', NULL, '011104000565983', '18768819646', '890105006000206732', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15164903', NULL, '011104000560240', '18765644012', '890105006000206733', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15164924', NULL, '011104000558087', '18768775159', '890105006000206754', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166584', NULL, '011104000561503', '18765642498', '890105006000204665', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166593', NULL, '011104000561776', '18763823370', '890105006000204674', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166597', NULL, '011104000561842', '18768696276', '890105006000204678', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166601', NULL, '011104000570744', '18765649382', '890105006000204682', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166610', NULL, '011104000566817', '18765645265', '890105006000204691', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166628', NULL, '011104000562436', '18765644606', '890105006000204709', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166630', NULL, '011104000562550', '18765644985', '890105006000204711', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166798', NULL, '011104000564135', '18768819762', '890105006000204879', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166812', NULL, '011104000566742', '18765090522', '890105006000204893', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166828', NULL, '011104000563665', '18765649720', '890105006000204909', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166941', NULL, '011104000564150', '18763835388', '890105006000205022', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166951', NULL, '011104000561750', '18765645201', '890105006000205032', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166953', NULL, '353239006021239', '18763835396', '890105006000205034', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166959', NULL, '353239006021502', '18763835094', '890105006000205040', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166970', NULL, '011104000564499', '18768819762', '890105006000205051', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166973', NULL, '011104000564523', '18763825167', '890105006000205054', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166974', NULL, '011104000564093', '18765647391', '890105006000205055', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166991', NULL, '011104000563806', '18765778853', '890105006000205072', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166994', NULL, '011104000563780', '18765794572', '890105006000205075', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15166998', NULL, '011104000570165', '18765649683', '890105006000205079', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15375826', NULL, '353239006018953', '18765644818', '890105001000210812', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15469731', NULL, '011104005121212', '18765643048', '890105001000215349', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15469743', NULL, '011104005431249', '18764411072', '890105001000215361', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15470300', NULL, '011104000562378', '18768697317', '890105001000214418', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15470302', NULL, '011104000562485', '18768696088', '890105001000214420', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15470323', NULL, '011104000562170', '18765644567', '890105001000214441', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15470328', NULL, '011104000565801', '18763826366', '890105001000214446', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15470339', NULL, '011104000563889', '18763834951', '890105001000214458', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15470342', NULL, '011104000738697', '18768786527', '890105001000214460', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15470477', NULL, '011104000566528', '18763825024', '890105001000214595', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15470480', NULL, '011104000546488', '18765649817', '890105001000214598', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15470492', NULL, '011104000565561', '18764692193', '890105001000214610', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D15470494', NULL, '011104000565371', '18763835918', '890105001000214612', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087173', NULL, '011104000729332', '18765611283', '890105001000237398', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087179', NULL, '011104000729324', '18765780534', '890105001000237403', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087182', NULL, '011104005119125', '18763826507', '890105001000237405', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087184', NULL, '011104005119075', '18765624893', '890105001000237407', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087199', NULL, '011104000732708', '18764665435', '890105001000237415', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087208', NULL, '011104000731031', '18762769661', '890105001000237421', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087212', NULL, '011104000731023', '18765781015', '890105001000237424', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087214', NULL, '011104000732815', '18765781011', '890105001000237426', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087220', NULL, '011104000731064', '18765781014', '890105001000237431', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087223', NULL, '011104000729357', '217', '890105001000237433', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087225', NULL, '011104005131567', '18763811727', '890105001000237435', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087235', NULL, '011104005122491', '18762986605', '890105001000237442', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087246', NULL, '011104005114746', '18765781016', '890105001000237447', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087251', NULL, '011104005131583', '18765620578', '890105001000237451', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087263', NULL, '011104005131666', '18765781013', '890105001000237460', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087265', NULL, '011104000732781', '18764815731', '890105001000237462', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087268', NULL, '011104005131658', '18764401690', '890105001000237464', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087277', NULL, '011104005122327', '18763811048', '890105001000237472', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087287', NULL, '011104005122558', '18768817636', '890105001000237480', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087292', NULL, '011104005121105', '18762766748', '890105001000237484', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087296', NULL, '011104000669801', '18763829626', '890105001000237487', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087327', NULL, '011104000669819', '18762826533', '890105001000237509', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087332', NULL, '011104005120842', '18762769432', '890105001000237513', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087336', NULL, '011104005114555', '18762767195', '890105001000237516', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087337', NULL, '011104005114589', '18763830677', '890105001000237517', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087343', NULL, '011104005127714', '18762769424', '890105001000237523', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087347', NULL, '011104005121345', '18762767185', '890105001000237526', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087380', NULL, '011104000660834', '18762765902', '890105001000237550', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087407', NULL, '357852035973877', '18762985584', '890105001000237569', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087417', NULL, '011104005114373', '18762930982', '890105001000237576', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087421', NULL, '011104005114308', '18762823399', '890105001000237579', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087430', NULL, '011104005120784', '18763614340', '890105001000237585', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087483', NULL, '011104000740842', '18765648869', '890105001000237621', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087496', NULL, '011104005130445', '18762769357', '890105001000237631', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087499', NULL, '011104000669777', '18765779772', '890105001000237633', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16087505', NULL, '011104000670023', '18762985988', '890105001000237636', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121513', NULL, '011104005117525', '18762767728', '890105001000242138', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121527', NULL, '011104005117905', '18764635151', '890105001000242152', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121540', NULL, '011104005117640', '18764692637', '890105001000242165', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121543', NULL, '011104005129892', '18762766465', '890105001000242168', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121550', NULL, '011104005129835', '18763725377', '890105001000242175', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121555', NULL, '011104005117756', '18763728718', '890105001000242180', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121558', NULL, '011104005129686', '18764406768', '890105001000242183', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121559', NULL, '011104005129827', '18762767109', '890105001000242184', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121570', NULL, '011104005120453', '18762827445', '890105001000242195', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121583', NULL, '011104005127656', '18768755958', '890105001000242208', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121584', NULL, '011104005127623', '18764514012', '890105001000242209', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121585', NULL, '011104005127482', '18762823820', '890105001000242210', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121587', NULL, '011104005114662', '18762797451', '890105001000242212', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121590', NULL, '011104005114779', '18764690053', '890105001000242215', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121595', NULL, '011104005114654', '18764454182', '890105001000242220', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121600', NULL, '011104005114639', '18762986513', '890105001000242225', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121615', NULL, '011104005118697', '18763832099', '890105001000242240', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121629', NULL, '011104005118630', '18762883754', '890105001000242254', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121636', NULL, '011104005120024', '18768816769', '890105001000242261', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121638', NULL, '011104005122418', '18762997007', '890105001000242263', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121642', NULL, '011104005119687', '18764521640', '890105001000242267', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121650', NULL, '011104005120040', '18762768780', '890105001000242275', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121652', NULL, '011104005119810', '18768754798', '890105001000242277', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121657', NULL, '011104005122459', '18768819011', '890105001000242282', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121658', NULL, '011104005119786', '18763829200', '890105001000242283', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121659', NULL, '011104005122145', '18768816046', '890105001000242284', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121664', NULL, '011104000670015', '18763938120', '890105001000242289', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121683', NULL, '011104005120123', '18762767282', '890105001000242308', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121695', NULL, '011104005114811', '18762768401', '890105001000242320', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121715', NULL, '011104005118952', '18762769399', '890105001000242340', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121716', NULL, '011104000729282', '18764082568', '890105001000242341', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121720', NULL, '011104000729274', '18768755723', '890105001000242345', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121729', NULL, '011104005119083', '18764785438', '890105001000242354', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121731', NULL, '011104000729449', '18765731659', '890105001000242356', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121733', NULL, '011104000725710', '18762987210', '890105001000242358', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121744', NULL, '011104000564762', '18763714660', '890105001000242369', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121746', NULL, '011104005122434', '18763832523', '890105001000242371', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121750', NULL, '011104005120818', '18768755964', '890105001000242375', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121751', NULL, '011104005120958', '18763727724', '890105001000242376', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121753', NULL, '011104005122129', '18764690315', '890105001000242378', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D16121756', NULL, '011104005121238', '18763814260', '890105001000242381', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17220893', NULL, '011104005471542', '18764319816', '890105009000291761', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17220928', NULL, '011104005474975', '18764323047', '890105009000291781', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17220975', NULL, '011104005133373', '18764218961', '890105009000291802', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17220982', NULL, '011104005261059', '18763991795', '890105009000291808', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17220983', NULL, '011104005260721', '18762986781', '890105009000291809', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17220998', NULL, '011104005256216', '18764884423', '890105009000291824', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221002', NULL, '011104005256604', '18764768343', '890105009000291828', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221004', NULL, '011104005256398', '18764893443', '890105009000291830', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221009', NULL, '011104005256778', '18764764058', '890105009000291835', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221014', NULL, '011104005260945', '18768790699', '890105009000291840', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221132', NULL, '357852036006164', '18763714562', '890105009000291857', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221155', NULL, '357852036020785', '18764591095', '890105009000291874', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221156', NULL, '357852036006529', '18764387377', '890105009000291875', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221172', NULL, '357852035414864', '18768410522', '890105009000291880', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221183', NULL, '357852035959082', '18764048294', '890105009000291885', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221191', NULL, '357852036020330', '18764075545', '890105009000291889', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221249', NULL, '357852036007691', '18762833624', '890105009000291910', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221281', NULL, '357852035972432', '18763614179', '890105009000291930', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221303', NULL, '357852035434847', '18764488214', '890105009000291941', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221309', NULL, '357852035414369', '18762986388', '890105009000291944', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221754', NULL, '011104005435489', '18764690587', '890105009000289857', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221756', NULL, '011104005435356', '18764469915', '890105009000289859', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221761', NULL, '011104005435414', '18764021994', '890105009000289864', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221767', NULL, '011104005435463', '18762816703', '890105009000289870', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221769', NULL, '011104005435422', '18763614503', '890105009000289872', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221777', NULL, '011104005259673', '18763614502', '890105009000289880', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221788', NULL, '011104005431140', '18763682276', '890105009000289891', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221792', NULL, '011104005431082', '18764457210', '890105009000289895', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221799', NULL, '011104005430894', '18764469721', '890105009000289902', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221815', NULL, '011104005431603', '18762812916', '890105009000289918', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221819', NULL, '011104005431686', '18764708108', '890105009000289922', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221822', NULL, '011104005431793', '18762812208', '890105009000289925', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221831', NULL, '011104005431538', '18764458214', '890105009000289934', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221848', NULL, '357852036018631', '18765831446', '890105009000289751', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221849', NULL, '357852036011214', '18763613527', '890105009000289752', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221855', NULL, '357852036013749', '18764225274', '890105009000289758', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221859', NULL, '357852036020835', '18762994487', '890105009000289762', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221883', NULL, '357852035969206', '18764224791', '890105009000289786', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221885', NULL, '357852035968117', '18768689193', '890105009000289788', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221892', NULL, '357852035968141', '18764103654', '890105009000289795', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221894', NULL, '357852035969214', '18762986165', '890105009000289797', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221897', NULL, '011104005256505', '18763614440', '890105009000289800', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221902', NULL, '011104005256638', '18764456025', '890105009000289805', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221917', NULL, '011104005256224', '18762814937', '890105009000289820', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221920', NULL, '011104005255259', '18763614687', '890105009000289823', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221939', NULL, '011104005254922', '18763614916', '890105009000289842', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221947', NULL, '357852035433252', '18764324574', '890105009000289950', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221948', NULL, '357852035409740', '18764328947', '890105009000289951', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221961', NULL, '357852035412645', '18764465675', '890105009000289964', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221967', NULL, '357852035409724', '18764708047', '890105009000289970', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221974', NULL, '357852035958514', '18762754196', '890105009000289977', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221978', NULL, '357852035409088', '18764334324', '890105009000289981', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221982', NULL, '357852035409096', '18764328678', '890105009000289985', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221987', NULL, '357852035992281', '18764065658', '890105009000289990', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221991', NULL, '357852036013079', '18764222767', '890105009000289994', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221994', NULL, '357852035409161', '18765090925', '890105009000289997', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17221995', NULL, '357852035433195', '18764219463', '890105009000289998', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222001', NULL, '357852035414898', '18768673621', '890105009000290004', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222013', NULL, '357852036006859', '18763613975', '890105009000290014', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222015', NULL, '357852036024365', '18764354747', '890105009000290015', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222019', NULL, '357852036006115', '18762997267', '890105009000290018', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222021', NULL, '357852036007683', '18764867876', '890105009000290020', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222023', NULL, '357852036006503', '18762985240', '890105009000290021', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222025', NULL, '357852036006917', '18764149344', '890105009000290022', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222030', NULL, '357852036007360', '18764675511', '890105009000290025', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222038', NULL, '357852035958530', '18764052180', '890105009000290029', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222040', NULL, '357852036010976', '18762830658', '890105009000290030', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222056', NULL, '357852036006081', '18764048760', '890105009000290036', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222069', NULL, '357852036006594', '18762950498', '890105009000290043', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222072', NULL, '357852035993834', '18764781945', '890105009000290045', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222075', NULL, '357852035998783', '18764252866', '890105009000290046', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222085', NULL, '357852036021502', '18763660057', '890105009000290052', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222091', NULL, '357852035974131', '18764074708', '890105009000290056', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222116', NULL, '357852035973133', '18765796227', '890105009000290071', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222140', NULL, '357852035998866', '18768928317', '890105009000290081', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222146', NULL, '357852035998718', '18764653295', '890105009000290086', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222147', NULL, '357852036020744', '18762827572', '890105009000290087', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222158', NULL, '357852035990087', '18763612112', '890105009000290098', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222196', NULL, '011104005256679', '18763612725', '890105009000290120', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222198', NULL, '011104005256984', '18763698336', '890105009000290121', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222200', NULL, '011104005258238', '18763613461', '890105009000290122', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17222209', NULL, '011104005256497', '18764690973', '890105009000290127', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17239190', NULL, '357852036006800', '18763710978', '890105009000286651', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17239192', NULL, '357852035417099', '18764329195', '890105009000286653', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17239196', NULL, '357852035414583', '18764337382', '890105009000286657', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17239200', NULL, '357852035414559', '18764222307', '890105009000286661', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17239208', NULL, '357852035973885', '18763710787', '890105009000286669', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17239215', NULL, '357852035417008', '18764336797', '890105009000286676', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17239220', NULL, '357852035982209', '18764122455', '890105009000286681', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17239230', NULL, '357852035417115', '18764897283', '890105009000286691', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17239233', NULL, '357852035968075', '18763711584', '890105009000286694', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17239249', NULL, '357852035432858', '18764080577', '890105009000286710', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17239257', NULL, '357852035410896', '18764479680', '890105009000286718', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17239287', NULL, '357852035433260', '18764149680', '890105009000286748', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17239307', NULL, '357852035410938', '18764024410', '890105009000286568', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17239316', NULL, '357852035433757', '18762834684', '890105009000286577', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17239319', NULL, '357852035433765', '18768492050', '890105009000286580', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17809526', NULL, '358696044592643', '18764393997', '890105003000327753', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17809540', NULL, '358696044581760', '18764288467', '890105003000327764', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17809548', NULL, '358696044562489', '18762864728', '890105003000327771', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17809549', NULL, '358696044531914', '18764691214', '890105003000327772', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17809556', NULL, '358696044581752', '18765645246', '890105003000327779', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17809559', NULL, '358696044621756', '18764021068', '890105003000327781', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17809570', NULL, '358696044593393', '18763826432', '890105003000327788', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17809573', NULL, '358696044593468', '18764363163', '890105003000327791', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17809574', NULL, '358696044593476', '18764424140', '890105003000327792', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17809576', NULL, '358696044586413', '18763814289', '890105003000327794', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17809602', NULL, '358696044622119', '18764280411', '890105003000327802', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17809619', NULL, '358696044580010', '18765641769', '890105003000327819', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17809621', NULL, '358696044579434', '18763615722', '890105003000327821', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17809636', NULL, '358696044585167', '18764304359', '890105003000327836', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17809637', NULL, '358696044592684', '18764284409', '890105003000327837', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17809647', NULL, '358696044592668', '18764020903', '890105003000327847', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17809649', NULL, '358696044580986', '18762798108', '890105003000327849', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835397', NULL, '358696044577776', '18764520851', '890105004000343160', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835407', NULL, '358696044621798', '18763596131', '890105004000343170', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835409', NULL, '358696044599838', '18764468100', '890105004000343172', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835411', NULL, '358696044599762', '18765773518', '890105004000343174', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835437', NULL, '358696044577859', '18765645223', '890105004000343185', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835502', NULL, '358696044582297', '18762985564', '890105004000343212', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835521', NULL, '358696044599655', '18762956342', '890105004000343231', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835533', NULL, '358696044591793', '18764211667', '890105004000343243', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835571', NULL, '358696044594037', '18768780172', '890105004000343251', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835713', NULL, '358696044580150', '18763824691', '890105004000343367', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835715', NULL, '358696044580127', '18765647857', '890105004000343369', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835725', NULL, '358696044599770', '18764364935', '890105004000343379', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835727', NULL, '358696044599804', '18764172028', '890105004000343381', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835735', NULL, '358696044576067', '18764403879', '890105004000343389', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835737', NULL, '358696044579731', '18765778906', '890105004000343391', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835739', NULL, '358696044586652', '18764528819', '890105004000343392', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835744', NULL, '358696044593757', '18768780614', '890105004000343394', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835755', NULL, '358696044582206', '18763712671', '890105004000343397', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835762', NULL, '358696044591611', '18764693059', '890105004000343400', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835788', NULL, '358696044579202', '18764708226', '890105004000343418', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835790', NULL, '358696044600099', '18765090332', '890105004000343420', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835797', NULL, '358696044598822', '18763824154', '890105004000343427', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835803', NULL, '358696044582891', '18765641517', '890105004000343433', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17835809', NULL, '358696044586397', '18768816848', '890105004000343437', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837402', NULL, '358696044575929', '18768780160', '890105004000344257', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837425', NULL, '358696044587932', '18764292245', '890105004000344268', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837430', NULL, '358696044591561', '18762857515', '890105004000344271', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837435', NULL, '358696044576695', '18768780408', '890105004000344276', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837437', NULL, '357852035973844', '18764394607', '890105004000344278', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837452', NULL, '358696044586660', '18762867219', '890105004000344291', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837457', NULL, '358696044579590', '18764691924', '890105004000344293', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837465', NULL, '358696044579608', '18765642478', '890105004000344296', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837468', NULL, '358696044581240', '18768780433', '890105004000344298', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837496', NULL, '358696044591512', '18763811283', '890105004000344308', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837499', NULL, '358696044592007', '18764468413', '890105004000344309', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837519', NULL, '358696044591942', '18768816857', '890105004000344317', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837539', NULL, '358696044586496', '18764692691', '890105004000344326', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837543', NULL, '358696044587890', '18765642709', '890105004000344330', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837547', NULL, '358696044576059', '18765646823', '890105004000344334', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837549', NULL, '358696044580028', '18764480571', '890105004000344336', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837553', NULL, '358696044621343', '18768489386', '890105004000344340', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837554', NULL, '358696044587064', '18764308912', '890105004000344341', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837555', NULL, '358696044587056', '18764370936', '890105004000344342', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837601', NULL, '358696044575960', '18763622393', '890105004000344363', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837605', NULL, '358696044582883', '18764435738', '890105004000344365', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837607', NULL, '358696044576968', '18762986612', '890105004000344366', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837609', NULL, '357852036001637', '18764292333', '890105004000344367', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837626', NULL, '358696044585118', '18764394489', '890105004000344374', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837638', NULL, '358696044579905', '18765773521', '890105004000344380', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837640', NULL, '358696044579814', '18764194152', '890105004000344382', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837647', NULL, '358696044599564', '18763828153', '890105004000344389', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837685', NULL, '358696044575994', '18763833156', '890105004000344415', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837693', NULL, '358696044579335', '18762985894', '890105004000344420', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837697', NULL, '358696044579194', '18765773545', '890105004000344422', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837706', NULL, '358696044526005', '18764507103', '890105004000344427', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837724', NULL, '358696044508300', '18762985769', '890105004000344434', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837738', NULL, '358696044556846', '18762864360', '890105004000344440', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837761', NULL, '358696044582289', '18764634113', '890105004000344448', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17837764', NULL, '358696044582255', '18765647746', '890105004000344451', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17943915', NULL, '011104005624900', '18765645376', '890105005000349762', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17943920 ', NULL, '011104005625063', '18762909718', '890105005000349767', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17943926 ', NULL, '011104005625022', '18765798445', '890105005000349773', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17943936 ', NULL, '011104005623084', '18762896739', '890105005000349783', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17943945 ', NULL, '011104005623472', '18762909685', '890105005000349792', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D17943947 ', NULL, '011104005638777', '18764038483', '890105005000349794', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18503596', NULL, '351802057713020', '18764616032', '890105007000375506', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18503605', NULL, '351802057708657', '18762806204', '890105007000375515', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18503609', NULL, '351802057680864', '18762985168', '890105007000375519', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18503625', NULL, '353301050251664', '18762986995', '890105007000375535', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18504252', NULL, '353301050274096', '18764613554', '890105007000376162', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18504254', NULL, '353301050286330', '18764691033', '890105007000376164', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18504274', NULL, '353301050285050', '18763829564', '890105007000376184', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18504586', NULL, '011104005256323', '18762816397', '890105007000376496', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18595017 ', NULL, '351802057680930', '18765722795', '890105002000398487', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18595024 ', NULL, '351802057699070', '18764854714', '890105002000398494', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18595034 ', NULL, '351802057674859', '18768534352', '890105002000398504', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18595971', NULL, '353301055492412', '18765893256', '890105007000377433', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18596033 ', NULL, '353301054314013', '18764379774', '890105007000377495', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18596037 ', NULL, '353301054325530', '18764635347', '890105007000377499', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18680349', NULL, '353301058212130', '18765090863 ', '890105002000399178', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18680366', NULL, '353301058202388', '18765090450', '890105002000399195', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18680371', NULL, '353301058203824', '18764404503', '890105002000399200', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18680375', NULL, '353301058204160', ' 18762785804', '890105002000399204', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18680382', NULL, '353301058203808', ' 18765090445', '890105002000399211', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18680387', NULL, '353301054325597', '18762826024', '890105002000399216', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18680411', NULL, '353301054313890', '18764410302', '890105002000399240', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18680424', NULL, '353301054313817', '18764737616', '890105002000399253', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18680433', NULL, '353301054311886', '18764413392', '890105002000399262', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18680440', NULL, '353301058321113', '18763671869', '890105002000399269', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18680452', NULL, '353301058200572', '18764027974', '890105002000399281', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18680476', NULL, '353301054262709', ' 18762791984', '890105002000399305', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18680483', NULL, '353301058204475', ' 18762792331', '890105002000399312', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683159', NULL, '355233052759246', '18764361425', '890105002000401988', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683200', NULL, '355233052759105', '18768781205', '890105002000402029', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683201', NULL, '355233052748975', '18768775326', '890105002000402030', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683213', NULL, '355233052746920', '18768781225', '890105002000402042', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683277', NULL, '355233050925369', '18763792683', '890105002000402106', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683279', NULL, '355233050891066', '18768781214', '890105002000402108', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683286', NULL, '355233052758263', '18764292558', '890105002000402115', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683291', NULL, '355233052758313', '18765773692', '890105002000402120', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683314', NULL, '355233052714068', '18768780132', '890105002000402143', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683317', NULL, '355233052758230', '18763989272', '890105002000402146', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683321', NULL, '355233054152606', '18764023391', '890105002000402150', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683339', NULL, '355233050925724', '18768781220', '890105002000402168', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683349', NULL, '355233050890308', '18762959695', '890105002000402178', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683383', NULL, '355233050924271', '18764302068', '890105002000402212', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683394', NULL, '355233052747209', '18768781163', '890105002000402223', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683408', NULL, '355233052741137', '18768781139', '890105002000402237', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683416', NULL, '355233052707856', '18768781147', '890105002000402246', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683853', NULL, '355233054076912', '18763835975', '890105002000402682', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683874', NULL, '355233050923836', '18762760770', '890105002000402703', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683935', NULL, '355233052748454', '18763888793', '890105002000402764', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683947', NULL, '355233050924263', '18764546842', '890105002000402776', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683959', NULL, '355233052714910', '18762868950', '890105002000402788', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683963', NULL, '355233052748405', '18762908064', '890105002000402792', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683980', NULL, '355233052760905', '18762764807', '890105002000402809', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18683993', NULL, '355233054124001', '18762767706', '890105002000402822', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18684008', NULL, '355233054131535', '18762843190', '890105002000402837', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18684014', NULL, '355233054124043', '18764705450', '890105002000402843', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18684016', NULL, '355233054076540', '18764136954', '890105002000402845', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18684018', NULL, '355233054129513', '18764384364', '890105002000402847', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18684019', NULL, '355233054128309', '18763526018', '890105002000402848', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18684187', NULL, '355233052714399', '18764524654', '890105002000403016', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18684208', NULL, '355233054157803', '18763739332', '890105002000403037', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18684221', NULL, '355233054157050', '18764525139', '890105002000403050', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18684565', NULL, '355233054125131', '18765643008', '890105005000403400', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18684570', NULL, '355233054128366', '18762759065', '890105005000403405', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18684586', NULL, '355233054131345', '18764540908', '890105005000403420', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18684641', NULL, '355233054157357', '18764050450', '890105005000403475', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18684651', NULL, '355233054146574', '18763739114', '890105005000403485', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18684657', NULL, '355233054146525', '18763640809', '890105005000403491', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18899159', NULL, '355233053464366', '18762911030', '890105005000404586', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18899164', NULL, '355233053466429', '18763986035', '890105005000404591', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18899170', NULL, '355233053467237', '18764488014', '890105005000404597', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18899178', NULL, '355233053466742', '18762950493', '890105005000404605', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18899187', NULL, '355233053464358', '18762932080', '890105005000404614', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18899200', NULL, '355233053529614', '18765643832', '890105005000404621', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18899220', NULL, '355233053464556', '18765644904', '890105005000404632', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18899225', NULL, '355233053527188', '18762950140', '890105005000404635', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18899242', NULL, '355233053527196', '18762986672', '890105005000404645', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18899246', NULL, '355233053511869', '18765641546', '890105005000404647', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18899261', NULL, '355233053467906', '18764320636', '890105005000404654', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18899263', NULL, '355233053467955', '18764413072', '890105005000404655', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18899363', NULL, '355233053467021', '18764487479', '890105005000404700', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18899399', NULL, '355233053511729', '18764012439', '890105005000404719', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18899480', NULL, '355233050924040', '18763689415', '890105005000404747', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18900883', NULL, '357207055746697', '18763836744', '890105005000405021', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18900889', NULL, '357207055737423', '18764690420', '890105005000405027', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18900928', NULL, '357207055746531', '18768817244', '890105005000405066', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997155', NULL, '355233054126451', '18763711247', '890105011000417156', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997159', NULL, '355233054127525', '18764477252', '890105011000417160', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997174', NULL, '355233054147424', '18764174430', '890105011000417175', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997177', NULL, '355233054156672', '18763612676', '890105011000417178', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997206', NULL, '355233054147648', '18763825248', '890105011000416909', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997218', NULL, '355233054146657', '18764855549', '890105011000416921', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997219', NULL, '355233054148620', '18764276561', '890105011000416922', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997222', NULL, '355233054154768', '18764865998', '890105011000416925', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997223', NULL, '355233054157761', '18764279011', '890105011000416926', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997225', NULL, '355233054126543', '18762470468', '890105011000416928', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997257', NULL, '355233054126535', '18764298798', '890105011000416960', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997260', NULL, '355233054124019', '18762799105', '890105011000416963', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997299', NULL, '355233054157787', '18764357276', '890105011000417002', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997310', NULL, '355233050923802', '18762470481', '890105011000417013', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997331', NULL, '355233054147457', '18764372169', '890105011000417034', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997333', NULL, '355233054154875', '18764277696', '890105011000417036', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997344', NULL, '355233054154818', '18764279384', '890105011000417047', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997377', NULL, '355233053511828', '18764279316', '890105011000417080', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997384', NULL, '355233054146558', '18763814129', '890105011000417087', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997386', NULL, '355233054148646', '18764293160', '890105011000417089', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997395', NULL, '355233054124530', '18768781014', '890105011000417098', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997402', NULL, '355233054126493', '18765773066', '890105011000417105', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997408', NULL, '355233054130040', '18763825979', '890105011000417111', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997418', NULL, '355233054126477', '18762470482', '890105011000417121', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D18997433', NULL, '355233054127426', '18763612622', '890105011000417136', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19034796', NULL, '357207057440646', '18763671719', '890105011000417789', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19034862', NULL, '357207057544900', '18765797085', '890105011000417804', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19034867', NULL, '357207057438848', '18768782669', '890105011000417809', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19034882', NULL, '357207057440331', '18765798839', '890105011000417812', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19034884', NULL, '357207057440604', '18768784239', '890105011000417813', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19034963', NULL, '357207057544447', '18765641989', '890105011000417827', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19034988', NULL, '357207056421357', '18765799130', '890105011000417836', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19035061', NULL, '357207055746762', '18765779150', '890105011000417840', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19035125', NULL, '355233054110117', '18765797192', '890105011000417843', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19035197', NULL, '357207055736763', '18765778992', '890105011000417881', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19035395', NULL, '357207056421316', '18765644957', '890105011000417895', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19035491', NULL, '357207057440497', '18765798516', '890105011000417918', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19035517', NULL, '357207057637712', '18765798945', '890105011000417925', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19035521', NULL, '357207057437402', '18765645266', '890105011000417929', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19035523', NULL, '357207057543613', '18765797614', '890105011000417931', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19035525', NULL, '357207057594582', '18765797564', '890105011000417933', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19035577', NULL, '357207057543605', '18763575643', '890105011000417983', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039162', NULL, '357207056407547', '18764198436', '890105011000421503', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039167', NULL, '357207056431265', '18764205332', '890105011000421508', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039170', NULL, '357207056407885', '18763748363', '890105011000421511', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039176', NULL, '357207056407281', '18762875645', '890105011000421517', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039208', NULL, '357207056421407', '18765640825', '890105011000421530', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039211', NULL, '355233054111990', '18765641260', '890105011000421532', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039332', NULL, '355233050924115', '18768815609', '890105011000421571', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039400', NULL, '355233050924560', '18765773190', '890105011000421588', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039408', NULL, '357207057637266', '18765795523', '890105011000421589', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039412', NULL, '357207057440547', '18762776206', '890105011000421593', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039414', NULL, '357207057456170', '18768784226', '890105011000421595', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039420', NULL, '357207057546145', '18765796283', '890105011000421601', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039438', NULL, '357207057544967', '18765796236', '890105011000421617', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039442', NULL, '357207057546137', '18765798891', '890105011000421621', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039465', NULL, '357207057440679', '18768784336', '890105011000421636', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039505', NULL, '355233050925096', '18768816952', '890105011000421641', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039520', NULL, '355233050924446', '18764690939', '890105011000421648', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039535', NULL, '355233054111925', '18765799172', '890105011000421663', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039543', NULL, '355233050924503', '18768815591', '890105011000421671', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039545', NULL, '355233050924529', '18763925739', '890105011000421673', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039552', NULL, '357207055745137', '18765798660', '890105011000421675', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039555', NULL, '357207055737308', '18765640457', '890105011000421677', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039557', NULL, '357207055746218', '18765799143', '890105011000421678', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039559', NULL, '357207057636599', '18768782644', '890105011000421679', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19039576', NULL, '357207055737324', '18765799150', '890105011000421685', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19041109', NULL, '357207057544512', '18768976257', '890105011000422242', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19041113', NULL, '357207057436891', '18763591816', '890105011000422244', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19041140', NULL, '355233054119902', '18765799235', '890105011000422262', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19041153', NULL, '357207056407315', '18768782643', '890105011000422272', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19041197', NULL, '355233054111248', '18765798620', '890105011000422285', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19041820', NULL, '357207056410871', '18765797238', '890105011000424471', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19041825', NULL, '357207057436925', '18765798786', '890105011000424476', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19041829', NULL, '357207056407349', '18765798651', '890105011000424480', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19041833', NULL, '357207056408057', '18764692450', '890105011000424484', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19100599', NULL, '357207055746267', '18762986713', '890105011000427485', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19100754', NULL, '355233054160898', '18764506354', '890105011000427588', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19100765', NULL, '355233054147259', '18768787344', '890105011000427599', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19100773', NULL, '355233054157381', '18762985374', '890105011000427607', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19100778', NULL, '357207056397581', '18764692063', '890105011000427612', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19100802', NULL, '357207055744452', '18763827566', '890105011000427636', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19100803', NULL, '357207055744494', '18763710870', '890105011000427637', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19100823', NULL, '355233054123532', '18763833818', '890105011000427648', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19100838', NULL, '355233054123789', '18764505857', '890105011000427656', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19100845', NULL, '355233054045479', '18768696306', '890105011000427660', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19100850', NULL, '355233054122708', '18763812786', '890105011000427661', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19100860', NULL, '355233054121577', '18764691737', '890105011000427668', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19100879', NULL, '355233054122658', '18764505536', '890105011000427679', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19100911', NULL, '355233054123797', '18764708297', '890105011000427700', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19100934', NULL, '355233054121619', '18765773048', '890105011000427717', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19100942', NULL, '355233054121247', '18762942320', '890105011000427724', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19100956', NULL, '355233054123466', '18765773282', '890105011000427734', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19100985', NULL, '357207055712772', '18762934485', '890105011000427745', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19100994', NULL, '357207055747315', '18763814061', '890105011000427750', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19101016', NULL, '357207055744486', '18765773362', '890105011000427761', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19101018', NULL, '357207055744171', '18765773213', '890105011000427762', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19101021', NULL, '357207055747323', '18764090536', '890105011000427763', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19101037', NULL, '357207055747307', '18764010060', '890105011000427772', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19101048', NULL, '357207056410319', '18763614882', '890105011000427779', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19101051', NULL, '357207055712707', '18763831353', '890105011000427782', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19103171', NULL, '357207057595449', '18765799148', '890105011000429823', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19103184', NULL, '357207057637134', '18762767671', '890105011000429833', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19107952', NULL, '357207057637464', '18768782628', '890105001000433393', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19107956', NULL, '357207057435596', '18768784263', '890105001000433396', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19107960', NULL, '357207057637647', '18765798473', '890105001000433399', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19108059', NULL, '357207057636581', '18765799259', '890105001000433478', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19110369', NULL, '357207057636052', '18765798513', '890105001000439664', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19110418', NULL, '357207057661670', '18768781449', '890105001000439713', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	('D19110422', NULL, '357207057545055', '18765798666', '890105001000439717', 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07');
/*!40000 ALTER TABLE `devices_log` ENABLE KEYS */;


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

-- Dumping data for table bunio_vts.device_assignments: ~560 rows (approximately)
/*!40000 ALTER TABLE `device_assignments` DISABLE KEYS */;
INSERT INTO `device_assignments` (`customer_id`, `d_number`, `installation_date`, `installation_fee`, `subscription_fee`, `additional_features`, `technician`, `job_description`, `services`) VALUES
	(4832, 'D19100823', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(4835, 'D17835744', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4837, 'D16121558', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4840, 'D14286848', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4841, 'D16087343', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4842, 'D17239196', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4845, 'D18683279', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4849, 'D19034882', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4852, 'D17221994', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4853, 'D17222001', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4854, 'D18683408', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4858, 'D18683291', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4863, 'D14286905', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4865, 'D14284084', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4866, 'D14283829', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4870, 'D15164902', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4871, 'D16087336', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4894, 'D15469731', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4896, 'D16121615', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4900, 'D17809649', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4905, 'D15163761', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4911, 'D18997299', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4915, 'D17221978', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4922, 'D18683935', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4927, 'D15470300', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(4934, 'D18899225', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4935, 'D16121584', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4936, 'D19107956', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4942, 'D16087292', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4943, 'D17221917', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4944, 'D17221815', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4945, 'D17222198', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4946, 'D18899261', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4955, 'D16087483', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4964, 'D18997310', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(4967, 'D14970574', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4968, 'D17809636', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4969, 'D17837601', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4981, 'D17239319', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4983, 'D17239192', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4985, 'D17837539', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4989, 'D15163749', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(4996, 'D17239257', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5001, 'D15163752', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5003, 'D19035517', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5005, 'D17837549', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5007, 'D18680375', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5014, 'D17837553', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5016, 'D17221009', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5022, 'D17221309', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5023, 'D17837499', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5029, 'D17221767', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5032, 'D18684187', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5034, 'D18684657', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5038, 'D18504252', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5039, 'D19100942', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5040, 'D19100879', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5041, 'D19100838', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo'),
	(5043, 'D17809548', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5055, 'D17222196', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5058, 'D19101051', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5059, 'D17222023', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5061, 'D15163738', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5068, 'D16087265', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5072, 'D19100985', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5073, 'D17837647', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5076, 'D18997377', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5077, 'D15166798', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5079, 'D14969977', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5082, 'D14970503', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5083, 'D14286805', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5090, 'D17221819', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5091, 'D16087407', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5092, 'D16121570', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5093, 'D18683980', NULL, NULL, NULL, NULL, NULL, NULL, 'MOBAY'),
	(5094, 'D18680476', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5103, 'D18680440', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5108, 'D18997433', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5109, 'D18899246', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5117, 'D14969973', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5131, 'D17221894', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5132, 'D17221172', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5133, 'D17221961', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5134, 'D17943945 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5148, 'D15025084', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5151, 'D19100773', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5155, 'D18683416', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5158, 'D15470492', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5159, 'D15166593', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5160, 'D15164924', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5161, 'D16121716', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5162, 'D16121715', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5163, 'D17835788', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5164, 'D17837496', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5168, 'D18683286', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5171, 'D15166973', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5176, 'D18997402', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5190, 'D14970667', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5191, 'D14283891', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5203, 'D17221769', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5207, 'D14969813', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5211, 'D14969936', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5212, 'D17809573', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5216, 'D19041833', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5219, 'D17221761', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5220, 'D18503609', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5222, 'D17837437', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5227, 'D18683201', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5231, 'D17221939', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5232, 'D17221822', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5233, 'D19034988', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5235, 'D19107952', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5239, 'D14283877', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5241, 'D17222030', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5244, 'D18503605', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5248, 'D17221892', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5249, 'D19041153', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5251, 'D18899170', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5253, 'D19039545', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5255, 'D19035521', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5261, 'D19039408', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5264, 'D16121683', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5265, 'D17835521', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5270, 'D17222056', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5282, 'D19041825', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5294, 'D15470480', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5299, 'D17221987', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5301, 'D16121746', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5311, 'D17835735', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET'),
	(5313, 'D15166951', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5318, 'D18683277', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5319, 'D16121629', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5320, 'D17221902', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5331, 'D17220998', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5334, 'D16121642', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5335, 'D19034862', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5346, 'D15163577', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5347, 'D15163533', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5348, 'D15166970', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5349, 'D14969974', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5350, 'D14970513', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5356, 'D17835809', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5357, 'D15166828', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5358, 'D15166998', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5360, 'D18899164', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5361, 'D15163746', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5364, 'D14286633', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5366, 'D17837435', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5385, 'D16121733', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5386, 'D16087337', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5394, 'D17222085', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5402, 'D17835739', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5409, 'D16121751', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5411, 'D17837640', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5415, 'D15375826', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5418, 'D17837638', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5420, 'D18504274', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5426, 'D17221777', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5427, 'D17222209', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5428, 'D18997223', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5429, 'D18997257', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5440, 'D19035197', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5441, 'D16087496', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5444, 'D19039555', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5458, 'D17943915', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5459, 'D14969741', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5465, 'D17239233', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5466, 'D15166628', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5468, 'D19101021', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5469, 'D15163758', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5471, 'D14970659', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5478, 'D19041109', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5480, 'D16121729', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5482, 'D16121527', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5484, 'D17837605', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5486, 'D17221883', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5489, 'D18680382', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5490, 'D18680366', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5498, 'D17809576', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5500, 'D18595034 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5507, 'D18683959', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5509, 'D15166941', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5510, 'D19041820', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo'),
	(5515, 'D16121550', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5519, 'D18683963', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5522, 'D17221156', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5524, 'D18683349', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5527, 'D19039412', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5528, 'D19039465', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5535, 'D18503596', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5538, 'D19034884', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5548, 'D17239316', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5549, 'D17835397', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5550, 'D17222025', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5551, 'D17837452', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5553, 'D18680433', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5554, 'D14283797', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5558, 'D17835725', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5561, 'D18684014', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5563, 'D18596037 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5567, 'D18900883', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5569, 'D16121720', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5571, 'D16121543', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5573, 'D15470328', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5574, 'D17222140', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5576, 'D17239190', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5587, 'D17837425', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5588, 'D18683947', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5595, 'D14970723', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5598, 'D19039552', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5599, 'D19039167', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5608, 'D17221249', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5611, 'D18683317', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5612, 'D19100850', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo'),
	(5616, 'D17835762', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5623, 'D17221799', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5624, 'D16087327', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5625, 'D17837465', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5626, 'D18900928', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5627, 'D17835803', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5632, 'D16121555', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5633, 'D17221859', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5635, 'D19039400', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5639, 'D19100765', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5649, 'D16087208', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5650, 'D17837724', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5655, 'D15470494', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5656, 'D18683394', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5659, 'D16087499', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5663, 'D19039559', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5666, 'D14969829', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5667, 'D16087268', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5669, 'D17221132', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5675, 'D16121744', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5677, 'D19035061', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5680, 'D15166584', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5681, 'D18683321', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5686, 'D16121513', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5691, 'D16087214', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5703, 'D17837468', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5707, 'D17809621', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5712, 'D17222072', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5713, 'D17222038', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5715, 'D14286616', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5718, 'D14969756', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5719, 'D17835407', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5723, 'D19039576', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5733, 'D18684641', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5736, 'D18683213', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5744, 'D17809549', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5745, 'D18595017 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5761, 'D18997333', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5766, 'D15163766', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5767, 'D17835502', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5770, 'D17809556', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5779, '', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5786, 'D17837738', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5788, 'D19041113', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5789, 'D19034796', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5797, 'D19100803', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5799, 'D19101016', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo'),
	(5800, 'D19100778', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5804, 'D17837693', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5805, 'D17221991', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5815, 'D19110418', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5816, 'D17222015', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5817, 'D18997218', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5818, 'D18997344', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5831, 'D17222069', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5833, 'D14286691', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5834, 'D15164903', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5836, 'D16121600', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5842, 'D16087417', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5848, 'D14970563', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5851, 'D14283840', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5869, 'D16087421', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5875, 'D15166610', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5878, 'D16121750', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5880, 'D16121583', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5881, 'D17835715', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5897, 'D17837761', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5898, 'D18684570', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5901, 'D17221885', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5905, 'D18899187', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5906, 'D17239230', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5911, 'D15166974', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5912, 'D16121756', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5917, 'D15470339', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5919, 'D16087380', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5923, 'D19101018', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(5924, 'D17239249', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5927, 'D17222021', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5928, 'D17222013', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(5938, 'D16121540', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5939, 'D18997219', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5945, 'D17239307', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5947, 'D16087246', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5950, 'D17239208', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET'),
	(5952, 'D14284067', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5953, 'D17220893', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5954, 'D14969868', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5963, 'D19035395', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5969, 'D17837402', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5971, 'D19041140', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5973, 'D17837607', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5985, 'D19034867', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo'),
	(5991, 'D17837706', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(5995, 'D17239287', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6009, 'D16121731', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6013, 'D16121664', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6019, 'D15166601', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6021, 'D19100754', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo'),
	(6026, 'D18680452', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6027, 'D17943936 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6030, 'D14969905', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6039, 'D18684565', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6047, 'D16121559', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6049, 'D18900889', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6056, 'D16087430', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6061, 'D17837543', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6066, 'D17809570', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6072, 'D17837547', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6074, 'D18899363', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6076, 'D14286575', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6077, 'D14286925', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6085, 'D17809559', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6099, 'D14970610', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6100, 'D17222147', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6101, 'D19103184', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6105, 'D14286784', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6106, 'D14286952', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6107, 'D16121652', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6115, 'D17221848', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6125, 'D19035577', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6135, 'D19039520', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo'),
	(6138, 'D18997384', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6145, 'D17835790', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6153, 'D19039420', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6158, 'D19100934', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6175, 'D18683200', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6183, 'D18684016', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6188, 'D18595971', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6189, 'D15166991', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6202, 'D17809619', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6206, 'D18899159', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6220, 'D17221754', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6228, 'D18504254', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6229, 'D18684018', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6230, 'D14969818', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6232, 'D19039176', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo'),
	(6233, 'D15470477', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6240, 'D14969780', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6242, 'D18680371', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6254, 'D15166812', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6255, 'D19100994', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6258, 'D19035525', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6266, 'D18684208', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6276, 'D16087296', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6277, 'D18683314', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6278, 'D16087235', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6284, 'D17835797', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6294, 'D14970555', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6299, 'D18504586', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6302, 'D14970725', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6307, 'D16121587', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6308, 'D19039170', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6309, 'D18997174', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6311, 'D16121595', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6316, 'D17220982', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6317, 'D18680411', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6326, 'D18997395', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6328, 'D17222200', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6335, 'D17943926 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6339, 'D17837554', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6344, 'D17220975', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6353, 'D17837457', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6357, 'D14286816', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6362, 'D17222091', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6375, 'D19035491', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6379, 'D17837519', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6380, 'D19039442', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6381, 'D14283985', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6386, 'D17222116', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6389, 'D16087505', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6392, 'D17835533', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6394, 'D17809526', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6395, 'D16121657', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6396, 'D16087173', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6397, 'D16087251', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6398, 'D16087225', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6399, 'D16121658', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6401, 'D16121636', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6402, 'D16121659', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6403, 'D16087220', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6404, 'D16087212', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6406, 'D16087287', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6408, 'D17837697', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6409, 'D16087263', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6410, 'D16087223', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6411, 'D16087179', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6413, 'D17221002', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6414, 'D17221014', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6415, 'D17221982', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6416, 'D17221281', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6417, 'D17222158', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6419, 'D17835411', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6420, 'D17221756', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6423, 'D19100860', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6427, 'D18680483', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6433, 'D17835409', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6449, 'D17835713', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6452, 'D18997260', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6460, 'D18683874', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6462, 'D18595024 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6465, 'D15470302', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6468, 'D19039211', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6469, 'D17835437', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6481, 'D19039505', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6485, 'D17809647', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6488, 'D19041829', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6490, 'D19108059', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6493, 'D17222146', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6498, 'D18684651', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6503, 'D17220983', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6509, 'D18899480', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6517, 'D17221920', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6518, 'D18684008', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6519, 'D18899220', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6524, 'D17220928', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6540, 'D18684221', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6542, 'D15166994', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6549, 'D18899200', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6551, 'D17835571', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6555, 'D17221947', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6556, 'D19035523', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6557, 'D14969788', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6566, 'D18997177', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6567, 'D19101048', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6575, 'D19100956', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6580, 'D15469743', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6587, 'D18683993', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6592, 'D17809602', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6593, 'D17835755', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6597, 'D19100802', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6601, 'D18680387', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6602, 'D18680424', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6603, 'D17221155', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6604, 'D15164893', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6607, 'D17221897', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6608, 'D19035125', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo'),
	(6609, 'D14970664', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6610, 'D18997222', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6617, 'D19039414', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6621, 'D19110422', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6622, 'D19107960', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6626, 'D16087199', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6629, 'D16121695', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6631, 'D17239200', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6633, 'D18899263', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6642, 'D18997225', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6649, 'D19034963', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6650, 'D17222019', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6651, 'D17837555', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6655, 'D19100599', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6656, 'D18503625', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6659, 'D14970712', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6665, 'D17837430', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6666, 'D17221855', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6667, 'D17837626', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6668, 'D19110369', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6670, 'D19039208', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6675, 'D17221948', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6676, 'D17943947 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6680, 'D18899399', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6684, 'D17221974', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6685, 'D18683853', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6691, 'D15470323', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6693, 'D16121585', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6695, 'D16087182', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6704, 'D18899178', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6711, 'D17222075', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6717, 'D17239220', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6720, 'D16087277', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6725, 'D17221788', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6731, 'D15166630', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6741, 'D16121638', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6744, 'D18684019', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6746, 'D19103171', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6752, 'D18683383', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6758, 'D14969962', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6766, 'D14969881', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6770, 'D16121590', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6773, 'D17835737', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6778, 'D17809637', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6786, 'D17221792', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6787, 'D14970585', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6788, 'D16087347', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6790, 'D18997418', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6792, 'D17222040', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6794, 'D14969947', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6809, 'D17221191', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6810, 'D18997386', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6811, 'D17809574', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6817, 'D17221995', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6822, 'D17835727', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6823, 'D19039438', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6825, 'D18596033 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6830, 'D19101037', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo'),
	(6834, 'D19039557', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6846, 'D18684586', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6851, 'D16121753', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET'),
	(6853, 'D17221183', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6854, 'D17221849', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6855, 'D16087332', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET'),
	(6857, 'D17221303', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET'),
	(6863, 'D14969970', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6864, 'D18680349', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6866, 'D19039535', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo'),
	(6870, 'D15163767', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6871, 'D19041197', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo'),
	(6872, 'D17837609', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6873, 'D15025093', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6875, 'D15166959', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6876, 'D15166953', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6877, 'D18899242', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6878, 'D19039332', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo'),
	(6879, 'D19039543', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo'),
	(6880, 'D19039162', NULL, NULL, NULL, NULL, NULL, NULL, 'combo'),
	(6885, 'D17809540', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6886, 'D17221831', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6889, 'D17239215', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET'),
	(6891, 'D14284079', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6893, 'D18997155', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6894, 'D18683339', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6897, 'D16121650', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6898, 'D16087184', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6900, 'D18997159', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6903, 'D18997331', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6905, 'D19100911', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY'),
	(6908, 'D17221967', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6911, 'D17943920 ', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6912, 'D18997408', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo'),
	(6913, 'D18997206', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo'),
	(6914, 'D18683159', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6916, 'D17837685', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6917, 'D17221004', NULL, NULL, NULL, NULL, NULL, NULL, 'Security'),
	(6918, 'D17837764', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6920, 'D15166597', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6921, 'D15163772', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6922, 'D19100845', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6924, 'D15470342', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET'),
	(6927, 'D14969930', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6928, 'D14970541', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6929, 'D14969956', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6931, 'D14286618', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6932, 'D14969755', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6933, 'D14969972', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6934, 'D14969857', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6937, 'D14970618', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO'),
	(6938, 'D14970710', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO');
/*!40000 ALTER TABLE `device_assignments` ENABLE KEYS */;


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

-- Dumping data for table bunio_vts.device_assignments_log: 1,120 rows
/*!40000 ALTER TABLE `device_assignments_log` DISABLE KEYS */;
INSERT INTO `device_assignments_log` (`customer_id`, `d_number`, `installation_date`, `installation_fee`, `subscription_fee`, `additional_features`, `technician`, `job_description`, `services`, `user_id`, `machine`, `ip_address`, `action`, `action_type`, `log_date`) VALUES
	(4832, 'D19100823', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4835, 'D17835744', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4837, 'D16121558', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4840, 'D14286848', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4841, 'D16087343', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4842, 'D17239196', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4845, 'D18683279', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4849, 'D19034882', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4852, 'D17221994', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4853, 'D17222001', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4854, 'D18683408', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4858, 'D18683291', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4863, 'D14286905', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4865, 'D14284084', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4866, 'D14283829', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4870, 'D15164902', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4871, 'D16087336', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4894, 'D15469731', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4896, 'D16121615', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4900, 'D17809649', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4905, 'D15163761', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4911, 'D18997299', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4915, 'D17221978', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4922, 'D18683935', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4927, 'D15470300', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4934, 'D18899225', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4935, 'D16121584', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4936, 'D19107956', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4942, 'D16087292', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4943, 'D17221917', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4944, 'D17221815', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4945, 'D17222198', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4946, 'D18899261', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4955, 'D16087483', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4964, 'D18997310', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4967, 'D14970574', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4968, 'D17809636', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4969, 'D17837601', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4981, 'D17239319', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4983, 'D17239192', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4985, 'D17837539', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4989, 'D15163749', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4996, 'D17239257', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5001, 'D15163752', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5003, 'D19035517', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5005, 'D17837549', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5007, 'D18680375', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5014, 'D17837553', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5016, 'D17221009', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5022, 'D17221309', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5023, 'D17837499', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5029, 'D17221767', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5032, 'D18684187', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5034, 'D18684657', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5038, 'D18504252', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5039, 'D19100942', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5040, 'D19100879', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5041, 'D19100838', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5043, 'D17809548', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5055, 'D17222196', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5058, 'D19101051', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5059, 'D17222023', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5061, 'D15163738', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5068, 'D16087265', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5072, 'D19100985', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5073, 'D17837647', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5076, 'D18997377', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5077, 'D15166798', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5079, 'D14969977', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5082, 'D14970503', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5083, 'D14286805', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5090, 'D17221819', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5091, 'D16087407', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5092, 'D16121570', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5093, 'D18683980', NULL, NULL, NULL, NULL, NULL, NULL, 'MOBAY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5094, 'D18680476', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5103, 'D18680440', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5108, 'D18997433', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5109, 'D18899246', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5117, 'D14969973', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5131, 'D17221894', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5132, 'D17221172', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5133, 'D17221961', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5134, 'D17943945 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5148, 'D15025084', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5151, 'D19100773', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5155, 'D18683416', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5158, 'D15470492', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5159, 'D15166593', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5160, 'D15164924', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5161, 'D16121716', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5162, 'D16121715', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5163, 'D17835788', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5164, 'D17837496', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5168, 'D18683286', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5171, 'D15166973', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5176, 'D18997402', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5190, 'D14970667', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5191, 'D14283891', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5203, 'D17221769', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5207, 'D14969813', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5211, 'D14969936', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5212, 'D17809573', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5216, 'D19041833', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5219, 'D17221761', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5220, 'D18503609', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5222, 'D17837437', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5227, 'D18683201', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5231, 'D17221939', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5232, 'D17221822', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5233, 'D19034988', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5235, 'D19107952', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5239, 'D14283877', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5241, 'D17222030', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5244, 'D18503605', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5248, 'D17221892', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5249, 'D19041153', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5251, 'D18899170', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5253, 'D19039545', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5255, 'D19035521', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5261, 'D19039408', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5264, 'D16121683', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5265, 'D17835521', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5270, 'D17222056', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5282, 'D19041825', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5294, 'D15470480', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5299, 'D17221987', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5301, 'D16121746', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5311, 'D17835735', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5313, 'D15166951', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5318, 'D18683277', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5319, 'D16121629', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5320, 'D17221902', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5331, 'D17220998', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5334, 'D16121642', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5335, 'D19034862', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5346, 'D15163577', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5347, 'D15163533', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5348, 'D15166970', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5349, 'D14969974', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5350, 'D14970513', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5356, 'D17835809', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5357, 'D15166828', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5358, 'D15166998', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5360, 'D18899164', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5361, 'D15163746', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5364, 'D14286633', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5366, 'D17837435', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5385, 'D16121733', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5386, 'D16087337', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5394, 'D17222085', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5402, 'D17835739', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5409, 'D16121751', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5411, 'D17837640', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5415, 'D15375826', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5418, 'D17837638', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5420, 'D18504274', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5426, 'D17221777', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5427, 'D17222209', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5428, 'D18997223', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5429, 'D18997257', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5440, 'D19035197', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5441, 'D16087496', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5444, 'D19039555', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5458, 'D17943915', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5459, 'D14969741', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5465, 'D17239233', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5466, 'D15166628', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5468, 'D19101021', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5469, 'D15163758', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5471, 'D14970659', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5478, 'D19041109', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5480, 'D16121729', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5482, 'D16121527', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5484, 'D17837605', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5486, 'D17221883', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5489, 'D18680382', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5490, 'D18680366', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5498, 'D17809576', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5500, 'D18595034 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5507, 'D18683959', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5509, 'D15166941', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5510, 'D19041820', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5515, 'D16121550', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5519, 'D18683963', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5522, 'D17221156', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5524, 'D18683349', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5527, 'D19039412', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5528, 'D19039465', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5535, 'D18503596', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5538, 'D19034884', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5548, 'D17239316', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5549, 'D17835397', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5550, 'D17222025', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5551, 'D17837452', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5553, 'D18680433', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5554, 'D14283797', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5558, 'D17835725', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5561, 'D18684014', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5563, 'D18596037 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5567, 'D18900883', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5569, 'D16121720', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5571, 'D16121543', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5573, 'D15470328', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5574, 'D17222140', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5576, 'D17239190', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5587, 'D17837425', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5588, 'D18683947', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5595, 'D14970723', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5598, 'D19039552', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5599, 'D19039167', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5608, 'D17221249', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5611, 'D18683317', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5612, 'D19100850', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5616, 'D17835762', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5623, 'D17221799', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5624, 'D16087327', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5625, 'D17837465', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5626, 'D18900928', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5627, 'D17835803', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5632, 'D16121555', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5633, 'D17221859', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5635, 'D19039400', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5639, 'D19100765', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5649, 'D16087208', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5650, 'D17837724', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5655, 'D15470494', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5656, 'D18683394', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5659, 'D16087499', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5663, 'D19039559', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5666, 'D14969829', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5667, 'D16087268', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5669, 'D17221132', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5675, 'D16121744', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5677, 'D19035061', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5680, 'D15166584', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5681, 'D18683321', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5686, 'D16121513', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5691, 'D16087214', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5703, 'D17837468', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5707, 'D17809621', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5712, 'D17222072', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5713, 'D17222038', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5715, 'D14286616', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5718, 'D14969756', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5719, 'D17835407', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5723, 'D19039576', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5733, 'D18684641', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5736, 'D18683213', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5744, 'D17809549', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5745, 'D18595017 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5761, 'D18997333', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5766, 'D15163766', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5767, 'D17835502', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5770, 'D17809556', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5779, '', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5786, 'D17837738', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5788, 'D19041113', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5789, 'D19034796', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5797, 'D19100803', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5799, 'D19101016', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5800, 'D19100778', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5804, 'D17837693', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5805, 'D17221991', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5815, 'D19110418', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5816, 'D17222015', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5817, 'D18997218', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5818, 'D18997344', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5831, 'D17222069', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5833, 'D14286691', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5834, 'D15164903', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5836, 'D16121600', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5842, 'D16087417', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5848, 'D14970563', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5851, 'D14283840', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5869, 'D16087421', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5875, 'D15166610', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5878, 'D16121750', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5880, 'D16121583', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5881, 'D17835715', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5897, 'D17837761', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5898, 'D18684570', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5901, 'D17221885', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5905, 'D18899187', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5906, 'D17239230', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5911, 'D15166974', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5912, 'D16121756', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5917, 'D15470339', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5919, 'D16087380', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5923, 'D19101018', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5924, 'D17239249', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5927, 'D17222021', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5928, 'D17222013', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5938, 'D16121540', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5939, 'D18997219', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5945, 'D17239307', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5947, 'D16087246', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5950, 'D17239208', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5952, 'D14284067', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5953, 'D17220893', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5954, 'D14969868', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5963, 'D19035395', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5969, 'D17837402', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5971, 'D19041140', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5973, 'D17837607', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5985, 'D19034867', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5991, 'D17837706', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(5995, 'D17239287', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6009, 'D16121731', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6013, 'D16121664', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6019, 'D15166601', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6021, 'D19100754', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6026, 'D18680452', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6027, 'D17943936 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6030, 'D14969905', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6039, 'D18684565', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6047, 'D16121559', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6049, 'D18900889', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6056, 'D16087430', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6061, 'D17837543', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6066, 'D17809570', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6072, 'D17837547', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6074, 'D18899363', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6076, 'D14286575', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6077, 'D14286925', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6085, 'D17809559', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6099, 'D14970610', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6100, 'D17222147', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6101, 'D19103184', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6105, 'D14286784', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6106, 'D14286952', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6107, 'D16121652', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6115, 'D17221848', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6125, 'D19035577', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6135, 'D19039520', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6138, 'D18997384', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6145, 'D17835790', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6153, 'D19039420', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6158, 'D19100934', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6175, 'D18683200', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6183, 'D18684016', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6188, 'D18595971', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6189, 'D15166991', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6202, 'D17809619', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6206, 'D18899159', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6220, 'D17221754', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6228, 'D18504254', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6229, 'D18684018', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6230, 'D14969818', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6232, 'D19039176', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6233, 'D15470477', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6240, 'D14969780', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6242, 'D18680371', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6254, 'D15166812', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6255, 'D19100994', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6258, 'D19035525', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6266, 'D18684208', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6276, 'D16087296', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6277, 'D18683314', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6278, 'D16087235', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6284, 'D17835797', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6294, 'D14970555', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6299, 'D18504586', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6302, 'D14970725', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6307, 'D16121587', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6308, 'D19039170', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6309, 'D18997174', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6311, 'D16121595', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6316, 'D17220982', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6317, 'D18680411', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6326, 'D18997395', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6328, 'D17222200', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6335, 'D17943926 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6339, 'D17837554', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6344, 'D17220975', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6353, 'D17837457', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6357, 'D14286816', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6362, 'D17222091', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6375, 'D19035491', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6379, 'D17837519', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6380, 'D19039442', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6381, 'D14283985', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6386, 'D17222116', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6389, 'D16087505', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6392, 'D17835533', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6394, 'D17809526', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6395, 'D16121657', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6396, 'D16087173', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6397, 'D16087251', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6398, 'D16087225', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6399, 'D16121658', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6401, 'D16121636', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6402, 'D16121659', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6403, 'D16087220', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6404, 'D16087212', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6406, 'D16087287', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6408, 'D17837697', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6409, 'D16087263', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6410, 'D16087223', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6411, 'D16087179', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6413, 'D17221002', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6414, 'D17221014', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6415, 'D17221982', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6416, 'D17221281', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6417, 'D17222158', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6419, 'D17835411', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6420, 'D17221756', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6423, 'D19100860', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6427, 'D18680483', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6433, 'D17835409', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6449, 'D17835713', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6452, 'D18997260', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6460, 'D18683874', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6462, 'D18595024 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6465, 'D15470302', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6468, 'D19039211', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6469, 'D17835437', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6481, 'D19039505', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6485, 'D17809647', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6488, 'D19041829', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6490, 'D19108059', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6493, 'D17222146', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6498, 'D18684651', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6503, 'D17220983', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6509, 'D18899480', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6517, 'D17221920', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6518, 'D18684008', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6519, 'D18899220', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6524, 'D17220928', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6540, 'D18684221', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6542, 'D15166994', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6549, 'D18899200', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6551, 'D17835571', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6555, 'D17221947', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6556, 'D19035523', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6557, 'D14969788', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6566, 'D18997177', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6567, 'D19101048', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6575, 'D19100956', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6580, 'D15469743', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6587, 'D18683993', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6592, 'D17809602', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6593, 'D17835755', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6597, 'D19100802', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6601, 'D18680387', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6602, 'D18680424', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6603, 'D17221155', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6604, 'D15164893', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6607, 'D17221897', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6608, 'D19035125', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6609, 'D14970664', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6610, 'D18997222', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6617, 'D19039414', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6621, 'D19110422', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6622, 'D19107960', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6626, 'D16087199', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6629, 'D16121695', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6631, 'D17239200', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6633, 'D18899263', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6642, 'D18997225', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6649, 'D19034963', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6650, 'D17222019', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6651, 'D17837555', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6655, 'D19100599', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6656, 'D18503625', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6659, 'D14970712', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6665, 'D17837430', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6666, 'D17221855', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6667, 'D17837626', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6668, 'D19110369', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6670, 'D19039208', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6675, 'D17221948', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6676, 'D17943947 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6680, 'D18899399', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6684, 'D17221974', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6685, 'D18683853', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6691, 'D15470323', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6693, 'D16121585', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6695, 'D16087182', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6704, 'D18899178', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6711, 'D17222075', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6717, 'D17239220', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6720, 'D16087277', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6725, 'D17221788', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6731, 'D15166630', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6741, 'D16121638', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6744, 'D18684019', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6746, 'D19103171', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6752, 'D18683383', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6758, 'D14969962', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6766, 'D14969881', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6770, 'D16121590', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6773, 'D17835737', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6778, 'D17809637', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6786, 'D17221792', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6787, 'D14970585', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6788, 'D16087347', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6790, 'D18997418', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6792, 'D17222040', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6794, 'D14969947', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6809, 'D17221191', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6810, 'D18997386', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6811, 'D17809574', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6817, 'D17221995', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6822, 'D17835727', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6823, 'D19039438', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6825, 'D18596033 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6830, 'D19101037', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6834, 'D19039557', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6846, 'D18684586', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6851, 'D16121753', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6853, 'D17221183', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6854, 'D17221849', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6855, 'D16087332', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6857, 'D17221303', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6863, 'D14969970', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6864, 'D18680349', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6866, 'D19039535', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6870, 'D15163767', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6871, 'D19041197', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6872, 'D17837609', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6873, 'D15025093', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6875, 'D15166959', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6876, 'D15166953', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6877, 'D18899242', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6878, 'D19039332', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6879, 'D19039543', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6880, 'D19039162', NULL, NULL, NULL, NULL, NULL, NULL, 'combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6885, 'D17809540', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6886, 'D17221831', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6889, 'D17239215', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6891, 'D14284079', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6893, 'D18997155', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6894, 'D18683339', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6897, 'D16121650', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6898, 'D16087184', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6900, 'D18997159', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6903, 'D18997331', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6905, 'D19100911', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6908, 'D17221967', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(6911, 'D17943920 ', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(187, 'D10453181', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(188, 'D10457855', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(189, 'D10453146', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(192, 'D19999805', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(193, 'D10461230', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(195, 'D20000981', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(196, 'D18899455', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(197, 'D18899488', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(198, 'D19107673', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-06-09 22:01:56'),
	(4853, 'D17222001', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-06-10 22:01:21'),
	(4853, 'D17222001', '2014-11-13 00:00:00', 256475, 52, '                                    ', 1, '                                    ', 'security', 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-06-10 22:20:45'),
	(4853, 'D17222001', '2014-11-13 00:00:00', 256475, 52, '                                                                        ', 1, '                                                                        ', 'security', 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-06-10 22:21:05'),
	(4853, 'D17222001', '2014-11-13 00:00:00', 256475, 529, '                                                                        ', 1, '                                                                        ', 'security', 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-06-10 22:21:37'),
	(4845, 'D18683279', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-06-11 19:53:01'),
	(4845, 'D18683279', '2012-01-31 00:00:00', 78798, 457, '                                    ', 3, '                                    ', 'security', 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-06-11 20:05:00'),
	(4845, 'D18683279', '2012-01-31 00:00:00', 78798, 457, '                                                                        ', 3, '                                                                        ', 'security', 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-06-11 20:08:21'),
	(4845, 'D18683279', '2012-01-31 00:00:00', 78798, 457, '', 3, '', 'security', 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-06-11 20:12:31'),
	(4845, 'D18683279', '2012-01-31 00:00:00', 78798, 457, '', 3, '', 'security', 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-06-11 20:16:53'),
	(4845, 'D18683279', '2012-01-31 00:00:00', 78798, 457, 'Test', 3, 'Me', 'security', 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-06-11 20:20:16'),
	(4832, 'D19100823', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4835, 'D17835744', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4837, 'D16121558', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4840, 'D14286848', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4841, 'D16087343', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4842, 'D17239196', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4845, 'D18683279', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4849, 'D19034882', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4852, 'D17221994', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4853, 'D17222001', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4854, 'D18683408', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4858, 'D18683291', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4863, 'D14286905', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4865, 'D14284084', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4866, 'D14283829', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4870, 'D15164902', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4871, 'D16087336', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4894, 'D15469731', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4896, 'D16121615', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4900, 'D17809649', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4905, 'D15163761', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4911, 'D18997299', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4915, 'D17221978', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4922, 'D18683935', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4927, 'D15470300', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4934, 'D18899225', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4935, 'D16121584', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4936, 'D19107956', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4942, 'D16087292', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4943, 'D17221917', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4944, 'D17221815', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4945, 'D17222198', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4946, 'D18899261', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4955, 'D16087483', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4964, 'D18997310', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4967, 'D14970574', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4968, 'D17809636', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4969, 'D17837601', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4981, 'D17239319', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4983, 'D17239192', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4985, 'D17837539', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4989, 'D15163749', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(4996, 'D17239257', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5001, 'D15163752', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5003, 'D19035517', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5005, 'D17837549', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5007, 'D18680375', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5014, 'D17837553', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5016, 'D17221009', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5022, 'D17221309', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5023, 'D17837499', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5029, 'D17221767', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5032, 'D18684187', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5034, 'D18684657', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5038, 'D18504252', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5039, 'D19100942', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5040, 'D19100879', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5041, 'D19100838', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5043, 'D17809548', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5055, 'D17222196', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5058, 'D19101051', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5059, 'D17222023', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5061, 'D15163738', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5068, 'D16087265', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5072, 'D19100985', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5073, 'D17837647', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5076, 'D18997377', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5077, 'D15166798', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5079, 'D14969977', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5082, 'D14970503', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5083, 'D14286805', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5090, 'D17221819', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5091, 'D16087407', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5092, 'D16121570', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5093, 'D18683980', NULL, NULL, NULL, NULL, NULL, NULL, 'MOBAY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5094, 'D18680476', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5103, 'D18680440', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5108, 'D18997433', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5109, 'D18899246', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5117, 'D14969973', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5131, 'D17221894', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5132, 'D17221172', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5133, 'D17221961', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5134, 'D17943945 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5148, 'D15025084', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5151, 'D19100773', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5155, 'D18683416', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5158, 'D15470492', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5159, 'D15166593', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5160, 'D15164924', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5161, 'D16121716', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5162, 'D16121715', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5163, 'D17835788', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5164, 'D17837496', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5168, 'D18683286', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5171, 'D15166973', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5176, 'D18997402', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5190, 'D14970667', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5191, 'D14283891', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5203, 'D17221769', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5207, 'D14969813', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5211, 'D14969936', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5212, 'D17809573', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5216, 'D19041833', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5219, 'D17221761', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5220, 'D18503609', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5222, 'D17837437', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5227, 'D18683201', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5231, 'D17221939', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5232, 'D17221822', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5233, 'D19034988', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5235, 'D19107952', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5239, 'D14283877', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5241, 'D17222030', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5244, 'D18503605', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5248, 'D17221892', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5249, 'D19041153', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5251, 'D18899170', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5253, 'D19039545', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5255, 'D19035521', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5261, 'D19039408', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5264, 'D16121683', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5265, 'D17835521', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5270, 'D17222056', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5282, 'D19041825', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5294, 'D15470480', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5299, 'D17221987', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5301, 'D16121746', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5311, 'D17835735', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5313, 'D15166951', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5318, 'D18683277', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5319, 'D16121629', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5320, 'D17221902', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5331, 'D17220998', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5334, 'D16121642', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5335, 'D19034862', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5346, 'D15163577', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5347, 'D15163533', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5348, 'D15166970', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5349, 'D14969974', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5350, 'D14970513', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5356, 'D17835809', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5357, 'D15166828', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5358, 'D15166998', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5360, 'D18899164', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5361, 'D15163746', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5364, 'D14286633', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5366, 'D17837435', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5385, 'D16121733', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5386, 'D16087337', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5394, 'D17222085', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5402, 'D17835739', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5409, 'D16121751', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5411, 'D17837640', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5415, 'D15375826', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5418, 'D17837638', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5420, 'D18504274', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5426, 'D17221777', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5427, 'D17222209', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5428, 'D18997223', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5429, 'D18997257', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5440, 'D19035197', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5441, 'D16087496', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5444, 'D19039555', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5458, 'D17943915', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5459, 'D14969741', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5465, 'D17239233', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5466, 'D15166628', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5468, 'D19101021', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5469, 'D15163758', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5471, 'D14970659', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5478, 'D19041109', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5480, 'D16121729', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5482, 'D16121527', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5484, 'D17837605', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5486, 'D17221883', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5489, 'D18680382', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5490, 'D18680366', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5498, 'D17809576', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5500, 'D18595034 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5507, 'D18683959', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5509, 'D15166941', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5510, 'D19041820', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5515, 'D16121550', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5519, 'D18683963', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5522, 'D17221156', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5524, 'D18683349', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5527, 'D19039412', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5528, 'D19039465', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5535, 'D18503596', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5538, 'D19034884', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5548, 'D17239316', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5549, 'D17835397', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5550, 'D17222025', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5551, 'D17837452', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5553, 'D18680433', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5554, 'D14283797', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5558, 'D17835725', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5561, 'D18684014', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5563, 'D18596037 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5567, 'D18900883', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5569, 'D16121720', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5571, 'D16121543', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5573, 'D15470328', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5574, 'D17222140', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5576, 'D17239190', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5587, 'D17837425', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5588, 'D18683947', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5595, 'D14970723', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5598, 'D19039552', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5599, 'D19039167', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5608, 'D17221249', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5611, 'D18683317', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5612, 'D19100850', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5616, 'D17835762', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5623, 'D17221799', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5624, 'D16087327', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5625, 'D17837465', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5626, 'D18900928', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5627, 'D17835803', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5632, 'D16121555', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5633, 'D17221859', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5635, 'D19039400', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5639, 'D19100765', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5649, 'D16087208', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5650, 'D17837724', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5655, 'D15470494', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5656, 'D18683394', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5659, 'D16087499', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5663, 'D19039559', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5666, 'D14969829', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5667, 'D16087268', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5669, 'D17221132', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5675, 'D16121744', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5677, 'D19035061', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5680, 'D15166584', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5681, 'D18683321', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5686, 'D16121513', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5691, 'D16087214', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5703, 'D17837468', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5707, 'D17809621', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5712, 'D17222072', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5713, 'D17222038', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5715, 'D14286616', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5718, 'D14969756', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5719, 'D17835407', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5723, 'D19039576', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5733, 'D18684641', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5736, 'D18683213', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5744, 'D17809549', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5745, 'D18595017 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5761, 'D18997333', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5766, 'D15163766', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5767, 'D17835502', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5770, 'D17809556', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5779, '', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5786, 'D17837738', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5788, 'D19041113', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5789, 'D19034796', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5797, 'D19100803', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5799, 'D19101016', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5800, 'D19100778', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5804, 'D17837693', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5805, 'D17221991', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5815, 'D19110418', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5816, 'D17222015', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5817, 'D18997218', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5818, 'D18997344', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5831, 'D17222069', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5833, 'D14286691', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5834, 'D15164903', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5836, 'D16121600', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5842, 'D16087417', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5848, 'D14970563', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5851, 'D14283840', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5869, 'D16087421', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5875, 'D15166610', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5878, 'D16121750', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5880, 'D16121583', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5881, 'D17835715', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5897, 'D17837761', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5898, 'D18684570', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5901, 'D17221885', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5905, 'D18899187', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5906, 'D17239230', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5911, 'D15166974', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5912, 'D16121756', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5917, 'D15470339', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5919, 'D16087380', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5923, 'D19101018', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5924, 'D17239249', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5927, 'D17222021', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5928, 'D17222013', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5938, 'D16121540', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5939, 'D18997219', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5945, 'D17239307', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5947, 'D16087246', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5950, 'D17239208', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5952, 'D14284067', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5953, 'D17220893', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5954, 'D14969868', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5963, 'D19035395', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5969, 'D17837402', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5971, 'D19041140', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5973, 'D17837607', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5985, 'D19034867', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5991, 'D17837706', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(5995, 'D17239287', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6009, 'D16121731', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6013, 'D16121664', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6019, 'D15166601', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6021, 'D19100754', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6026, 'D18680452', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6027, 'D17943936 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6030, 'D14969905', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6039, 'D18684565', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6047, 'D16121559', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6049, 'D18900889', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6056, 'D16087430', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6061, 'D17837543', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6066, 'D17809570', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6072, 'D17837547', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6074, 'D18899363', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6076, 'D14286575', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6077, 'D14286925', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6085, 'D17809559', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6099, 'D14970610', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6100, 'D17222147', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6101, 'D19103184', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6105, 'D14286784', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6106, 'D14286952', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6107, 'D16121652', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6115, 'D17221848', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6125, 'D19035577', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6135, 'D19039520', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6138, 'D18997384', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6145, 'D17835790', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6153, 'D19039420', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6158, 'D19100934', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6175, 'D18683200', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6183, 'D18684016', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6188, 'D18595971', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6189, 'D15166991', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6202, 'D17809619', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6206, 'D18899159', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6220, 'D17221754', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6228, 'D18504254', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6229, 'D18684018', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6230, 'D14969818', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6232, 'D19039176', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6233, 'D15470477', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6240, 'D14969780', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6242, 'D18680371', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6254, 'D15166812', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6255, 'D19100994', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6258, 'D19035525', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6266, 'D18684208', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6276, 'D16087296', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6277, 'D18683314', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6278, 'D16087235', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6284, 'D17835797', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6294, 'D14970555', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6299, 'D18504586', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6302, 'D14970725', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6307, 'D16121587', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6308, 'D19039170', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6309, 'D18997174', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6311, 'D16121595', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6316, 'D17220982', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6317, 'D18680411', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6326, 'D18997395', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6328, 'D17222200', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6335, 'D17943926 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6339, 'D17837554', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6344, 'D17220975', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6353, 'D17837457', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6357, 'D14286816', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6362, 'D17222091', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6375, 'D19035491', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6379, 'D17837519', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6380, 'D19039442', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6381, 'D14283985', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6386, 'D17222116', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6389, 'D16087505', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6392, 'D17835533', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6394, 'D17809526', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6395, 'D16121657', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6396, 'D16087173', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6397, 'D16087251', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6398, 'D16087225', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6399, 'D16121658', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6401, 'D16121636', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6402, 'D16121659', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6403, 'D16087220', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6404, 'D16087212', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6406, 'D16087287', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6408, 'D17837697', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6409, 'D16087263', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6410, 'D16087223', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6411, 'D16087179', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6413, 'D17221002', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6414, 'D17221014', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6415, 'D17221982', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6416, 'D17221281', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6417, 'D17222158', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6419, 'D17835411', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6420, 'D17221756', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6423, 'D19100860', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6427, 'D18680483', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6433, 'D17835409', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6449, 'D17835713', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6452, 'D18997260', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6460, 'D18683874', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6462, 'D18595024 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6465, 'D15470302', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6468, 'D19039211', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6469, 'D17835437', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6481, 'D19039505', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6485, 'D17809647', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6488, 'D19041829', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6490, 'D19108059', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6493, 'D17222146', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6498, 'D18684651', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6503, 'D17220983', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6509, 'D18899480', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6517, 'D17221920', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6518, 'D18684008', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6519, 'D18899220', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6524, 'D17220928', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6540, 'D18684221', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6542, 'D15166994', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6549, 'D18899200', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6551, 'D17835571', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6555, 'D17221947', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6556, 'D19035523', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6557, 'D14969788', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6566, 'D18997177', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6567, 'D19101048', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6575, 'D19100956', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6580, 'D15469743', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6587, 'D18683993', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6592, 'D17809602', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6593, 'D17835755', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6597, 'D19100802', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6601, 'D18680387', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6602, 'D18680424', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6603, 'D17221155', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6604, 'D15164893', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6607, 'D17221897', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6608, 'D19035125', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6609, 'D14970664', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6610, 'D18997222', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6617, 'D19039414', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6621, 'D19110422', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6622, 'D19107960', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6626, 'D16087199', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6629, 'D16121695', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6631, 'D17239200', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6633, 'D18899263', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6642, 'D18997225', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6649, 'D19034963', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6650, 'D17222019', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6651, 'D17837555', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6655, 'D19100599', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6656, 'D18503625', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6659, 'D14970712', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6665, 'D17837430', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6666, 'D17221855', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6667, 'D17837626', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6668, 'D19110369', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6670, 'D19039208', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6675, 'D17221948', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6676, 'D17943947 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6680, 'D18899399', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6684, 'D17221974', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6685, 'D18683853', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6691, 'D15470323', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6693, 'D16121585', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6695, 'D16087182', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6704, 'D18899178', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6711, 'D17222075', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6717, 'D17239220', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6720, 'D16087277', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6725, 'D17221788', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6731, 'D15166630', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6741, 'D16121638', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6744, 'D18684019', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6746, 'D19103171', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6752, 'D18683383', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6758, 'D14969962', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6766, 'D14969881', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6770, 'D16121590', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6773, 'D17835737', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6778, 'D17809637', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6786, 'D17221792', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6787, 'D14970585', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6788, 'D16087347', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6790, 'D18997418', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6792, 'D17222040', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6794, 'D14969947', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6809, 'D17221191', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6810, 'D18997386', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6811, 'D17809574', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6817, 'D17221995', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6822, 'D17835727', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6823, 'D19039438', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6825, 'D18596033 ', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6830, 'D19101037', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6834, 'D19039557', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6846, 'D18684586', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6851, 'D16121753', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6853, 'D17221183', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6854, 'D17221849', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6855, 'D16087332', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6857, 'D17221303', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6863, 'D14969970', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6864, 'D18680349', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6866, 'D19039535', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6870, 'D15163767', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6871, 'D19041197', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6872, 'D17837609', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6873, 'D15025093', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6875, 'D15166959', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6876, 'D15166953', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6877, 'D18899242', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6878, 'D19039332', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6879, 'D19039543', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6880, 'D19039162', NULL, NULL, NULL, NULL, NULL, NULL, 'combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6885, 'D17809540', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6886, 'D17221831', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6889, 'D17239215', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6891, 'D14284079', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6893, 'D18997155', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6894, 'D18683339', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6897, 'D16121650', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6898, 'D16087184', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6900, 'D18997159', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6903, 'D18997331', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6905, 'D19100911', NULL, NULL, NULL, NULL, NULL, NULL, 'SECURITY', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6908, 'D17221967', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6911, 'D17943920 ', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6912, 'D18997408', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6913, 'D18997206', NULL, NULL, NULL, NULL, NULL, NULL, 'Combo', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6914, 'D18683159', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6916, 'D17837685', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6917, 'D17221004', NULL, NULL, NULL, NULL, NULL, NULL, 'Security', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6918, 'D17837764', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6920, 'D15166597', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6921, 'D15163772', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6922, 'D19100845', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6924, 'D15470342', NULL, NULL, NULL, NULL, NULL, NULL, 'FLEET', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6927, 'D14969930', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6928, 'D14970541', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6929, 'D14969956', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6931, 'D14286618', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6932, 'D14969755', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6933, 'D14969972', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6934, 'D14969857', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6937, 'D14970618', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07'),
	(6938, 'D14970710', NULL, NULL, NULL, NULL, NULL, NULL, 'COMBO', 3, 'ANDREBONNER', '::1', 'INSERT', 'Import from Interface', '2016-09-06 20:46:07');
/*!40000 ALTER TABLE `device_assignments_log` ENABLE KEYS */;


-- Dumping structure for table bunio_vts.device_status
CREATE TABLE IF NOT EXISTS `device_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COMMENT='Device Status';

-- Dumping data for table bunio_vts.device_status: ~4 rows (approximately)
/*!40000 ALTER TABLE `device_status` DISABLE KEYS */;
INSERT INTO `device_status` (`id`, `status`) VALUES
	(1, 'Active'),
	(2, 'Suspended'),
	(3, 'Damaged'),
	(4, 'Un-Assigned'),
	(5, 'Active Suzuk');
/*!40000 ALTER TABLE `device_status` ENABLE KEYS */;


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

-- Dumping data for table bunio_vts.device_status_log: 0 rows
/*!40000 ALTER TABLE `device_status_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_status_log` ENABLE KEYS */;


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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COMMENT='IMEI Notes';

-- Dumping data for table bunio_vts.imei_notes: ~2 rows (approximately)
/*!40000 ALTER TABLE `imei_notes` DISABLE KEYS */;
INSERT INTO `imei_notes` (`id`, `imei`, `note`, `expiry_date`) VALUES
	(2, '353239002251913', 'Test', '2016-05-18 00:00:00'),
	(3, '353239002251913', 'Devo Test     ', '2017-02-03 00:00:00'),
	(4, '353239002251913', 'Y Test', '2016-05-27 00:00:00');
/*!40000 ALTER TABLE `imei_notes` ENABLE KEYS */;


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

-- Dumping data for table bunio_vts.imei_notes_log: 0 rows
/*!40000 ALTER TABLE `imei_notes_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `imei_notes_log` ENABLE KEYS */;


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

-- Dumping data for table bunio_vts.import: 0 rows
/*!40000 ALTER TABLE `import` DISABLE KEYS */;
/*!40000 ALTER TABLE `import` ENABLE KEYS */;


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

-- Dumping data for table bunio_vts.issuepriority: ~0 rows (approximately)
/*!40000 ALTER TABLE `issuepriority` DISABLE KEYS */;
/*!40000 ALTER TABLE `issuepriority` ENABLE KEYS */;


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

-- Dumping data for table bunio_vts.issues: ~0 rows (approximately)
/*!40000 ALTER TABLE `issues` DISABLE KEYS */;
/*!40000 ALTER TABLE `issues` ENABLE KEYS */;


-- Dumping structure for table bunio_vts.issuestatus
CREATE TABLE IF NOT EXISTS `issuestatus` (
  `issue_status_id` int(11) NOT NULL AUTO_INCREMENT,
  `issue_status_type` varchar(20) NOT NULL,
  PRIMARY KEY (`issue_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table bunio_vts.issuestatus: ~0 rows (approximately)
/*!40000 ALTER TABLE `issuestatus` DISABLE KEYS */;
/*!40000 ALTER TABLE `issuestatus` ENABLE KEYS */;


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

-- Dumping data for table bunio_vts.messages: ~0 rows (approximately)
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;


-- Dumping structure for table bunio_vts.message_links
CREATE TABLE IF NOT EXISTS `message_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message_id` int(11) DEFAULT '0',
  `from_id` int(11) DEFAULT '0',
  `to_id` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Message Links';

-- Dumping data for table bunio_vts.message_links: ~0 rows (approximately)
/*!40000 ALTER TABLE `message_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `message_links` ENABLE KEYS */;


-- Dumping structure for table bunio_vts.message_types
CREATE TABLE IF NOT EXISTS `message_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COMMENT='Message Types';

-- Dumping data for table bunio_vts.message_types: ~2 rows (approximately)
/*!40000 ALTER TABLE `message_types` DISABLE KEYS */;
INSERT INTO `message_types` (`id`, `type`) VALUES
	(1, 'chat'),
	(2, 'email');
/*!40000 ALTER TABLE `message_types` ENABLE KEYS */;


-- Dumping structure for table bunio_vts.permissions
CREATE TABLE IF NOT EXISTS `permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permission` varchar(50) DEFAULT NULL,
  `right` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=latin1 COMMENT='Permissions';

-- Dumping data for table bunio_vts.permissions: ~28 rows (approximately)
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` (`id`, `permission`, `right`) VALUES
	(1, 'Add_Table', 1),
	(2, 'Delete_Table', 1),
	(3, 'Edit_Table', 1),
	(4, 'View_Table', 1),
	(5, 'Add_User', 1),
	(6, 'Delete_User', 1),
	(7, 'Edit_User', 1),
	(8, 'View_User', 1),
	(9, 'Add_Device', 1),
	(10, 'Delete_Device', 1),
	(11, 'Edit_Device', 1),
	(12, 'View_Device', 1),
	(13, 'Add_Customer', 1),
	(14, 'Delete_Customer', 1),
	(15, 'Edit_Customer', 1),
	(16, 'View_Customer', 1),
	(17, 'Add_Data', 1),
	(18, 'Delete_Data', 1),
	(19, 'Edit_Data', 1),
	(20, 'View_Data', 1),
	(21, 'Add_Log', 1),
	(22, 'Delete_Log', 1),
	(23, 'Edit_Log', 1),
	(24, 'View_Log', 1),
	(25, 'Add_Device-Assignment', 1),
	(26, 'Delete_Device-Assignment', 1),
	(27, 'Edit_Device-Assignment', 1),
	(28, 'View_Device-Assignment', 1);
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;


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

-- Dumping data for table bunio_vts.permissions_log: 0 rows
/*!40000 ALTER TABLE `permissions_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `permissions_log` ENABLE KEYS */;


-- Dumping structure for table bunio_vts.projectaccess
CREATE TABLE IF NOT EXISTS `projectaccess` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `projectid` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `accesstype` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='access to projects';

-- Dumping data for table bunio_vts.projectaccess: ~0 rows (approximately)
/*!40000 ALTER TABLE `projectaccess` DISABLE KEYS */;
/*!40000 ALTER TABLE `projectaccess` ENABLE KEYS */;


-- Dumping structure for table bunio_vts.projects
CREATE TABLE IF NOT EXISTS `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `description` varchar(150) NOT NULL,
  `modifiedon` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='projects table';

-- Dumping data for table bunio_vts.projects: ~0 rows (approximately)
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;


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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COMMENT='Role of the system users';

-- Dumping data for table bunio_vts.roles: ~2 rows (approximately)
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` (`id`, `role`) VALUES
	(1, 'Administrator'),
	(2, 'Editor');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;


-- Dumping structure for table bunio_vts.role_permissions
CREATE TABLE IF NOT EXISTS `role_permissions` (
  `role` int(11) DEFAULT NULL,
  `permission` int(11) DEFAULT NULL,
  `right` tinyint(4) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Role Permissions';

-- Dumping data for table bunio_vts.role_permissions: ~80 rows (approximately)
/*!40000 ALTER TABLE `role_permissions` DISABLE KEYS */;
INSERT INTO `role_permissions` (`role`, `permission`, `right`) VALUES
	(1, 1, 1),
	(1, 2, 1),
	(1, 3, 1),
	(1, 4, 1),
	(1, 5, 1),
	(1, 6, 1),
	(1, 7, 1),
	(1, 8, 1),
	(1, 9, 1),
	(1, 10, 1),
	(1, 11, 1),
	(1, 12, 1),
	(1, 13, 1),
	(1, 14, 1),
	(1, 15, 1),
	(1, 16, 1),
	(1, 17, 1),
	(1, 18, 1),
	(1, 19, 1),
	(1, 20, 1),
	(1, 21, 1),
	(1, 22, 1),
	(1, 23, 1),
	(1, 24, 1),
	(1, 25, 1),
	(1, 26, 1),
	(2, 1, 1),
	(2, 2, 1),
	(2, 3, 0),
	(2, 4, 1),
	(2, 5, 1),
	(2, 6, 1),
	(2, 7, 1),
	(2, 8, 0),
	(2, 9, 1),
	(2, 10, 1),
	(2, 11, 0),
	(2, 12, 0),
	(2, 13, 1),
	(2, 14, 0),
	(2, 15, 0),
	(2, 16, 0),
	(2, 17, 1),
	(2, 18, 0),
	(2, 19, 1),
	(2, 20, 1),
	(2, 21, 1),
	(2, 22, 1),
	(2, 23, 1),
	(2, 24, 1),
	(2, 25, 0),
	(2, 26, 1),
	(3, 1, 1),
	(3, 2, 1),
	(3, 3, 0),
	(3, 4, 1),
	(3, 5, 1),
	(3, 6, 1),
	(3, 7, 1),
	(3, 8, 0),
	(3, 9, 1),
	(3, 10, 1),
	(3, 11, 0),
	(3, 12, 0),
	(3, 13, 1),
	(3, 14, 0),
	(3, 15, 0),
	(3, 16, 0),
	(3, 17, 0),
	(3, 18, 0),
	(3, 19, 1),
	(3, 20, 1),
	(3, 21, 1),
	(3, 22, 1),
	(3, 23, 1),
	(3, 24, 1),
	(3, 25, 0),
	(3, 26, 1),
	(1, 27, 1),
	(1, 28, 1),
	(2, 27, 1),
	(2, 28, 1),
	(3, 27, 1),
	(3, 28, 1);
/*!40000 ALTER TABLE `role_permissions` ENABLE KEYS */;


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

-- Dumping data for table bunio_vts.role_permissions_log: 0 rows
/*!40000 ALTER TABLE `role_permissions_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `role_permissions_log` ENABLE KEYS */;


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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COMMENT='Technicians';

-- Dumping data for table bunio_vts.technicians: ~2 rows (approximately)
/*!40000 ALTER TABLE `technicians` DISABLE KEYS */;
INSERT INTO `technicians` (`id`, `technician`) VALUES
	(1, 'Sam Weiss'),
	(2, 'Jack Harkness'),
	(3, 'Martha Jones');
/*!40000 ALTER TABLE `technicians` ENABLE KEYS */;


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

-- Dumping data for table bunio_vts.technicians_log: 0 rows
/*!40000 ALTER TABLE `technicians_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `technicians_log` ENABLE KEYS */;


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

-- Dumping data for table bunio_vts.userprofile: ~5 rows (approximately)
/*!40000 ALTER TABLE `userprofile` DISABLE KEYS */;
INSERT INTO `userprofile` (`user_id`, `name`, `allowemailnotification`) VALUES
	(2, 'Andre', 0),
	(3, 'Admin', 1),
	(5, 'Josh', 0),
	(21, 'Sweeny', 1),
	(23, 'Chad', 0);
/*!40000 ALTER TABLE `userprofile` ENABLE KEYS */;


-- Dumping structure for table bunio_vts.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `password` varchar(150) NOT NULL,
  `status` int(11) NOT NULL,
  `role` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1 COMMENT='Users';

-- Dumping data for table bunio_vts.users: ~7 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`, `username`, `password`, `status`, `role`) VALUES
	(2, 'andre', '6297bfa8063327ab29f532b5b215f4e6', 2, 1),
	(3, 'admin', '77723183754eb6db3757b52f2ab1c950', 1, 1),
	(5, 'tech1', 'cc45a44842e924b114621f6c2cfdd75d', 1, 3),
	(21, 'test', '1af64bbd82633b5870791f875c3d8302', 2, 1),
	(23, 'monitor', '3b89c564453e0cac3d78448d828a826c', 1, 2),
	(24, 'newuser', 'password', 2, 1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;


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

-- Dumping data for table bunio_vts.users_log: 27 rows
/*!40000 ALTER TABLE `users_log` DISABLE KEYS */;
INSERT INTO `users_log` (`id`, `username`, `password`, `status`, `role`, `user_id`, `machine`, `ip_address`, `action`, `action_type`, `log_date`) VALUES
	(2, 'andre', '3b89c564453e0cac3d78448d828a826c', 1, 1, 0, 'ANDREBONNER', '127.0.0.1', 'INSERT', 'SETUP', '2016-04-14 21:59:54'),
	(3, 'andre', '3b89c564453e0cac3d78448d828a826c', 1, 1, 0, 'ANDREBONNER', '127.0.0.1', 'INSERT', 'SETUP', '2016-04-14 22:00:18'),
	(3, 'admin', '3b89c564453e0cac3d78448d828a826c', 1, 1, 0, 'ANDREBONNER', '127.0.0.1', 'UPDATE', 'SETUP', '2016-04-14 22:01:28'),
	(2, 'andre', '3b89c564453e0cac3d78448d828a826c', 2, 1, 0, 'ANDREBONNER', '127.0.0.1', 'UPDATE', 'TEST', '2016-04-14 22:42:29'),
	(2, 'andre', '6297bfa8063327ab29f532b5b215f4e6', 2, 1, 0, 'ANDREBONNER', '127.0.0.1', 'UPDATE', 'TEST', '2016-04-15 00:08:52'),
	(3, 'admin', '77723183754eb6db3757b52f2ab1c950', 1, 1, 0, 'ANDREBONNER', '127.0.0.1', 'UPDATE', 'TEST', '2016-04-16 13:04:19'),
	(5, 'tech1', '35ac157cbd3de400070be5e5e62f815c', 0, 0, 3, 'ANDREBONNER', '', 'INSERT', '', '2016-04-30 16:17:55'),
	(5, 'tech1', '35ac157cbd3de400070be5e5e62f815c', 1, 1, 3, 'ANDREBONNER', '', 'UPDATE', '', '2016-04-30 16:47:35'),
	(21, 'test', '1af64bbd82633b5870791f875c3d8302', 1, 1, 3, 'ANDREBONNER', '192.168.1.2', 'INSERT', 'Insert from Interface', '2016-04-30 23:21:36'),
	(21, 'test', '1af64bbd82633b5870791f875c3d8302', 1, 1, 3, 'ANDREBONNER', '192.168.1.2', 'UPDATE', 'Update from Interface', '2016-04-30 23:22:44'),
	(21, 'test', '1af64bbd82633b5870791f875c3d8302', 1, 1, 3, 'ANDREBONNER', '192.168.1.2', 'UPDATE', 'Update from Interface', '2016-04-30 23:22:53'),
	(22, 'tech2', '35ac157cbd3de400070be5e5e62f815c', 2, 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Insert from Interface', '2016-04-30 23:23:20'),
	(21, 'test', '1af64bbd82633b5870791f875c3d8302', 2, 1, 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-04-30 23:28:29'),
	(21, 'test', '1af64bbd82633b5870791f875c3d8302', 2, 1, 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-04-30 23:33:59'),
	(21, 'test', '1af64bbd82633b5870791f875c3d8302', 2, 1, 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-04-30 23:34:06'),
	(21, 'test', '1af64bbd82633b5870791f875c3d8302', 2, 1, 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-04-30 23:36:42'),
	(21, 'test', '1f2aee5f000a54d901d329025cfd1071', 2, 1, 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-04-30 23:40:17'),
	(21, 'test', '1af64bbd82633b5870791f875c3d8302', 2, 1, 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-04-30 23:53:10'),
	(23, 'monitor', '47f00578fbc4e248a5e565a0494d8d7a', 2, 1, 3, 'ANDREBONNER', '::1', 'INSERT', 'Insert from Interface', '2016-05-01 00:05:50'),
	(22, 'tech2', '35ac157cbd3de400070be5e5e62f815c', 2, 1, 3, 'ANDREBONNER', '::1', 'DELETE', 'Delete from Interface', '2016-05-01 00:48:33'),
	(23, 'monitor', 'e6a683832d09c6eff8f8689731571d31', 1, 2, 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-05-17 22:52:09'),
	(5, 'tech1', '35ac157cbd3de400070be5e5e62f815c', 1, 3, 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-05-17 22:52:54'),
	(5, 'tech1', '35ac157cbd3de400070be5e5e62f815c', 1, 3, 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-05-17 22:52:54'),
	(5, 'tech1', '6297bfa8063327ab29f532b5b215f4e6', 1, 3, 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-05-26 17:44:47'),
	(23, 'monitor', '3b89c564453e0cac3d78448d828a826c', 1, 2, 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-05-26 17:45:12'),
	(24, 'newuser', 'password', 2, 1, 1, 'server', '::1', 'INSERT', 'Pub', '2016-08-31 23:41:50'),
	(5, 'tech1', 'cc45a44842e924b114621f6c2cfdd75d', 1, 3, 3, 'ANDREBONNER', '::1', 'UPDATE', 'Update from Interface', '2016-09-03 22:16:57');
/*!40000 ALTER TABLE `users_log` ENABLE KEYS */;


-- Dumping structure for table bunio_vts.user_roles
CREATE TABLE IF NOT EXISTS `user_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COMMENT='User Roles';

-- Dumping data for table bunio_vts.user_roles: ~3 rows (approximately)
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` (`id`, `role`) VALUES
	(1, 'Administrator'),
	(2, 'Monitoring'),
	(3, 'Service');
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;


-- Dumping structure for table bunio_vts.user_sessions
CREATE TABLE IF NOT EXISTS `user_sessions` (
  `user_id` int(11) DEFAULT NULL,
  `session_id` varchar(150) DEFAULT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='User Sessions';

-- Dumping data for table bunio_vts.user_sessions: ~4 rows (approximately)
/*!40000 ALTER TABLE `user_sessions` DISABLE KEYS */;
INSERT INTO `user_sessions` (`user_id`, `session_id`, `timestamp`) VALUES
	(3, 'k57id69fk2o5bof5eogpngo793', '2016-08-09 21:27:31'),
	(3, '2vaecd3s20d9rfrifk0pjo9ck7', '2016-08-28 16:47:12'),
	(5, '85leqb1phqitshpbu87iksh8d7', '2016-09-03 22:17:11'),
	(5, '9q9kedon18c2q2e9v3qdjcp7o1', '2016-09-06 21:11:42');
/*!40000 ALTER TABLE `user_sessions` ENABLE KEYS */;


-- Dumping structure for table bunio_vts.user_status
CREATE TABLE IF NOT EXISTS `user_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COMMENT='User Status';

-- Dumping data for table bunio_vts.user_status: ~2 rows (approximately)
/*!40000 ALTER TABLE `user_status` DISABLE KEYS */;
INSERT INTO `user_status` (`id`, `status`) VALUES
	(1, 'ACTIVE'),
	(2, 'DISABLED');
/*!40000 ALTER TABLE `user_status` ENABLE KEYS */;


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
