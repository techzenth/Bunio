<script>
    $(document).ready(function (e) {
        var title = '<?php echo $this->title; ?>';
        console.log($("#frmDevice").attr("action"));
        $("#frmDevice").submit(function (e) {
            $form = $(this);
            e.preventDefault();
            if ($("#frmDevice").valid()) {
                $("#imei").prop("disabled", false);
                $.post($form.attr("action"), $("#frmDevice").serialize(), function (data) {
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
                }).fail(function (err) {
                    console.log(err);
                });
                $("#imei").prop("disabled", true);
            }

        });

        /*$(".page").click(function (e) {
         url = $(this).attr('href');
         $.get(url, function (data) {
         $("#divMain").html(data);
         //console.log(data);
         });
         e.preventDefault();
         });*/

        $("#frmDevice").validate({
            rules: {
                dNumber: "required",
                deviceVersion: "required",
                imei: "required",
                msisdn: "required",
                simNumber: "required"
            },
            messages: {
                dNumber: "Please enter device number",
                deviceVersion: "Please enter device version",
                imei: "Please enter imei",
                msisdn: "Please enter msisdn",
                simNumber: "Please enter sim number"
            }
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
    <h4 class="modal-title" id="deviceModalLabel"><?php echo $this->title; ?></h4>
</div>
<div class="modal-body">

    <form method="post" id="frmDevice" action="device/save" class="form-horizontal">
        <input type="hidden" name="state" value="<?php echo $this->data['state']; ?>"><div class="form-group">
            <label for="imei" class="col-sm-4 control-label">IMEI</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="imei" name="imei" <?php echo ($this->data['device']['imei'] != '') ? 'disabled="disabled"' : ''; ?>placeholder="IMEI" value="<?php echo $this->data['device']['imei']; ?>">
            </div>
        </div>
        <div class="form-group">
            <label for="dNumber" class="col-sm-4 control-label">D Number</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="dNumber" name="dNumber" placeholder="D Number" value="<?php echo $this->data['device']['d_number']; ?>">
            </div>
        </div>
        <div class="form-group">
            <label for="deviceVersion" class="col-sm-4 control-label">Device Version</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="deviceVersion" name="deviceVersion" placeholder="Device Version" value="<?php echo $this->data['device']['device_version']; ?>">
            </div>
        </div>

        <div class="form-group">
            <label for="msisdn" class="col-sm-4 control-label">MSISDN</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="msisdn" name="msisdn" placeholder="MSISDN" value="<?php echo $this->data['device']['msisdn']; ?>">
            </div>
        </div>
        <div class="form-group">
            <label for="simNumber" class="col-sm-4 control-label">Sim Number</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="simNumber" name="simNumber" placeholder="Sim Number" value="<?php echo $this->data['device']['sim_number']; ?>">
            </div>
        </div> 
        <div class="form-group">
            <label for="deviceStatus" class="col-sm-4 control-label">Device Status</label>
            <div class="col-sm-8">
                <select class="form-control" id="deviceStatus" name="deviceStatus">
                    <option value="">Select Device Status</option>
                    <?php foreach ($this->data['status'] as $status) { ?>
                        <option value="<?php echo $status['id'] ?>" <?php echo ($status['id'] == $this->data['device']['status']) ? 'selected' : ''; ?>>
                            <?php echo $status['status']; ?>
                        </option>
                    <?php } ?>
                </select>
            </div>
        </div> 
        <div class="form-group">
            <div class="col-sm-offset-4 col-sm-8">
                <?php
                //echo $this->data['device']['notes_count']; 
                if ($this->data['device']['imei']) {
                    ?>
                    <?php if ($this->data['device']['notes_count'] > 0) { ?>
                        <a href="imei_note/view/<?php echo $this->data['device']['imei']; ?>" id="linkNotes" data-toggle="modal" data-target="#noteModal">View Notes</a>&nbsp;| &nbsp;
                    <?php } else { ?>
                        <a href="imei_note/add/<?php echo $this->data['device']['imei']; ?>" id="linkNotes" data-toggle="modal" data-target="#noteModal">Add Note</a>&nbsp;| &nbsp;
                    <?php } ?>
                <?php } ?>
                <button type="submit" id="btnSave" class="btn btn-success">Save</button>&nbsp;|&nbsp;
                <button type="button" class="btn btn-default" data-dismiss="modal" aria-label="Close">Cancel</button>
            </div>
        </div>
    </form>

</div>