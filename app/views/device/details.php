<script>
    $(document).ready(function () {
        var title = '<?php echo $this->title; ?>';
        console.log($("#frmDelete").attr("action"));
        $("#frmDelete").submit(function (e) {
            $form = $(this);
            console.log($form.attr("action"));
            $.post($form.attr("action"), $("#frmDelete").serialize(), function (data) {
                var obj = $.parseJSON(data);
                if (obj.mtype === 'E') {
                    toastr.error(obj.msg, title);
                } else if (obj.mtype === 'W') {
                    toastr.error(obj.msg, title);
                    //alert(obj.msg);
                } else if (obj.mtype === 'S') {
                    toastr.success(obj.msg, title);
                    location.reload();
                }
                console.log(data);
            });
            e.preventDefault();
        });
    });
</script>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hd_numberden="true">&times;</span>
    </button>
    <h4 class="modal-title" d_number="deviceModalLabel"><?php echo $this->title; ?></h4>
</div>
<div class="modal-body">
    <div>
        <h4>Device Details #<?php echo $this->data['device']['d_number']; ?></h4>
        <p><?php echo $this->data['msg']; ?></p>
        <dl class="dl-horizontal">
            <dt>Device Version:</dt>
            <dd><?php echo $this->data['device']['device_version']; ?></dd>
            <dt>IMEI:</dt>
            <dd><?php echo $this->data['device']['imei']; ?></dd>
            <dt>Status:</dt>
            <dd><?php echo $this->data['device']['status']; ?></dd>
        </dl>
    </div>
</div>
<div class="modal-footer">
    <form d_number="frmDelete" action="device/delete/<?php echo $this->data['device']['d_number']; ?>" method="POST">
        <input type="hidden" name="d_number" value="<?php echo $this->data['device']['d_number']; ?>">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        <button type="submit" class="btn btn-primary">Delete Device</button>
    </form>
</div>