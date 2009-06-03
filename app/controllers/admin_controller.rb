class AdminController < ApplicationController
  #before_filter :authorize, :except => [:login,:try_to_login,:get_session_past_due_minutes,:index]
  def index
  end

  def login
    if session[:user_id]
      redirect_to :action => 'index'
    else
      render :layout => false
    end
  end

  def try_to_login
    if request.post?
      if check_captcha()
        if(user = User.login(params[:username],params[:password]))
            session[:user_id] = user.id
            session[:last_request_time] = Time.now
            redirect_to :action => 'index'
        else
          flash[:notice] = "Invalid user/password combination"
          redirect_to :action => 'login'
        end
      else
        flash[:notice] = 'Please input the image text correctly.'
        redirect_to :action => 'login'
      end
    end
  end

  def logout
    reset_session
    redirect_to  :action => 'login'
  end

  #获取session多少分钟后过期
  def get_session_past_due_minutes
    if(manage_session_overtime?)
      reset_session
      render :text => "0"
    else
      render :text => (session_timeout / 60 - ((Time.now - session[:last_request_time]) / 60).floor).to_s
    end
  end
end
