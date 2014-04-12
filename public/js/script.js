//
// See http://kagen88.blogspot.jp/2011/07/javascriptimagepreview.html
//
this.imagePreview = function(){
	/* CONFIG */

		xOffset = 100;  // 上方向へのずれ
		yOffset = 10;   // 右方向へのずれ

		// these 2 variable determine popup's distance from the cursor
		// you might want to adjust to get the right result

	/* END CONFIG */

	//$("a.preview").hover(function(e){
        //        // 動的に preview の存在を調べる -- katoy
        //        if(!$(this).hasClass('preview')) {
        //            return true;
        //        }
        //
	//	this.t = this.title;
	//	this.title = "";
        //
	//	var c = (this.t != "") ? "" + this.t : "";
	//	$("body").append("<p id='preview'><img src='"+ this.href +"' alt='Image preview' />"+ c +"</p>");
	//	$("#preview")
	//		.css("top",(e.pageY - xOffset) + "px")
	//		.css("left",(e.pageX + yOffset) + "px")
	//		.fadeIn("fast");
	//},
	//function(){
        //        // title = undefined にならないようにする。-- katoy
	//	if (this.t) {
        //          this.title = this.t;
        //        }
	//	$("#preview").remove();
	//});
        //
	//$("a.preview").mousemove(function(e){
	//	$("#preview")
	//		.css("top",(e.pageY - xOffset) + "px")
	//		.css("left",(e.pageX + yOffset) + "px");
	//});

	$(document).on("mouseenter", "a.preview", function(e){
                // 動的に preview の存在を調べる -- katoy
                if(!$(this).hasClass('preview')) {
                    return true;
                }

		this.t = this.title;
		this.title = "";

		var c = (this.t != "") ? "" + this.t : "";
		$("body").append("<p id='preview'><img src='"+ this.href +"' alt='Image preview' />"+ c +"</p>");
		$("#preview")
			.css("top",(e.pageY - xOffset) + "px")
			.css("left",(e.pageX + yOffset) + "px")
			.fadeIn("fast");
	});
	$(document).on("mouseleave", "a.preview", function(){
                // title = undefined にならないようにする。-- katoy
		if (this.t) {
                  this.title = this.t;
                }
		$("#preview").remove();
	});

	$(document).on("mousemove", "a.preview", function(e){
		$("#preview")
			.css("top",(e.pageY - xOffset) + "px")
			.css("left",(e.pageX + yOffset) + "px");
	});
};

// 画像がなかった時は、動的に preview 機能を off にする。-- katoy
function set_no_img(elem) {
    elem.src='images/404.png';
    elem.parentNode.className = "";
    elem.parentNode.title = "";
};

