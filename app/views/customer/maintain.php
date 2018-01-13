<script>
    $(document).ready(function () {
        var title = '<?php echo $this->title; ?>';
        console.log($("#frmCustomer").attr("action"));
        $("#frmCustomer").submit(function (e) {
            $form = $(this);
            if ($("#frmCustomer").valid()) {
                $.post($form.attr("action"), $("#frmCustomer").serialize(), function (data) {
                    var obj = $.parseJSON(data);
                    if (obj.mtype === 'E') {
                        toastr.error(obj.msg, title);
                    } else if (obj.mtype === 'W') {
                        toastr.warning(obj.msg, title);
                        //alert(obj.msg);
                    } else if (obj.mtype === 'S') {
                        toastr.success(obj.msg, title);
                        location.reload();
                    }
                    console.log(data);
                }).fail(function (err) {
                    console.log(err);
                });
            }
            e.preventDefault();
        });

        /*$(".page").click(function (e) {
         url = $(this).attr('href');
         $.get(url, function (data) {
         $("#divMain").html(data);
         //console.log(data);
         });
         e.preventDefault();
         });*/

        $("#frmCustomer").validate({
            rules: {
                customerName: "required",
                fleetOrgNumber: "required",
                licenseNumber: "required",
                vehicleDescription: "required"
            },
            messages: {
                customerName: "Please enter customer name",
                fleetOrgNumber: "Please enter Fleet Orb Number",
                licenseNumber: "Please enter license number",
                vehicleDescription: "Please vehicle description"
            }
        });
    });
</script>
<!-- Modal -->
<!--<div class="modal fade" id="bunioModal" tabindex="-1" data-keyboard="false" data-backdrop="static" role="dialog" aria-labelledby="bunioModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">

        </div>
    </div>
</div>-->
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>
    <h4 class="modal-title" id="customerModalLabel"><?php echo $this->title; ?></h4>
</div>
<div class="modal-body">

    <form method="post" id="frmCustomer" action="customer/save" class="form-horizontal">
        <div class="form-group">
            <label for="customerId" class="col-sm-4 control-label">Customer ID</label>
            <div class="col-sm-8">
                <input type="hidden" id="state" name="state" value="<?php echo ($this->data['customer']) ? 'EDIT' : 'NEW'; ?>">
                <input type="text" class="form-control" id="customerId" name="customerId" placeholder="Customer ID" value="<?php echo $this->data['customer']['id']; ?>">
            </div>
        </div>
        <div class="form-group">
            <label for="customerName" class="col-sm-4 control-label">Customer Name</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="customerName" name="customerName" placeholder="Customer Name" value="<?php echo $this->data['customer']['customer_name']; ?>">
            </div>
        </div>
        <div class="form-group">
            <label for="fleetOrgNumber" class="col-sm-4 control-label">Fleet Orb Number</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="fleetOrgNumber" name="fleetOrgNumber" placeholder="Fleet Orb Number" value="<?php echo $this->data['customer']['fleet_org_number']; ?>">
            </div>
        </div> 
        <div class="form-group">
            <label for="licenseNumber" class="col-sm-4 control-label">License Number</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="licenseNumber" name="licenseNumber" placeholder="License Number" value="<?php echo $this->data['customer']['license_plate_number']; ?>">
            </div>
        </div> 
        <div class="form-group">
            <label for="vehicleDescription" class="col-sm-4 control-label">Vehicle Description</label>
            <div class="col-sm-8">
                <textarea class="form-control" id="vehicleDescription" name="vehicleDescription">
                    <?php echo $this->data['customer']['vehicle_description']; ?>
                </textarea>
            </div>
        </div> 
        <div class="form-group">
            <div class="col-sm-offset-4 col-sm-8">
                <?php if ($this->data['customer']) { ?>
                <a href="device_assignment/assign/<?php echo $this->data['customer']['id']; ?>" id="linkAssign" data-toggle="modal" data-target="#bunioModal">Assign</a>&nbsp;| &nbsp;
                <?php } ?>
                <button type="submit" id="btnSave" class="btn btn-success">Save</button>&nbsp;|&nbsp
                <button type="button" class="btn btn-default" data-dismiss="modal" aria-label="Close">Cancel</button>
            </div>
        </div>
    </form>

</div>