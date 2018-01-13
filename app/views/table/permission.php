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
        $("#permission_name").change(function () {
            if ($("#permission_name").length < 1) {
                $("#btnSave").attr('disabled', 'disabled');
            } else {
                $("#btnSave").removeAttr('disabled');
            }
        });

        $("#frmPermission").submit(function (e) {
            $form = $(this);
            console.log($form.attr("action"));
            $.post($form.attr("action"), $("#frmPermission").serialize(), function (data) {
                var obj = $.parseJSON(data);
                if (obj.mtype === 'E') {
                    toastr.error(obj.msg, title);
                } else if (obj.mtype === 'W') {
                    toastr.error(obj.msg, title);
                    //alert(obj.msg);
                } else if (obj.mtype === 'S') {
                    toastr.success(obj.msg, title);
                    $(".modal-content").load('table/permission');
                }
                console.log(data);
            });
            e.preventDefault();
        });

        $(".edit").click(function (e) {
            url = $(this).attr('href');
            $.get(url, function (data) {
                var obj = $.parseJSON(data);
                $("#frmPermission").trigger("reset");
                $("#permission_name").val(obj.permission);
                $("#permission_id").val(obj.id);
                
                $("#permission_name").trigger("change");
                console.log(obj.permission);
            });
            e.preventDefault();
        });

        $(".delete").click(function (e) {
            url = $(this).attr('href'); 
            console.log(url);
            doAction = confirm('Are you sure you want to delete the permission?');
            if (doAction) {
                $.get(url, function (data) {
                    var obj = $.parseJSON(data);                   
                    if (obj.mtype === 'E') {
                        toastr.error(obj.msg, title);
                    } else if (obj.mtype === 'W') {
                        toastr.error(obj.msg, title);
                        //alert(obj.msg);
                    } else if (obj.mtype === 'S') {
                        toastr.success(obj.msg, title);
                        $(".modal-content").load('table/permission');
                    }
                    console.log(data);
                });
            }
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
    <div class="container">
        <fieldset class="col-sm-6">
            <legend>Search</legend>
            <form id="frmSearch" method="post" action="table/permission/search" class="form-inline">
                <div class="form-group">
                    <label  for="permission">Permission</label>
                    <input type="text" class="form-control" id="permission" name="permission" placeholder="Permission" value="<?php echo $_POST['permission'];?>">

                    <button type="submit" class="btn btn-primary">Search</button>
                </div>
            </form>
        </fieldset>
    </div>
    <fieldset>
        <legend>Permissions</legend>
        <p>
        <form id ="frmPermission" method="post" action="table/permission/save" class="form-inline">
            <div class="form-group">
                <label  for="permission">Permission</label>
                <input type="hidden" id="permission_id" name="permission_id" value="">
                <input type="text" class="form-control" id="permission_name" name="permission_name" placeholder="Permission">


                

                <button type="submit" id="btnSave" class="btn btn-success">Save</button>
            </div>
        </form>
        </p>
        <?php if (count($this->data['records']) > 0) { ?>
            <table id="permissions" class="table table-bordered table-striped">
                <tr>

                    <th>Permission <a class="pull-right" href="sort"><i class="glyphicon glyphicon-sort"></i></a></th>
                    <th>Right</th>

                    <th>&nbsp;</th>
                </tr>
                <?php foreach ($this->data['records'] as $record) { ?>
                    <tr>

                        <td><?php echo $record['permission']; ?></td>
                        <td><?php echo $record['right']; ?></td>
                        <td class="text-center">
                            <a class="edit" href="table/permission/edit/<?php echo $record['id']; ?>">
                                <?php echo 'EDIT'; ?>
                            </a>&nbsp;|&nbsp;
                            <a class="delete" href="table/permission/delete/<?php echo $record['id']; ?>">
                                <?php echo 'DELETE'; ?>
                            </a>
                        </td>
                    </tr>
                <?php } ?>
            </table>

        <?php } else { ?>
            <div class="alert alert-info"> 
                <h4>No Data!!</h4> 
                No data can be found in the system
            </div>
        <?php } ?>
    </fieldset>
</div>