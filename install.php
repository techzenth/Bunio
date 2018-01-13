<?php
/**install.php
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

# check language var
if (isset($_REQUEST['lang'])) {
    $lang = preg_replace('/[^A-Za-z0-9_-]/i', '', $_REQUEST['lang']);
} else {
    $lang = 'en';
}

# check admin var
if (isset($_REQUEST['admin'])) {
    $admin = preg_replace('/[^A-Za-z0-9_-]/i', '', $_REQUEST['admin']);
} else {
    $admin = 'admin';
}

# If config.php exists we just created config.php and need to redirect to continue installation
$configfile = './config.php';
if (file_exists($configfile)) {
    header("Location: $admin/$lang");
    die;
}

# needs some work
