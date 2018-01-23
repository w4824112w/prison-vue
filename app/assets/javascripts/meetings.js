
var meetings_app = angular.module('meetings_app',['ng']);

meetings_app.filter('status',function(){
    return function(input){
        if(input == 'PENDING'){
            return '未授权';
        }else if(input == 'PASSED'){
            return '已通过';
        }else if(input == 'DENIED'){
            return '已拒绝';
        }else if(input == 'CANCELED') {
            return '已取消';
        }else if(input == 'FINISHED') {
            return '已完成';
        }
    }
});

meetings_app.controller('meetingsCtrl',['$scope','$http',function($scope,$http){
    $scope.btn_agree = '同意';
    $scope.btn_disagree = '不同意';
    $scope.formShow = false;
    $scope.success = false;
    $scope.failed = false;
    $scope.errMsg = '';
    $scope.limit = 10;//每页显示多少条数据
    $scope.page = 0;//当前第几页
    $scope.totalPages = '';//总共多少条
    $scope.searchingContent = '';
    $scope.isAbleSearching = false;//控制搜索按钮禁止还是可用
    //点击分页页码执行的函数
    $scope.allFlights =function(page){
      //获取未授权的申请信息
      $http({
          method:'get',
          url:'/meetings.json',
          // url:'data/test.json',
          // cache:true
          params:{
            limit:$scope.limit,
            'page':page
          }
      }).then(function(res){
          $scope.meetingList = res.data.meetings;

          $scope.total = res.data.total;
          // let totalPages = Math.floor(total/$scope.limit);
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

          $("#paginator").bootstrapPaginator(options);

      },function(err){
          $scope.meetingList = [];
          console.log(err);
      });
  }

  $scope.allFlights(0);

  //每页显示数据条数下拉框改变执行的方法
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
                    url:'/meetings/'+$scope.id,
                    // url:'/data/200.json',
                    data:{
                        status:'PASSED',
                        remarks:''
                    }
                }).then(function(res){
                    let data = res.data;
                    if(data.code == '200'){
                        $.each($scope.meetingList,function(index,val){
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
                    console.log(err);
                    $scope.failed = true;
                    $scope.msg = '授权失败';
                    $scope.errMsg =err.status + ' ' + err.statusText;
                })
            } else {
                $http({
                    method:'patch',
                    // method:'get',
                    url:'/meetings/'+$scope.id,
                    // url:'/data/200.json',
                    data:{
                        status:'DENIED',
                        remarks:$scope.reason
                    }
                }).then(function(res){
                    let data = res.data;
                    if(data.code == '200'){
                        $.each($scope.meetingList,function(index,val){
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
                    // console.log(err);
                    $scope.failed = true;
                    $scope.msg = '授权失败';
                    $scope.errMsg = err.status + ' ' + err.statusText;
                })
            }
        }
    }

    //点击撤回按钮的方法
    $scope.callback = function(e) {

        $scope.id = $(e.target).attr('data-id');

        $('#formModalSecond').modal();
    }

    //确认撤回
    $scope.callbackConfirm = function(){
        $http({
            method:'patch',
            url:'/meetings/'+$scope.id,
            data:{
                status:'DENIED',
                remarks:$scope.callbackReason
            }
        }).then(function(res){
            let data = res.data;
            if(data.code == '200'){
                // $.each($scope.registList,function(index,val){
                //     if(val.id == $scope.id){
                //         val.status = 'DENIED';
                //     }
                // });
                // console.log('hide');
                $('#formModalSecond').modal('hide');
            } else {
                // $scope.failed = true;
                // $scope.errMsg = data.msg;
            }
        },function(err){
            $scope.failed = true;
            $scope.msg = '授权失败';
            $scope.errMsg = err.status + ' ' + err.statusText;
        })

        $scope.callbackReason = '';
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

    //点击搜索执行的方法
    $scope.search = function(page){
      if(!page){
        page = 0;
      }
      $http({
          method:'get',
          url:'/search',
          params:{
            c:'meetings',
            value:$scope.searchingContent,
            'page':page,
            limit:$scope.limit
          }
      }).then(function(res){
        $scope.meetingList = res.data.meetings;
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
        //初始化分页列表
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
