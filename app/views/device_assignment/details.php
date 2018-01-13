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
        <span aria-hidden="true">&times;</span>
    </button>
    <h4 class="modal-title" id="assignmentModalLabel"><?php echo $this->title; ?></h4>
</div>
<div class="modal-body">
    <div>
        <h4>Assignment Details #<?php echo $this->data['assignment']['customer_id']; ?></h4>
        <p><?php echo $this->data['msg']; ?></p>
        <dl class="dl-horizontal">
            <dt>Customer Name:</dt>
            <dd><?php echo $this->data['assignment']['customer_info']; ?></dd>
            <dt>Device Number:</dt>
            <dd><?php echo $this->data['assignment']['d_number']; ?></dd>
            <dt>Services:</dt>
            <dd><?php echo $this->data['assignment']['services']; ?></dd>
        </dl>
    </div>
</div>
<div class="modal-footer">
    <form id="frmDelete" action="device_assignment/delete/<?php echo $this->data['assignment']['customer_id'].'/'.$this->data['assignment']['d_number']; ?>" method="POST">
        <input type="hidden" name="customer_id" value="<?php echo $this->data['assignment']['customer_id']; ?>">
        <input type="hidden" name="d_number" value="<?php echo $this->data['assignment']['d_number']; ?>">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        <button type="submit" class="btn btn-primary"><i class="glyphicon glyphicon-trash"></i>&nbsp;Delete Assignment</button>
    </form>
</div>