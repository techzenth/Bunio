<script>
    $(document).ready(function () {
        var title = '<?php echo $this->title; ?>';
        console.log($("#frmSearch").attr("action"));
        
        $("#frmSearch").submit(function (e) {
            e.preventDefault();
            $form = $(this);
            url = $("#frmSearch").attr("action");
            $("#btnSearch").prop('disabled', true);
            $.post(url, $("#frmSearch").serialize(), function (data) {
                $("#divMain").html(data);
                //console.log(data);
            });
            
        });

        $(".page").click(function (e) {
            e.preventDefault();
            url = $(this).attr('href');
            $.get(url, function (data) {
                $("#divMain").html(data);
                //console.log(data);
            });
            
        });
    });
</script>
<!-- Modal -->
<div class="modal fade" id="userModal" tabindex="-1" data-keyboard="false" data-backdrop="static" role="dialog" aria-labelledby="userModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">

        </div>
    </div>
</div>
<div class="panel panel-default">
    <div class="panel-heading"><?php echo $this->title; ?></div>
    <div class="panel-body">
        <div class="container">
            <fieldset class="col-sm-6">
                <legend>Search</legend>
                <form method="post" id="frmSearch" action="user/search" class="form-horizontal">

                    <div class="form-group">
                        <label for="username" class="col-sm-4 control-label">User Name</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="username" name="username" placeholder="User Name" value="<?php echo $_POST['username']; ?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="user_status" class="col-sm-4 control-label">User Status</label>
                        <div class="col-sm-8">
                            <select class="form-control" id="user_status" name="user_status"> 
                                <option value="">Select User Status</option>
                                <?php foreach ($this->data['status'] as $status) { ?>
                                    <option value="<?php echo $status['id'] ?>" <?php echo ($status['id'] == $_POST['user_status']) ? 'selected' : ''; ?>><?php echo $status['status'] ?></option>
                                <?php } ?>
                            </select>

                        </div>
                    </div> 
                    <div class="form-group">
                        <label for="user_role" class="col-sm-4 control-label">User Role</label>
                        <div class="col-sm-8">
                            <select class="form-control" id="user_role" name="user_role"> 
                                <option value="">Select User Role</option>
                                <?php foreach ($this->data['roles'] as $role) { ?>
                                    <option value="<?php echo $role['id'] ?>" <?php echo ($role['id'] == $_POST['user_role']) ? 'selected' : ''; ?>><?php echo $role['role'] ?></option>
                                <?php } ?>
                            </select>

                        </div>
                    </div> 
                    <div class="form-group">
                        <div class="col-sm-offset-4 col-sm-8">
                            <button type="submit" id="btnSearch" class="btn btn-default">Search</button>
                        </div>
                    </div>
                </form>
            </fieldset>
        </div>
        <fieldset>
            <legend>Users</legend>
            <?php if (Auth::hasPermission('Add_User')) { ?>
                <p>                
                    <a href="user/add" id="linkNew" data-toggle="modal" data-target="#userModal" class="btn btn-primary">New</a>

                </p>
            <?php } ?>
            <?php if (count($this->data['records']) > 0) { ?>
                <?php if (Auth::hasPermission('View_User')) { ?>
                    <table id="devices" class="table table-bordered table-striped">
                        <tr>
                            <th>#</th>
                            <th>User Name <a class="page pull-right" href="user/index/<?php echo $this->data['current_page'] . '/' . ($this->data['sort'] == '') ? 'asc' : 'desc'; ?>"><i class="glyphicon glyphicon-sort"></i></a></th>
                            <th>Status</th>
                            <th>Role</th>
                            <th>&nbsp;</th>
                        </tr>
                        <?php foreach ($this->data['records'] as $record) { ?>
                            <tr>
                                <td><?php echo $record['id']; ?></td>
                                <td><?php echo $record['username']; ?></td>
                                <td><?php echo $record['status']; ?></td>
                                <td><?php echo $record['role']; ?></td>
                                <td class="text-center">
                                    <?php if (Auth::hasPermission('Edit_User')) { ?>
                                        <a data-toggle="modal" data-target="#userModal" href="user/edit/<?php echo $record['id']; ?>"><?php echo 'EDIT'; ?></a>
                                    <?php } ?>
                                    <?php if (Auth::hasPermission('Delete_User')) { ?>
                                        &nbsp;|&nbsp;
                                        <a data-toggle="modal" data-target="#userModal" href="user/delete/<?php echo $record['id']; ?>"><?php echo 'DELETE'; ?></a>
                                    <?php } ?>
                                </td>
                            </tr>
                        <?php } ?>
                    </table>
                    <?php
                    $total_pages = (int) ($this->data['record_count'] / $this->data['cfg']->limit);
                    if ($this->data['record_count'] > $this->data['cfg']->limit) {
                        ?>
                        <nav class="col-sm-offset-4">
                            <ul class="pagination">
                                <?php if ($this->data['current_page'] == 1) { ?>
                                    <li class="disabled">
                                        <a class="page" href="#" aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                <?php } else { ?>
                                    <li>
                                        <a class="page" href="device_assignment/index/<?php echo 1; ?>" aria-label="First">
                                            <span aria-hidden="true" class="glyphicon glyphicon-step-backward"></span>
                                        </a>
                                    </li>
                                    <li>
                                        <a class="page" href="device_assignment/index/<?php echo (int) $this->data['current_page'] - 1; ?>" aria-label="Previous">
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
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                <?php } else { ?>     
                                    <li>
                                        <a class="page" href="device_assignment/index/<?php echo (int) $this->data['current_page'] + 1; ?>" aria-label="Next">
                                            <span aria-hidden="true" class="glyphicon glyphicon-forward"></span>
                                        </a>
                                    </li>
                                    <li>
                                        <a class="page" href="device_assignment/index/<?php echo $total_pages; ?>" aria-label="Last">
                                            <span aria-hidden="true" class="glyphicon glyphicon-step-forward"></span>
                                        </a>
                                    </li>
                                <?php } ?>
                            </ul>
                        </nav>
                    <?php } ?>
                    <?php } else { ?>
                        <div class="alert alert-warning"> 
                            <h4>Permission!!</h4> 
                            Not Allowed!!
                        </div>
                    <?php } ?>
                
            <?php } else { ?>
                <div class="alert alert-info"> 
                    <h4>No Data!!</h4> 
                    No data can be found in the system
                </div>
            <?php } ?>
        </fieldset>
    </div>

</div>
