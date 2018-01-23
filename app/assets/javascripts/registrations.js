
var registrations_app = angular.module('registrations_app',['ng']);

registrations_app.filter('status',function(){
    return function(input){
        if(input == 'PENDING'){
            return '未授权';
        }else if(input == 'PASSED'){
            return '已通过';
        }else if(input == 'DENIED'){
            return '已拒绝';
        }
    }
});

registrations_app.controller('registrationsCtrl',['$scope','$http',function($scope,$http){
    $scope.btn_agree = '同意';
    $scope.btn_disagree = '不同意';
    $scope.formShow = false;
    $scope.success = false;
    $scope.failed = false;
    $scope.isCallback = false;
    $scope.limit = 10;//每页显示多少条数据
    $scope.page = 0;//当前第几页
    $scope.totalPages = ''//总共有多少页
    $scope.total = ''//总共有多少条记录
    $scope.searchingContent = ''
    $scope.isAbleSearching = false//搜索按钮的可用和禁止
    //点击分页页码执行的函数
    $scope.allFlights =function(page){
      //获取未授权的申请信息
     $http({
          method:'get',
          url:'/registrations.json',
          // url:'data/test.json',
          // cache:true,
          params:{
            'limit':$scope.limit,
            'page':page
          }
     }).then(function(res){
          $scope.registList = res.data.registrations;
          $scope.total = res.data.total;
          // let totalPages = Math.floor(res.data.total/$scope.limit);
          if($scope.total%$scope.limit != 0){
            $scope.totalPages = Math.ceil($scope.total/$scope.limit);
          }else{
            $scope.totalPages = $scope.total/$scope.limit;
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
                  $scope.allFlights($scope.page);
              }
          }
          // console.log("options= ",options);
          $("#paginator").bootstrapPaginator(options);
     },function(err){
        // $scope.registList = [];
        console.log(err);
     });
    }

    $scope.allFlights($scope.page);

    //每页显示数据条数改变执行的方法
    $scope.limitChange = function(){
      $scope.page = 0;
      $scope.allFlights($scope.page);
    }

    //点击授权方法
    $scope.authorize = function(e){
        $scope.id = $(e.target).attr('data-id');
        $scope.btn_agree = '同意';
        $scope.btn_disagree = '不同意';
        $scope.formShow = false;
        $scope.success = false;
        $scope.failed = false;
        $('#formModal').modal();

        //获取申请照片信息
        $http({
            method:'get',
            url:'/registrations/'+$scope.id+'/uuid_images',
            cache:true
        }).then(function(res){
            $scope.imgs = res.data;
        },function(err){
            console.log(err);
        });
    }

    //点击同意或者确定申请通过的方法
    $scope.agree = function(){
        if($scope.btn_agree == '同意'){
            $scope.btn_agree = '确定申请通过？';
            $scope.btn_disagree = '返回';
        }else{
            if($scope.btn_agree == '确定申请通过？'){
                $http({
                    method:'patch',
                    // method:'get',
                    url:'/registrations/'+$scope.id,
                    // url:'/data/200.json',
                    data:{
                        status:'PASSED',
                        remarks:''
                    }
                }).then(function(res){
                    let data = res.data;
                    if(data.code == '200'){
                        $.each($scope.registList,function(index,val){
                            if(val.id == $scope.id){
                                val.status = 'PASSED';
                            }
                        });
                        $('[data-id='+$scope.id+']').css({
                            visibility:'hidden'
                        });
                        $scope.success = true;
                        $scope.msg = '授权成功';
                    }
                },function(err){
                    $scope.failed = true;
                    $scope.msg = '授权失败';
                    $scope.errMsg =err.status + ' ' + err.statusText;
                })
            } else {
                $http({
                    method:'patch',
                    // method:'get',
                    url:'/registrations/'+$scope.id,
                    // url:'/data/200.json',
                    data:{
                        status:'DENIED',
                        remarks:$scope.reason
                    }
                }).then(function(res){
                    let data = res.data;
                    if(data.code == '200'){
                        $.each($scope.registList,function(index,val){
                            if(val.id == $scope.id){
                                val.status = 'DENIED';
                            }
                        });
                        $scope.success = true;
                        $scope.msg = '拒绝成功';
                    }else{
                        $scope.failed = true;
                        $scope.msg = '授权失败';
                        $scope.errMsg = data.msg;
                    }
                },function(err){
                    console.log(err);
                    $scope.failed = true;
                    $scope.msg = '授权失败';
                    $scope.errMsg = err.status + ' ' + err.statusText;
                })
            }
        }
    }

    //点击返回或不同意的方法
    $scope.disagree = function(){
        if($scope.btn_disagree =='返回'){
            $scope.formShow = false;
            $scope.btn_agree = '同意';
            $scope.btn_disagree = '不同意';
        }else{
            $scope.formShow = true;
            $scope.btn_agree = '提交';
            $scope.btn_disagree = '返回';
            $scope.reason = '您的身份信息错误';
        }
    }



    //照片划入的方法
    $scope.imgMouseOver = function(event){
        let _this = event.target;
        $.each($("#photos").find("img"),function(i,n){
            $(n).css({
              "display":"none"
            });
          });
          $(_this).css({
            "display":"block",
            "height":"300px",
            "width":"90%"
          });
    }

    //照片划出的方法
    $scope.imgMouseOut = function(event){
        let _this = event.target;
        $.each($("#photos").find("img"),function(i,n){
            $(n).css({
              "display":""
            });
          });
          $(_this).css({
            "height":"150px",
            "width":"150px"
          });
    }

    //点击搜索时执行的方法
    $scope.search = function(page){
      if(!page){
        page = 0;
      }
      $http({
          method:'get',
          url:'/search',
          params:{
            c:'registrations',
            value:$scope.searchingContent,
            'page':page,
            limit:$scope.limit
          }
      }).then(function(res){
          $scope.registList = res.data.registrations;
          $scope.total = res.data.total;
          //计算总共多少页
          if($scope.total%$scope.limit != 0){
            $scope.totalPages = Math.ceil($scope.total/$scope.limit);
          }else{
            $scope.totalPages = $scope.total/$scope.limit;
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
                  $scope.search($scope.page);
              }
          }
          // 初始化分页列表
          $("#paginator").bootstrapPaginator(options);
      },function(err){
        console.log(err);
      })
    }

    //监听搜索条件的变化
    $scope.$watch('searchingContent',function(){
      if($scope.searchingContent){
        $scope.isAbleSearching = false;
      }else {
        $scope.isAbleSearching = true;
      }
    });

}]);
