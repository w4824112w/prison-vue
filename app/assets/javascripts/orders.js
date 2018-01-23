(function(){
	var status = $(".status");
	for(var i=0;i<status.length;i++){
		var btn = $(status[i]).parent().find(".reach");
		var id = $(status[i]).parent().find(".id").text();
		$(status[i]).parent().find(".details").attr({href:"/orders/"+id});
		if($(status[i]).text() == "已配送"){
			$(status[i]).html("<span>已配送 </span> <i class='icon fa fa-check'> </i>");
			$(btn).parent().html("<button class='btn btn-block btn-default disabled'>已配送</button>");
		}
		if(i%2 == 0){
			$(status[i]).parent().addClass(" info");
		}
	}
	$(".reach").click(function(){
		$("#formModal").modal("toggle");

		var id = $(this).parent().parent().find(".id").text();
		$(".complete").click(function(){
			var data = {
				order:{"status":"已配送"}
			}
			$.ajax({
	 	   	type:"PUT",
        url:"/orders/"+id,
        dataType:"json",
        data:data,
        success:function(){
        	window.location.reload();
        }
			})
		})
	})
//分页
	//alert($("tr").length);
	var order_list = $("tbody").find("tr");
	var child = "";
	var now_page = 1;
	//$(".pagination").find("#1").unbind("click");
	//alert(Math.ceil(order_list.length/10));
	var page_num = Math.ceil(order_list.length/10)//向上取整,得总共的分页数
	//console.log($(".page").find(".prev"));
	for(var rank=1;rank<=page_num;rank++){
		child += "<li><a style='cursor:pointer' class='page_num' id='"+rank+"'>"+rank+"</a></li>";
	}
	$(".pagination").append("<li><a style='cursor:pointer' class='first'>首页</a></li>"+
                "<li><a style='cursor:pointer' class='prev'>上一页</a></li>"+
                child+
                "<li><a style='cursor:pointer' class='next'>下一页</a></li>"+
                "<li><a style='cursor:pointer' class='last'>尾页</a></li>");

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
		//alert($(this).find("a").text());
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

}())
