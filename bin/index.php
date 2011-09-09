<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="Content-language" content="en" />
    <title>FlashAtFix</title>
    <script type="text/javascript" src="js/swfobject.js"></script>
    <style>
        body {margin:0px;overflow:hidden}
        html, body, #flashcontent {width:100%;height:100%;outline:none;}
    </style>
    
 </head>
 
 <body style="text-align:center;">
	
	<div id="flashcontent" style="font-family:Verdana,sans-serif;display:none;">
		Vous n'avez pas la dernière version de Flash Player.<br/><a href="http://get.adobe.com/flashplayer/" target="_blank">Téléchargez-la</a>
	</div>
	<a href="https://github.com/myrddinus/FlashAtFix">Sources on GitHub</a>
	
	<script type="text/javascript">
		//<![CDATA[
		
		document.getElementById("flashcontent").style.display = 'block';
		
		var flashvars = {
		
		}
		
		var params = {
			allowScriptAccess: "always",
			wmode: "transparent",
			bgcolor : "#000000"
		};
	
		var attributes = {
			id: "app",
			name: "app"
		};
	
		swfobject.embedSWF("sample.swf?v=<?php echo time(); ?>", "flashcontent", "550", "400", "10.0.0","inc/expressInstall.swf", flashvars, params, attributes);
		
        //]]>
    </script>
</body>

</html>