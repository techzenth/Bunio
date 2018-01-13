<script>
    $(document).ready(function () {
        var title = '<?php echo $this->title; ?>';
        console.log($("#frmSearch").attr("action"));
        $("#frmSearch").submit(function (e) {
            $form = $(this);
            $.post($form.attr("action"), $("#frmSearch").serialize(), function (data) {
                $(".modal-content").html(data);
                //console.log(data);
            });
            e.preventDefault();
        });

        $("#btnSave").attr('disabled', 'disabled');
        $("#role_permission_name").change(function () {
            if ($("#role_permission_name").length < 1) {
                $("#btnSave").attr('disabled', 'disabled');
            } else {
                $("#btnSave").removeAttr('disabled');
            }
        });



        $(".right").on("click", function (e) {
            url = 'table/role_permission/edit';
            role_id = $(this).prop('id');
            permission_id = $(this).prop('name');
            value = $(this).prop('value');
            console.log('role: '+ role_id);
            console.log('permission'+ permission_id);
            $.post(url, {role: role_id, permission: permission_id, right: value}, function (data) {
                var obj = $.parseJSON(data);
                if (obj.mtype === 'E') {
                    toastr.error(obj.msg, title);
                } else if (obj.mtype === 'W') {
                    toastr.warning(obj.msg, title);
                    //alert(obj.msg);
                } else if (obj.mtype === 'S') {
                    toastr.success(obj.msg, title);
                    //$(".modal-content").load('table/role_permission');
                }
                console.log(data);
            });
            //e.preventDefault();
        });
//
//        $(".delete").click(function (e) {
//            url = $(this).attr('href');
//            console.log(url);
//            doAction = confirm('Are you sure you want to delete the role_permission?');
//            if (doAction) {
//                $.get(url, function (data) {
//                    var obj = $.parseJSON(data);
//                    if (obj.mtype === 'E') {
//                        toastr.error(obj.msg, title);
//                    } else if (obj.mtype === 'W') {
//                        toastr.error(obj.msg, title);
//                        //alert(obj.msg);
//                    } else if (obj.mtype === 'S') {
//                        toastr.success(obj.msg, title);
//                        $(".modal-content").load('table/role_permission');
//                    }
//                    console.log(data);
//                });
//            }
//            e.preventDefault();
//        });
    });
</script>
<!-- Modal -->
<div class="modal fade" id="permissionModal" tabindex="-1" data-keyboard="false" data-backdrop="static" role="dialog" aria-labelledby="deviceAssignmentModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">

        </div>
    </div>
</div>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>
    <h4 class="modal-title" id="bunioModalLabel"><i class="glyphicon glyphicon-plus-sign"></i>&nbsp;<?php echo $this->title; ?></h4>
</div>
<div class="modal-body">
    <div class="container">
        <fieldset class="col-sm-6">
            <legend>Search</legend>
            <form id="frmSearch" method="post" action="table/role_permission/search" class="form-inline">
                <div class="form-group">
                    <label  for="roles">Role</label>
                    <select class="form-control" id="roles" name="roles"> 
                        <option value="">Select Role</option>
                        <?php foreach ($this->data['roles'] as $role) { ?>
                            <option value="<?php echo $role['id'] ?>" <?php echo ($role['id'] == $_POST['roles']) ? 'selected' : ''; ?>><?php echo $role['role'] ?></option>
                        <?php } ?>
                    </select>
                </div>
                <div class="form-group">
                    <label  for="role_permission">Permission</label> 
                    <select class="form-control" id="permissions" name="permissions"> 
                        <option value="">Select Permission</option>
                        <?php foreach ($this->data['permissions'] as $permission) { ?>
                            <option value="<?php echo $permission['permission'] ?>" <?php echo ($permission['permission'] == $_POST['permissions']) ? 'selected' : ''; ?>><?php echo $permission['permission'] ?></option>
                        <?php } ?>
                    </select>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">Filter</button>
                </div>
            </form>
        </fieldset>
    </div>
    <fieldset>
        <legend>Permissions</legend>
        <p>                
            <a href="table/role_permission/add" id="linkNew" data-toggle="modal" data-target="#deviceAssignmentModal" class="btn btn-primary"><i class="glyphicon glyphicon-plus"></i>&nbsp; Role Permission</a>
            <br>
        </p>
<!--        <p>
    <form id ="frmPermission" method="post" action="table/role_permission/save" class="form-inline">
        <div class="form-group">
            <label  for="role_permission">Role Permission</label>
            <input type="hidden" id="role_permission_id" name="role_permission_id" value="">
            <input type="text" class="form-control" id="role_permission_name" name="role_permission_name" placeholder="Permission">


            <div class="checkbox">
                <label>
                    <input type="checkbox" id="right" name="right" value="1"> Add
                </label>
                <label>
                    <input type="checkbox" id="role_permission_delete" name="role_permission_delete" value="1"> Delete
                </label>
                <label>
                    <input type="checkbox" id="role_permission_edit" name="role_permission_edit" value="1"> Edit
                </label>
                <label>
                    <input type="checkbox" id="role_permission_view" name="role_permission_view" value="1"> View
                </label>
            </div>

            <button type="submit" id="btnSave" class="btn btn-success">Save</button>
        </div>
    </form>
    </p>-->
        <?php if (count($this->data['records']) > 0) { ?>

            <table id="role_permissions" class="table table-bordered table-striped">
                <tr>
                    <th>Role</th>
                    <th>Permission <a class="pull-right" href="sort"><i class="glyphicon glyphicon-sort"></i></a></th>
                    <th>Right</th>
                </tr>
                <?php foreach ($this->data['records'] as $record) { ?>
                    <tr>
                        <td>
                            <?php echo $record['role']; ?>
                        </td>
                        <td>
                            <?php echo $record['permission']; ?>
                        </td>
                        <td class="text-center">
                            <div class="checkbox">
                                <label>
                                    <input type="checkbox" class="right" id="<?php echo $record['role_id']; ?>" name="<?php echo $record['permission_id']; ?>" value="<?php echo ($record['type'] ==true) ? '0': '1'; ?>" <?php echo ($record['type'] == true) ? 'checked' : ''; ?>>
                                </label>
                            </div>
                        </td>

                    </tr>
                <?php } ?>
            </table>


        <?php } else { ?>
            <div class="alert alert-info"> 
                <h4>Role Permissions</h4> 
                Filter by available Roles and Permissions
            </div>
        <?php } ?>
    </fieldset>
</div>