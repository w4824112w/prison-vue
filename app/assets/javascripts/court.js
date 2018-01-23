//减刑假释应用模块
var prisoners_app = angular.module('prisoners_app',['prisoners_services']).
	controller('prisoners_all',['$scope','$timeout','getPrisonersData','initDatatable',
								'searchPrisoner',
		function($scope,$timeout,getPrisonersData,initDatatable,searchPrisoner){
			$scope.prisoners_data = getPrisonersData.prisonersData;
			/*初始化表格*/
			initDatatable.initTable($scope.prisoners_data,"prisoners_list");
			$scope.box_height = $(".main-sidebar").height()-$(".bar1").height()-$(".content-header").height()-$(".main-header").height();
			$scope.date = "选择日期";
			$scope.prisonersId = "请输入囚号进行搜索";
			$scope.search = function(){
				$scope.prisoner = searchPrisoner.searching($scope.prisonersId,$scope.prisoners_data);
			};
		}
	]);
//减刑假释服务模块
var prisoners_services = angular.module('prisoners_services',[]).
	factory('getPrisonersData',function(){
		var prisonersData;
		$.ajax({
			type:"get",
		    url:"/prisoners",
		    dataType:'json',
		    async:false,
		    success:function(data){
		    	prisonersData=data;
			}
		});	
		return {
			prisonersData:prisonersData
		};
	}).
	factory('initDatatable',function(){
		return {
			initTable:initTable
		};

		function initTable(prisoners_data,id){
			var table = $("#"+id).dataTable({
				autoWidth:false,
			    paging: true,//分页
			    ordering: false,//是否启用排序
			    searching: true,//搜索
			    language: {
			        lengthMenu: '<select style="width:150px;" class="form-control input-xsmall">' + '<option value="1">1</option>' + '<option value="10">10</option>' + '<option value="20">20</option>' + '<option value="30">30</option>' + '<option value="40">40</option>' + '<option value="50">50</option>' + '</select> 条记录',//左上角的分页大小显示。
			        search: '',//右上角的搜索文本，可以写html标签
			        paginate: {//分页的样式内容。
			            previous: "上一页",
			            next: "下一页",
			            first: "第一页",
			            last: "最后"
			        },
			        zeroRecords: "没有内容",//table tbody内容为空时，tbody的内容。
			        //下面三者构成了总体的左下角的内容。
			        info: "总共_PAGES_ 页，显示第_START_ 到第 _END_ ，筛选之后得到 _TOTAL_ 条，初始_MAX_ 条 ",//左下角的信息显示，大写的词为关键字。
			        infoEmpty: "0条记录",//筛选为空时左下角的显示。
			        infoFiltered: ""//筛选之后的左下角筛选提示，
			    },
			    pagingType: "full_numbers",//分页样式的类型
			    sScrollY: "100%",
			    data:prisoners_data,
			    columns:[
			    	{data:'prisoner_number',render:function(data,type,row){
			        	return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
			      	}},
			      	{data:'name',render:function(data,type,row){
			        	return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
			      	}},
				    {data:'gender',render:function(data,type,row){
				        return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
				     }},
			      	{data:'crimes',render:function(data,type,row){
			            return "<p style='line-height:50px;text-align:center'>"+data+"</p>"                     
			      	}},
			      	{data:'jail_id',render:function(data,type,row){
			        	return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
			      	}},
			      	{data:'prison_term_started_at',render:function(data,type,row){
			        	return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
			      	}},
			      	{data:'prison_term_ended_at',render:function(data,type,row){
			        	return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
			      	}},
			      	{data:'prison_area',render:function(data,type,row){
			        	return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
			      	}}
			    ]
			});
			return table;
		}	
	}).
	factory('searchPrisoner',function(){
		return {
			searching:searching
		};

		function searching(prisonerId,prisonerList){
			var person;
			for(var i=0;i<prisonerList.length;i++){
				if(prisonerList[i].prisoner_number == prisonerId){
					person = prisonerList[i];
					return person;
				}
			}
			if(!person){
				return "您搜索的囚犯不存在";
			}
		}
	});

var prisoner_directive = angular.module('prisoner_directive',[]);


