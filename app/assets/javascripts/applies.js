function  power(id,type_id,year,month,day){
  this.id = id;//点击授权的申请id
  var app_date = year+"-"+month+"-"+day;//拼接远程视频预约时间
  $("#formModal").find("#photos").remove();//清空照片
  $("#formModal").find(".photo-text").remove();//清空文字提示
  $(".reason-select").attr({style:"display:none"});
  $("#formModal").modal("toggle");//设置弹出框
  $(".modal-footer").empty();//清空按钮
  $(".modal-footer").append('<button type="button" class="btn btn-block btn-default pull-right complete pass">同意</button>'+
                            '<button type="button" class="btn btn-block btn-default pull-right complete nopass">不同意</button>'+
                            '<button type="button" class="btn btn-block btn-default btn-danger pull-left" data-dismiss="modal">关闭</button>');
  if(type_id == 3){//当是注册申请显示照片
    $.ajax({
      type:"get",
      url:"/applies",
      data:{"id":id},
      success:function(data){
        $(".photo-info").append('<p class="photo-text">请核对申请人照片:</p>');
        $(".photo-info").append("<div id='photos' style='padding:5px 10px 0 10px'></div>");
        for(var i=0;i<data.length;i++){
          $("#photos").append("<img style='width:150px;height:150px;margin-left:25px' src="+data[i]+"/>");
        }
        //放大图片
        $("#photos").find("img").mouseover(function(){
          $.each($("#photos").find("img"),function(i,n){
            $(this).css({
              "display":"none"
            });
          });
          $(this).css({
            "display":"block",
            "height":"300px",
            "width":"90%"
          });
        }).mouseout(function(){
          $.each($("#photos").find("img"),function(i,n){
            $(this).css({
              "display":""
            });
          })
          $(this).css({
            "height":"150px",
            "width":"150px"
          });
        });
      }
    });
  }
//点击不通过执行的函数
  $(".nopass").off("click");
  $(".nopass").on("click",function(){
    $(".reason-select").attr({style:"display:block"});
    $(".pass").attr({style:"display:none"});
    $(".nopass").attr({style:"display:none"});
    $(".btn-danger").before('<a class="btn btn-block btn-default pull-right complete nopass_update">提交</a>');
    $(".btn-danger").before('<button type="button" class="btn btn-block btn-default pull-right complete back">返回</button>')
    $(".nopass_update").on("click",function(){
      $(".nopass_update").off("click");
      $("#msg").html('<div class="overlay"><i class="fa fa-refresh fa-spin"></i></div>');
      var data = {
        is_allowed: 0,
        reason:$("#reason").val()+""
      }
      $.ajax({
        type:"put",
        url:"/applies/"+id,
        data:data,
        success:function(data){
          $(".nopass_update").remove();
          $(".back").remove();
          $(".reason-select").attr({style:"display:none"});
          if(data.code == 200){
            $("#msg").html('<div class="col-md-12 col-sm-12 col-xs-12">'+
                          '<div class="info-box bg-green">'+
                          '<span class="info-box-icon"><i class="glyphicon glyphicon-ok"></i></span>'+
                          '<div class="info-box-content" style="text-align:center;padding-top:15px;">'+
                          '<span class="info-box-number">授权成功</span></div>');
            window.location.reload();   
          }
        }
      })
    })
    $(".back").on("click",function(){
      $(".nopass").attr({style:""});
      $(".pass").attr({style:""});
      $(".reason-select").attr({style:"display:none"});
      $(".back").remove();
      $(".nopass_update").remove();
    });
  })
  //点击通过执行的函数
  $(".pass").on("click",function(){
    if(type_id == 1){
      var Arr_num =new Array(sessionStorage.num_list);
      var Arr_time =new Array(sessionStorage.time_list);
      Arr_time = Arr_time[0].split(",");
      Arr_num = Arr_num[0].split(",");
      var date_index = $.inArray(app_date,Arr_time);
      if(parseInt(Arr_num[date_index]) >=3){
        alert("已经达到每日远程视频会见申请的人数上线，每天远程会见的人数上限为3人");
        return false;
      }
    }
    $(".nopass").attr({style:"display:none;"});
    $(".pass").attr({style:"display:none;"});
    $(".btn-danger").before('<a class="btn btn-block btn-default pull-right complete pass_update">确定申请通过？</a>');
    $(".btn-danger").before('<a class="btn btn-block btn-default pull-right complete back">返回</a>');
    $(".pass_update").on("click",function(){
      $(".pass_update").off("click");
      var data = {
        is_allowed: 1,
        reason:""
      };
      $("#msg").html('<div class="overlay"><i class="fa fa-refresh fa-spin"></i></div>');
      $.ajax({
        type:"put",
        url:"/applies/"+id,
        data:data,
        success:function(data){
          $(".pass_update").remove();
          $(".back").remove();
          console.log(data);
          if(data.code == 200){
            $("#msg").html('<div class="col-md-12 col-sm-12 col-xs-12">'+
                          '<div class="info-box bg-green">'+
                          '<span class="info-box-icon"><i class="glyphicon glyphicon-ok"></i></span>'+
                          '<div class="info-box-content" style="text-align:center;padding-top:15px;">'+
                          '<span class="info-box-number">授权成功</span></div>');
            window.location.reload();
                          
          }else if(data.code == 501){
            var msg = data.msg.apply_create;
            $("#msg").html('<div class="col-md-12 col-sm-12 col-xs-12">'+
                          '<div class="info-box bg-red">'+
                          '<span class="info-box-icon"><i class="glyphicon glyphicon-remove"></i></span>'+
                          '<div class="info-box-content" style="text-align:center;padding-top:15px;">'+
                          '<span class="info-box-number">授权失败</span>'+
                          '<span class="info-box-number">'+msg+
                          '</span></div>');
          }else if(data.code == 404){
            var msg = data.msg;
            $("#msg").html('<div class="col-md-12 col-sm-12 col-xs-12">'+
                          '<div class="info-box bg-red">'+
                          '<span class="info-box-icon"><i class="glyphicon glyphicon-remove"></i></span>'+
                          '<div class="info-box-content" style="text-align:center;padding-top:15px;">'+
                          '<span class="info-box-number">授权失败</span>'+
                          '<span class="info-box-number">'+msg+
                          '</span></div>');
          }else if(data.code == 201){
            var msg = data.msg;
            $("#msg").html('<div class="col-md-12 col-sm-12 col-xs-12">'+
                          '<div class="info-box bg-red">'+
                          '<span class="info-box-icon"><i class="glyphicon glyphicon-remove"></i></span>'+
                          '<div class="info-box-content" style="text-align:center;padding-top:15px;">'+
                          '<span class="info-box-number">授权失败</span>'+
                          '<span class="info-box-number">'+msg+
                          '</span></div>');
          }
          window.location.reload();          
        }
      })
    })
    $(".back").on("click",function(){
      $(".nopass").attr({style:""});
      $(".pass").attr({style:""});
      $(".back").remove();
      $(".pass_update").remove();
    });  
  })
}
//查看今日申请
function refer_to_today_apply(){
  var today_data = eval ( "{[" + localStorage.today_data + "]}" );
  $(".today_video_table").css({"display":""});
  $(".nav").css({"display":"none"});
  $(".tab-content").css({"display":"none"});   
  $(".today_apply_btn").css({"display":"none"});
  $(".back").css({"display":""});
  var today_video_table = $("#today_video_table").DataTable({
    autoWidth:false,
    paging: true,//分页
    ordering: false,//是否启用排序
    searching: true,//搜索
    language: {
        lengthMenu: '<select style="width:150px;" class="form-control input-xsmall">' + '<option value="1">1</option>' + '<option value="10">10</option>' + '<option value="20">20</option>' + '<option value="30">30</option>' + '<option value="40">40</option>' + '<option value="50">50</option>' + '</select>条记录',//左上角的分页大小显示。
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
    paging: true,
    pagingType: "full_numbers",//分页样式的类型
    sScrollY: "100%",
    data:today_data,
    columns:[
      {data:'name',render:function(data,type,row){
                            return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
                          }
      },
      {data:'phone',render:function(data,type,row){
                             return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
                           }
      },
      {data:'uuid',render:function(data,type,row){
                            return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
                          }
      },
      {data:'created_at',render:function(data,type,row){
                                  var a = data+"";
                                  var  r = a.match(/^([0-9]+)-([0-1][0-9])-([0-3][0-9])/);
                                  //console.log(r[0]);
                                  return "<p style='line-height:50px;text-align:center'><span>"+r[0]+"</span></p>"                     
                                }
      },
      {data:'app_date',render:function(data,type,row){
                                return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
                              }
      },
      {data:'prisoner_number',render:function(data,type,row){
                                       return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
                                     }
      },
      {data:'relationship',render:function(data,type,row){
                                    return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
                                  }
      },
      {data:'is_allowed',render: function(data,type,row){
                                    if(data){
                                      return "<p style='line-height:50px;text-align:center'><span style='font-weight:bold;color:#00a65a'>已授权</span></p>"
                                    }else if(data == false){
                                      return "<p style='line-height:50px;text-align:center'><span style='font-weight:bold;color:#dd4b39'>已拒绝</span></p>"
                                    }else if(data == null){
                                      return "<p style='line-height:50px;text-align:center'><span style='font-weight:bold;color:#f39c12'>未授权</span></p>"
                                    }
                                 }
      }
    ],
    "columnDefs":[
      {
        "targets":[8],
        "visible":true,
        "data":"id",
        "render":function(data,type,row){
          if(row.is_allowed == null || row.is_allowed == undefined){
            var a = row.app_date+"";
            var r = a.match(/^([0-9]+)-([0-1][0-9])-([0-3][0-9])/);
            if(r==null){
              return "没填写全部信息不能授权";
            }else{
              r[2] = parseInt(r[2])+"";
              r[3] = parseInt(r[3])+"";
              return "<p style='line-height:50px;text-align:center;float:left;'><a class='btn btn-default btn-sm' style='color:#3c8dbc;font-weight:bold;' onClick='power("+row.id+","+row.type_id+","+r[1]+","+r[2]+","+r[3]+")'>授权</a></p>"
            }
          }else if(row.is_allowed){
            return '<div class="form-group has-success"><p style="line-height:50px;text-align:center"><label class="control-label" for="inputSuccess"><i class="fa fa-check"></i></label></p></div>'
          }else if(!row.is_allowed){
            return "<div class='form-group has-error'><p style='line-height:50px;text-align:center'><span><label class='control-label' for='inputError'><i class='icon fa fa-ban'></i></label></span></p></div>"
          }
        } 
     }
    ]
  })
  $("#today_video_table_filter input[type=search]").css({ width: "auto" });
  $("#today_video_table_filter").find("input").wrap('<div class="box-tools"><div class="input-group input-group-sm" style="width:150px;"></div></div>');
  $("#today_video_table_filter").find(".input-group").append('<div class="input-group-btn"><button type="submit" class="btn btn-default"><i class="fa fa-search"></i></button></div>');
  $("#today_video_table_filter").css({"margin":"10px 0 20px 0"});
  $("#today_video_table_length").css({"margin":"10px 0 20px 0"});
  $("#today_video_table_length").find("label").css({"margin":"0 0 20px 0"});
  
  $(".back").click(function(){
    $(".today_video_table").css({"display":"none"});
    $(".nav").css({"display":""});
    $(".tab-content").css({"display":""});   
    $(".today_apply_btn").css({"display":""});
    $(".back").css({"display":"none"});
    today_video_table.destroy();
  })
}
//-----------------------------------------------------------------------------------
(function(){
  $(document).on('ready',function(){
//time_list-------------------------------------------------------------------
  var time_list = new Array();
  var num_list = new Array();
  sessionStorage.num_list = num_list;
  sessionStorage.time_list = time_list;
  var num_array = eval ("[" + sessionStorage.num_list + "]");
  var array = eval ("[" + sessionStorage.time_list + "]");
//----------------------------------------------------------------------------
  $.ajax({
    type:"get",
    url:"/applies",
    dataType:"json",
    success:function(data){
//存储今日申请------------------------------------------------------------------
   function save_today_apply(data){
      var date = new Date();
      var day = date.getDate();
      var month =  date.getMonth() + 1;
      var year = date.getFullYear();
      if(parseInt(month) >= 10){
        date = year + "-" + month + "-" + day;
      }else{
        date = year + "-0" + month + "-" + day;
      }
      var today_data = new Array();
      for(var i=0,j=0;i<data.length;i++){
        if(data[i].app_date == date){
          today_data[j] = JSON.stringify(data[i]);
          j++;
        }
      }
      localStorage.today_data = today_data;
    } 
   save_today_apply(data);
// ---vedio_table    ----------------------------------------------------------
  var vedio_data = new Array();
  for(var i=0,  j=0;i<data.length;i++){
    if(data[i].type_id == 1){
      vedio_data[j] = data[i];
      j++;
    }
  }
  video_table = $("#video_table").dataTable({
    autoWidth:false,
    paging: true,//分页
    ordering: false,//是否启用排序
    searching: true,//搜索
    language: {
        lengthMenu: '<select style="width:150px;" class="form-control input-xsmall">' + '<option value="1">1</option>' + '<option value="10">10</option>' + '<option value="20">20</option>' + '<option value="30">30</option>' + '<option value="40">40</option>' + '<option value="50">50</option>' + '</select>    条记录',//左上角的分页大小显示。
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
    data:vedio_data,
    columns:[
      {data:'name',render:function(data,type,row){
        return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
      }},
      {data:'phone',render:function(data,type,row){
        return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
      }},
      {data:'uuid',render:function(data,type,row){
        return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
      }},
      {data:'created_at',render:function(data,type,row){
          var a = data+"";
          var  r = a.match(/^([0-9]+)-([0-1][0-9])-([0-3][0-9])/);
          return "<p style='line-height:50px;text-align:center'><span>"+r[0]+"</span></p>"                     
      }},
      {data:'app_date',render:function(data,type,row){
        return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
      }},
      {data:'prisoner_number',render:function(data,type,row){
        return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
      }},
      {data:'relationship',render:function(data,type,row){
        return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
      }},
      {data:'is_allowed',render: function(data,type,row){
          if(data){
            return "<p style='line-height:50px;text-align:center'><span style='font-weight:bold;color:#00a65a'>已授权</span></p>"
          }else if(data == false){
            return "<p style='line-height:50px;text-align:center'><span style='font-weight:bold;color:#dd4b39'>已拒绝</span></p>"
          }else if(data == null){
            return "<p style='line-height:50px;text-align:center'><span style='font-weight:bold;color:#f39c12'>未授权</span></p>"
          }
      }}
    ],
    "columnDefs":[
      {
        "targets":[8],
        "visible":true,
        "data":"id",
        "render":function(data,type,row){
          if(row.is_allowed == null || row.is_allowed == undefined){
            var a = row.app_date+"";
            var r = a.match(/^([0-9]+)-([0-1][0-9])-([0-3][0-9])/);
            if(r==null){
              return "没填写全部信息不能授权";
            }else{
              r[2] = parseInt(r[2])+"";
              r[3] = parseInt(r[3])+"";
              return "<p style='margin-top:5px;margin-left:15px;line-height:50px;text-align:center;float:left;'><a class='btn btn-default btn-sm' style='color:#3c8dbc;font-weight:bold;' onClick='power("+row.id+","+row.type_id+","+r[1]+","+r[2]+","+r[3]+")'>授权</a></p>"
            }
          }else if(row.is_allowed){
            return '<div class="form-group has-success"><p style="margin-left:15px;line-height:50px;text-align:center;margin-left:40%;"><label class="control-label" for="inputSuccess"><i class="fa fa-check"></i></label></p></div>'
          }else if(!row.is_allowed){
            return "<div class='form-group has-error' style='width:100px;'><p style='line-height:50px;text-align:center;'><span><label class='control-label' for='inputError'><i class='icon fa fa-ban'></i></label></span></p></div>"
        }
      } 
     }
    ]
  })
  $("#video_table_filter input[type=search]").css({ width: "auto" });
  $("#video_table_filter").find("input").wrap('<div class="box-tools"><div class="input-group input-group-sm" style="width:150px;"></div></div>');
  $("#video_table_filter").find(".input-group").append('<div class="input-group-btn"><button type="submit" class="btn btn-default"><i class="fa fa-search"></i></button></div>');
  $("#video_table_filter").css({"margin":"10px 0 20px 0"});

  $("#video_table_length").css({"margin":"10px 0 20px 0"});
  $("#video_table_length").find("label").css({"margin":"0 0 20px 0"});
  $("#video_table_length").append('<div class="button"><button class="btn btn-default all">查看全部</button><button style="margin-left:10px;" class="btn btn-default refuse">查看已拒绝</button><button style="margin-left:10px;" class="btn btn-default already_apply">查看已授权</button><button style="margin-left:10px;" style="" class="btn btn-default no_apply">查看未授权</button></div>')
  video_table.api().search("未授权").draw();
  $("#video_table_length").find(".refuse").click(function(){
    video_table.api().search("已拒绝").draw()
  })
  $("#video_table_length").find(".already_apply").click(function(){
    video_table.api().search("已授权").draw()
  })
  $("#video_table_length").find(".no_apply").click(function(){
    video_table.api().search("未授权").draw()
  })
  $("#video_table_length").find(".all").click(function(){
    video_table.api().search("").draw()
  })
//tab_table --------------------------------------------------------------
//login_table   ----------------------------------------------------------
  var login_data = new Array();
  for(var i=0,  j=0;i<data.length;i++){
    if(data[i].type_id == 3){
      login_data[j] = data[i];
      j++;
    }
  }
  var num=0;
  login_table = $("#login_table").dataTable({
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
    paging: true,
    pagingType: "full_numbers",//分页样式的类型
    data:login_data,
    columns:[
      {data:'name',render:function(data,type,row){
          return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
      }},
      {data:'phone',render:function(data,type,row){
          return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
      }},
      {data:'uuid',render:function(data,type,row){
          return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
      }},
      {data:'created_at',render:function(data,type,row){
          var a = data+"";
          var  r = a.match(/^([0-9]+)-([0-1][0-9])-([0-3][0-9])/);
          return "<p style='line-height:50px;text-align:center'><span>"+r[0]+"</span></p>"                     
      }},
      {data:'prisoner_number',render:function(data,type,row){
          return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
      }},
      {data:'relationship',render:function(data,type,row){
          return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
      }},
      {data:'is_allowed',render:function(data,type,row){
          if(data){
            return "<p style='line-height:50px;text-align:center'><span style='font-weight:bold;color:#00a65a'>已授权</span></p>"
          }else if(data == false){
            return "<p style='line-height:50px;text-align:center'><span style='font-weight:bold;color:#dd4b39'>已拒绝</span></p>"
          }else{
            return "<p style='line-height:50px;text-align:center'><span style='font-weight:bold;color:#f39c12'>未授权</span></p>"
          }
      }}
    ],
    "columnDefs":[
      {
        "targets":[7],
        "visible":true,
        "data":"id",
        "render":function(data,type,row){
          if(row.is_allowed == null || row.is_allowed == undefined){
            return "<p style='line-height:50px;text-align:center;float:left;'><a class='btn btn-default btn-sm' style='font-weight:bold;color:#3c8dbc;' onClick='power("+row.id+","+row.type_id+")'>授权</a></p>"
          }else if(row.is_allowed == true){
            return '<div class="form-group has-success"><p style="line-height:50px;text-align:center;margin-left:60%;"><label class="control-label" for="inputSuccess"><i class="fa fa-check"></i></label></p></div>'
          }else if(row.is_allowed == false){
            return "<div class='form-group has-error'><p style='line-height:50px;text-align:center;margin-left:60%;'><span><label class='control-label' for='inputError'><i class='icon fa fa-ban'></i></label></span></p></div>"
        }
      } 
     }
    ]
  })
$("#login_table_filter input[type=search]").css({ width: "auto" });
$("#login_table_filter").find("input").wrap('<div class="box-tools"><div class="input-group input-group-sm" style="width:150px;"></div></div>');
$("#login_table_filter").find(".input-group").append('<div class="input-group-btn"><button type="submit" class="btn btn-default"><i class="fa fa-search"></i></button></div>');
$("#login_table_filter").css({"margin":"10px 0 20px 0"});
$("#login_table_length").css({"margin":"10px 0 20px 0"});
$("#login_table_length").find("label").css({"margin":"0 0 20px 0"});
$("#login_table_length").append('<div class="button"><button class="btn btn-default all">查看全部</button><button style="margin-left:10px;" class="btn btn-default refuse">查看已拒绝</button><button style="margin-left:10px;" class="btn btn-default already_apply">查看已授权</button><button style="margin-left:10px;" style="" class="btn btn-default no_apply">查看未授权</button></div>')
login_table.api().search("未授权").draw();
$("#login_table_length").find(".refuse").click(function(){
  login_table.api().search("已拒绝").draw()
})
$("#login_table_length").find(".already_apply").click(function(){
  login_table.api().search("已授权").draw()
})
$("#login_table_length").find(".no_apply").click(function(){
  login_table.api().search("未授权").draw()
})
$("#login_table_length").find(".all").click(function(){
  login_table.api().search("").draw()
})
//-----------------------------------------------------------
//look_table-------------------------------------------------
  var look_data = new Array();
  for(var i=0,  j=0;i<data.length;i++){
    if(data[i].type_id == 2){
      look_data[j] = data[i];
      j++;
    }
  }
  var num=0;
    look_table = $("#look_table").dataTable({
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
    paging: true,
    pagingType: "full_numbers",//分页样式的类型
    data:look_data,
    columns:[
      {data:'name',render:function(data,type,row){
        return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
      }},
      {data:'phone',render:function(data,type,row){
        return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
      }},
      {data:'uuid',render:function(data,type,row){
        return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
      }},
      {data:'app_date',render:function(data,type,row){
          var a = data+"";
          var  r = a.match(/^([0-9]+)-([0-1][0-9])-([0-3][0-9])/);
          return "<p style='line-height:50px;text-align:center'><span>"+r[0]+"</span></p>"                     
      }},
      {data:'prisoner_number',render:function(data,type,row){
        return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
      }},
      {data:'relationship',render:function(data,type,row){
        return "<p style='line-height:50px;text-align:center'>"+data+"</p>"
      }},
      {data:'is_allowed',render:function(data,type,row){
          if(data){
            return "<p style='line-height:50px;text-align:center'><span style='font-weight:bold;color:#00a65a'>已授权</span></p>"
          }else if(data == false){
            return "<p style='line-height:50px;text-align:center'><span style='font-weight:bold;color:#dd4b39'>已拒绝</span></p>"
          }else{
            return "<p style='line-height:50px;text-align:center'><span style='font-weight:bold;color:#f39c12'>未授权</span></p>"
          }
        }}
    ],
    "columnDefs":[
      {
        "targets":[7],
        "visible":true,
        "data":"id",
        "render":function(data,type,row){
          if(row.is_allowed == null || row.is_allowed == undefined){
            return "<p style='line-height:50px;text-align:center;float:left;'><a class='btn btn-default btn-sm' style='font-weight:bold;color:#3c8dbc;' onClick='power("+row.id+")'>授权</a></p>"
          }else if(row.is_allowed == true){
            return '<div class="form-group has-success"><p style="line-height:50px;text-align:center;margin-left:40%;"><label class="control-label" for="inputSuccess"><i class="fa fa-check"></i></label></p></div>'
          }else if(row.is_allowed == false){
          return "<div class='form-group has-error'><p style='line-height:50px;text-align:center;margin-left:40%;'><span><label class='control-label' for='inputError'><i class='icon fa fa-ban'></i></label></span></p></div>"
        }
      } 
     }
    ]
  })
$("#look_table_filter input[type=search]").css({ width: "auto" });
$("#look_table_filter").find("input").wrap('<div class="box-tools"><div class="input-group input-group-sm" style="width:150px;"></div></div>');
$("#look_table_filter").find(".input-group").append('<div class="input-group-btn"><button type="submit" class="btn btn-default"><i class="fa fa-search"></i></button></div>');
$("#look_table_length").css({"margin":"10px 0 20px 0"});
$("#look_table_length").css({"margin":"10px 0 20px 0"});
$("#look_table_length").find("label").css({"margin":"0 0 20px 0"});
$("#look_table_length").append('<div class="button"><button class="btn btn-default all">查看全部</button><button style="margin-left:10px;" class="btn btn-default refuse">查看已拒绝</button><button style="margin-left:10px;" class="btn btn-default already_apply">查看已授权</button><button style="margin-left:10px;" style="" class="btn btn-default no_apply">查看未授权</button></div>')
look_table.api().search("未授权").draw()
$("#look_table_length").find(".refuse").click(function(){
  look_table.api().search("已拒绝").draw()
})
$("#look_table_length").find(".already_apply").click(function(){
  look_table.api().search("已授权").draw()
})
$("#look_table_length").find(".no_apply").click(function(){
  look_table.api().search("未授权").draw()
})
$("#look_table_length").find(".all").click(function(){
  look_table.api().search("").draw()
})
//-----------------------------------------------------------
//line_length_limit -----------------------------------------
  function line_length_limit(data){
    //console.log(data);
    for(var i=0;i<data.length;i++){
      if(data[i].type_id == 1){
        //-----------time_list------------
        var a = data[i].app_date;
        var  r = a.match(/^([0-9]+)-([0-1][0-9])-([0-3][0-9])/);
        var month = parseInt(r[2])+"";
        var day = parseInt(r[3])+"";
        var app_date = r[1]+"-"+month+"-"+day
        if($.inArray(app_date,array) == -1){
          array[array.length] = app_date;
          sessionStorage.time_list = array;
          if(data[i].is_allowed == 1){
            num_array[array.length-1] = 1;
            sessionStorage.num_list = num_array;
          }else{
            num_array[array.length-1] = 0;
            sessionStorage.num_list = num_array;
          }
        }else{
          if(data[i].is_allowed == 1){
            num_array[$.inArray(app_date,array)] += 1;
            sessionStorage.num_list = num_array ;
          }
        }
        //--------------------------------
      }
    }
  }
      line_length_limit(data);
      //console.log(video_table.api());
//------------------------------------------------------------
      }
    })
  })
  var li = $(".nav-tabs").find("li")
  for(var i=0;i<li.length;i++){
    $(li[i]).click(function(){
      for(var j=0;j<li.length;j++){
        $(li[j]).css({
          "font-weight":"",
          "font-size":""
        });
        $(li[j]).find("a").css({
          "color":""
        })
      }
      $(this).css({
        "font-weight":"weight",
        "font-size":"14px"
      }).find("a").css({
        "color":"#3c8dbc"
      })
    })
  }
}())
