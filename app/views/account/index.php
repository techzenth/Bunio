<script lang="jscript">
    $(document).ready(function () {
        console.log($("#frmLogin").attr("action"));
        $("#frmLogin").submit(function (e) {
            $form = $(this);
            if ($("#username").val() == "" || $("#password").val() == "") {
                
            } else {
                var url = $form.attr("action");
                $.ajax({
                    type: 'POST',
                    url: url,
                    data: $("#frmLogin").serialize(),
                    success: function (data) {
                        var obj = $.parseJSON(data)
                        if(obj.mtype==='E'){
                            alert(obj.msg);
                        }else if(obj.mtype==='S'){
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
                        <input type="checkbox"> Remember me
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


