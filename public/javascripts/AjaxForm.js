function initAjaxForm(){
  var formWrap = $page.getCurrViewId();
  var form = jQuery('#' + formWrap + " form");
  initControlStyle(form);
  var suceess_submit_callback = function(data,status){
    try{
      var json = eval("(function(){return " + data + " })()"); 
    }catch(e){
      alert(e);
      return;
    }
    if(json.status && json.status == "success"){
      if(json.message)alert(json.message);
      $page.showListView("reloadData");
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
        success: suceess_submit_callback
      });
    }
  });
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
