class BackupIntervalController < ActionController::Base
  def index
    render :text => AppConfig.get("database_backup_interval")
  end
end
