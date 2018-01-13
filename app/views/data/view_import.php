<script>
    $(document).ready(function () {
        var title = '<?php echo $this->title; ?>';
//        console.log($("#frmSearch").attr("action"));
//        $("#frmSearch").submit(function (e) {
//            $form = $(this);
//            $.post('user/index', $("#frmSearch").serialize(), function (data) {
//                $("#divMain").html(data);
//                //console.log(data);
//            });
//            e.preventDefault();
//        });

        $(".page").click(function (e) {
            url = $(this).attr('href');
            $.get(url, function (data) {
                $("#divMain").html(data);
                //console.log(data);
            });
            e.preventDefault();
        });

        $("#btnProceed").addClass("disabled");

        $("#chkImport").click(function (e) {
            var self = this;
            console.log(self.checked);

            $('.chkBox').each(function () {
                this.checked = self.checked;
            });

        });

        $(".chkBox").change(function (e) {
            console.log($("#btnProceed"));
        });

    });
</script>
<div class="panel panel-default">
    <div class="panel-heading"><?php echo $this->title; ?></div>
    <div class="panel-body">
        <p class="badge">Record(s): <?php echo $this->data['record_count']; ?></p>

        <p>                
            <a href="ass" id="btnProceed" data-toggle="modal" data-target="#bunioModal" class="btn btn-primary">Proceed</a>
        </p>
        <?php if (count($this->data['records']) > 0) { ?>
            <?php if (Auth::hasPermission('View_Data')) { ?>
                <table id="importedData" class="table table-bordered table-striped">
                    <tr>
                        <th class="text-center">
                            <label>Select All<br>
                                <input type="checkbox" id="chkImport" value="all">
                            </label>
                        </th>
                        <th>Account <a class="pull-right" href="sort"><i class="glyphicon glyphicon-sort"></i></a></th>
                        <th>IMEI</th>
                        <th>License</th>
                        <th>&nbsp;</th>
                    </tr>
                    <?php foreach ($this->data['records'] as $record) { ?>
                        <tr>
                            <td class="text-center"><input type="checkbox" class="chkBox" name="id[]" value="<?php echo $record['id']; ?>"></td>
                            <td><?php echo $record['account']; ?></td>
                            <td class="text-right"><?php echo $record['imei']; ?></td>
                            <td><?php echo $record['lic_number']; ?></td>
                            <td class="text-center">                           
                                <a href="data/import/details/<?php echo $record['id']; ?>" data-toggle="modal" data-target="#bunioModal"><?php echo 'DETAILS'; ?></a>
                            </td>
                        </tr>
                    <?php } ?>
                </table>
                <?php
                $total_pages = (int) ($this->data['record_count'] / $this->data['cfg']->limit);
                if ($this->data['record_count'] > $total_pages) {
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
                                    <a class="page" href="data/import/view/<?php echo 1; ?>" aria-label="First">
                                        <span aria-hidden="true" class="glyphicon glyphicon-step-backward"></span>
                                    </a>
                                </li>
                                <li>
                                    <a class="page" href="data/import/view/<?php echo (int) $this->data['current_page'] - 1; ?>" aria-label="Previous">
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
                                    <a class="page" href="data/import/view/<?php echo (int) $this->data['current_page'] + 1; ?>" aria-label="Next">
                                        <span aria-hidden="true" class="glyphicon glyphicon-forward"></span>
                                    </a>
                                </li>
                                <li>
                                    <a class="page" href="data/import/view/<?php echo $total_pages; ?>" aria-label="Last">
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
                <h4>No Data!!</h4> 
                No data can be found in the sytem
                <!--                        <a href="data/import" class="btn btn-info" data-toggle="modal" data-target="#dataModal">Import</a>-->
            </div>
        <?php } ?>
    </div>
</div>
