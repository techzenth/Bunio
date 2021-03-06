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
        $("#technician_name").change(function () {
            if ($("#technician_name").length < 1) {
                $("#btnSave").attr('disabled', 'disabled');
            } else {
                $("#btnSave").removeAttr('disabled');
            }
        });

        $("#frmTechnician").submit(function (e) {
            $form = $(this);
            console.log($form.attr("action"));
            $.post($form.attr("action"), $("#frmTechnician").serialize(), function (data) {
                var obj = $.parseJSON(data);
                if (obj.mtype === 'E') {
                    toastr.error(obj.msg, title);
                } else if (obj.mtype === 'W') {
                    toastr.error(obj.msg, title);
                    //alert(obj.msg);
                } else if (obj.mtype === 'S') {
                    toastr.success(obj.msg, title);
                    $(".modal-content").load('table/technician');
                }
                console.log(data);
            });
            e.preventDefault();
        });

        $(".edit").click(function (e) {
            url = $(this).attr('href');
            console.log(url);
            $.get(url, function (data) {
                //console.log(data);
                var obj = $.parseJSON(data);
                $("#frmTechnician").trigger("reset");
                $("#technician_name").val(obj.technician);
                $("#technician_id").val(obj.id);
                $("#technician_name").trigger("change");
                console.log(obj.technician);
            });
            e.preventDefault();
        });

        $(".delete").click(function (e) {
            url = $(this).attr('href');
            console.log(url);
            doAction = confirm('Are you sure you want to delete the technician?');
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
                        $(".modal-content").load('table/technician');
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
            <form id="frmSearch" method="post" action="table/technician/search" class="form-inline">
                <div class="form-group">
                    <label  for="technician">Technician</label>
                    <input type="text" class="form-control" id="technician" name="technician" placeholder="Technician" value="<?php echo $_POST['technician']; ?>">

                    <button type="submit" class="btn btn-primary">Search</button>
                </div>
            </form>
        </fieldset>
    </div>
    <fieldset>
        <legend>Technicians</legend>
        <p>
        <form id="frmTechnician" method="post" action="table/technician/save" class="form-inline">
            <div class="form-group">
                <label  for="technician">Technician</label>
                <input type="hidden" id="technician_id" name="technician_id" value="">
                <input type="text" class="form-control" id="technician_name" name="technician_name" placeholder="Technician">

                <button type="submit" id="btnSave" class="btn btn-success">Save</button>
            </div>
        </form>
        </p>
        <?php if (count($this->data['records']) > 0) { ?>
            <table id="technicians" class="table table-bordered table-striped">
                <tr>
                    <th>#</th>
                    <th>Technician <a class="pull-right" href="sort"><i class="glyphicon glyphicon-sort"></i></a></th>


                    <th>&nbsp;</th>
                </tr>
                <?php foreach ($this->data['records'] as $record) { ?>
                    <tr>
                        <td><?php echo $record['id']; ?></td>
                        <td><?php echo $record['technician']; ?></td>

                        <td class="text-center">
                            <a class="edit" href="table/technician/edit/<?php echo $record['id']; ?>"><?php echo 'EDIT'; ?></a>&nbsp;|&nbsp;
                            <a class="delete" href="table/technician/delete/<?php echo $record['id']; ?>"><?php echo 'DELETE'; ?></a>
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