<script lang="jscript">
    $(document).ready(function () {
$('#month').prop('disabled',true);
$('#type').change(function(){
    if($('#type').val()!==''){
        $('#month').prop('disabled',false);
    }
});
        $('.loading')
                .hide();
    });
</script>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>
    <h4 class="modal-title" id="bunioModalLabel"><?php echo $this->title; ?></h4>
</div>
<div class="modal-body">
    <form method="post" id="frmExport"  action="data/export" class="form-horizontal">
        <div class="loading"></div>
        <div class="form-group">
            <label for="type" class="col-sm-4 control-label">Type:</label>
            <div class="col-sm-8">
                <select class="form-control" id="type" name="type" >
                    <option value="">All</option>
                    <?php foreach ($this->data['types'] as $type) { ?>
                        <option value="<?php echo $type['id'] ?>" <?php echo ($type['id'] == $_POST['type']) ? 'selected' : ''; ?>>
                            <?php echo $type['type']; ?>
                        </option>
                    <?php } ?>
                </select>
            </div>
        </div>
        <div class="form-group">
            <label for="type" class="col-sm-4 control-label">Month:</label>
            <div class="col-sm-8">
                <select class="form-control" id="month" name="month" >
                    <option value="">Select Month</option>
                    <?php foreach ($this->data['months'] as $month) { ?>
                        <option value="<?php echo $month['id'] ?>" <?php echo ($month['id'] == $_POST['month']) ? 'selected' : ''; ?>>
                            <?php echo $month['month']; ?>
                        </option>
                    <?php } ?>
                </select>
            </div>
        </div>
        <div class="form-group">
            <label for="deviceStatus" class="col-sm-4 control-label">Device Status:</label>
            <div class="col-sm-8">
                <select class="form-control" id="deviceStatus" name="deviceStatus">
                    <option value="">All</option>
                    <?php foreach ($this->data['status'] as $status) { ?>
                        <option value="<?php echo $status['id'] ?>" <?php echo ($status['id'] == $this->data['device']['status']) ? 'selected' : ''; ?>>
                            <?php echo $status['status']; ?>
                        </option>
                    <?php } ?>
                </select>
            </div>
        </div> 
        <div class="form-group">
            <label for="format" class="col-sm-4 control-label">Format:</label>
            <div class="col-sm-8">
                <div class="radio">
                    <label class="radio-inline">
                        <input type="radio" name="format" value="xls" checked>Excel
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="format" value="pdf" disabled>PDF
                    </label>                    
                </div>
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-4 col-sm-8">
                <button type="submit" id="btnPrint" class="btn btn-primary">Export</button>
            </div>
        </div>
    </form>

</div>