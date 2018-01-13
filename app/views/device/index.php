<script>
    $(document).ready(function () {
        var title = '<?php echo $this->title; ?>';
        console.log($("#frmSearch").attr("action"));

        $("#btnReset").click(function (e) {
            $("#device_status").val('');
            $("#simNumber").val('');
            $("#msisdn").val('');
            $("#imei").val('');
            $("#frmSearch").submit(e);
        });

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
                console.log(url);
            });
            
        });

    });
</script>
<!-- Modal -->
<div class="modal fade" id="deviceModal" tabindex="-1" data-keyboard="false" data-backdrop="static" role="dialog" aria-labelledby="deviceModalLabel">
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
                <form method="post" id="frmSearch" action="device/search" class="form-horizontal">
                    <div class="form-group">
                        <label for="imei" class="col-sm-4 control-label">IMEI</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="imei" name="imei" placeholder="IMEI" value="<?php echo $_POST['imei']; ?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="msisdn" class="col-sm-4 control-label">MSISDN</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="msisdn" name="msisdn" placeholder="MSISDN" value="<?php echo $_POST['msisdn']; ?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="simNumber" class="col-sm-4 control-label">Sim Number</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="simNumber" name="simNumber" placeholder="Sim Number" value="<?php echo $_POST['simNumber']; ?>">
                        </div>
                    </div> 
                    <div class="form-group">
                        <label for="device_status" class="col-sm-4 control-label">Device Status</label>
                        <div class="col-sm-8">
                            <select class="form-control" id="device_status" name="device_status">
                                <option value="">Select Device Status</option>
                                <?php foreach ($this->data['status'] as $status) { ?>
                                    <option value="<?php echo $status['id'] ?>" <?php echo ($status['id'] == $_POST['device_status']) ? 'selected' : ''; ?>><?php echo $status['status'] ?></option>
                                <?php } ?>
                            </select>
                        </div>
                    </div> 
                    <div class="form-group">
                        <div class="col-sm-offset-4 col-sm-8">
                            <button type="submit" id="btnSearch" class="btn btn-default">Search</button>
                            <button type="button" id="btnReset" class="btn btn-default"> <span class="glyphicon glyphicon-refresh"></span></button>
                        </div>
                    </div>
                </form>
            </fieldset>
        </div>
        <fieldset>
            <legend>Devices</legend>
            <?php if (Auth::hasPermission('Add_Device')) { ?>
                <p>                
                    <a href="device/add" id="linkNew" data-toggle="modal" data-target="#deviceModal" class="btn btn-primary">New</a>

                </p>
            <?php } ?>
            <?php if (count($this->data['records']) > 0) { ?>
                <?php if (Auth::hasPermission('View_Device')) { ?>
                    <table id="devices" class="table table-bordered table-striped">
                        <tr>
                            <th>D Number</th>
                            <th>IMEI <a class="pull-right" href="sort"><i class="glyphicon glyphicon-sort"></i></a></th>
                           <th>MSISDN</th>
                           <th>Status</th>                            
                            <th>&nbsp;</th>
                        </tr>
                        <?php foreach ($this->data['records'] as $record) { ?>
                            <tr>
                                <td><?php echo $record['d_number']; ?></td>
                                <td><?php echo $record['imei']; ?></td>
                                <td><?php echo $record['msisdn']; ?></td>
                                <td><?php echo $record['status']; ?></td>
                                <td class="text-center">
                                    <?php if (Auth::hasPermission('Edit_Device')) { ?>
                                        <a href="device/edit/<?php echo $record['imei']; ?>" data-toggle="modal" data-target="#deviceModal"><?php echo 'EDIT'; ?></a>
                                    <?php } ?>
                                    <?php if (Auth::hasPermission('Delete_Device')) { ?>
                                        &nbsp;|&nbsp;
                                        <a href="device/delete/<?php echo $record['imei']; ?>" data-toggle="modal" data-target="#deviceModal"><?php echo 'DELETE'; ?></a>
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
                                        <a class="page" href="device/search/<?php echo 1; ?>" aria-label="First">
                                            <span aria-hidden="true" class="glyphicon glyphicon-step-backward"></span>
                                        </a>
                                    </li>
                                    <li>
                                        <a class="page" href="device/search/<?php echo (int) $this->data['current_page'] - 1; ?>" aria-label="Previous">
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
                                        <a class="page" href="device/search/<?php echo (int) $this->data['current_page'] + 1; ?>" aria-label="Next">
                                            <span aria-hidden="true" class="glyphicon glyphicon-forward"></span>
                                        </a>
                                    </li>
                                    <li>
                                        <a class="page" href="device/search/<?php echo $total_pages; ?>" aria-label="Last">
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

