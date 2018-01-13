<script>
    $(document).ready(function () {
        var title = '<?php echo $this->title; ?>';
        console.log($("#frmAssign").attr("action"));

        $("#installDate").datepicker();

        $("#frmAssign").submit(function (e) {
            $form = $(this);
            if ($("#frmAssign").valid()) {
                $('#btnSave').prop('disabled', true);
                $.post($form.attr("action"), $("#frmAssign").serialize(), function (data) {
                    console.log(data);
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
                $('#btnSave').prop('disabled', false);
            }
            e.preventDefault();
        });

        $("#autocomplete").hide();
        $("#search_customer").keyup(function (e) {
            $("#autocomplete").show();
            $("#autocomplete").html('');
            $.post('device_assignment/get_customers', {customer: $("#search_customer").val()}, function (data) {
                var obj = $.parseJSON(data);
                //console.log(data);
                if (obj.mtype === 'E') {
                    toastr.error(obj.msg, title);
                } else if (obj.mtype === 'W') {
                    toastr.warning(obj.msg, title);
                    //alert(obj.msg);
                } else if (obj.mtype === 'S') {
                    toastr.success(obj.msg, title);
                    //console.log(obj.data);
                    $.each(obj.data, function (index, customer) {
                        //console.log(customer);
                        var array = $.map(customer, function (value, index) {
                            return [value];
                        });
                        //console.log(array[0]);

                        $("#autocomplete").append("<li><a class=\"select-customer\"' id=\"" + array[0] + "\" name=\"" + array[0] + " " + array[1] + "\">&nbsp;" + array[0] + " " + array[1] + "&nbsp;</a></li>");
                        //$("#autocomplete").add(id + ' ' + name);
                        $(".select-customer").on("click", (function (e) {

                            $("#customerId").val($(this).attr("id"));
                            $("#search_customer").val($(this).attr("name"));
                            $("#autocomplete").html('');
                            $("#autocomplete").hide();
                            console.log($(this).attr("id"));
                            e.preventDefault();
                        }));
                    });

                }
            });

        });




//        var availableTags = [
//            "ActionScript", "AppleScript", "Asp", "BASIC", "C", "C++",
//            "Clojure", "COBOL", "ColdFusion", "Erlang", "Fortran",
//            "Groovy", "Haskell", "Java", "JavaScript", "Lisp", "Perl",
//            "PHP", "Python", "Ruby", "Scala", "Scheme"
//        ];
//
//        $(".autocomplete").autocomplete({
//            source: availableTags
//        });

        /*$(".page").click(function (e) {
         url = $(this).attr('href');
         $.get(url, function (data) {
         $("#divMain").html(data);
         //console.log(data);
         });
         e.preventDefault();
         });*/

        $("#frmAssign").validate({
            rules: {
                search_customer: "required",
                simNumber: "required",
                imei: "required",
                installDate: "required",
                installFee: "required",
                subscribeFee: "required"
            },
            messages: {
                search_customer: "Search for a customer",
                simNumber: "Please enter Sim Number",
                imei: "Please select an IMEI",
                installDate: "Please enter Install Date",
                installFee: "Please enter Install Fee",
                subscribeFee: "Please enter Subscription Fee"
            }
        });
    });
</script>
<style>
    #autocomplete{
        /* border-style:outset;
         border-bottom-left-radius: .5em;
         border-bottom-right-radius: .5em;
         border-bottom-width: 1px;
         border-left-width: 1px;
         border-right-width: 1px;
         border-bottom-color: #000;
          border-left-color: #000;
         border-right-color: #000;
         position: absolute;
         background-color: #fff;
         z-index: 999;
     display: list-item;*/
    }
    #autocomplete a{
        /*width: 100%;
        cursor: default;
        text-decoration: none;
        display: block;*/
    }
    #autocomplete a:hover{
        /* background-color: #ff0;*/

    }
</style>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>
    <h4 class="modal-title" id="bunioModalLabel"><i class="glyphicon glyphicon-edit"></i>&nbsp;<?php echo $this->title; ?></h4>
</div>
<div class="modal-body">

    <form method="post" id="frmAssign" action="device_assignment/assign/save" class="form-horizontal">
        <?php if ($this->data['assignment']['customer_id'] != '') { ?>
            <div class="form-group">
                <label for="customer" class="col-sm-4 control-label">Customer</label>
                <div class="col-sm-8">
                    <input type="hidden" name="customerId" value="<?php echo $this->data['assignment']['customer_id']; ?>" />
                    <input type="text" class="form-control" id="customer" name="customer" placeholder="Customer" value="<?php echo $this->data['assignment']['customer_info']; ?>" readonly>
                </div>
            </div>
        <?php } else { ?>
            <div class="form-group">
                <label for="customer" class="col-sm-4 control-label">Customer</label>
                <div class="col-sm-8">
                    <input type="hidden" id="customerId" name="customerId" value=""/>
                    <input type="text" class="form-control" data-toggle="dropdown" id="search_customer" name="search_customer" placeholder="Search Customer" value="" autocomplete="off" />
                    <ul id="autocomplete" class="dropdown-menu" ></ul>
                    <?php /*
                      <select class="form-control" id="customerId" name="customerId" placeholder="Customer">
                      <option value="">Select Customer</option>
                      <?php foreach ($this->data['customers'] as $customer) { ?>
                      <option value="<?php echo $customer['id'] ?>" <?php echo ($customer['id'] == $_POST['customerId']) ? 'selected' : ''; ?>>
                      <?php echo $customer['customer_name']; ?>
                      </option>
                      <?php } ?>
                     
                    </select>*/ ?>
                </div>
            </div>
        <?php } ?>
        <div class="form-group">
            <label for="simNumber" class="col-sm-4 control-label">Sim Number</label>
            <div class="col-sm-8">
                <input type="text" class="form-control" id="simNumber" name="simNumber" placeholder="Sim Number" value="<?php echo $this->data['assignment']['sim_number']; ?>">
            </div>
        </div>
        <div class="form-group">
            <label for="device" class="col-sm-4 control-label">Device</label>
            <div class="col-sm-8">
                <?php if ($this->data['assignment']['imei']) { ?>
                    <input type="hidden" name="imeiNumber" value="<?php echo $this->data['assignment']['imei']; ?>">
                <?php } ?>
                <select class="form-control" id="imei" name="imei">
                    <option value="" >Select Device</option>
                    <?php foreach ($this->data['devices'] as $device) { ?>
                        <option value="<?php echo $device['imei'] ?>" <?php echo ($device['imei'] === $this->data['assignment']['imei']) ? 'selected' : 'D'; ?>>
                            <?php echo $device['imei']; ?>
                        </option>
                    <?php } ?>
                </select>
            </div>
        </div> 
        <div class="form-group">
            <label for="installDate" class="col-sm-4 control-label">Installation Date</label>
            <div class="col-sm-8">
                <input type="date" class="form-control" id="installDate" name="installDate" placeholder="Installation Date" value="<?php echo $this->data['assignment']['installation_date']; ?>">
            </div>
        </div> 
        <div class="form-group">
            <label for="installFee" class="col-sm-4 control-label">Installation Fee</label>
            <div class="col-sm-8">
                <div class="input-group">
                    <div class="input-group-addon">$</div>
                    <input type="text" class="form-control" id="installFee" name="installFee" placeholder="Installation Fee" value="<?php echo $this->data['assignment']['installation_fee']; ?>">
                    <div class="input-group-addon">.00</div>
                </div>
            <!-- <input type="text" class="form-control" id="installFee" name="installFee" placeholder="Installation Fee">-->
            </div>
        </div> 
        <div class="form-group">
            <label for="subscribeFee" class="col-sm-4 control-label">Subscription Fee</label>
            <div class="col-sm-8">
                <div class="input-group">
                    <div class="input-group-addon">$</div>
                    <input type="text" class="form-control" id="subscribeFee" name="subscribeFee" placeholder="Subscription Fee" value="<?php echo $this->data['assignment']['subscription_fee']; ?>">
                    <div class="input-group-addon">.00</div>
                </div>
<!-- <input type="text" class="form-control" id="subscribeFee" name="subscribeFee" placeholder="Subscription Fee">-->
            </div>
        </div> 
        <div class="form-group">
            <label for="additionalFeatures" class="col-sm-4 control-label">Additional Features</label>
            <div class="col-sm-8">
                <textarea class="form-control" id="additionalFeatures" name="additionalFeatures">
                    <?php echo $this->data['assignment']['additional_features']; ?>
                </textarea>
            </div>
        </div>
        <div class="form-group">
            <label for="technician" class="col-sm-4 control-label">Technician</label>
            <div class="col-sm-8">
                <select class="form-control" id="technician" name="technician"> 
                    <option value="">Select Technician</option>
                    <?php foreach ($this->data['technicians'] as $technician) { ?>
                        <option value="<?php echo $technician['id']; ?>" <?php echo ($technician['id'] == $this->data['assignment']['technician']) ? 'selected' : ''; ?>>
                            <?php echo $technician['technician']; ?>
                        </option>
                    <?php } ?>
                </select>

            </div>
        </div>
        <div class="form-group">
            <label for="jobDecription" class="col-sm-4 control-label">Job Description</label>
            <div class="col-sm-8">
                <textarea class="form-control" id="jobDecription" name="jobDecription">
                    <?php echo $this->data['assignment']['job_description']; ?>
                </textarea>
            </div>
        </div>
        <div class="form-group">
            <label for="services" class="col-sm-4 control-label">Services</label>
            <?php //echo $this->data['assignment']['services'];  ?>
            <div class="col-sm-8 checkbox">
                <label>
                    <input type="checkbox" id="service1" name="services[]" value="fleet" <?php echo ($this->data['assignment']['services'] == 'fleet' || $this->data['assignment']['services'] == 'combo') ? 'checked' : ''; ?>>Fleet
                </label>      
                <label>
                    <input type="checkbox" id="service2" name="services[]" value="security" <?php echo ($this->data['assignment']['services'] == 'security' || $this->data['assignment']['services'] == 'combo') ? 'checked' : ''; ?>>Security
                </label>
            </div>
        </div> 
        <div class="form-group">
            <div class="col-sm-offset-4 col-sm-8">
                <button type="submit" id="btnSave" class="btn btn-success">Save</button>&nbsp;|&nbsp;
                <button type="button" class="btn btn-default" data-dismiss="modal" aria-label="Close">Cancel</button>
            </div>
        </div>
    </form>
</div>