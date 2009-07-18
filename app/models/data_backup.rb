require 'net/ssh'
class DataBackup
  def self.remote_sh(command)
    domain  = AppConfig.get("database_server_domain")
    username = AppConfig.get("database_server_username")
    pwd = AppConfig.get("database_server_pwd")
    output = ''
    Net::SSH.start(domain,username,:password => pwd) do |session|
      output = session.exec!(command)
    end
    return output
  end

  def self.backup
    backup_cmd = AppConfig.get("database_backup_command")
    return remote_sh(backup_cmd)
  end

  def self.restore(file_name)
    backup #恢复前先备份当前档
    restore_cmd = AppConfig.get("database_restore_command") + " " + file_name
    return remote_sh(restore_cmd)
  end

  def self.list_backup_files
    list_cmd = AppConfig.get("database_list_backups")
    return remote_sh(list_cmd)
  end
end
