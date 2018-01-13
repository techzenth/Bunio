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
    <h4 class="modal-title" id="customerModalLabel"><?php echo $this->title; ?></h4>
</div>
<div class="modal-body">
    <div>
        <h4>Customer Details #<?php echo $this->data['customer']['id']; ?></h4>
        <p><?php echo $this->data['msg']; ?></p>
        <dl class="dl-horizontal">
            <dt>Customer Name:</dt>
            <dd><?php echo $this->data['customer']['customer_name']; ?></dd>
            <dt>License Plate Number:</dt>
            <dd><?php echo $this->data['customer']['license_plate_number']; ?></dd>
            <dt>Vehicle Description:</dt>
            <dd><?php echo $this->data['customer']['vehicle_description']; ?></dd>
        </dl>
    </div>
</div>
<div class="modal-footer">
    <form id="frmDelete" action="customer/delete/<?php echo $this->data['customer']['id']; ?>" method="POST">
        <input type="hidden" name="id" value="<?php echo $this->data['customer']['id']; ?>">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        <button type="submit" class="btn btn-primary">Delete Customer</button>
    </form>
</div>