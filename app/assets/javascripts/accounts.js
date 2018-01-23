
// (function(){
// 		var table = $('#tTrolleys').DataTable({
// 			processing: true,
// 		    serverSide: true,
// 		    paging: true,//启用分页
// 		    length:10,
// 		    ordering:false,
// 				// searching:false,//右上角的搜索文本，可以写html标签
// 		    pagingType: "full_numbers",//分页样式的类型
// 		    language: {
// 			  lengthMenu: '<select style="width:150px;" class="form-control input-xsmall">' + '<option value="1">1</option>' + '<option value="10">10</option>' + '<option value="20">20</option>' + '<option value="30">30</option>' + '<option value="40">40</option>' + '<option value="50">50</option>' + '</select> 条记录',//左上角的分页大小显示。
// 			    paginate: {//分页的样式内容。
// 			      previous: "上一页",
// 			      next: "下一页",
// 			      first: "第一页",
// 			      last: "最后"
// 			    },
// 			    zeroRecords: "没有内容",//table tbody内容为空时，tbody的内容。
// 			    //下面三者构成了总体的左下角的内容。
// 			    info: "总共_PAGES_ 页， 总共_TOTAL_ 条记录",//左下角的信息显示，大写的词为关键字。
// 			    infoEmpty: "0条记录",//筛选为空时左下角的显示。
// 			    infoFiltered: ""//筛选之后的左下角筛选提示，
// 				},
// 		    ajax: {
// 		    	'url':'/accounts',
// 		    	//自定义数据源
		    // 	'dataSrc':function(json){
		    // 		var prisoners = json.data.prisoner_data;
		    // 		var accounts = json.data.accounts;
		    // 		var account_details = json.data.account_details;
				//
	    	// 		for(var i=0;i<prisoners.length;i++){
		    // 			for(var j=0;j<accounts.length;j++){
		    // 				if( accounts[j] && prisoners[i].id == accounts[j].prisoner_id ) {
		    // 					prisoners[i].account = accounts[j];
		    // 				}
		    // 			}
		    // 		}
				//
		    // 		for(var i=0;i<prisoners.length;i++){
		    // 			if(prisoners[i].account){
		    // 				for(var j=0;j<account_details.length;j++){
		    // 					if( account_details[j][0] && prisoners[i].account.id == account_details[j][0].accounts_id){
		    // 						prisoners[i].account_details = account_details[j];
		    // 					}
		    // 				}
		    // 			}
		    // 		}
				//
		    // 		return prisoners
		    // 	}
		    // },
// 		    createdRow:function(row,data,index){
// 		    	$(row).find(".account_details").on('click',function(){
// 		    		$("#accountModal").modal("toggle");
// 		    		$("#accountModal").find(".prisoner_name").text(data.name);
// 		    		$("#accountModal").find(".box-body").empty();
// 		    		$("#accountModal").find(".box-body").append('<table  class="table table-striped table-hover table-bordered" id="account_details">'+
// 	                  			 								'<thead><tr><th>操作金额</th><th>操作原因</th><th>操作时间</th></tr></thead></table>')
// 		    		$("#account_details").DataTable({
// 		    			paging: true,//启用分页
// 					    length:10,
// 					    ordering:false,
// 					    paginate: {//分页的样式内容。
// 					      previous: "上一页",
// 					      next: "下一页",
// 					      first: "第一页",
// 					      last: "最后"
// 					    },
// 					    language: {
// 						  lengthMenu: '<select style="width:150px;" class="form-control input-xsmall">' + '<option value="1">1</option>' + '<option value="10">10</option>' + '<option value="20">20</option>' + '<option value="30">30</option>' + '<option value="40">40</option>' + '<option value="50">50</option>' + '</select> 条记录',//左上角的分页大小显示。
// 						    search: false,//右上角的搜索文本，可以写html标签
// 						    paginate: {//分页的样式内容。
// 						      previous: "上一页",
// 						      next: "下一页",
// 						      first: "第一页",
// 						      last: "最后"
// 						    },
// 						    zeroRecords: "没有内容",//table tbody内容为空时，tbody的内容。
// 						    //下面三者构成了总体的左下角的内容。
// 						    info: "总共_TOTAL_ 条记录",//左下角的信息显示，大写的词为关键字。
// 						    infoEmpty: "0条记录",//筛选为空时左下角的显示。
// 						    infoFiltered: ""//筛选之后的左下角筛选提示，
// 						},
// 					    data:data.account_details,
// 					    columns:[
// 					    	{data:'amount'},
// 			    			{data:'reason'},
// 			    			{data:'created_at'},
// 					    ]
// 		    		});
// 		    	});
// 		    },
// 		    columns:[
// 		    	{data:'prisoner_number',render:function(data,type,row){
// 								                    return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
// 								                }
// 			    },
// 			    {data:'name',render:function(data,type,row){
// 			                            return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
// 			                        　}
// 			    },
// 			    {data:'gender',render:function(data,type,row){
// 						if(data == 'm'){
// 		 					 data = '男';
// 		 				 }else{
// 		 					 data = '女';
// 		 				 }
// 	            return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
// 	          }
// 			    },
// 			    {data:'crimes',render:function(data,type,row){
// 			                            return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
// 			                          }
// 			    },
// 			    {data:'prison_area',render:function(data,type,row){
// 			                                    return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
// 			                               }
// 			    },
// 			    {data:'account',render:function(data,type,row){
// 			    							if(data){
// 			                                    return "<p style='line-height:50px;text-align:center'>"+data.balance+"元</p>"
// 			    							}else{
// 			    								return "<p style='line-height:50px;text-align:center'>不存在</p>"
// 			    							}
// 			                            }
// 			    },
// 			    {data:'jail_id',render:function(data,type,row){
// 			    	                    	return "<p style='line-height:50px;text-align:center'><a class='account_details' style='text-decoration:none;cursor:pointer;'>查看账户记录</a></p>"
// 	                                	}
// 			    }
// 		    ]
// 		});
//
// })()


var accounts_app = angular.module('accounts_app',['ng']);

//性别过滤器
accounts_app.filter('gender',function(){
    return function(input){
        if(input == 'm'){
            return '男';
        }else{
            return '女';
        }
    }
});

accounts_app.controller('accountsCtrl',['$scope','$http',function($scope,$http){
	$scope.searchingContent = '';//搜索框的内容
	$scope.page = 0;//显示第几页的内容
	$scope.limit = 10;//每页显示多少条数据
	$scope.prisoners = [];//罪犯信息的数组
	$scope.accounts = [];//罪犯账户的数组
	$scope.account_details = [];//罪犯账户详情信息
	$scope.total = '';//总共有多少条记录
	$scope.totalPages = '';//总共有多少页
	$scope.isAbleSearching = false;//控制搜索按钮禁止还是可用

	//初始化分页
	$scope.initPaginator = function(callback,page) {
		//分页
		let options = {
				bootstrapMajorVersion: 3,//版本
				currentPage: page + 1,//当前页数
				totalPages: $scope.totalPages,//总页数
				numberOfPages: $scope.limit,//一页显示几个按钮（在ul里面生成5个li）
				size: "normal",
				alignment: "center",
				onPageClicked: function(e, originalEvent, type, page) {
						$scope.page = page - 1;
						callback($scope.page);
				}
		}

		$("#paginator").bootstrapPaginator(options);
	}

	//初始化数据表格
	$scope.initData = function(){
		//计算表格总的页数
		if($scope.total%$scope.limit != 0){
			$scope.totalPages = Math.ceil($scope.total/$scope.limit);
		}else{
			$scope.totalPages = $scope.total/$scope.limit;
		}

		//将对应的罪犯的账户数组添加到罪犯数组里面
		for(var i=0;i<$scope.prisoners.length;i++){
			for(var j=0;j<$scope.accounts.length;j++){
				if( $scope.accounts[j] && $scope.prisoners[i].id == $scope.accounts[j].prisoner_id ) {
					$scope.prisoners[i].account = $scope.accounts[j];
				}
			}
		}

		//将对应的罪犯的账户详情数组添加到罪犯数组里面
		for(var i=0;i<$scope.prisoners.length;i++){
			if($scope.prisoners[i].account){
				for(var j=0;j<$scope.account_details.length;j++){
					if( $scope.account_details[j][0] && $scope.prisoners[i].account.id == $scope.account_details[j][0].accounts_id){
						$scope.prisoners[i].account_details = $scope.account_details[j];
					}
				}
			}
		}

	}

  //点击查看账户记录执行的方法
  $scope.showAccountRecords = function(account_id,prisoner_name) {
    if(account_id) {
      $http({
        method:'get',
        url:'/accounts/' + account_id,
      }).then(function(res){
        if(res.data.code == 200) {
          $scope.account_details = res.data.details[0];
          //重新设置创建日期的时间
          let date = $scope.account_details.created_at.substring(0,10);
          let time = $scope.account_details.created_at.substring(11,19);
          $scope.account_details.created_at = date + ' ' + time;
          //添加罪犯姓名字段
          $scope.account_details.prisoner_name = prisoner_name;
        }else {
          console.log('code:' + res.data.code,'status:' + res.data.status);
        }
      },function(err){
        console.log(err);
      });
    }else {
      //如果囚犯没有账户记录 就重置账户详情数组
      $scope.account_details = '';
    }
    //弹出账户记录详情
    $("#accountModal").modal("toggle");
  }

	//加载页面时获取罪犯和罪犯家属的信息
	$scope.getAccountsAndPrisoners = function(page) {
		if(!page){
			page = 0;//当首次加载表格时默认显示第一页
		}
		$http({
			url:'/accounts.json',
			method:'get',
			params:{
				'page':page,
				// start:page * $scope.limit,
				limit:$scope.limit
			}
		}).then(function(res){
			$scope.prisoners = res.data.data;
			$scope.total = res.data.total;

			//初始化数据表格
			$scope.initData();

			//初始化分页组件
			$scope.initPaginator($scope.getAccountsAndPrisoners,page);

		},function(err){
			console.log(err);
		});
	}

	$scope.getAccountsAndPrisoners();

	//每页显示数据条数下拉框改变执行的方法
	$scope.limitChange = function(){
		$scope.page = 0;
		$scope.getAccountsAndPrisoners($scope.page);
	}

	//点击搜索执行的方法
	$scope.search = function(page){
		if(!page){
			page = 0;//当首次加载表格时默认显示第一页
		} else {
			page--;//点击分页时执行的方法
		}
		$http({
			method:'get',
			url:'/search',
			params:{
				c:'accounts',
				value:$scope.searchingContent,
				page:page,
				limit:$scope.limit
			}
		}).then(function(res){
			$scope.prisoners = res.data.data;
			// $scope.accounts = res.data.accounts;
			// $scope.account_details = res.data.account_details;

			$scope.total = res.data.total;

			//初始化数据表格
			$scope.initData();

			//初始化分页组件
			$scope.initPaginator($scope.search,page);

		},function(err){
			console.log(err);
		});
	}

	//监听搜索条件的变化
	$scope.$watch('searchingContent',function(){
		if($scope.searchingContent){
			$scope.isAbleSearching = false;
		}else {
			$scope.isAbleSearching = true;
		}
	});

}])
