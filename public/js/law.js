(function($){
  var href = window.location.href;
  var loc = href.substring(href.lastIndexOf('/'));
  switch(loc){
    case "/laws":
      laws_index_action();
      break;
    case "/edit":
      laws_edit_action();
      break;
    case "/new":
      laws_new_action();
      break;
  }

  /*
  *laws#index执行的js
  */
  function laws_index_action(){
    $(".title-list").css({
      "height":$(".main-sidebar").height()+"px"
    });
    $(".law_contents").css({
      "height":$(".main-sidebar").height()+"px"
    });
    $(".title-list").find("ul").find("li").first().addClass(" active");
    var now_active_obj = $(".title-list").find("ul").find("li").first();

    $.ajax({
      type:"get",
      url:"/laws",
      dataType:"json",
      success:function(data){
        var li_list = $(".title-list").find("ul").find("li");
        $(".law_contents").find("p").html(data[0].contents);
        $(".jails_edit").append("<p style='line-height:50px;text-align:center;'><a style='margin:0 10px 0 10px' class='btn btn-delete btn-sm btn-danger' href='laws/"+data[0].id+"/delete'>删除</a> <a style='color:#3c8dbc;margin:0 10px 0 10px' class='btn btn-edit btn-sm btn-default' href='/laws/"+data[0].id+"/edit' >编辑</a></p>");
        $(".img").append("<img style='width:90%;height:400px;margin-top:10px;' src='"+data[0].image_url+"'/>");
        for(var i=0;i<li_list.length;i++){
          $(li_list[i]).click(function(){
            var id = $(this).find(".id").text();
            for(var j=0;j<data.length;j++){
              if(data[j].id == id){
                $(".jails_edit").empty();
                $(".img").empty();
                $(".img").append("<img style='width:90%;height:400px;margin-top:10px;' src='"+data[j].image_url+"'/>");
                $(".law_contents").find("p").html(data[j].contents);
                $(".jails_edit").append("<p style='line-height:50px;text-align:center;'><a style='margin:0 10px 0 10px' class='btn btn-delete btn-sm btn-danger' href='laws/"+data[j].id+"/delete'>删除</a> <a style='color:#3c8dbc;margin:0 10px 0 10px' class='btn btn-edit btn-sm btn-default' href='/laws/"+data[j].id+"/edit' >编辑</a></p>");
              }
            }
            $(now_active_obj).removeClass(" active");
            $(this).addClass(" active");
            now_active_obj = $(this);
          })
        }
      }
    })
  }

  /*
  *laws#edit执行的js
  */
  function laws_edit_action(){
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
  *laws#new执行的js
  */
  function laws_new_action(){
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
