(function($){
  var dashboard_app = angular.module("dashboard_app",["dashboard_service","dashboard_directive"]).
    controller("indexCtrl",["$scope","$compile","getMailData","getTodayAppliesData","getTodayRegistor",function($scope,$compile,getMailData,getTodayAppliesData,getTodayRegistor){
      $scope.mails_len;
      // if(!mail_filter(getMailData.Data)){
      //   $scope.mail_data = 0;
      // }
      // if(!applies_filter(getTodayAppliesData.Data)){
      //   $scope.applies_data = 0;
      // }
      // if(!applies_filter(getTodayRegistor.Data)){
      //   $scope.registors_data = 0;
      // }
      $scope.mail_data　=　mail_filter(getMailData.Data);
      $scope.applies_data　=　applies_filter(getTodayAppliesData.Data);
      $scope.registors_data = applies_filter(getTodayRegistor.Data);
      if(!$scope.mail_data){
        $scope.mail_data = 0;
      }
      if(!$scope.applies_data){
        $scope.applies_data = 0;
      }
      if(!$scope.registors_data){
        $scope.registors_data = 0;
      }
      $scope.mail_data_len = $scope.mail_data.length;
      $scope.applies_data_len = $scope.applies_data.length;
      $scope.registors_data_len = $scope.registors_data.length;
      $(".mail_details").click(function(){
      	var scope = angular.element(test).scope();
      	$(".detailsboard").empty();
      	var html = '<mailboxes info="mail_data"></mailboxes>';
  	    var parent = $(".detailsboard");
    		var template = angular.element(html);
    		var linkFn = $compile(template);
    		var element = linkFn($scope);
    		$(parent).append(element);
      	$(".detailsboard").animate({
      		opacity:1,
      	})
      })

      $(".today_apply_details").click(function(){
      	var scope = angular.element(test).scope();
      	$(".detailsboard").empty();
      	var html = '<todayapply info="applies_data"></todayapply>';
  	    var parent = $(".detailsboard");
    		var template = angular.element(html);
    		var linkFn = $compile(template);
    		var element = linkFn($scope);
    		$(parent).append(element);
      	$(".detailsboard").animate({
      		opacity:1,
      	})
      })

      $(".today_registor_details").click(function(){

      	var scope = angular.element(test).scope();
      	$(".detailsboard").empty();
      	var html = '<today-registor info="registors_data"></today-registor>';
        var parent = $(".detailsboard");
    		var template = angular.element(html);
    		var linkFn = $compile(template);
    		var element = linkFn($scope);
    		$(parent).append(element);
      	$(".detailsboard").animate({
      		opacity:1,
      	})
      })
    }]);

  var dashboard_service = angular.module("dashboard_service",[]).
    factory("getMailData",function(){
      var Data;
  	  $.ajax({
  		type:"get",
  		url:"/mail_boxes",
  		dataType:'json',
  		async:false,
  		data:{
  			type:"1"
  		},
  		success:function(data){
  		  Data=data;
  		}
        });
  	  return {
  			Data:Data
  	  };
    }).
    factory("getTodayAppliesData",function(){
      var Data;
	  $.ajax({
		type:"get",
		// url:"/applies",
		url:"/meetings",
		dataType:'json',
		async:false,
		// data:{
    //       type:"1"
		// },
		success:function(data){
		  Data=data;
		},
		error:function(err){
			console.log(err);
			Data = [];
		}
      });
	  return {
			Data:Data
	  };
    }).
    factory("getTodayRegistor",function(){
      var Data;
	  $.ajax({
			type:"get",
			url:"/registrations",
			dataType:'json',
			async:false,
			success:function(data){
				// console.log(data);
				Data=data.registrations;
				// localStorage.clear();
				// localStorage.setItem(registrations,JSON.stringify(Data));
			},
			error:function(err){
				Data = [];
				// localStorage.setItem(registrations,JSON.stringify(Data));
			}
		});
	  return {
			Data:Data
	  };
    })

  var dashboard_directive = angular.module("dashboard_directive",[]).
    directive('mailboxes', function() {
      return {
        restrict: 'E',
        transclude: false,
        scope: {
          mailboxes: '=info'
        },
      templateUrl: '/templates/mail_boxes.html.erb'
      };
    }).
    directive('todayapply', function(){
      return {
      	restrict: 'E',
      	transclude: false,
        scope: {
          applies: '=info'
        },
      templateUrl: '/templates/today_apply.html.erb'
      };
    }).
    directive('todayRegistor', function() {
      return {
      	restrict: 'E',
      	transclude: false,
        scope: {
          registers: '=info'
        },
      templateUrl: '/templates/today_registor.html.erb'
      };
    });

    function mail_filter(data){
      	var i = 0;
      	for(var i=0;i<data.length;){
      	  if(data[i].state == "1"){
      	  	data.splice(i,1);
      	  }else{
          data[i].created_at = data[i].created_at.substring(0,10);
      	  	i++;
      	  }
      	}
      	return data;
      }
    function applies_filter(data){
      for(var i=0;i<data.length;){
        var date = new Date();
        var year = date.getFullYear();
        var month = date.getMonth()+1;
        if(month<10){
        	month = "0" + month;
        }
        var date = date.getDate();
        if(date<10){
        	date = "0" + date;
        }

        // date = year+"-"+month+"-"+date;

        date = year+"-"+month+"-"+date;

        // date = "2016-04-08";
        if(date != data[i].created_at.substring(0,10)){
        	data.splice(i,1);
        }else{
        	i++;
        }
      }
      return data;
    }
})(jQuery)
