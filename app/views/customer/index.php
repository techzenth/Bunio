<script>
    $(document).ready(function () {
        var title = '<?php echo $this->title; ?>';
        console.log($("#frmSearch").attr("action"));

        $("#btnReset").click(function (e) {
            $("#customerId").val('');
            $("#customerName").val('');
            $("#licenseNumber").val('');
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
<div class="modal fade" id="customerModal" tabindex="-1" data-keyboard="false" data-backdrop="static" role="dialog" aria-labelledby="customerModalLabel">
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
                <form method="post" id="frmSearch" action="customer/search" class="form-horizontal">
                    <div class="form-group">
                        <label for="customerId" class="col-sm-4 control-label">Customer ID</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="customerId" name="customerId" placeholder="Customer ID" value="<?php echo $_POST['customerId']; ?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="customerName" class="col-sm-4 control-label">Customer Name</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="customerName" name="customerName" placeholder="Customer Name" value="<?php echo $_POST['customerName']; ?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="licenseNumber" class="col-sm-4 control-label">License Number</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="licenseNumber" name="licenseNumber" placeholder="License Number" value="<?php echo $_POST['licenseNumber']; ?>">
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
            <legend>Customers</legend>
            <?php if (Auth::hasPermission('Add_Customer')) { ?>
                <p>                
                    <a href="customer/add" id="linkNew" data-toggle="modal" data-target="#customerModal" class="btn btn-primary">New</a>

                </p>
            <?php } ?>
            <?php if (count($this->data['records']) > 0) { ?>
                <?php if (Auth::hasPermission('View_Customer')) { ?>
                    <table id="devices" class="table table-bordered table-striped">
                        <tr>
                            <th>#</th>
                            <th>Customer Name <a class="pull-right" href="sort"><i class="glyphicon glyphicon-sort"></i></a></th>

                            <th>License</th>
                            <th>&nbsp;</th>
                        </tr>
                        <?php foreach ($this->data['records'] as $record) { ?>
                            <tr>
                                <td><?php echo $record['id']; ?></td>
                                <td><?php echo $record['customer_name']; ?></td>
                                <td><?php echo $record['license_plate_number']; ?></td>
                                <td class="text-center">
                                    <?php if (Auth::hasPermission('Edit_Customer')) { ?>
                                        <a data-toggle="modal" data-target="#customerModal" href="customer/edit/<?php echo $record['id']; ?>"><?php echo 'EDIT'; ?></a>
                                    <?php } ?>                                        
                                    <?php if (Auth::hasPermission('Delete_Customer')) { ?>
                                        &nbsp;|&nbsp;
                                        <a data-toggle="modal" data-target="#customerModal" href="customer/delete/<?php echo $record['id']; ?>"><?php echo 'DELETE'; ?></a></td>
                                <?php } ?>
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
