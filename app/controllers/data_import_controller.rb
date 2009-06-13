class DataImportController < ApplicationController
  def index
  end

  def import
    unless params[:excel_file].nil?
      unless params[:category].empty?
        begin
          data = DataImport.collet_excel_data(params[:excel_file],params[:category])
          unless data.nil?
            render :text => DataImport.print_data(data)
          else
            render :text => "导入数据失败"
          end
        rescue => error
          render :text => error.to_s
        end
      else
        render :text => "必须选择文件数据类别"
      end
    else
      render :text => "未选择导入文件"
    end
  end
end
