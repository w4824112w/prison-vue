(function($){
	$(".mailbox-name").find("a").click(function(){
		var id = $(this).parent().find("p").text();
		$(this).attr({href:"/mail_boxes/"+id});
	})

	$(".fa-reply").parent().click(function(){
		var id = $(".id").text();
		$(this).attr({href:"/mail_boxes/"+id+"/comments/new"});
	})

	var mail_date = $(".mailbox-date");
	for(var i=0;i<mail_date.length;i++){
		var time =  $(mail_date[i]).text().split(" ");
		time = time[0]+"   "+time[1];
		$(mail_date[i]).text(time);
	}
	//分页
	var order_list = $("tr");
	var child = "";
	var now_page = 1;
	var li_a = $(".pagination").find(".page_num");
	var page_num = Math.ceil(order_list.length/10)//向上取整,得总共的分页数
	for(var rank=1;rank<=page_num;rank++){
		child += "<li><a style='cursor:pointer' class='page_num' id='"+rank+"'>"+rank+"</a></li>";
	}
	$(".pagination").append("<li style='cursor:pointer'><a class='first'>首页</a></li>"+
			                "<li style='cursor:pointer'><a class='prev'>上一页</a></li>"+
			                child+
			                "<li style='cursor:pointer'><a class='next'>下一页</a></li>"+
			                "<li style='cursor:pointer'><a class='last'>尾页</a></li>");
	if(page_num == 1){
		for(var i=0;i<order_list.length;i++){
			$(order_list[i]).css({
				"display":""
			})
		}
		now_page = 1;
	}else{
		for(var i=0;i<10;i++){
			$(order_list[i]).css({
				"display":""
			})
		}
		now_page = 1;
	}
	$("#1").css({
				"background-color":"#3c8dbc",
				"color":"white"
			})
	$(".pagination").find(".page_num").click(function(){
		var show_page_num = parseInt($(this).text());
		if(now_page != show_page_num){
			$("#"+show_page_num).css({
				"background-color":"#3c8dbc",
				"color":"white"
			})
			$("#"+now_page).css({
				"background-color":"",
				"color":""
			})
			for(var i=show_page_num*10-1;i>=show_page_num*10-10;i--){
				$(order_list[i]).css({
					"display":""
				})
			}
			for(var i=now_page*10-1;i>=now_page*10-10;i--){
				$(order_list[i]).css({
					"display":"none"
				})
			}
		}
		now_page = show_page_num;
	})

	$(".first").click(function(){
		var show_page_num = 1;
		if(now_page != show_page_num){
			$("#"+show_page_num).css({
				"background-color":"#3c8dbc",
				"color":"white"
			})
			$("#"+now_page).css({
				"background-color":"",
				"color":""
			})
			for(var i=show_page_num*10-1;i>=show_page_num*10-10;i--){
				$(order_list[i]).css({
					"display":""
				})
			}
			for(var i=now_page*10-1;i>=now_page*10-10;i--){
				$(order_list[i]).css({
					"display":"none"
				})
			}
		}
		now_page = show_page_num;
	})
	$(".last").click(function(){
		var show_page_num = page_num;
		if(now_page != show_page_num){
			$("#"+show_page_num).css({
				"background-color":"#3c8dbc",
				"color":"white"
			})
			$("#"+now_page).css({
				"background-color":"",
				"color":""
			})
			for(var i=show_page_num*10-1;i>=show_page_num*10-10;i--){
				$(order_list[i]).css({
					"display":""
				})
			}
			for(var i=now_page*10-1;i>=now_page*10-10;i--){
				$(order_list[i]).css({
					"display":"none"
				})
			}
		}
		now_page = show_page_num;
	})
	$(".next").click(function(){
		var show_page_num = now_page + 1;
		if(show_page_num <= page_num){
			$("#"+show_page_num).css({
				"background-color":"#3c8dbc",
				"color":"white"
			})
			$("#"+now_page).css({
				"background-color":"",
				"color":""
			})
			for(var i=show_page_num*10-1;i>=show_page_num*10-10;i--){
				$(order_list[i]).css({
					"display":""
				})
			}
			for(var i=now_page*10-1;i>=now_page*10-10;i--){
				$(order_list[i]).css({
					"display":"none"
				})
			}
			now_page = show_page_num;
		}
	})
	$(".prev").click(function(){
		var show_page_num = now_page - 1;
		if(show_page_num >= 1){
			$("#"+show_page_num).css({
				"background-color":"#3c8dbc",
				"color":"white"
			})
			$("#"+now_page).css({
				"background-color":"",
				"color":""
			})
			for(var i=show_page_num*10-1;i>=show_page_num*10-10;i--){
				$(order_list[i]).css({
					"display":""
				})
			}
			for(var i=now_page*10-1;i>=now_page*10-10;i--){
				$(order_list[i]).css({
					"display":"none"
				})
			}
			now_page = show_page_num;
		}
	})

//添加监狱名称---------------------------------
  $(".update").click(function(){
  	var mail_box = $(".contents").val();
  	var prison_title = $(".prison_title").text();
  	$(".contents").val(mail_box + "\n                                          "+prison_title);
  	 
  })
})(jQuery)