<script>
    $(document).ready(function () {
        console.log("<?php echo $this->title; ?>");
        var title = '<?php echo $this->title; ?>';
        var pModal = $('#permissionModal');
        console.log(pModal);        
        $("#frmPermission").submit(function (e) {
            $form = $(this);
            console.log($form.attr("action"));
            $.post($form.attr("action"), $("#frmPermission").serialize(), function (data) {
                var obj = $.parseJSON(data);
                if (obj.mtype === 'E') {
                    toastr.error(obj.msg, title);
                } else if (obj.mtype === 'W') {
                    toastr.warning(obj.msg, title);
                    //alert(obj.msg);
                } else if (obj.mtype === 'S') {
                    toastr.success(obj.msg, title);
                    pModal.modal('hide');
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
    <h4 class="modal-title" id="bunioModalLabel"><?php echo $this->title; ?></h4>
</div>
<div class="modal-body">
    <fieldset>

        <p>
        <form id ="frmPermission" method="post" action="table/role_permission/save" class="form-horizontal">
            <div class="form-group">
                <label class="col-sm-4 control-label" for="roles">Role</label>
                <div class="col-sm-8">
                <select class="form-control" id="roles" name="roles"> 
                    <option value="">Select Role</option>
                    <?php foreach ($this->data['roles'] as $role) { ?>
                        <option value="<?php echo $role['id'] ?>" <?php echo ($role['id'] == $_POST['roles']) ? 'selected' : ''; ?>><?php echo $role['role'] ?></option>
                    <?php } ?>
                </select>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="permissions">Permission</label> 
                <div class="col-sm-8">
                <select class="form-control" id="permissions" name="permissions"> 
                    <option value="">Select Permission</option>
                    <?php foreach ($this->data['permissions'] as $permission) { ?>
                        <option value="<?php echo $permission['permission'] ?>" <?php echo ($permission['permission'] == $_POST['permissions']) ? 'selected' : ''; ?>><?php echo $permission['permission'] ?></option>
                    <?php } ?>
                </select>
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-4 col-sm-8">
                    <button type="submit" id="btnSave" class="btn btn-success">Save</button>&nbsp;|&nbsp;
                    <button type="button" class="btn btn-default" data-dismiss="modal" aria-label="Close">Cancel</button>
                </div>
            </div>
        </form>
        </p>
    </fieldset>
</div>