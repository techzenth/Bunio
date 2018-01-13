<script lang="jscript">
    $(document).ready(function () {
        var title = '<?php echo $this->title; ?>';
        console.log($("#frmUpload").attr("action"));
        $("#frmUpload").submit(function (e) {
            $form = $(this);
            //var file = $("#fileUpload");
            //console.log(file.val());
            if (!$form.valid()) {
                //toastr.warning('Please attach a file', title);
            } else {
                var url = $form.attr("action") + '/' + $("#type").val();
                var formData = new FormData();
                formData.append('fileUpload', $('#fileUpload')[0].files[0]);
                 $("#more-info").animate({"left":"+=50px" },"slow");
                $("#btnUpload").prop('disabled', true);
                $("#frmUpload").find('.loading').show();
                $.ajax({
                    type: 'POST',
                    url: url,
                    data: formData,
                    processData: false, // tell jQuery not to process the data
                    contentType: false, // tell jQuery not to set contentType
                    success: function (data) {
                        var obj = $.parseJSON(data);
                        $("#frmUpload").find('.loading').hide();
                        if (obj.mtype === 'E') {
                            toastr.error(obj.msg, title);
                            //alert(obj.msg);
                        } else if (obj.mtype === 'W') {
                            toastr.warning(obj.msg, title);
                        } else if (obj.mtype === 'S') {
                            toastr.success(obj.msg, title);
                            location.reload();
                        }
                        console.log(data);
                    },
                    error: function (err) {
                        //var eda = $.parseJSON(err);
                        toastr.error(err.statusText, title);
                        console.log(err);
                    }
                });
            }
            e.preventDefault();
        });

        $("#type, #fileUpload").change(function (e) {
            if ($(this).val() === '') {
                $("#fileUpload").prop('disabled', true);
                $("#btnUpload").prop('disabled', true);
                // console.log('Disabled');
            } else {
                $("#fileUpload").prop('disabled', false);
                $("#btnUpload").prop('disabled', false);
                // console.log('Enabled');
            }
        });

        $("#frmUpload").validate({
//            invalidHandler: function (e, va) {
//                var errors = va.numberOfInvalids();
//                if (errors) {
//                    var message = errors == 1 ? 'File not valid' : 'There are' + errors + 'errors';
//                    for (x = 0; x < errors; x++) {
//                        toastr.warning(message, title);
//                    }
//
//                }
//                console.log(e);
//            }

        });

        $("#frmUpload").find('.loading')
                .hide();
//        $(document).ajaxStart(function (e)
//        {
//            toastr.info('Uploading file', title);
//            console.log('start ajax');
//            $('.loading').show();
//            $("button.close").attr('disabled', 'disabled');
//            $("#frmUpload").find('#btnUpload').attr('disabled', 'disabled');
//        });
//        $(document).ajaxStop(function (e)
//        {
//            //toastr.clear();
//            //toastr.info('Upload csv',title);
//            console.log('stop ajax');
//            $('.loading').hide();
//            $("button.close").removeAttr('disabled');
//            $("#frmUpload").find('#btnUpload').removeAttr('disabled');
//        });

        $("#more-info").hide();
    });
</script>
<style>
    .loading{
        background: url('app/webroot/bootstrap/images/482.gif') center no-repeat;
        z-index: 9999;
        position: fixed;
        width: 99%;
        height: 99%;
    }
    #more-info{
        width: 99%;
    }
</style>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <h4 class="modal-title" id="bunioModalLabel"><?php echo $this->title; ?></h4>
</div>
<div class="modal-body">
    <form method="post" id="frmUpload" enctype="multipart/form-data"  action="data/import" class="form-horizontal">
        <div class="form-group">
            <div class="loading"></div>
            <label for="type" class="col-sm-4 control-label">Type:</label>
            <div class="col-sm-8">
                <select class="form-control" id="type" name="type" >
                    <!--                    <option value="">Select a Type</option>-->
                    <?php foreach ($this->data['types'] as $type) { ?>
                        <option value="<?php echo $type['id'] ?>" <?php echo ($type['id'] == $_POST['type']) ? 'selected' : ''; ?>>
                            <?php echo $type['type']; ?>
                        </option>
                    <?php } ?>
                </select>
            </div>
        </div>
        <div class="form-group">
            <label for="fileUpload" class="col-sm-4 control-label">Upload a file:</label>
            <div class="col-sm-8">
                <input type="hidden" name="MAX_FILE_SIZE" value="1000"/>
                <input type="file" class="form-control" id="fileUpload" name="fileUpload" accept="text/plain, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel" required="">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-8 control-label"> 
                <i class="glyphicon glyphicon-question-sign" ></i> Excel/Text/CSV file only. 
                <button type="button" class="btn btn-link" data-toggle="popover" title="File Format" data-content="The File must be in csv format.">Help ?</button>
                
            </label>
        </div><div id="more-info">Upload May take a couple seconds to minutes depending on size of Data</div>
        <div class="form-group">
            <div class="col-sm-offset-4 col-sm-8">
                <button type="submit" id="btnUpload" class="btn btn-primary">Import</button>
            </div>
        </div>
    </form>

</div>