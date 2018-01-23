(function($){

  var href = window.location.href;
  var loc = href.substring(href.lastIndexOf('/'));
  switch(loc){
    case "/news":
      news_index_action();
      break;
    case "/edit":
      news_edit_action();
      break;
    case "/new":
      news_new_action();
      break;
  }
  /*
  *news#index执行的js
  */
  function news_index_action(){
    $.ajax({
      type:"get",
      url:"/news",
      dataType:"json",
      success:function(data){
        //狱务公开新闻
        var news_data = new Array();
        console.log(data);
        for(var i=0;i<data[news].length;i++){
          if(data[news][i].type_id == 1){
            news_data.push(data[news][i]);
          }
        }
        $("#tTrolleys").DataTable({
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
            info: "总共 _PAGES_ 页",//左下角的信息显示，大写的词为关键字。
            infoEmpty: "0条记录",//筛选为空时左下角的显示。
            infoFiltered: ""//筛选之后的左下角筛选提示，
          },
          // paging: true,
          pagingType: "full_numbers",//分页样式的类型
          sScrollY: "100%",
          processing: true,
      	  serverSide: true,
          length:10,
          data:news_data,
          columns:[
            {data:'title',"sWidth":"30%",render:function(data,type,row){
              return "<div><p style='text-align:left;margin-top:50px;'>"+data+"</p></div>";
            }},
            {data:'contents',"sWidth":"40%",render:function(data,type,row){
              return "<div style='height:100px;overflow:auto;'><p>"+data+"</p></div>";
            }},
            {data:'image_url',"sWidth":"15%",render:function(data,type,full){
                return "<div><p style='text-align:center;line-height:100px;'><img style='width:80px;height:80px' src='"+data+"'/></p></div>";
            }}
          ],
          "columnDefs":[
            {
              "targets":[3],
              "visible":true,
              "data":"id",
              "render":function(data,type,full){
                return "<div style='margin-left:20px;'><p style='line-height:100px;'><a class='btn btn-delete btn-sm btn-danger' href='news/"+data+"/delete' >删除</a> <a style='margin-left:5px;color:#3c8dbc;' class='btn btn-edit btn-sm btn-default' href='/news/"+data+"/edit' >修改</a></p></div>";
              }
            }
          ]
        });
        $("#tTrolleys_filter input[type=search]").css({ width: "auto" });
        $("#tTrolleys_filter").find("input").wrap('<div class="box-tools"><div class="input-group input-group-sm" style="width:150px;"></div></div>');
        $("#tTrolleys_filter").find(".input-group").append('<div class="input-group-btn"><button type="submit" class="btn btn-default"><i class="fa fa-search"></i></button></div>');
        //投诉建议公示
        var notice_data = new Array();
        for(var i=0;i<data[news].length;i++){
          if(data[news][i].type_id == 3){
            notice_data.push(data[news][i]);
          }
        }
        $("#notices_table").DataTable({
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
            info: "总共_PAGES_ 页",//左下角的信息显示，大写的词为关键字。
            infoEmpty: "0条记录",//筛选为空时左下角的显示。
            infoFiltered: ""//筛选之后的左下角筛选提示，
          },
          paging: true,
          pagingType: "full_numbers",//分页样式的类型
          sScrollY: "100%",
          processing: true,
      	  serverSide: true,
          length:5,
          data:notice_data,
          columns:[
            {data:'title',"sWidth":"30%",render:function(data,type,row){
              return "<div><p style='text-align:left;margin-top:50px;'>"+data+"</p></div>";
            }},
            {data:'contents',"sWidth":"40%",render:function(data,type,row){
              return "<div style='height:100px;overflow:auto;'><p>"+data+"</p></div>";
            }},
            {data:'image_url',"sWidth":"15%",render:function(data,type,full){
                return "<div><p style='text-align:center;line-height:100px;'><img style='width:80px;height:80px' src='"+data+"'/></p></div>";
            }}
          ],
          "columnDefs":[
            {
              "targets":[3],
              "visible":true,
              "data":"id",
              "render":function(data,type,full){
                return "<div style='margin-left:20px;'><p style='line-height:100px;'><a class='btn btn-delete btn-sm btn-danger' href='news/"+data+"/delete' >删除</a> <a style='margin-left:5px;color:#3c8dbc;' class='btn btn-edit btn-sm btn-default' href='/news/"+data+"/edit' >修改</a></p></div>";
              }
            }
          ]
        });
        $(".dataTables_scrollHeadInner").css({
          // "width":"1010px"
          "width":"100%"
        });
        $(".dataTables_scrollHeadInner").find("table").css({
          // "width":"1010px"
          "width":"100%"
        });
        $("#notices_table_filter input[type=search]").css({ width: "auto" });
        $("#notices_table_filter").find("input").wrap('<div class="box-tools"><div class="input-group input-group-sm" style="width:150px;"></div></div>');
        $("#notices_table_filter").find(".input-group").append('<div class="input-group-btn"><button type="submit" class="btn btn-default"><i class="fa fa-search"></i></button></div>');
        //工作动态
        var work_news_data = new Array();
        for(var i=0;i<data[news].length;i++){
          if(data[news][i].type_id == 2){
            work_news_data.push(data[news][i]);
          }
        }
        $("#work_news_table").DataTable({
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
            info: "总共_PAGES_ 页",//左下角的信息显示，大写的词为关键字。
            infoEmpty: "0条记录",//筛选为空时左下角的显示。
            infoFiltered: ""//筛选之后的左下角筛选提示，
          },
          paging: true,
          processing: true,
      	  serverSide: true,
          pagingType: "full_numbers",//分页样式的类型
          sScrollY: "100%",
          data:work_news_data,
          columns:[
            {data:'title',"sWidth":"30%",render:function(data,type,row){
              return "<div><p style='text-align:left;margin-top:50px;'>"+data+"</p></div>";
            }},
            {data:'contents',"sWidth":"40%",render:function(data,type,row){
              return "<div style='height:100px;overflow:auto;'><p>"+data+"</p></div>";
            }},
            {data:'image_url',"sWidth":"15%",render:function(data,type,full){
                return "<div><p style='text-align:center;line-height:100px;'><img style='width:80px;height:80px' src='"+data+"'/></p></div>";
            }}
          ],
          "columnDefs":[
            {
              "targets":[3],
              "visible":true,
              "data":"id",
              "render":function(data,type,full){
                return "<div style='margin-left:20px;'><p style='line-height:100px;'><a class='btn btn-delete btn-sm btn-danger' href='news/"+data+"/delete' >删除</a> <a style='margin-left:5px;color:#3c8dbc;' class='btn btn-edit btn-sm btn-default' href='/news/"+data+"/edit' >修改</a></p></div>";
              }
            }
          ]
        });
        $(".dataTables_scrollHeadInner").css({
          // "width":"1010px"
          "width":"100%"
        });
        $(".dataTables_scrollHeadInner").find("table").css({
          // "width":"1010px"
          "width":"100%"
        })
        $("#work_news_table_filter input[type=search]").css({ width: "auto" });
        $("#work_news_table_filter").find("input").wrap('<div class="box-tools"><div class="input-group input-group-sm" style="width:150px;"></div></div>');
        $("#work_news_table_filter").find(".input-group").append('<div class="input-group-btn"><button type="submit" class="btn btn-default"><i class="fa fa-search"></i></button></div>');
      }
    })
  }
  /*
  *news#edit执行的js
  */
  function news_edit_action(){
    $('input[type="checkbox"].minimal, input[type="radio"].minimal').iCheck({
      checkboxClass: 'icheckbox_minimal-blue',
      radioClass: 'iradio_minimal-blue'
    });
    init_text_area();

    realtime_get_input_value();

    validate_form();

    checkfile();
    //文本非空验证
    $(".text-not-null").each(function(){
      $(this).keyup(function(){
        validate_form();
      });
    });
    //上传文件非空与大小验证
    $("#fileuploade").change(function(){
      validate_form();
    });
  }
  /*
  *news#new执行的js
  */
  function news_new_action(){
    $('input[type="checkbox"].minimal, input[type="radio"].minimal').iCheck({
      checkboxClass: 'icheckbox_minimal-blue',
      radioClass: 'iradio_minimal-blue'
    });

    init_text_area();

    realtime_get_input_value();

    validate_form();

    checkfile();
    //文本非空验证
    $(".text-not-null").each(function(){
      $(this).keyup(function(){
        validate_form();
      });
    });

    //上传文件非空与大小验证
    $("#fileuploade").change(function(){
      validate_form();
    });
  }
  //验证表单
  function validate_form(){
    $(".text-not-null").each(function(){
      if(!$(this).val()){
        $(this)
          .css({"color":"#a94442"})
          .parent().addClass(" has-error")
          .find("span").css({"border-color":"#a94442"});
        $("#update").attr({"disabled":"disabled"});
      }else{
        $(this)
          .css({"color":"#00a65a"})
          .parent().removeClass(" has-error")
          .addClass(" has-success")
          .find("span").css({"border-color":"#00a65a"});
      }
    });
    if($(".text-area-not-null").text() == "<br>" || $(".text-area-not-null").text() == ""){
      $(".text-area-not-null")
        .parent().parent().css({"color":"#a94442"})
        .addClass(" has-error")
        .find("span").css({"border-color":"#a94442"});
      $("#update").attr({"disabled":"disabled"});
    }else{
      $(".text-area-not-null")
        .parent().parent().css({"color":"#00a65a"})
        .removeClass(" has-error")
        .addClass(" has-success")
        .find("span").css({"border-color":"#00a65a"});
    }
    if($(".has-error").length == 0 && checkfile()){
      $("#update").removeAttr("disabled");
    }
  }
  //文件上传非空与大小验证
  function checkfile(){
    var maxsize = 2*1024*1024;//2M
    var errMsg = "上传的附件文件不能超过2M！！！";
    var tipMsg = "您的浏览器暂不支持计算上传文件的大小，确保上传文件不要超过2M，建议使用IE、FireFox、Chrome浏览器。";
    var  browserCfg = {};
    var ua = window.navigator.userAgent;

    if (ua.indexOf("MSIE")>=1){
        browserCfg.ie = true;
    }else if(ua.indexOf("Firefox")>=1){
        browserCfg.firefox = true;
    }else if(ua.indexOf("Chrome")>=1){
        browserCfg.chrome = true;
    }
    try{
      var obj_file = document.getElementById("fileuploade");
      if(obj_file.value==""){
        $(".imagefileName").text("请先选择上传文件");
        $("#update").attr({"disabled":"disabled"});
        return false;
      }
      var filesize = 0;
      if(browserCfg.firefox || browserCfg.chrome ){
        filesize = obj_file.files[0].size;
      }else if(browserCfg.ie){
        var obj_img = document.getElementById('tempimg');
        obj_img.dynsrc=obj_file.value;
        filesize = obj_img.fileSize;
      }else{
        $(".imagefileName").text(tipMsg);
        $("#update").attr({"disabled":"disabled"});
        return false;
      }
      if(filesize==-1){
        $(".imagefileName").text(tipMsg);
        $("#update").attr({"disabled":"disabled"});
        return false;
      }else if(filesize>maxsize){
        $(".imagefileName").text(errMsg);
        $("#update").attr({"disabled":"disabled"});
        return false;
      }else{
        $(".imagefileName").text(obj_file.value+"/文件大小符合要求");
        return true;
      }
    }catch(e){
      $(".imagefileName").text(e);
      $("#update").attr({"disabled":"disabled"});
    }
  }
  //初始化富文本编辑器
  function init_text_area(){
    var href = window.location.href;
    var loc = href.substring(0,href.lastIndexOf('/'));
    var textCSS = '/plugins/sinaEditor/style/css/contents.css';
    var config = {
      "id": "myEditor",
      //编辑器的按钮存放的base dom id 或者dom
      "toolBase": 'testSaveButtons',
      "initType": {
        "name": "initFromStatic",
        "args": {
          "parent": document.getElementById('frame')
        }
      },
      //可选
      "filter": {
        "name": "pasteFilter",
        "args": {
          "tagName": "SCRIPT|INPUT|IFRAME|TEXTAREA|SELECT|BUTTON",
          "noFlashExchange": false,
          "attribute": "id"
        }
      },
      "editorName": 'SinaEditor._.entyimpl.normalEditor',
      "styles": "body {\
              margin:0px;\
              padding:0px;\
              width:100%;\
              height:100%;\
            }\
            .biaoqing {\
              width:22px;\
              height:22px;\
            }",
      "styleLinks": [textCSS],
      "plugns": [{
        "name": "addContent"
      },{
        "name": "showSource",
        "args": {
          "entyArea": document.getElementById('frameToText')
        }
      },
      {
        "name": "link"
      },{
        "name": "backcolor"
      },
      {
        "name": "forecolor"
      }, {
        "name": "underline"
      },{
        "name": "italic"
      }, {
        "name": "bold"
      }, {
        "name": "linkBubble"
      }, {
        "name": "imgBubble"
      }, {
        "name": "flashBubble"
      }, {
        "name": "redoManager"
      }, {
        "name": "fontFamily"
      }, {
        "name": "fontSize"
      }, {
        "name": "markList"
      }, {
        "name": "numberList"
      }, {
        "name": "indent"
      }, {
        "name": "outdent"
      }, {
        "name": "justifyright"
      }, {
        "name": "justifycenter"
      }, {
        "name": "justifyleft"
      }]
    };
    window.editor1 = SinaEditor.createEditor(config);
  }
  //实时获取textarea文本框中的值
  function realtime_get_input_value(){
    setTimeout(function(){
      $("#frame").find("iframe").attr({"id":"test"});
      var text = $("#frameToText").text();
      $("iframe").contents().find("body").html(text);
      var doc = document.getElementById("test").contentDocument;
      doc.designMode = "on"
      function keyPress(e) {
        var text = $("iframe").contents().find("body").html();
        $("#frameToText").text(text);
        validate_form();
      }
      if(doc.addEventListener){
        doc.addEventListener('keyup', keyPress, false);
      }
      else doc.attachEvent('onkeypress', keyPress);
    },2000);
  }
})(jQuery)
