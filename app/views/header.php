<?php
/* header.php */
//header('Expires: '.date());
?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" href="app/webroot/bootstrap/images/favicon.ico">
        <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
        <title><?php echo isset($this->title) ? $this->title : $this->data['cfg']->title; ?></title>
        <!-- Jquery UI CSS -->
        <link href="<?php echo $this->data['cfg']->url; ?>app/webroot/jquery-ui-1.11.4.custom/jquery-ui.min.css" rel="stylesheet" type="text/css"/>
        <!-- Bootstrap -->
        <link href="<?php echo $this->data['cfg']->url; ?>app/webroot/bootstrap/css/cyborg.bootstrap.min.css" rel="stylesheet">
        <!-- Toastr -->
        <link href="<?php echo $this->data['cfg']->url; ?>app/webroot/toastr/css/toastr.css" rel="stylesheet">
        <?php
        // Custom Styles
        if (isset($this->css)) {
            ?>
            <!-- Custom styles for this template -->
            <?php
            foreach ($this->css as $css) {
                ?>
                <link rel="stylesheet" href="<?php echo $this->data['cfg']->url . 'app/views' . $css; ?>" />
                <?php
            }
        }
        ?>

        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="<?php echo $this->data['cfg']->url; ?>app/webroot/bootstrap/js/jquery.min.js"></script>
        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <!-- Bootstrap -->
        <script src="<?php echo $this->data['cfg']->url; ?>app/webroot/bootstrap/js/bootstrap.min.js"></script>
        <!-- Toastr -->
        <script src="<?php echo $this->data['cfg']->url; ?>app/webroot/toastr/js/toastr.js"></script>
    </head>
    <body>   