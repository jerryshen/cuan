module CoDetailsHelper

  #get counting title
  def content_title(year, month, department_id)
    department_name = department_id.blank? ? "全校" : Department.find(department_id).name
    content_title = year.to_s + "年度" + month.to_s + "月份" + department_name.to_s + "收入统计信息"
    return content_title
  end

  def check_user_for_salary
    unless @selected_user.is_retired
      render :partial => 'share/salary_entries'
    else
      render :partial => 'share/retired_salary_entries'
    end
  else
  end

  def check_user_for_benefit
    unless @selected_user.is_retired
      render :partial => 'share/benefit_entries'
    else
      render :partial => 'share/retired_benefit_entries'
    end
  else
  end

  def check_user_for_fee_cutting
    unless @selected_user.is_retired
      render :partial => 'share/fee_cutting_entries'
    else
      render :partial => 'share/retired_fee_cutting_entries'
    end
  else
  end

  def view_user_detail(on,name)
    options = Department.all.collect{|x| "<option value='#{x.id}' >#{x.name}</option>"}.join('')
    html = %q{
      <p>
        <label for="select_department_id">部门</label>
        <select id="select_department_id" class="required">
          <option value='' >选择部门...</option>
          <options>
        </select>
      </p>
      <p>
        <label for="select_user_id">教职工</label>
        <select id="select_user_id" disabled="disabled" name="<name>" class="required">
          <option value='' >选择教职工...</option>
          <user_options>
        </select>
      </p>
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
              data: {id: v, on:'<on>'},
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
    html.sub!("<options>",options).sub!("<name>",name).sub!("<on>",on)
  end
end
