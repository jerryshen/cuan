class ProfileController < ApplicationController

  def self_salary
    #to do
  end

  def my_profile
  end

  def change_my_password
  end

  def try_to_change_password
    if @current_user
      if @current_user.change_password(params[:old_password],params[:new_password])
        flash[:notice] = "密码已经成功修改"
      else
        flash[:notice] = "请检查您的密码"
      end
    end
    render :action => 'change_my_password'
  end
end
