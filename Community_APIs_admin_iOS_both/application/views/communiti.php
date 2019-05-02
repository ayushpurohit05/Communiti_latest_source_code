<!doctype html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>Communiti</title>
		<base href="/">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="icon" type="image/x-icon" href="favicon.ico">
		<script>
			var pst_id ="<?php echo $pstId ?>";
			var type_post ="<?php echo $type ?>";
			var app = {
			launchApp: function() {
			window.location.replace("Community://type="+type_post+"&pst_id="+pst_id);
			this.timer = setTimeout(this.openWebApp, 1000);
			},
			openWebApp: function() {
			window.location.replace("https://itunes.apple.com/us/app/communiti/id1234138195?mt=8");
			}
			};
			window.onload = function() {
			app.launchApp();
			};
		</script>
	</head>
	<body>
	</body>
</html>