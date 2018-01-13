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

//        $("#btnSave").attr('disabled', 'disabled');
//        $("#device_status_name").change(function () {
//            if ($("#device_status_name").length < 1) {
//                $("#btnSave").attr('disabled', 'disabled');
//            } else {
//                $("#btnSave").removeAttr('disabled');
//            }
//        });

//        $("#frmImei_Note").submit(function (e) {
//                    $form = $(this);
//                    console.log($form.attr("action"));
//                    $.post($form.attr("action"), $("#frmImei_Note").serialize(), function (data) {
//                        var obj = $.parseJSON(data);
//                        if (obj.mtype === 'E') {
//                            toastr.error(obj.msg, title);
//                        } else if (obj.mtype === 'W') {
//                            toastr.error(obj.msg, title);
//                            //alert(obj.msg);
//                        } else if (obj.mtype === 'S') {
//                            toastr.success(obj.msg, title);
//                            $(".modal-content").load('imei_notes/view');
//                        }
//                        console.log(data);
//                    });
//                    e.preventDefault();
//                });

//        $(".edit").click(function (e) {
//            url = $(this).attr('href');
//            console.log(url);
//            $.get(url, function (data) {
//                console.log(data);
//                var obj = $.parseJSON(data);
//                $("#frmImei_Note").trigger("reset");
//                $("#device_status_name").val(obj.device_status);
//                $("#device_status_id").val(obj.id);
//                $("#device_status_name").trigger("change");
//                console.log(obj.device_status);
//            });
//            e.preventDefault();
//        });

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
                        $(".modal-content").load('imei_note');
                    }
                    console.log(data);
                });
            }
            e.preventDefault();
        });
    });
</script>
<!-- Modal -->
<div class="modal fade" id="noteModal" tabindex="-1" data-keyboard="false" data-backdrop="static" role="dialog" aria-labelledby="noteModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">

        </div>
    </div>
</div>
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
            <form id="frmSearch" method="post" action="imei_note/view" class="form-inline">
                <div class="form-group">
                    <label  for="device_status">IMEI</label>
                    <input type="text" class="form-control" id="imei" name="imei" placeholder="IMEI" value="<?php echo $this->data['imei'];?>">
                </div>
            </form>
        </fieldset>
    </div>
    <fieldset>
        <legend>IMEI notes</legend>
<!--        <p>
        <form id="frmImei_Note" method="post" action="table/imei/save" class="form-inline">
            <div class="form-group">
                <label  for="imei">IMEI</label>
                <input type="hidden" id="imei_id" name="imei_id" value="">
                <input type="text" class="form-control" id="imei_name" name="imei_name" placeholder="IMEI">

                <button type="submit" id="btnSave" class="btn btn-success">Save</button>
            </div>
        </form>
        </p>-->
        <?php if (count($this->data['records']) > 0) { ?>
            <table id="imei" class="table table-bordered table-striped">
                <tr>
                     <th>IMEI Note <a class="pull-right" href="sort"><i class="glyphicon glyphicon-sort"></i></a></th>
                    <th>Created Date</th>
                    <th>Expiry Date</th>
                    <th>&nbsp;</th>
                </tr>
                <?php foreach ($this->data['records'] as $record) { ?>
                    <tr>
                        <td><?php echo $record['note']; ?></td>
                        <td><?php echo $record['created_date']; ?></td>
                        <td><?php echo $record['expiry_date']; ?></td>
                        <td class="text-center">
                            <a href="imei_note/edit/<?php echo $record['imei'].'/'.$record['id']; ?>" data-toggle="modal"  data-target="#bunioModal"><?php echo 'EDIT'; ?></a>&nbsp;|&nbsp;
                            <a class="delete"href="imei_note/delete/<?php echo $record['imei'].'/'.$record['id']; ?>"><?php echo 'DELETE'; ?></a>
                        </td>
                    </tr>
                <?php } ?>
            </table>
        <div class="col-sm-offset-4 col-sm-8">
            <a href="imei_note/add" id="linkNotes" data-toggle="modal" data-target="#noteModal">Add Note</a>
            <button type="button" class="btn btn-default" data-dismiss="modal" aria-label="Close">Close</button>
        </div>
        <?php } else { ?>
            <div class="alert alert-info"> 
                <h4>No Data!!</h4> 
                No data can be found in the system

            </div>
        <?php } ?>
    </fieldset>
</div>