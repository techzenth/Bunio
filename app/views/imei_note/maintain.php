<script>
    $(document).ready(function () {
        var title = '<?php echo $this->title; ?>';
        console.log($("#frmImei_Note").attr("action"));
        $("#frmImei_Note").submit(function (e) {
            $form = $(this);
            if ($("#frmImei_Note").valid()) {
                $("#imei").removeAttr("disabled");
                $.post($form.attr("action"), $("#frmImei_Note").serialize(), function (data) {
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

        $("#frmImei_Note").validate({
            rules: {
                imei: "required",
                imei_notes: "required",
                expiryDate: "required"
            },
            messages: {
                imei: "Please enter imei",
                imei_notes: "Please enter imei_notes",
                expiryDate: "Please enter expiry date"
            }
        });
    });
</script>
<!-- Modal -->
<!--<div class="modal fade" id="bunioModal" tabindex="-1" data-keyboard="false" data-backdrop="static" role="dialog" aria-labelledby="bunioModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">

        </div>
    </div>
</div>-->
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>
    <h4 class="modal-title" id="noteModalLabel"><?php echo $this->title; ?></h4>
</div>
<div class="modal-body">

    <form method="post" id="frmImei_Note" action="imei_note/save<?php echo $this->data['id'] != '' ? '/'.$this->data['id'] : ''; ?>" class="form-horizontal">
        <input type="hidden" name="state" value="<?php echo $this->data['state'];?>">
        <?php if($this->data['imei']){?>
        <div class="form-group">
            <label for="imei" class="col-sm-4 control-label">IMEI</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="imei" name="imei" placeholder="IMEI" disabled="disabled" value="<?php echo $this->data['imei']; ?>">
            </div>
        </div>
        <?php }?>
        <div class="form-group">
            <label for="imei_notes" class="col-sm-4 control-label">IMEI Notes</label>
            <div class="col-sm-8">
                <textarea class="form-control" id="imei_notes" name="imei_notes">
                    <?php echo $this->data['imei_note']['notes']; ?>
                </textarea>
            </div>
        </div>
        <div class="form-group">
            <label for="expiryDate" class="col-sm-4 control-label">Expiry Date</label>
            <div class="col-sm-8">
                <input type="date" class="form-control" id="expiryDate" name="expiryDate" placeholder="Expiry Date" value="<?php echo $this->data['imei_note']['expiry_date']; ?>">
            </div>
        </div> 
        
        <div class="form-group">
            <div class="col-sm-offset-4 col-sm-8">
                
                <button type="submit" id="btnSave" class="btn btn-success">Save</button>&nbsp;|&nbsp;
                <button type="button" class="btn btn-default" data-dismiss="modal" aria-label="Close">Cancel</button>
            </div>
        </div>
    </form>

</div>
