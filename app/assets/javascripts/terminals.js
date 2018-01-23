var terminals_app = angular.module('terminals_app',['ng']);

//性别过滤器
terminals_app.filter('gender',function(){
    return function(input){
        if(input == 'm'){
            return '男';
        }else{
            return '女';
        }
    }
});

terminals_app.controller('terminalsCtrl',['$scope','$http',function($scope,$http){
	$scope.searchingContent = '';//搜索框的内容
	$scope.page = 0;//显示第几页的内容
	$scope.limit = 10;//每页显示多少条数据
	$scope.terminals = [];//终端的数组
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
		} else {
			$scope.totalPages = $scope.total/$scope.limit;
		}
	}

	//加载页面时获取罪犯和罪犯家属的信息
	$scope.getTerminals = function(page) {
		if(!page){
			page = 0;//当首次加载表格时默认显示第一页
		}
		$http({
			url:'/terminals.json',
			method:'get',
      params:{
        draw:page + 1,
        start:page * $scope.limit,
        length:$scope.limit
      }
		}).then(function(res){
			$scope.terminals = res.data.data.prisoner_data;
			$scope.total = res.data.recordsTotal[0]['COUNT(*)'];

			//初始化数据表格
			$scope.initData();

			//初始化分页组件
			$scope.initPaginator($scope.getTerminals,page);

		},function(err){
			console.log(err);
		});
	}

	$scope.getTerminals();

	//每页显示数据条数下拉框改变执行的方法
	$scope.limitChange = function(){
		$scope.page = 0;
		$scope.getTerminals($scope.page);
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
				c:'terminals',
				value:$scope.searchingContent,
				page:page,
				limit:$scope.limit
			}
		}).then(function(res){
			$scope.terminals = res.data.terminals;
			$scope.total = res.data.total[0]['COUNT(*)'];
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

  //点击修改版本执行的方法
  $scope.modifyTerminal = (id) => {
    window.location.href=`/terminals/${id}/edit`
  }

}])
