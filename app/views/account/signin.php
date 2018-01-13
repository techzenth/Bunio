<script lang="jscript">
    $(document).ready(function () {
        var title = '<?php echo $this->title; ?>';
        console.log($("#frmLogin").attr("action"));
        $("#frmLogin").submit(function (e) {
            $form = $(this);
            var username = $("#username").val();
            var password = $("#password").val();
            if (!$form.valid()) {
//                toastr.warning('Please enter username and password', title);
//            } else if (username.length < 3 || password.length < 6) {
                toastr.warning('Username must be 3 characters and Password must be 6 characters', title);
            } else {
                var url = $form.attr("action");
                $("#btnLogin").prop('disabled', true);
                $.ajax({
                    type: 'POST',
                    url: url,
                    data: $("#frmLogin").serialize(),
                    success: function (data) {
                        var obj = $.parseJSON(data);
                        if (obj.mtype === 'E') {
                            toastr.error(obj.msg, title);
                        } else if (obj.mtype === 'W') {
                            toastr.error(obj.msg, title);
                            //alert(obj.msg);
                        } else if (obj.mtype === 'S') {
                            toastr.success(obj.msg, title);
                            location.reload();
                        }
                        console.log(data);
                    },
                    error: function (err) {
                        console.log(err);
                    }
                });
                $("#btnLogin").prop('disabled', false);
            }
            e.preventDefault();
        });
        
        $("#frmLogin").validate({
            rules:{
                username:{
                    required: true,
                    minlength: 3
                },
                password:{
                    required: true,
                    minlength: 6
                }
            },
            messages:{
                username: "Enter username",
                password: "Enter password"
            }
        });
    });
</script>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <h4 class="modal-title" id="loginModalLabel"><?php echo $this->title; ?></h4>
</div>
<div class="modal-body">
    <form method="post" id="frmLogin" action="account/signin" class="form-horizontal">
      <!--<h2 class="form-signin-heading"><?php echo strtoupper($this->data['cfg']->title); ?></h2>-->
        <div class="form-group">
            <label for="username" class="col-sm-2 control-label">Username</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="username" name="username" placeholder="username">
            </div>
        </div>
        <div class="form-group">
            <label for="password" class="col-sm-2 control-label">Password</label>
            <div class="col-sm-10">
                <input type="password" class="form-control" id="password" name="password" placeholder="Password">
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
                <div class="checkbox">
                    <label>
                        <input type="checkbox" name="rememberme"> Remember me
                    </label>
                </div>
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
                <button type="submit" id="btnLogin" class="btn btn-default">Login</button>
            </div>
        </div>
    </form>
</div>


