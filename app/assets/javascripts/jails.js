(function($){
  var href = window.location.href;
  var loc = href.substring(href.lastIndexOf('/'));
  switch(loc){
    case "/jails":
      jails_action();
      break;
    case "/edit":
      jails_edit();
      break;
    case "default":
      break;
  }
  /*
  *jails#index执行的js
  */
  function jails_action(){
    $.ajax({
      type:"get",
      url:"/jails",
      dataType:"json",
      success:function(data){
        var jail_id = $(".jail_id").text();
        var jail_data;
        for(var i=0;i<data.length;i++){
          if(data[i].id == jail_id){
            jail_data = data[i];
          }
        }
        $(".title").html(jail_data.title);
        $(".state").html("&emsp;"+jail_data.state);
        $(".city").html("&emsp;"+jail_data.city);
        $(".district").html("&emsp;"+jail_data.district);
        $(".street").html("&emsp;"+jail_data.street);
        $(".description").html(jail_data.description);
        $(".edit").attr({
          "href":"/jails/"+jail_data.id+"/edit"
        });
      }
    });
  }
  /*
  *jails#edit执行的js
  */
  function jails_edit(){

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
      validate_form()
    });
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
