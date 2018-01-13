<div class="container">
	<div class="error-template">
		<h1><?php echo $this->title; ?></h1>
		<img alt="<?php echo $this->data['description']; ?>" src="<?php echo $this->data['cfg']->url;?>app/views/error/images/error.png"/>
		<hr/>
		<p class="lead">
			<?php echo $this->data['msg']; ?><br/>
		</p>
	</div>
</div><!-- /.container -->
