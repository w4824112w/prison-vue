// var app  = angular.module('prison_app',['ng']);
//
// app.controller('auditorCtrl',['$scope','$http',($scope,$http)=>{
//   $scope.logout = ()=>{
//     $http({
//       url:'get/cancel'
//     }).then(res=>{
//       console.log(res);
//     },err=>{
//       console.log(err);
//     });
//   }
// }]);


(function($){
  
  //点击退出按钮执行的方法
  $('.logout').on('click',function(){
    // console.log('logout');
    $('#logout-modal').modal();
  });

  $('#confirm-logout').on('click',function(){
    $.ajax({
      type:'delete',
      // url:'get/cancel',
      url:'/logout',
      success:function(res){
        // console.log(res);
      },
      error:function(err){
        console.log(err);
      },
      complete:function(){
        window.location.reload();
      }
    });
  })

})(jQuery);
