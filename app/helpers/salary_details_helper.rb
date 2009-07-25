module SalaryDetailsHelper

  #list inc users for index search
  def select_inc_user
    options = Department.all.reject{|x| x.name == "离退休"}.collect{|x| "<option value='#{x.id}' >#{x.name}</option>"}.join('')
    html = %q{
        <label for="select_department_id">部门</label>
        <select id="select_department_id" name="search_department">
          <option value='' >选择部门...</option>
          <options>
        </select>
        <label for="select_user_id">教职工</label>
        <select id="select_user_id" disabled="disabled" name="search_user">
          <option value='' >选择教职工...</option>
          <user_options>
        </select>
    <label for="search_year_month">年月:</label>
    <select style="margin: 0px; padding: 0px; float: none;" name="search_year" id="search_year">
      <option value="" selected="selected">年度</option>
      <option value="2009">2009</option>
      <option value="2010">2010</option>
      <option value="2011">2011</option>
      <option value="2012">2012</option>
    </select>
    <select style="margin: 0px; padding: 0px; float: none;" name="search_month" id="search_month">
      <option value="" selected="selected">月份</option>
      <option value="1">1</option>
      <option value="2">2</option>
      <option value="3">3</option>
      <option value="4">4</option>
      <option value="5">5</option>
      <option value="6">6</option>
      <option value="7">7</option>
      <option value="8">8</option>
      <option value="9">9</option>
      <option value="10">10</option>
      <option value="11">11</option>
      <option value="12">12</option>
    </select>
      <script>
        jQuery("#select_department_id").bind("change",function(){
          var v = this.value;
          var select = document.getElementById("select_user_id");
          select.disabled = true;
          jQuery(select).empty();
          var option = document.createElement("option");
          option.setAttribute("value",'');
          option.text = "选择教职工...";
          select.options.add(option);
          if(v){
            jQuery.ajax({
              url: "/departments/users_to_json",
              data: {id: v},
              type: "POST",
              success: function(data){
                var users = Ext.util.JSON.decode(data);
                for(var i=0, l=users.length; i<l; i++){
                  var option = document.createElement("option");
                  var u = users[i];
                  option.setAttribute("value",u.id);
                  option.text = u.name;
                  select.options.add(option);
                }
                select.disabled = false;
              }
            })
          }else{
            select.disabled = true;
          }
        });
      </script>
    }
    html.sub!("<options>",options)
  end
end
