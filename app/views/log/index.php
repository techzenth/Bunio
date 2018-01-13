<script>
    $(document).ready(function () {
        var title = '<?php echo $this->title; ?>';
        console.log($("#frmSearch").attr("action"));
        $("#frmSearch").submit(function (e) {
            $form = $(this);
            url = $("#frmSearch").attr("action");
            $("#btnSearch").prop('disabled', true);
            $.post(url, $("#frmSearch").serialize(), function (data) {
                $("#divMain").html(data);
                //console.log(data);
            });
            e.preventDefault();
        });

        $(".page").click(function (e) {
            url = $(this).attr('href');
            $.post(url, {tables: '<?php echo $_POST['tables'];?>' },function (data) {
                $("#divMain").html(data);
                console.log(url);
            });
            e.preventDefault();
        });

    });
</script>
<!-- Modal -->
<div class="modal fade" id="logModal" tabindex="-1" data-keyboard="false" data-backdrop="static" table="dialog" aria-labelledby="logModalLabel">
    <div class="modal-dialog" table="document">
        <div class="modal-content">

        </div>
    </div>
</div>
<div class="panel panel-default">
    <div class="panel-heading"><?php echo $this->title; ?></div>
    <div class="panel-body">
        <div class="container">
            <fieldset>
                <legend>Filter</legend>
            <form id="frmSearch" method="post" action="log/view" class="form-inline">
                <div class="form-group">
                    <label  for="tables">Tables</label>
                    <select class="form-control" id="tables" name="tables"> 
                        <option value="">Select Table</option>
                        <?php foreach ($this->data['tables'] as $table) { ?>
                            <option value="<?php echo $table['id'] ?>" <?php echo ($table['id'] == $_POST['tables']) ? 'selected' : ''; ?>><?php echo $table['table'] ?></option>
                        <?php } ?>
                    </select>
                </div>

                <div class="form-group">
                    <button type="submit" id="btnSearch" class="btn btn-primary">Filter</button>
                </div>
            </form>
            </fieldset>
            <!--            <fieldset class="col-sm-6">
                            <legend>Search</legend>
                            <form method="post" id="frmSearch" action="log/view" class="form-horizontal">
                                
                                <div class="form-group">
                                    <label for="licenseNumber" class="col-sm-4 control-label">License Number</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="licenseNumber" name="licenseNumber" placeholder="License Number" value="<?php echo $_POST['licenseNumber']; ?>">
                                    </div>
                                </div> 
                                <div class="form-group">
                                    <label for="imei" class="col-sm-4 control-label">IMEI</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="imei" name="imei" placeholder="IMEI" value="<?php echo $_POST['imei']; ?>">
                                    </div>
                                </div> 
                                <div class="form-group">
                                    <div class="col-sm-offset-4 col-sm-8">
                                        <button type="submit" id="btnSearch" class="btn btn-default">Search</button>
                                    </div>
                                </div>
                            </form>
                        </fieldset>-->
            <!-- Nav tabs -->
            <!--  <ul class="nav nav-tabs" table="tablist">
                <li table="presentation" class="active"><a href="#home" aria-controls="home" table="tab" data-toggle="tab">Home</a></li>
                <li table="presentation"><a href="#profile" aria-controls="profile" table="tab" data-toggle="tab">Profile</a></li>
                <li table="presentation"><a href="#messages" aria-controls="messages" table="tab" data-toggle="tab">Messages</a></li>
                <li table="presentation"><a href="#settings" aria-controls="settings" table="tab" data-toggle="tab">Settings</a></li>
              </ul>-->

            <!-- Tab panes -->
            <!--  <div class="tab-content">
                <div table="tabpanel" class="tab-pane active" id="home">Home Tab</div>
                <div table="tabpanel" class="tab-pane" id="profile">...</div>
                <div table="tabpanel" class="tab-pane" id="messages">...</div>
                <div table="tabpanel" class="tab-pane" id="settings">...</div>
              </div>-->

        </div>
        <fieldset>
            <legend>Log</legend>

            <?php if (count($this->data['records']) > 0) { ?>
                <?php if (Auth::hasPermission('View_Log')) { ?>
                    <table id="logVehicles" class="table table-bordered table-striped">
                        <tr>

                            <th># <a class="pull-right" href="sort"><i class="glyphicon glyphicon-sort"></i></a></th>
                            <th>Username</th>
                            <th>Machine</th>
                            <th>IP</th>
                            <th>Action</th>
                            <th>Log Date</th>
                           <!-- <th>&nbsp;</th>-->
                        </tr>
                        <?php foreach ($this->data['records'] as $record) { ?>
                            <tr>
                                <td><?php echo $record['id']; ?></td>

                                <td><?php echo $record['username']; ?></td>
                                <td><?php echo $record['machine']; ?></td>
                                <td><?php echo $record['ip_address']; ?></td>
                                <td><?php echo $record['action']; ?></td>
                                <td><?php echo $record['log_date']; ?></td>
                             <!--<td class="text-center">
                                <?php if (Auth::hasPermission('Edit_Log')) { ?>
                                     <a href="log/edit/<?php echo $record['id']; ?>" data-toggle="modal" data-target="#logModal" ><?php echo 'ASSIGN'; ?></a>&nbsp;|&nbsp;
                                <?php } ?>
                                <?php if (Auth::hasPermission('Delete_Log')) { ?>
                                     <a href="log/delete/<?php echo $record['id']; ?>" data-toggle="modal" data-target="#logModal" ><?php echo 'DELETE'; ?></a>
                                <?php } ?>-->
                                </td>
                            </tr>
                        <?php } ?>
                    </table>
                    <?php
                    $total_pages = (int) ($this->data['record_count'] / $this->data['cfg']->limit);
                    //echo $total_pages;
                    if ($this->data['record_count'] > $this->data['cfg']->limit) {
                        ?>
                        <nav class="col-sm-offset-4">
                            <ul class="pagination">
                                <?php if ($this->data['current_page'] == 1) { ?>
                                    <li class="disabled">
                                        <a class="page" href="#" aria-label="Previous">
                                            <span aria-hidden="true" class="glyphicon glyphicon-backward"></span>
                                        </a>
                                    </li>
                                <?php } else { ?>
                                    <li>
                                        <a class="page" href="log/view/<?php echo 1; ?>" aria-label="First">
                                            <span aria-hidden="true" class="glyphicon glyphicon-step-backward"></span>
                                        </a>
                                    </li>
                                    <li>
                                        <a class="page" href="log/view/<?php echo (int) $this->data['current_page'] - 1; ?>" aria-label="Previous">
                                            <span aria-hidden="true" class="glyphicon glyphicon-backward"></span>
                                        </a>
                                    </li>
                                <?php } ?>

                                <li >
                                    <span>
                                        <?php echo $this->data['current_page']; ?> <span class="sr-only">(current)</span>                                            
                                        of
                                        <?php echo $total_pages; ?> <span class="sr-only">Last</span>                                            
                                    </span>
                                </li>


                                <?php if ($this->data['current_page'] >= $total_pages) { ?>
                                    <li class="disabled">
                                        <a class="page" href="#" aria-label="Next">
                                            <span aria-hidden="true" class="glyphicon glyphicon-forward"></span>
                                        </a>
                                    </li>
                                <?php } else { ?>     
                                    <li>
                                        <a class="page" href="log/view/<?php echo (int) $this->data['current_page'] + 1; ?>" aria-label="Next">
                                            <span aria-hidden="true" class="glyphicon glyphicon-forward"></span>
                                        </a>
                                    </li>
                                    <li>
                                        <a class="page" href="log/view/<?php echo $total_pages; ?>" aria-label="Last">
                                            <span aria-hidden="true" class="glyphicon glyphicon-step-forward"></span>
                                        </a>
                                    </li>
                                <?php } ?>
                            </ul>
                        </nav>
                    <?php } else { ?>
                        <div class="alert alert-warning"> 
                            <h4>Permission!!</h4> 
                            Not Allowed!!
                        </div>
                    <?php } ?>
                <?php } ?>
            <?php } else { ?>
                <div class="alert alert-info"> 
                    <h4>No Log Data!!</h4> 
                    No data can be found in the system log

                </div>
            <?php } ?>
        </fieldset>
    </div>

</div>
