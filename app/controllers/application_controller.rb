# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def session_timeout
    return  30 * 60  #30 minutes
  end

  def session_overtime?
    if(session[:last_request_time])
    return (Time.now - session[:last_request_time]) > session_timeout()
    else
        return false
    end
  end

  def authorize
    if !session_overtime? && session[:user_id]
        session[:last_request_time] = Time.now
    else
      reset_session
      redirect_to :controller => "admin",:action => "login"
    end
  end

  protected

  #get json data
  def render_json records,total
    json_texts = []
    records.to_a.each{ |cat| json_texts << cat.attributes.to_json }
    return "{'count':#{total},'rows':[#{json_texts.join(",")}]}"
  end
end
