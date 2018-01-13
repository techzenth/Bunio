<?php
/**index.php
 *
 * This is the main web entry point for Predque.
 *
 * If you are reading this in your web browser, your server is probably
 * not configured correctly to run PHP applications!
 *
 * See the README, INSTALL, and UPGRADE files for basic setup instructions
 * and pointers to the online documentation.
 *
 * http://web.andrebonner.com/predque/
 *
 * ----------
 *
 * Copyright (C) 2001-2011 Andre Bonner and JREAM.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 * http://www.gnu.org/copyleft/gpl.html
 *
 * @file
 */


// bunio.com
// localhost/bunio
# for debug purposes
//error_reporting(!E_NOTICE && E_ALL);
ini_set('display_errors', 'Off');
# error log
ini_set('log_errors', 'On');
ini_set('error_log', 'app/logs/bunio.log');

# install config if not found
# needs some work ;-)
if (!file_exists('./config.php')) {
    header('Location: install.php');
    die;
}

# configuration file
require_once('config.php');
# load plugin classes
require_once 'app/plugins/PHPMailer/PHPMailerAutoload.php';
require_once 'app/plugins/PHPExcel-1.8/Classes/PHPExcel.php';
#################################################################

# load utility classes
require_once('app/util/Auth.php');
require_once('app/util/CsvImporter.php');
##################################################################


# autoload class as needed

//function __autoload($class) {
//    require("core/$class.php");
//}

spl_autoload_register(function($class) {
    require("core/$class.php");
});

# define new bootstrap object
$app = new Boot;

# call bootstrap initializer
$app->init();
?>