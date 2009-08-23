class UpdateAccountController < ApplicationController
  def index
  end

  def update
	unless params[:login_id].blank?
		if @current_user.update_attribute(:login_id, params[:login_id])
			flash[:msg] = "更新成功"
		else
			flash[:msg] = "更新失败"
		end
		render :index
	end
  end

end
