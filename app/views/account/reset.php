<script lang="jscript">
    $(document).ready(function () {
        var title = '<?php echo $this->title;?>';
        console.log($("#frmReset").attr("action"));
        $("#frmReset").submit(function (e) {
            $form = $(this);
            var old-password = $("#old-password").val();
            var password = $("#password").val();
            if (old-password.length<3 || password.length<6) {
                toastr.warning('Please enter old-password and password',title);
            } else {
                var url = $form.attr("action");
                $.ajax({
                    type: 'POST',
                    url: url,
                    data: $("#frmReset").serialize(),
                    success: function (data) {
                        var obj = $.parseJSON(data);
                        if(obj.mtype==='E'){
                            toastr.error(obj.msg,title);
                            //alert(obj.msg);
                        }else if(obj.mtype==='S'){
                            toastr.success(obj.msg,title);
                            location.reload();
                        }
                        console.log(data);
                    },
                    error: function (err){
                        console.log(err);
                    }
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
    <form method="post" id="frmReset" action="account/reset" class="form-horizontal">
      <!--<h2 class="form-signin-heading"><?php echo strtoupper($this->data['cfg']->title); ?></h2>-->
        <div class="form-group">
            <label for="old-password" class="col-sm-4 control-label">Old Password</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="old-password" name="old-password" placeholder="Old Password">
            </div>
        </div>
        <div class="form-group">
            <label for="new-password" class="col-sm-4 control-label">New Password</label>
            <div class="col-sm-8">
                <input type="new-password" class="form-control" id="new-password" name="new-password" placeholder="New Password">
            </div>
        </div>
        <div class="form-group">
            <label for="password-again" class="col-sm-4 control-label">Password Again</label>
            <div class="col-sm-8">
                <input type="password-again" class="form-control" id="password-again" name="password-again" placeholder="Password Again">
            </div>
        </div>
        
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
                <button type="submit" id="btnReset" class="btn btn-default">Reset</button>
            </div>
        </div>
    </form>
</div>


