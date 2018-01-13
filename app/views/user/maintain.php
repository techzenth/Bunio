<script>
    $(document).ready(function () {
        var title = '<?php echo $this->title; ?>';
        console.log($("#frmUser").attr("action"));
        $("#frmUser").submit(function (e) {
            $form = $(this);
            if ($("#frmUser").valid()) {
                $.post($form.attr("action"), $("#frmUser").serialize(), function (data) {
                    var obj = $.parseJSON(data);
                    if (obj.mtype === 'E') {
                        toastr.error(obj.msg, title);
                    } else if (obj.mtype === 'W') {
                        toastr.warning(obj.msg, title);
                        //alert(obj.msg);
                    } else if (obj.mtype === 'S') {
                        toastr.success(obj.msg, title);
                        location.reload();
                    }
                    console.log(data);
                }).fail(function(err){
                    console.log(err);
                });
            }
            e.preventDefault();
        });

        /*$(".page").click(function (e) {
         url = $(this).attr('href');
         $.get(url, function (data) {
         $("#divMain").html(data);
         //console.log(data);
         });
         e.preventDefault();
         });*/

        $("#frmUser").validate({
            rules: {
                username: "required",
                password: "required",
                password_again: {
                    equalTo: "#password"
                },
                user_status: "required",
                user_role: "required"
            },
            messages: {
                username: "Please enter username",
                password: "Please enter password",
                password_again: "Password again must match Password",
                user_status: "Please select a status",
                user_role: "Please select a role"
            }
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
    <form method="post" id="frmUser" action="user/save" class="form-horizontal">
        <?php if ($this->data['user']) { ?>
            <div class="form-group">
                <label for="userId" class="col-sm-4 control-label">User ID</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" id="userId" name="userId" placeholder="User ID" value="<?php echo $this->data['user']['id']; ?>">
                </div>
            </div>
        <?php } ?>
        <div class="form-group">
            <label for="username" class="col-sm-4 control-label">User Name</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="username" name="username" placeholder="User Name" value="<?php echo $this->data['user']['username']; ?>">
            </div>
        </div>
        <div class="form-group">
            <label for="password" class="col-sm-4 control-label">Password</label>
            <div class="col-sm-8">
                <input type="password" class="form-control" id="password" name="password" placeholder="Password" >
            </div>
        </div>
        <div class="form-group">
            <label for="password_again" class="col-sm-4 control-label">Password Again</label>
            <div class="col-sm-8">
                <input type="password" class="form-control" id="password_again" name="password_again" placeholder="Password Again">
            </div>
        </div>
        <div class="form-group">
            <label for="user_status" class="col-sm-4 control-label">User Status</label>
            <div class="col-sm-8">
                <select class="form-control" id="user_status" name="user_status"> 
                    <option value="">Select User Status</option>
                    <?php foreach ($this->data['status'] as $status) { ?>
                        <option value="<?php echo $status['id'] ?>" <?php echo ($status['id'] == $this->data['user']['status_id']) ? 'selected' : ''; ?>><?php echo $status['status'] ?></option>
                    <?php } ?>
                </select>

            </div>
        </div> 
        <div class="form-group">
            <label for="user_role" class="col-sm-4 control-label">User Role</label>
            <div class="col-sm-8">
                <select class="form-control" id="user_role" name="user_role"> 
                    <option value="">Select User Role</option>
                    <?php foreach ($this->data['roles'] as $role) { ?>
                        <option value="<?php echo $role['id'] ?>" <?php echo ($role['id'] == $this->data['user']['role_id']) ? 'selected' : ''; ?>><?php echo $role['role'] ?></option>
                    <?php } ?>
                </select>

            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-4 col-sm-8">
                <button type="submit" id="btnSave" class="btn btn-success">Save</button>&nbsp;|&nbsp;<button type="button" class="btn btn-default" data-dismiss="modal" aria-label="Close">Cancel</button>
            </div>
        </div>
    </form>

</div>