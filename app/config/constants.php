<?php

/* * constants.php
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


$REG->hash_gen_key = 'hjkhj7';
$REG->hash_pass_key = 'hjkhj7';

$REG->title = 'Bunio';

// http://www.php.net/manual/en/features.file-upload.errors.php
$REG->upload_errors = array(
    UPLOAD_ERR_OK => 'No errors.',
    UPLOAD_ERR_INI_SIZE => 'Large than upload_max_filesize.',
    UPLOAD_ERR_FORM_SIZE => 'Large than MAX_FILE_SIZE.',
    UPLOAD_ERR_PARTIAL => 'Partial Upload.',
    UPLOAD_ERR_NO_FILE => 'No file.',
    UPLOAD_ERR_NO_TMP_DIR => 'No temporary directory.',
    UPLOAD_ERR_CANT_WRITE => 'Can\'t write to disk.',
    UPLOAD_ERR_EXTENSION => 'File upload stopped by extension.'
);

$REG->csv_array [1]=  array('ID',
            'Device Version',
            'SIM Card number',
            'Account',
            'Account Description',
            'DNumber',
            'IMEI',
            'MSISDN',
            'Billing Date',
            'LIC Number',
            'Payment Info',
            'Replace By');

$REG->csv_array[2] =  array('Customer ID',
            'First Name',
            'Last Name',
            'Address 1',
            'Address 2',
            'Home Phone',
            'Work Phone',
            'Cell 1',
            'Cell 2',
            'Email',
            'Fleet Orb Number',
            'Vechicle Description');
