class DataImportController < ApplicationController
  def index
  end

  def import
    if params[:excel_file].nil?
      return render :text => "未选择导入文件"
    end
    if params[:category].empty?
      return render :text => "必须选择文件数据类别"
    end    
    if params[:year].empty?
      return render :text => "年份不能为空"
    end
    if params[:month].empty?
      return render :text => "月份不能为空"
    end    
    
    begin
      success = DataImport.collet_excel_data(params[:excel_file],params[:category],params[:year],params[:month])
      if success
        case params[:category].to_i
        when 1 #财政在职工资
          return redirect_to :controller => 'temp5s', :action => 'index'
        when 2 #在职学院工资
          return redirect_to :controller => 'temp2s', :action => 'index'
        when 3 #离休人员工资
          return redirect_to :controller => 'temp1s', :action => 'index'
        when 4 #退休人员工资
          return redirect_to :controller => 'temp3s', :action => 'index'
        when 5 #退休人员学院工资
          return redirect_to :controller => 'temp4s', :action => 'index'
        end
      else
        render :text => "导入数据失败"
      end
    rescue => error
      render :text => error.to_s
    end
      
  end
end
