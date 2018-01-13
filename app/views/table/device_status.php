<script>
    $(document).ready(function () {
        var title = '<?php echo $this->title; ?>';
        console.log($("#frmSearch").attr("action"));
        $("#btnReset").click(function(e){
            $("#device_status").val('');
            $("#frmSearch").submit();
        });
        $("#frmSearch").submit(function (e) {
            $form = $(this);
            $.post($form.attr("action"), $("#frmSearch").serialize(), function (data) {
                $(".modal-content").html(data);
                //console.log(data);
            });
            e.preventDefault();
        });

        $("#btnSave").attr('disabled', 'disabled');
        $("#device_status_name").change(function () {
            if ($("#device_status_name").length < 1) {
                $("#btnSave").attr('disabled', 'disabled');
            } else {
                $("#btnSave").removeAttr('disabled');
            }
        });

        $("#frmDevice_Status").submit(function (e) {
            $form = $(this);
            console.log($form.attr("action"));
            $.post($form.attr("action"), $("#frmDevice_Status").serialize(), function (data) {
                console.log(data);
                var obj = $.parseJSON(data);
                if (obj.mtype === 'E') {
                    toastr.error(obj.msg, title);
                } else if (obj.mtype === 'W') {
                    toastr.error(obj.msg, title);
                    //alert(obj.msg);
                } else if (obj.mtype === 'S') {
                    toastr.success(obj.msg, title);
                    $(".modal-content").load('table/device_status');
                }
                console.log(data);
            });
            e.preventDefault();
        });

        $(".edit").click(function (e) {
            url = $(this).attr('href');
            console.log(url);
            $.get(url, function (data) {
                console.log(data);
                var obj = $.parseJSON(data);
                $("#frmDevice_Status").trigger("reset");
                $("#device_status_name").val(obj.status);
                $("#device_status_id").val(obj.id);
                $("#device_status_name").trigger("change");
                console.log(obj.status);
            });
            e.preventDefault();
        });

        $(".delete").click(function (e) {
            url = $(this).attr('href');
            console.log(url);
            doAction = confirm('Are you sure you want to delete the device_status?');
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
                        $(".modal-content").load('table/device_status');
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
            <form id="frmSearch" method="post" action="table/device_status/search" class="form-inline">
                <div class="form-group">
                    <label  for="device_status">Device Status</label>
                    <input type="text" class="form-control" id="device_status" name="device_status" placeholder="Device Status" value="<?php echo $_POST['device_status'];?>">

                    <button type="submit" id="btnSearch" class="btn btn-primary">Search</button>
                    <button type="button" id="btnReset" class="btn btn-default"> <span class="glyphicon glyphicon-refresh"></span></button>
                </div>
            </form>
        </fieldset>
    </div>
    <fieldset>
        <legend>Device Status</legend>
        <p>
        <form id="frmDevice_Status" method="post" action="table/device_status/save" class="form-inline">
            <div class="form-group">
                <label  for="device_status">Device Status</label>
                <input type="hidden" id="device_status_id" name="device_status_id" value="">
                <input type="text" class="form-control" id="device_status_name" name="device_status_name" placeholder="Device Status">

                <button type="submit" id="btnSave" class="btn btn-success">Save</button>
            </div>
        </form>
        </p>
        <?php if (count($this->data['records']) > 0) { ?>
            <table id="device_status" class="table table-bordered table-striped">
                <tr>
                    <th>#</th>
                    <th>Device Status <a class="pull-right" href="sort"><i class="glyphicon glyphicon-sort"></i></a></th>


                    <th>&nbsp;</th>
                </tr>
                <?php foreach ($this->data['records'] as $record) { ?>
                    <tr>
                        <td><?php echo $record['id']; ?></td>
                        <td><?php echo $record['status']; ?></td>

                        <td class="text-center">
                            <a class="edit" href="table/device_status/edit/<?php echo $record['id']; ?>"><?php echo 'EDIT'; ?></a>&nbsp;|&nbsp;
                            <a class="delete"href="table/device_status/delete/<?php echo $record['id']; ?>"><?php echo 'DELETE'; ?></a></td>
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