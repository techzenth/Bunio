<script>
    $(document).ready(function () {
        var title = '<?php echo $this->title; ?>';
        console.log($("#frmSearch").attr("action"));
        $("#frmSearch").submit(function (e) {
            $form = $(this);
            $.post('customer/index', $("#frmSearch").serialize(), function (data) {
                $("#divMain").html(data);
                /console.log(data);
            });
            e.preventDefault();
        });
        $(".page").click(function (e) {
            url = $(this).attr('href');
            $.get(url, function (data) {
                $("#divMain").html(data);
                /console.log(data);
            });
            e.preventDefault();
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
                            <input type="text" class="form-control" id="customerId" name="customerId" placeholder="Customer ID" value="<?php echo $_POST['customerId'];?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="customerName" class="col-sm-4 control-label">Customer Name</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="customerName" name="customerName" placeholder="Customer Name" value="<?php echo $_POST['customerName'];?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="licenseNumber" class="col-sm-4 control-label">License Number</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="licenseNumber" name="licenseNumber" placeholder="License Number" value="<?php echo $_POST['licenseNumber'];?>">
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
            <legend>Customers</legend>
            <p>                
                <a href="customer/add" id="linkNew" data-toggle="modal" data-target="#customerModal" class="btn btn-primary">New</a>

            </p>
            <?php if (count($this->data['records']) > 0) { ?>
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
                                <a data-toggle="modal" data-target="#customerModal" href="customer/edit/<?php echo $record['id']; ?>"><?php echo 'EDIT'; ?></a>&nbsp;|&nbsp;
                                <a data-toggle="modal" data-target="#customerModal" href="customer/delete/<?php echo $record['id']; ?>"><?php echo 'DELETE'; ?></a></td>
                        </tr>
                    <?php } ?>
                </table>
                <?php if ($this->data['record_count'] > $this->data['cfg']->limit) { ?>
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
                                    <a class="page" href="user/index/<?php echo (int) $this->data['current_page'] - 1; ?>" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                            <?php } ?>
                            <?php for ($i = 0; $i < $this->data['record_count']; $i++) { ?>
                                <?php if ($this->data['current_page'] == $i + 1) { ?>
                                    <li class="active">
                                        <span>
                                            <?php echo $i + 1; ?> <span class="sr-only">(current)</span>                                            
                                        </span>
                                    </li>
                                <?php } else { ?>
                                    <li >
                                        <a class="page" href="user/index/<?php echo $i + 1; ?>" >
                                            <?php echo $i + 1; ?>
                                        </a>
                                    </li>
                                <?php } ?>
                            <?php } ?>
                            <?php if ($this->data['current_page'] == $this->data['record_count']) { ?>
                                <li class="disabled">
                                    <a class="page" href="#" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            <?php } else { ?>     
                                <li>
                                    <a class="page" href="user/index/<?php echo (int) $this->data['current_page'] + 1; ?>" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            <?php } ?>
                        </ul>
                    </nav>
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
