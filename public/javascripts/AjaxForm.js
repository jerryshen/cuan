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
