<?php
/* footer.php */
?>
        <!-- Jquery UI -->
        <script src="<?php echo $this->data['cfg']->url; ?>app/webroot/jquery-ui-1.11.4.custom/jquery-ui.min.js" type="text/javascript"></script>
        <!-- Jquery Validation-->
        <script src="<?php echo $this->data['cfg']->url; ?>app/webroot/jquery-validation/dist/jquery.validate.js"></script>
        <script src="<?php echo $this->data['cfg']->url; ?>app/webroot/jquery-validation/dist/additional-methods.js"></script> 

<?php
// Custom Scripts
if (isset($this->js)) {
    foreach ($this->js as $js) {
        ?>
        <!-- // Custom Scripts for the templates -->
        <script type="text/javascript" src="<?php echo $this->data['cfg']->url . 'app/views' . $js; ?>"></script>
        <?php
    }
}
?>
</body>
</html>