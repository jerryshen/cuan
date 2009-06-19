class DataBackupController < ApplicationController
  #备份页面
  def backup
    respond_to do |format|
      format.html
    end
  end

  #备份
  def do_backup
    flash[:notice] = DataBackup.backup
    respond_to do |format|
      format.html{ redirect_to :action => "backup"}
    end
  end

  #可恢复备份列表页面
  def restore
    @list = []
    begin
      files = DataBackup.list_backup_files
      unless files.blank?
        @list = files.split("\n")
        @list.each_index do |i|
          @list[i].gsub!(/.*\//,'')
        end
      end
    rescue => error
      flash[:error] = error.to_s
    end
    respond_to do |format|
      format.html
    end
  end

  #恢复
  def do_restore
    target = params[:restore_file]
    flash[:notice] = DataBackup.restore(target)
    respond_to do |format|
        format.html { redirect_to  :action => "restore" }
    end
  end

  #获取备份间隔时间设置(小时为单位)
  def interval
    render :text => AppConfig.get("database_backup_interval")
  end
end
