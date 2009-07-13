function initAjaxForm(){
  var formWrap = $page.getCurrViewId();
  var form = jQuery('#' + formWrap + " form");
  initControlStyle(form);
  var suceess_submit_callback = function(data,status,action){
    try{
      var json = eval("(function(){return " + data + " })()"); 
    }catch(e){
      alert(e);
      return;
    }
    if(json.status && json.status == "success"){
      if(json.message)alert(json.message);
      if(action)action();
    }else{
      if(json.error){
        alert(json.error.join('\n'));
      }
    }
  }

  var v = form.validate({
    submitHandler: function(form) {
      jQuery(form).ajaxSubmit({
        url: form.action + '.json',
        success: function(data,status){ 
            suceess_submit_callback(data,status,function(){$page.showListView("reloadData")})
        }
      });
    }
  });

  jQuery("#save_and_new").click(function(){
    if(v.form()){
      jQuery(form).ajaxSubmit({
        url: form[0].action + '.json',
        success: function(data,status){
            suceess_submit_callback(data,status,function(){ form[0].reset();})
        }
      });
    }
  })

  jQuery("#update").click(function(){
    if(v.form()){
      jQuery(form).ajaxSubmit({
        url: form[0].action + '.json',
        success: function(data,status){
          suceess_submit_callback(data,status,function(){
          })
        }
      });
    }
  })

  jQuery("#btnNew").click(function(){
    $page.showNewView();
  })
  jQuery("#btnNext").click(edit_next_item);
  jQuery("#btnPrev").click(edit_prev_item);
  jQuery("#btnLast").click(edit_last_item);
}

function initControlStyle(form){
  jQuery("input",form).each(function(){
    var o = jQuery(this);
    var type = this.type.toLowerCase();
    o.addClass(type);
    if(type == "radio" || type == "checkbox"){
      o.parent().addClass("item");
    }
  })
}

function edit_last_item(){
  var forms = document.forms;
  var controller = '';
  for(var i=0,l=forms.length; i<l; i++){
    var f = forms[i];
    if(f.id.indexOf("new") != -1){
      /* /undefind_fees */
      var ar = f.action.split("/");
      controller = ar.pop();
    }
  }
  if(id && controller){
    jQuery.ajax({
      url: "/" + controller + "/last",
      type: "POST",
      success: function(data){
        if(data == "nodata"){
          alert("还没有一条记录!")  
        }else{
          $page.showEditView(data);
          initAjaxForm();
        }
      }
    })
  }else{
    alert("获取请求参数失败!");
  }
}

function get_item(type){
  var forms = document.forms;
  var id = 0; 
  var controller = '';
  for(var i=0,l=forms.length; i<l; i++){
    var f = forms[i];
    if(f.id.indexOf("edit") != -1){
      /* action="/undefind_fees/996332878" */
      var ar = f.action.split("/");
      id = ar.pop();
      controller = ar.pop();
    }
  }

  if(id && controller){
    jQuery.ajax({
      url: "/" + controller + "/" + type,
      data: {id: id},
      type: "POST",
      success: function(data){
        if(data == "nodata"){
          alert("已经是第一条或最末一条!")  
        }else{
          jQuery("#edit-view").html(data);
          initAjaxForm();
        }
      }
    })
  }else{
    alert("获取请求参数失败!");
  }

}

function edit_prev_item(){
  get_item("prev");
}

function edit_next_item(){
  get_item("next");
}
