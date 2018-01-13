<?php

require '../../config.php';
require '../../core/Language.php';
$lang = new Language();

require_once '../language/default/lang_default_full.php';
require_once($lang->getLangPath("full.php"));

echo '<pre>';
echo $lang_test;
echo '</pre>';