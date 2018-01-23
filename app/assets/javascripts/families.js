// (function($){
//   init_table();
//
//   function init_table(){
//   	var table = $("#tTrolley").DataTable({
//     autoWidth:false,
// 	  paging: true,//分页
// 	  ordering: false,//是否启用排序
// 	  // searching: false,//搜索
//     searching:true,
// 	  language: {
// 	    lengthMenu: '<select style="width:150px;" class="form-control input-xsmall">' + '<option value="1">1</option>' + '<option value="10">10</option>' + '<option value="20">20</option>' + '<option value="30">30</option>' + '<option value="40">40</option>' + '<option value="50">50</option>' + '</select> 条记录',//左上角的分页大小显示。
// 	      // search: '<input type="text" placeholder="请输入囚犯姓名">',//右上角的搜索文本，可以写html标签
// 	      paginate: {//分页的样式内容。
// 	        previous: "上一页",
// 	        next: "下一页",
// 	        first: "第一页",
// 	        last: "最后"
// 	      },
// 	      zeroRecords: "没有内容",//table tbody内容为空时，tbody的内容。
// 	      //下面三者构成了总体的左下角的内容。
// 	      info: "总共_PAGES_ 页",//左下角的信息显示，大写的词为关键字。
// 	      infoEmpty: "0条记录",//筛选为空时左下角的显示。
// 	      infoFiltered: ""//筛选之后的左下角筛选提示，
// 	  },
//     paging:true,
// 	  pagingType: "full_numbers",//分页样式的类型
// 	  sScrollY: "100%",
// 	  processing: true,
// 	  serverSide: true,
// 	  length:10,
// 	  ajax: {
// 	  	url: '/families',
// 	  	dataSrc:function(json){
// 	  		var families = json.data.families_data;
// 	  		var prisoners = json.data.prisoners_data;
//
// 	  		for(var j=0; j<prisoners.length; j++){
// 	  			if(prisoners[j]){
// 	  				for(var i=0; i<families.length; i++){
// 	  					if( prisoners[j].id == families[i].prisoner_id ){
// 	  						families[i].prisoner = prisoners[j];
// 	  					}
// 	  				}
// 	  			}
// 	  		}
//
// 	  		return families;
// 	  	}
// 	  },
// 	  createdRow:function(row,data,index){
// 	  	$(row).find(".prisoner_detail").on('click',function(){
// 	  		var prisoner = data.prisoner;
// 				if(prisoner.gender == 'm' || '男'){
// 					prisoner.gender = '男';
// 				}else{
// 					prisoner.gender = '女';
// 				}
// 	  		$("#prisoner_detail").modal('toggle');
// 	  		$("#prisoner_detail").find(".name").text(prisoner.name);
// 	  		$("#prisoner_detail").find(".prisoner_number").text(prisoner.prisoner_number);
// 	  		$("#prisoner_detail").find(".gender").text(prisoner.gender);
// 	  		$("#prisoner_detail").find(".crime").text(prisoner.crimes);
// 	  		$("#prisoner_detail").find(".prison_area").text(prisoner.prison_area);
// 	  	})
// 	  },
// 	  columns:[
// 	    {data:'name',render:function(data,type,row){
// 	   	  return "<p style='line-height:50px;text-align:left'>"+data+"</p>"
// 	   	}},
// 	   	{data:'uuid',render:function(data,type,row){
// 	   	  return "<p style='line-height:50px;text-align:left'>"+data+"</p>"
// 	    }},
// 	    {data:'phone',render:function(data,type,row){
// 	      return "<p style='line-height:50px;text-align:left'>"+data+"</p>"
// 	    }},
// 	    {data:'relationship',render:function(data,type,row){
// 	      return "<p style='line-height:50px;text-align:left'>"+data+"</p>"
// 	    }},
// 	    {data:'prisoner',render:function(data,type,row){
// 	    	if(data){
// 	    		return "<p style='line-height:50px;text-align:left'><a class='prisoner_detail'　style='text-decoration:none;cursor:pointer;'>"+data.name+"</a></p>";
// 	    	} else {
// 	    		return "<p style='line-height:50px;text-align:left'>无对应囚犯</p>"
// 	    	}
// 	    }}
// 	  ]
// 	});
// 	return table;
//   }
// })(jQuery)

var families_app = angular.module('families_app',['ng']);

//性别过滤器
families_app.filter('gender',function(){
    return function(input){
        if(input == 'm'){
            return '男';
        }else{
            return '女';
        }
    }
});

families_app.controller('familiesCtrl',['$scope','$http',function($scope,$http){
  $scope.searchingContent = '';//搜索框的内容
  $scope.page = 0;//显示第几页的内容
  $scope.limit = 10;//每页显示多少条数据
  $scope.prisoners = [];//罪犯信息的数组
  $scope.families = [];//罪犯家属的数组
  $scope.total = '';//总共有多少条记录
  $scope.totalPages = '';//总共有多少页
  $scope.isAbleSearching = false;//控制搜索按钮禁止还是可用

  //点击对应囚犯时的信息弹出框
  $scope.prisonerDetail = function(prisoner){
    $scope.prisoners = prisoner;
    $("#prisoner_detail").modal('toggle');
  }



  //加载页面时获取罪犯和罪犯家属的信息
  $scope.getFamilies = function(page) {
    if(!page){
      page = 0;//当首次加载表格时默认显示第一页
    }
    $http({
      url:'/families.json',
      method:'get',
      params:{
        draw:page + 1,
        start:page * $scope.limit,
        length:$scope.limit
      }
    }).then(function(res){
      $scope.prisoners = res.data.data.prisoners_data;
      $scope.families = res.data.data.families_data;
      $scope.total = res.data.recordsTotal;

      //计算表格总的页数
      if($scope.total%$scope.limit != 0){
        $scope.totalPages = Math.ceil($scope.total/$scope.limit);
      }else{
        $scope.totalPages = $scope.total/$scope.limit;
      }

      //给家属信息数组里添加对应的罪犯信息数组
      for(var j=0; j<$scope.prisoners.length; j++){
  			if($scope.prisoners[j]){
  				for(var i=0; i<$scope.families.length; i++){
  					if( $scope.prisoners[j].id == $scope.families[i].prisoner_id ){
  						$scope.families[i].prisoner = $scope.prisoners[j];
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
              $scope.getFamilies($scope.page);
          }
      }

      $("#paginator").bootstrapPaginator(options);

    },function(err){
      console.log(err);
    });
  }

  $scope.getFamilies();

  //每页显示数据条数下拉框改变执行的方法
  $scope.limitChange = function(){
    $scope.page = 0;
    $scope.getFamilies($scope.page);
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
        c:'families',
        value:$scope.searchingContent,
        page:page,
        limit:$scope.limit
      }
    }).then(function(res){
      $scope.prisoners = res.data.prisoners;
      $scope.families = res.data.families;
      $scope.total = res.data.total;

      //计算表格总的页数
      if($scope.total%$scope.limit != 0){
        $scope.totalPages = Math.ceil($scope.total/$scope.limit);
      } else {
        $scope.totalPages = $scope.total/$scope.limit;
      }

      //给家属信息数组里添加对应的罪犯信息数组
      for(var j=0; j<$scope.prisoners.length; j++){
  			if($scope.prisoners[j]){
  				for(var i=0; i<$scope.families.length; i++){
  					if( $scope.prisoners[j].id == $scope.families[i].prisoner_id ){
  						$scope.families[i].prisoner = $scope.prisoners[j];
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
