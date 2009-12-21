<%@ page import="org.opencms.workplace.galleries.*" %><%

A_CmsAjaxGallery wp = new CmsAjaxImageGallery(pageContext, request, response);

%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<!--[if IE 7]>
<style>
  div.container {
  	height: 1%;
  }
</style>
<![endif]-->
<link rel="stylesheet" type="text/css" media="screen" href="css/custom-theme/jquery-ui-1.7.2.custom.css" />
<link rel="stylesheet" type="text/css" media="screen" href="css/advanced_direct_edit.css" />
<link rel="stylesheet" type="text/css" media="screen" href="css/galleries.css" />
<style>
	* {
		margin: 0;
		padding: 0;
	}
	
	#cms-cropping-main {
		font-size: 12px;
		background: #ffffff;
		margin: 0;
		padding: 0;
	}
	
	#cms-cropping-main button {
        margin: 0 0 0 2px;
        padding: 0 3px;
        /* Fix for IE to avoid too wide buttons */
        height:23px !important;        
        padding: 0 3px 2px !important;
        width:auto;
        overflow:visible;
    }
	
	div.cms-border {
		background: #F9F9F9 none repeat scroll 0 0;
		margin: 1px 1px 1px 1px;
		padding: 2px 1px 2px 1px;
	}
	
	div.head {
		padding: 6px 0 6px 4px;
		font-size: 12px;
		font-weight: bold;
	}
	
	div.imgbg {		
		height: 366px;
		text-align: center;
	}
	
	div.container {
		
	}
	
	div.selection {
		font-size: 12px;
		margin-top:2px;
		text-align: center;
	}
	
	span.cms-item-title {
		display:inline-block;
		font-weight:bold;
		line-height:16px;
		margin-right: 0px;
	}
	
	span.cms-item-value {
		display:inline-block;
		margin-right:30px;
		width:40px;
	}
	
	div.button-bar.cms-center-buttom {
        text-align: center;        
        margin-top: 5px;
    }
        
</style>
<script type="text/javascript" src="lib/jquery-1.3.2.js"></script>
<script type="text/javascript" src="lib/jquery.imgareaselect.min.js"></script>
<script type="text/javascript">
var cms = { html: {}, previewhandler:{}, imagepreviewhandler: {}, galleries: {}, messages: {} };
</script>
<script type="text/javascript" src="/opencms/opencms/system/workplace/editors/ade/cms.messages.jsp"></script>
<script type="text/javascript" src="js/cms.html.js"></script>
<script type="text/javascript" src="js/cms.selectbox.js"></script>
<script type="text/javascript" src="js/cms.directinput.js"></script>
<script type="text/javascript" src="js/cms.galleries.js"></script>
<script type="text/javascript" src="js/cms.previewhandler.js"></script>
<script type="text/javascript" src="js/cms.imagepreviewhandler.js"></script>
<script type="text/javascript">
	var imgPreviewHeight = 366;
	if (parent.cms.galleries.initValues.dialogmode == "editor") {
		imgPreviewHeight = 390;
	}

	/* The image to crop. */
	var img = parent.cms.galleries.activeItem;
	
	/* The scale factor of the image. Initial value of 1 means that now downscaling is necessary. */
	var scaleFactor = 1;

	/* These variables store the DOM elements containing the selection information data. */
	var $x1, $y1, $w, $h;
	
	/* The values of the image selection. */
	var selX, selY, selW, selH;
	
	/* The initialization coordinates. */
	var initCoords;
	
	/* The flags for a variable width/height setting. */
	var variableWidth = false;
	var variableHeight = false;
	var targetSizeW = -1;
	var targetSizeH = -1;
 
    /* Callback function that is triggered every time the selection changes. */
	function selectChange(cropImg, selection) {
		// recalculate real selection values using the scale factor
		selX = Math.round(selection.x1 * scaleFactor);
		selY = Math.round(selection.y1 * scaleFactor);
		selW = Math.round(selection.width * scaleFactor);
		selH = Math.round(selection.height * scaleFactor);
		
		// assure that selection dimensions are correct and do not exceed image dimensions
		if ((selX + selW) > img.width) {
			selW = img.width - selX;
		}
		if ((selY + selH) > img.height) {
			selH = img.height - selY;
		}
		
		// adjust the selection dimensions to show the result size
		var shownW = selW;
		var shownH = selH;
		var factor = 1;
		if (variableWidth == true) {
			factor = selH / targetSizeH;
			shownW = Math.round(selW / factor);
			shownH = Math.round(selH / factor);
		} else if (variableHeight == true) {
			factor = selW / targetSizeW;
			shownW = Math.round(selW / factor);
			shownH = Math.round(selH / factor);
		} else if (parent.cms.imagepreviewhandler.formatSelected.type != "free") {
			shownW = targetSizeW;
			shownH = targetSizeH;
		}
		
		// display the updated information
		$w.text(shownW);
		$h.text(shownH);
		//$w.text(shownW + ", W: " + selW + ", X: " + selX);
		//$h.text(shownH + ", H: " + selH + ", Y: " + selY);
		updateRatio();
	}
	
	/* Updates the crop ratio, which is an indicator for the result image quality. */
	function updateRatio() {
		var result = 0;
		if (parent.cms.imagepreviewhandler.formatSelected.type == "free") {
			result = 100;
		} else {
			var sum = 0;
			if (variableWidth == true) {
				sum += (selH / targetSizeH) * 100;
			} else if (variableHeight == true) {
				sum += (selW / targetSizeW) * 100;
			} else {
				sum += (selW / targetSizeW) * 100;
				sum += (selH / targetSizeH) * 100;
				sum = sum / 2;
			}
			result = Math.round(sum);
		}
		$r.text(result + " %");
	}
	
	/* Sets the updated image information and closes the thickbox iframe. */
	function okPressed() {
		if (!isNaN(selX)) {
			if (variableWidth == true) {
				var factor = selH / targetSizeH;
				parent.cms.galleries.activeItem.newwidth = Math.round(selW / factor); 
			} else if (variableHeight == true) {
				var factor = selW / targetSizeW;
				parent.cms.galleries.activeItem.newheight = Math.round(selH / factor);
			} else if (parent.cms.imagepreviewhandler.formatSelected.type != "free") {
				parent.cms.galleries.activeItem.newwidth = targetSizeW;
				parent.cms.galleries.activeItem.newheight = targetSizeH;
			}
			var cropParams = "cx:" + selX;
			cropParams += ",cy:" + selY;
			cropParams += ",cw:" + selW;
			cropParams += ",ch:" + selH;
			parent.cms.galleries.activeItem.crop = cropParams;
			parent.cms.galleries.activeItem.cropx = selX;
			parent.cms.galleries.activeItem.cropy = selY;
			parent.cms.galleries.activeItem.cropw = selW;
			parent.cms.galleries.activeItem.croph = selH;
			if (parent.cms.imagepreviewhandler.formatSelected.type == "free") {
				parent.cms.galleries.activeItem.newwidth = selW;
				parent.cms.galleries.activeItem.newheight = selH;
			}
			parent.cms.imagepreviewhandler.setCropActive(true, true);
			
		}			
		parent.cms.imagepreviewhandler.closeCropDialog()	
		
	}
	
	/* Checks is the image is loaded, after successful load, activate the selector. */
	function checkImage() {
		if (!document.images[0].complete) {
			// image not yet loaded, check again
			setTimeout("checkImage();", 50);
		} else {
			// image loaded, now initialize image area selector
			setTimeout("$('#cropimg').imgAreaSelect({ selectionOpacity: 0, onSelectChange: selectChange" + initCoords + " });", 50);
		}
	}
	
	/* Buttons with ui jquery */
	function uiButtons() {
		$("button").addClass("ui-button ui-state-default ui-corner-all")
			.hover(
			function(){ 
				$(this).addClass("ui-state-hover"); 
			},
			function(){ 
				$(this).removeClass("ui-state-hover"); 	
			});
	}

	$(document).ready(function () {
		// show the image to crop, downscale it if necessary
		var srcAttr = img.linkpath;
		$(".imgbg").css("height", imgPreviewHeight + "px");
		var newDimensions = parent.cms.imagepreviewhandler.calculateDimensions(img.width, img.height, 600, imgPreviewHeight);
		scaleFactor = newDimensions.scaleFactor;
		if (scaleFactor != 1) {
			srcAttr += "?__scale=w:" + Math.round(newDimensions.width) + ",h:" + Math.round(newDimensions.height) + ",c:transparent,q:70";
		}
		$("#cropimg").attr("src", srcAttr);
		// store the information DOM elements in variables
		$w = $('#w');
		$h = $('#h');
		$r = $('#r');
		// get target sizes
		var width = img.newwidth <= 0 ? img.width : img.newwidth;
		var height = img.newheight <= 0 ? img.height : img.newheight;
		targetSizeW = width;
		targetSizeH = height;
		// check if variable width or height should be used for format selection
		if (parent.cms.imagepreviewhandler.formatSelected.type != "free" 
				&& parent.cms.imagepreviewhandler.formatSelected.type != "user") {
			if (parent.cms.imagepreviewhandler.formatSelected.height == -1) {
				// variable height
				variableHeight = true;
			} else if (parent.cms.imagepreviewhandler.formatSelected.width == -1) {
				// variable width
				variableWidth = true;
			}
		}
		// calculate initialization coordinates
		initCoords = "";
		if (img.isCropped == true) {
			// the image is already cropped, show the selection from start
			selX = img.cropx;
			selY = img.cropy;
			selW = img.cropw;
			selH = img.croph;
			var factor = 1;
			var shownW = selW;
			var shownH = selH;
			if (variableHeight == true) {
				factor = selW / targetSizeW;
				shownW = Math.round(selW / factor);
				shownH = Math.round(selH / factor);
			} else if (variableWidth == true) {
				factor = selH / targetSizeH;
				shownW = Math.round(selW / factor);
				shownH = Math.round(selH / factor);
			} else if (parent.cms.imagepreviewhandler.formatSelected.type != "free") {
				shownW = targetSizeW;
				shownH = targetSizeH;
			}

			// show the selection information
			$w.text(shownW);
			$h.text(shownH);
			updateRatio();
			// the selection coordinates must be calculated using the found scale factor
			initCoords += ", x1: " + Math.round(selX / scaleFactor);
			initCoords += ", y1: " + Math.round(selY / scaleFactor);
			initCoords += ", x2: " + Math.round((selX + selW) / scaleFactor);
			initCoords += ", y2: " + Math.round((selY + selH) / scaleFactor);
		} else {
			// image not yet cropped, eventually configure start parameters for format values
		}
		if ((parent.cms.imagepreviewhandler.formatSelected.type != "free" 
				&& !(parent.cms.imagepreviewhandler.formatSelected.width == -1 
			    || parent.cms.imagepreviewhandler.formatSelected.height == -1)) 
			    || parent.cms.imagepreviewhandler.formatSelected.type == "user") {
			initCoords += ", aspectRatio: \"" + width + ":" + height + "\"";
		}
		// check if image is loaded and activate selector
		checkImage();
		uiButtons();

		//bind event to the buttons
		$('button[name="crop-ok"]').click(okPressed);
		$('button[name="crop-cancel"]').click(parent.cms.imagepreviewhandler.closeCropDialog);
	});
</script>
</head>
<body>
	<div id="cms-cropping-main">
	    <div class="cms-border ui-widget-content ui-corner-all">
			<div class="head"><%= wp.key(Messages.GUI_IMAGEGALLERY_CROP_HEADLINE_0) %></div>
			
			<div class="imgbg">
				<div class="container">
					<img id="cropimg" src="#" />
				</div>
			</div>
		</div>
		<div class="cms-border ui-widget-content ui-corner-all">		
			<div class="selection">
				<span class="cms-item-title">Width:</span><span id="w" class="cms-item-value"></span>
				<span class="cms-item-title">Height:</span><span id="h" class="cms-item-value"></span>
				<span class="cms-item-title">Scale:</span><span id="r" class="cms-item-value"></span>
			</div>	
			<div class="button-bar cms-center-buttom">
				<button class="ui-state-default ui-corner-all" name="crop-ok">
					<span class="cms-galleries-button cms-galleries-icon-apply cms-icon-text">Ok</span>
				</button>
				<button class="ui-state-default ui-corner-all" name="crop-cancel">
					<span class="cms-galleries-button">Cancel</span>
				</button>
			</div>
		</div>
	</div>
</body>
</html>