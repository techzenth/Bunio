<script>
    $(document).ready(function () {
        var title = '<?php echo $this->title; ?>';
        console.log(title);

<?php if (!$this->data['loggedin']) { ?>
            //$("#loginModal").modal('show');
            $("#aLink").trigger("click");
<?php } else { ?>
            url = '<?php echo ($this->data['url'] == '') ? 'device_assignment/search' : $this->data['url']; ?>';
            $("#divMain").load(url, function (responseTxt, statusTxt, xhr) {
                if (statusTxt === "success")
                    //toastr.options.positionClass = 'toast-top-full-width';
                    toastr.info('Main View Loaded', title);
                console.log(xhr.statusText);
                if (statusTxt === "error")
                    toastr.error("Error: " + xhr.status + ": " + xhr.statusText, title);
            });

            $("a.link").click(function (e) {
                url = $(this).attr('href');
                console.log(url);
                $("#divMain").load(url, function (responseTxt, statusTxt, xhr) {
                    if (statusTxt === "success")
                        //toastr.info('View Loaded', title);
                        if (statusTxt === "error")
                            toastr.error("Error: " + xhr.status + ": " + xhr.statusText, title);
                });
                e.preventDefault();
            });

            //            $(document.body).on('hidden.bs.modal', function () {
            //                $('#myModal').removeData('bs.modal');
            //            });

            //Edit SL: more universal
            $(document).on('hidden.bs.modal', function (e) {
                $(e.target).removeData('bs.modal');
            });
            $('.loading').hide();
            //            $(document).ajaxStart(function (e)
            //            {
            //                console.log('start ajax');
            //                $('.loading').show();
            //
            //            });
            //            $(document).ajaxStop(function (e)
            //            {
            //                //toastr.clear();
            //                //toastr.info('Upload csv',title);
            //                console.log('stop ajax');
            //                $('.loading').hide();
            //            });
            //            function myfunc(){
            //                console.log(date);
            //            }
            //            setInterval(myfunc, 1000);

            /*********************************************************************************************/
            var sess_pollInterval = 60000;
            var sess_expirationMintues = 240;
            var sess_warningMinutes = 215;

            var sess_intervalID;
            var sess_lastActivity;

            function initSessionMonitor() {
                sess_lastActivity = new Date();
                sessSetInterval();

                $(document).bind('keypress', function (ed, e) {
                    sessKeyPressed(ed, e);
                });
            }

            function sessSetInterval() {
                sess_intervalID = setInterval(sessInterval, sess_pollInterval);
            }

            function sessClearInterval() {
                clearInterval(sess_intervalID);
            }

            function sessKeyPressed(ed, e) {
                sess_lastActivity = new Date();
                console.log(sess_lastActivity);
            }

            function sessPingServer() {
                sess();
            }

            function sessLogOut() {
                window.location.href = 'account/logout';
            }

            function sessInterval() {
                var now = new Date();
                var diff = now - sess_lastActivity;
                var diffMins = (diff / 1000 / 60);

                if (diffMins > sess_warningMinutes) {
                    sessClearInterval();
                    if (confirm('Your session will expire in ' + (sess_expirationMintues - sess_warningMinutes) +
                            'minutes (as of ' + $("#clock").html() + '), press OK to remain logged in ' +
                            'or press Cancel to log off. \nIf you are logged off changes will be lost.')) {
                        now = new Date();
                        diff = now - sess_lastActivity;
                        diffMins = (diff / 100 / 60);
                        if (diffMins > sess_expirationMintues) {
                            sessLogOut();
                        } else {
                            sessPingServer();
                            sessSetInterval();
                            sess_lastActivity = new Date();
                        }
                    } else {
                        sessLogOut();
                    }
                } else {
                    sessPingServer();
                }
            }

            function sess() {
                $.ajax({
                    type: 'GET',
                    url: 'account/check_session',
                    success: function (data) {
                        var obj = $.parseJSON(data);
                        if (obj.mtype === 'E') {
                            //toastr.error(obj.msg, title);
                            sessLogOut();
                        } else if (obj.mtype === 'W') {
                            toastr.error(obj.msg, title);
                            //alert(obj.msg);
                        } else if (obj.mtype === 'S') {
                            //toastr.success(obj.msg, title);
                            //location.reload();
                        }
                        console.log(data);
                    },
                    error: function (err) {
                        console.log(err);

                    }
                });
            }

            initSessionMonitor();

            /*********************************************************************************************/
            function updateClock( )
            {
                var currentTime = new Date( );
                var currentHours = currentTime.getHours( );
                var currentMinutes = currentTime.getMinutes( );
                var currentSeconds = currentTime.getSeconds( );

                // Pad the minutes and seconds with leading zeros, if required
                currentMinutes = (currentMinutes < 10 ? "0" : "") + currentMinutes;
                currentSeconds = (currentSeconds < 10 ? "0" : "") + currentSeconds;

                // Choose either "AM" or "PM" as appropriate
                var timeOfDay = (currentHours < 12) ? "AM" : "PM";

                // Convert the hours component to 12-hour format if needed
                currentHours = (currentHours > 12) ? currentHours - 12 : currentHours;

                // Convert an hours component of "0" to "12"
                currentHours = (currentHours === 0) ? 12 : currentHours;

                // Compose the string for display
                var currentTimeString = currentHours + ":" + currentMinutes + ":" + currentSeconds + " " + timeOfDay;


                $("#clock").html(currentTimeString);

            }

            setInterval(updateClock, 1000);
            /*********************************************************************************************/
            $("#sidebar").hide();
            $("#chat-head").click(function (e) {
                url = $(this).attr('href');
                console.log(url);
                // load data
                $.getJSON(url, function (data) {
                    var items = [];
                    console.log(data);
                    //if(count(data)>0)
                    $(data).each(function () {
                        //<li><a class="msg-user" href="message"><i class="glyphicon glyphicon-comment"></i> Greg Hanson</a></li>
                        items.push("<li id='" + data.id + "'><a class='msg-user' href='message/text/" + data.username + "'><i class='glyphicon glyphicon-comment'></i> " + data.name + "</a></li>");
                    });
                    /*for(x in data){
                     items.push("<li id='" + data[x].username + "'>" + data[x].name + "</li>");
                     }*/

                    $("<ul/>", {
                        "class": "online-users",
                        html: items.join("")
                    }).appendTo("#chat-users");
                });
                $("#sidebar").animate({'right': '0px'}, 1000);
                $("#sidebar").show();
                $(this).hide();
                $("#chat-messages").hide();
                //toastr.warning('Chat Head');
                e.preventDefault();
            });

            $("#close-sidebar").click(function (e) {
                $("#sidebar").animate({'right': '-248px'}, 1000);
                $("#sidebar").hide();
                $("#chat-head").show();
                e.preventDefault();
            });


<?php } ?>
    });
</script>
<?php if (!$this->data['loggedin']) { ?>
    <!-- Modal -->
    <div class="modal fade" id="loginModal" tabindex="-1" data-keyboard="false" data-backdrop="static" role="dialog" aria-labelledby="loginModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">

            </div>
        </div>
    </div>
<?php } else { ?>
    <style>
        .loading{
            background: url('app/webroot/bootstrap/images/loading.gif') center no-repeat;
            z-index: 9999;
            position: fixed;
            width: 100%;
            height:100%;
        }
        .footer {
            position: fixed;
            height: 10px;
            bottom: 0;
            width: 100%;
        }
        #clock {
            background: #fff;
            text-align: center;
            width: 148px;
            color: #000;
            border: 1px #ccc groove;
            position: relative;
            bottom: 10px;
            left: 15px;
            display: inline-block;
        }
        #chat{ 
            text-align: center;
            background: #fff;
            position: relative; 
            bottom: 10px;
            right: 20px;
            width: 148px;
            display: inline-block;
        }
        #chat-users{
            
        }
        #online-users ul{
            list-style: none;
            margin-left: 0;
        }
        #sidebar{
            position: fixed;
            width: 248px;
            /*height: 100%;*/
            right: -248px;
            bottom: 0px;
            z-index: 999;
            /*background: #fff;
            color: #000;
            border: 1px #ccc groove;*/
        }
    </style>
    <!-- Modal -->
    <div class="modal fade" id="bunioModal" tabindex="-1" data-keyboard="false" data-backdrop="static" role="dialog" aria-labelledby="bunioModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">

            </div>
        </div>
    </div>

<?php } ?>
<div class="loading"></div>
<div class="navbar-wrapper">

    <nav class="navbar navbar-default navbar-static-top">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#"><?php echo $this->data['cfg']->title; ?></a>
            </div>
            <div id="navbar" class="navbar-collapse collapse">
                <?php if ($this->data['loggedin']) { ?>
                    <ul class="nav navbar-nav">                        
                        <li><a class="link" href="customer/search">Customers</a></li>                       
                        <li><a class="link" href="device/search">Devices</a></li>
                        <li><a class="link" href="device_assignment/search">Device Assignments</a></li>
                        <?php if (Auth::role() == "Administrator") { ?>
                            <li><a class="link" href="user/search">Users</a></li>
                            <li class="dropdown">
                                <a data-toggle="dropdown" href="table/index">Tables</a>
                                <ul class="dropdown-menu">
                                    <li><a href="table/device_status" data-toggle="modal"  data-target="#bunioModal">Device Status</a></li>
                                    <li><a href="imei_note/view" data-toggle="modal" data-target="#bunioModal">Imei Notes</a></li>
                                    <li><a href="table/permission" data-toggle="modal"  data-target="#bunioModal">Permissions</a></li>
                                    <li><a href="table/role_permission" data-toggle="modal"  data-target="#bunioModal">Role Permissions</a></li>
                                    <li><a href="table/technician" data-toggle="modal"  data-target="#bunioModal">Technicians</a></li>
                                    <li><a href="table/user_status" data-toggle="modal" data-target="#bunioModal">User Status</a></li>
                                    <li><a href="table/user_role" data-toggle="modal" data-target="#bunioModal">User Roles</a></li>
                                </ul>
                            </li>
                            <li class="dropdown">
                                <a data-toggle="dropdown" href="#dropdown">Data</a>
                                <ul class="dropdown-menu">
                                    <li> <a href="data/import" data-toggle="modal" data-target="#bunioModal">Import</a></li>
                                    <li> <a href="data/export" data-toggle="modal" data-target="#bunioModal">Export</a></li>
                                </ul>
                            </li>
                            <li ><a class="link" href="log/view">Logs</a></li> 
                        <?php } ?>
                    </ul> 
                <?php } ?>
                <ul class="nav navbar-nav navbar-right">
                    <?php if (!$this->data['loggedin']) { ?>
                        <li><a id="aLink" href="account/signin" data-toggle="modal" data-target="#loginModal"><span class="glyphicon glyphicon-log-in" ></span> Login</a></li>

                    <?php } else { ?>
                        <li class="dropdown">
                            <a data-toggle="dropdown" href="#dropdown"><i class="glyphicon glyphicon-envelope"></i></a>
                            <ul class="dropdown-menu">
                                <li>
                                    <a href="#messages">2 Messages</a></li>
                            </ul>
                        </li>
                        <li class="dropdown">
                            <a data-toggle="dropdown" href="#dropdown">Welcome <?php print(Auth::username()); ?>  <span class="caret"></span></a>
                            <ul class="dropdown-menu"> 
                                <li><a href="about" data-toggle="modal" data-target="#bunioModal"><span class="glyphicon glyphicon-dashboard"></span>&nbsp;About</a></li>
                                <li><a href="account/reset" data-toggle="modal" data-target="#bunioModal"><span class="glyphicon glyphicon-user"></span>&nbsp;Reset Password</a></li>
                                <li><a href="account/logout" ><span class="glyphicon glyphicon-log-out" ></span>&nbsp;Logout</a></li>
                            </ul>
                        </li>
                    <?php } ?>
                </ul>
            </div>
        </div>
    </nav>


</div>

<?php
//print_r(Session::get('bunio_perms'));
echo Session::get('debug');
Session::set('debug', '');
?>
<?php if ($this->alert['msg'] != '') { ?>
    <div class="container">      
        <?php
        switch ($this->alert['mtype']) {
            case 'I':
                ?>
                <div class="alert alert-info"><button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button> <strong><?php echo $this->alert['title']; ?></strong> <?php echo $this->alert['msg']; ?></div>
                <?php
                break;
            case 'S':
                ?>
                <div class="alert alert-success"> <strong><?php echo $this->alert['title']; ?></strong> <p><?php echo $this->alert['msg']; ?></p>
                    <?php if ($this->alert['action'] != '') { ?>
                        <a href="<?php echo $this->alert['action']; ?>" class="btn btn-primary">Take this action!</a>
                    <?php } ?>
                </div>
                <?php
                break;
            case 'W':
                ?>
                <div class="alert alert-warning"> <strong><?php echo $this->alert['title']; ?></strong> <?php echo $this->alert['msg']; ?></div>
                <?php
                break;
            case 'D':
                ?>
                <div class="alert alert-danger"> <strong><?php echo $this->alert['title']; ?></strong> <?php echo $this->alert['msg']; ?></div>
            <?php
        }
        ?>
    </div>     
<?php } ?>

<?php if ($this->data['loggedin']) { ?>
    <div id="sidebar" class="panel panel-default pull-right">
        <button type="button" id="close-sidebar" class="close pull-right"><span aria-hidden="true">&times;</span></button>
        <div id="chat-users">
            <h5 class="">Online Users</h5>
            
        </div>
        <div id="chat-messages">
            <h5>Name</h5>
            <p>Message about the chat</p>
            <form action="">
                <textarea id="message-text" name="message-text" class="form-control"></textarea>
                <button class="btn btn-success btn-block">Send</button>
            </form>
        </div>
        <p></p>
    </div>
    <div id="divMain" class="container">

    </div>
<?php } ?>

<!-- FOOTER -->
<footer>
    <div class="footer navbar-fixed-bottom">
        <div id="clock"></div>
        <div id="chat" class="pull-right">
            <a id="chat-head" href="message">Chat <i class="glyphicon glyphicon-inbox"></i></a>
        </div>
    </div>
  <!--  <p class="pull-right"><a href="#">Back to top</a></p>
    <p>&copy; <?php echo date('Y'); ?> <?php echo $this->title; ?>, Inc. &middot; <a href="#">Privacy</a> &middot; <a href="#">Terms</a></p>
    -->
</footer>


