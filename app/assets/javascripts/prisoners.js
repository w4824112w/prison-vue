// (function($){
//
//   var table = init_table();
//   var prisoners;
//   var families;
//
//   function init_table(){
//   	var table = $("#tTrolley").dataTable({
//     autoWidth:false,
// 	  paging: true,//分页
// 	  ordering: false,//是否启用排序
// 	  // searching: false,//搜索
//     searching: true,
//     processing: true,
// 	  serverSide: true,
// 	  length:10,
//     language: {
// 	    lengthMenu: '<select style="width:150px;" class="form-control input-xsmall">' + '<option value="1">1</option>' + '<option value="10">10</option>' + '<option value="20">20</option>' + '<option value="30">30</option>' + '<option value="40">40</option>' + '<option value="50">50</option>' + '</select> 条记录',//左上角的分页大小显示。
//
// 	      paginate: {//分页的样式内容。
// 	        previous: "上一页",
// 	        next: "下一页",
// 	        first: "第一页",
// 	        last: "最后"
// 	      },
// 	      zeroRecords: "没有内容",//table tbody内容为空时，tbody的内容。
// 	      //下面三者构成了总体的左下角的内容。
// 	      info: "总共_PAGES_ 页，总共 _TOTAL_ 条记录",//左下角的信息显示，大写的词为关键字。
// 	      infoEmpty: "0条记录",//筛选为空时左下角的显示。
// 	      infoFiltered: ""//筛选之后的左下角筛选提示，
// 	  },
// 	  pagingType: "full_numbers",//分页样式的类型
// 	  sScrollY: "100%",
// 	  ajax: {
// 	  	url:'/prisoners.json',
//
// 	  	dataSrc: function(json){
// 	  		prisoners = json.data.prisoner_data;
// 	  		families = json.data.families_data;
//
// 	  		for(var j=0;j<families.length;j++){
// 	  			if( families[j][0] ){
// 	  				for(var i=0;i<prisoners.length;i++){
// 	  					if( prisoners[i].id == families[j][0].prisoner_id ){
// 	  						prisoners[i].family = families[j];
// 	  					}
// 	  				}
// 	  			}
// 	  		}
// 	  		return prisoners;
// 	  	}
// 	  },
// 	  createdRow:function(row,data,index){
// 	  	var data = data.family
//
	  	// if(data){
		  // 	$(row).find(".family_detail").on('click',function(){
		  // 		$("#family_detail").modal("toggle");
		  // 		for(var i=0; i<data.length; i++){
		  // 			if(data[i].name == $(this).text()){
		  // 				var src = data[i].image_url.split('|');
			// 				//var src = eval(data[i].image_url);
			// 	  		$("#family_detail").find(".name").text(data[i].name);
			// 	  		$("#family_detail").find(".phone").text(data[i].phone);
			// 	  		$("#family_detail").find(".uuid").text(data[i].uuid);
			// 	  		$("#family_detail").find(".relationship").text(data[i].relationship);
			// 	  		$("#family_detail").find(".img").html('<img style="width:100%" src="'+src[2]+'" />');
		  // 			}
		  // 		}
		  // 	})
			// }
// 	  },
// 	  columns:[
// 	    {data:'name',render:function(data,type,row){
// 	   	  return "<p style='line-height:50px;text-align:left'>"+data+"</p>"
// 	   	}},
      // data:'gender',render:function(data,type,row){
			// 	 if(data == 'm'){
			// 		 data = '男';
			// 	 }else{
			// 		 data = '女';
			// 	 }
	   	//   return "<p style='line-height:50px;text-align:left'>"+data+"</p>"
	    // }},
      //新增加的囚号
  //     {
  //       data:'prisoner_number',render:function(data,type,row){
  //         return "<p style='line-height:50px;text-align:left'>"+data+"</p>"
  //       }
  //     },
	//     {data:'crimes',render:function(data,type,row){
	//       return "<p style='line-height:50px;text-align:left'>"+data+"</p>"
	//     }},
	//     {data:'prison_term_started_at',render:function(data,type,row){
	//       return "<p style='line-height:50px;text-align:left'>"+row.prison_term_started_at+"/"+row.prison_term_ended_at+"</p>"
	//     }},
	//     {data:'family',render:function(data,type,row){
	//       var a = "";
	//       if(data){
	//       	for(var i=0; i<data.length; i++){
	//       		var s = "<a class='family_detail' style='text-decoration:none;cursor:pointer;'>"+data[i].name+"</a> ";
	//       		a += s;
	//       	}
	//       	return "<p style='line-height:50px;text-align:left'>"+a+"</p>";
	//       } else {
	//       	return "<p style='line-height:50px;text-align:left'>无对应家属</p>";
	//       }
	//     }}
	//   ]
	// });
	// return table;
  // }

  var prisoners_app = angular.module('prisoners_app',['ng']);

  prisoners_app.controller('prisonersCtrl',['$scope','$http',function($scope,$http){
    $scope.searchingContent = '';//搜索框的内容
    $scope.page = 0;//显示第几页的内容
    $scope.limit = 10;//每页显示多少条数据
    $scope.isNotSearchingTable = true;//是否是搜索出来的表格信息
    $scope.prisoners = [];//罪犯信息的数组
    $scope.families = [];//罪犯家属的数组
    $scope.total = '';//总共有多少条记录
    $scope.totalPages = '';//总共有多少页
    $scope.isAbleSearching = false;//控制搜索按钮禁止还是可用

    //点击家属名称时的信息弹出框
    $scope.familyDetail = function(family){
      $scope.families = family;
      $scope.families.image_url = $scope.families.image_url.split('|')[2];
      $("#family_detail").modal("toggle");
    }

    //加载页面时获取罪犯和罪犯家属的信息
    $scope.getPrisonersAndFamilies = function(page) {
      if(!page){
        page = 0;//当首次加载表格时默认显示第一页
      }
      $http({
        url:'/prisoners.json',
        method:'get',
        params:{
          draw:page + 1,
          start:page * $scope.limit,
          length:$scope.limit
        }
      }).then(function(res){
        $scope.prisoners = res.data.data.prisoner_data;
        $scope.families = res.data.data.families_data;
        $scope.total = res.data.recordsTotal[0]['COUNT(*)'];

        //计算表格总的页数
        if($scope.total%$scope.limit != 0){
          $scope.totalPages = Math.ceil($scope.total/$scope.limit);
        } else {
          $scope.totalPages = $scope.total/$scope.limit;
        }

        //将对应的家属信息加到罪犯信息里面
        for(var j=0;j<$scope.families.length;j++){
          if( $scope.families[j][0]){
            for(var i=0;i<$scope.prisoners.length;i++){
              if( $scope.prisoners[i].id == $scope.families[j][0].prisoner_id ){
                $scope.prisoners[i].family = $scope.families[j];
              }
            }
          }
        }

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
                $scope.getPrisonersAndFamilies($scope.page);
            }
        }

        $("#paginator").bootstrapPaginator(options);

      },function(err){
        console.log(err);
      });
    }

    $scope.getPrisonersAndFamilies();

    //每页显示数据条数下拉框改变执行的方法
    $scope.limitChange = function(){
      $scope.page = 0;
      $scope.getPrisonersAndFamilies($scope.page);
    }

    //点击搜索执行的方法
    $scope.search = function(page){
      if(!page){
        page = 0;//当首次加载表格时默认显示第一页
      }else{
        page--;//点击分页时执行的方法
      }
      $http({
        method:'get',
        url:'/search',
        params:{
          c:'prisoners',
          value:$scope.searchingContent,
          page:page,
          limit:$scope.limit
        }
      }).then(function(res){
        $scope.prisoners = res.data.prisoners;
        $scope.families = res.data.families;
        $scope.total = res.data.prisoners.length;
        //计算表格总的页数
        if($scope.total%$scope.limit != 0){
          $scope.totalPages = Math.ceil($scope.total/$scope.limit);
        } else {
          $scope.totalPages = $scope.total/$scope.limit;
        }
        //将对应的家属信息加到罪犯信息里面
        for(var j=0;j<$scope.families.length;j++){
          if( $scope.families[j][0]){
            for(var i=0;i<$scope.prisoners.length;i++){
              if( $scope.prisoners[i].id == $scope.families[j][0].prisoner_id ){
                $scope.prisoners[i].family = $scope.families[j];
              }
            }
          }
        }
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
              $scope.search(page);
            }
        }
        $("#paginator").bootstrapPaginator(options);
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

// })(jQuery)
