# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  attr_accessor :current_user
  except_actions = [:logout,:login,:try_to_login,:interval]
  before_filter :get_current_user , :except => except_actions
  before_filter :authorize_session, :except => except_actions
  before_filter :authorize_permission, :except => except_actions
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  #find user by session[:user_id]
  def get_current_user
    unless session[:user_id]
      @current_user = nil
      return
    end
    @current_user = User.first(:conditions => {:id => session[:user_id] })
  end

  def is_admin?
    name = "超级管理员"
    return true if @current_user.roles.find_by_name(name)
  end

  def session_timeout
    return  120 * 60  #30 minutes
  end

  def session_overtime?
    if(session[:last_request_time])
      return (Time.now - session[:last_request_time]) > session_timeout()
    else
      return false
    end
  end

  def authorize_session
    if !session_overtime? && session[:user_id]
      session[:last_request_time] = Time.now
    else
      reset_session
      redirect_to :controller => "admin",:action => "login"
    end
  end

  def authorize_permission
    unless Page.accessable?(request.url,@current_user)
      render :text => "警告，你没有权限访问该页面！"
    end
  end

  protected
  #get json data
  def render_json(records,total)
    json_texts = []
    records.to_a.each{ |cat| json_texts << cat.attributes.to_json }
    return "{'count':#{total},'rows':[#{json_texts.join(",")}]}"
  end

  #hash to json
  def hash_to_json(records,total)
    json_texts = []
    records.to_a.each{ |cat| json_texts << cat.to_json }
    return "{'count':#{total},'rows':[#{json_texts.join(",")}]}"
  end

  def load_page_data
    @pagesize = 10
    if(params[:page_size])
      param_pagesize = params[:page_size].to_i
      if param_pagesize > 0 then @pagesize = param_pagesize end
    end
  end

  def export_csv(data,fields,filename="data.csv")
    require 'faster_csv'
    require 'iconv'
    content_type = if request.user_agent =~ /windows/i
      'application/vnd.ms-excel'
    else
      'text/csv'
    end
    csv_string = FasterCSV.generate do |csv| 
      header = []
      fields.each_key { |key| header << Iconv.iconv("GB2312//IGNORE","UTF-8//IGNORE", fields[key]) } 
      csv << header.reverse

      data.each do |row|
        csv_row = []
        fields.each_key do |key|
          v = row[key]
          if v.class == String
            v = Iconv.iconv("GB2312//IGNORE","UTF-8//IGNORE", v)
          end
          csv_row << v
        end
        csv << csv_row.reverse
      end
    end
    send_data csv_string, :type => content_type, :filename => filename, :disposition => 'attachment'
  end

end
