
let versions_app = angular.module('versions_app',['ng']);

versions_app.controller('versionsCtrl',['$scope','$http',($scope,$http) => {
  $scope.limit = 10;//每页显示多少条
  $scope.versions = [];//版本信息数组
  $scope.family_versions = [];//家属信息版本数组
  $scope.prison_versions = [];//监狱信息版本数组
  $scope.isModification = true;//是否是编辑状态
  $scope.btnMessage = '修改';//页面加载时 按钮为修改按钮
  $scope.username = '';//用户名
  $scope.password = '';//密码
  $scope.userOrPassErr = false;//验证用户名或密码错误信息
  $scope.version = new Object();//当前修改的版本对象

  //页面加载时获取版本信息数据son
  $scope.getVersions = () => {
    $http({
      method:'get',
      url:'/search',
      params:{
        c:'versions',
        limit:$scope.limit
      }
    }).then(res => {
      // console.log(res);
      $scope.versions = res.data.versions;
      $.each($scope.versions,(index,value) => {
        value.isModification = true;
        value.btnMessage = '修改';
        if(value.type_id == 1) {
          $scope.family_versions.push(value);
        } else if(value.type_id == 2) {
          $scope.prison_versions.push(value);
        }
      })

      // console.log($scope.family_versions,$scope.prison_versions);
    },err => {
      console.log(err);
    })
  }

  $scope.getVersions();

  //点击修改或者保存按钮执行的方法
  $scope.toggleSearchToModify = (version) => {
    if(version.btnMessage == '修改') {
      $scope.username = '';
      $scope.password = '';
      $scope.userOrPassErr = false;
      $.extend($scope.version,version)
      $('#modal-default').modal();
      console.log($scope.version);
    }else if(version.btnMessage == '保存') {
      $http({
        method:'post',
        url:'/versions/update',
        data:{
          id:version.id,
          version_code:version.version_code,
          version_number:version.version_number,
          is_force:version.is_force
        }
      }).then(res => {
        // console.log(res);
        if(res.data.code == 200) {
          $scope.family_versions = [];
          $scope.prison_versions = [];
          $scope.getVersions();
        }
      },err => {
        console.log(err);
      })
    }
  }

  //点击登录按钮执行的方法
  $scope.loginVersion = () => {
    if($scope.username == 'yuwutong' && $scope.password == 'yuwutong') {
      $scope.userOrPassErr = false;
      let versionFindOut = true;
      //将对对应修改的版本信息的按钮名称改为保存 将input控件disabled属性设置为false
      $.each($scope.family_versions,(index,value) => {
        if(value.id == $scope.version.id) {
          value.btnMessage = '保存';
          value.isModification = false;
          versionFindOut = false;
        }
      });
      //将对对应修改的版本信息的按钮名称改为保存 将input控件disabled属性设置为false
      if(versionFindOut) {
        $.each($scope.prison_versions,(index,value) => {
          if(value.id == $scope.version.id) {
            value.btnMessage = '保存';
            value.isModification = false;
          }
        });
      }
      $('#modal-default').modal('hide');
    } else {
      $scope.userOrPassErr = true;
    }
  }

}]);
