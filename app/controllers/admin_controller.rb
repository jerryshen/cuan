class AdminController < ApplicationController
  protect_from_forgery :only => :index
  def index
  end

  def login
    if session[:user_id]
      redirect_to :action => 'index'
    end
  end

  #  def check_captcha
  #    if !Captcha.is_valid(params[:captcha_key].upcase, params[:captcha_digest])
  #      return false
  #    end
  #    return true
  #  end

  def try_to_login
    if request.post?
      if(user = User.login(params[:login_id],params[:password]))
        session[:user_id] = user.id
        @current_user = user
        session[:last_request_time] = Time.now
        redirect_to :action => 'index'
      else
        flash.now[:notice] = "用户名／密码不匹配!"
        render :action => 'login'
      end
    end
  end

  def logout
    reset_session
    redirect_to  :action => 'login'
  end

  #获取session多少分钟后过期
  def get_session_past_due_minutes
    if(session_overtime?)
      reset_session
      render :text => "0"
    else
      render :text => (session_timeout / 60 - ((Time.now - session[:last_request_time]) / 60).floor).to_s
    end
  end
end
