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
    <h4 class="modal-title" id="userModalLabel"><?php echo $this->title; ?></h4>
</div>
<div class="modal-body">
    <div>
        <h4>User Details #<?php echo $this->data['user']['id']; ?></h4>
        <p><?php echo $this->data['msg']; ?></p>
        <dl class="dl-horizontal">
            <dt>User Name:</dt>
            <dd><?php echo $this->data['user']['username']; ?></dd>
            <dt>Status:</dt>
            <dd><?php echo $this->data['user']['status']; ?></dd>
            <dt>Role:</dt>
            <dd><?php echo $this->data['user']['role']; ?></dd>
        </dl>
    </div>
</div>
<div class="modal-footer">
    <form id="frmDelete" action="user/delete/<?php echo $this->data['user']['id']; ?>" method="POST">
        <input type="hidden" name="id" value="<?php echo $this->data['user']['id']; ?>">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        <button type="submit" class="btn btn-primary">Delete User</button>
    </form>
</div>