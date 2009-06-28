class CoDetailsController < ApplicationController
  def index
    @departments = Department.all.collect { |d| [d.name, d.id] }
  end

  def select_with_ajax
    conditions = ["department_id = ?", params[:department_id]]
    @users = User.find(:all, :conditions => conditions).collect { |u| [u.name, u.id] }
  end

  def ajax_total_list
    year = params[:date_year]
    month = params[:date_month]
    user_id = params[:user_id]
    department_id = params[:department_id]

    unless user_id.blank?
      @selected_user = User.find(user_id)
    else
      @selected_user = User.find(:first, :conditions => ["department_id =?", department_id])
    end

    conditions = CoDetail.get_conditions(@selected_user.id, year, month)
    unless @selected_user.is_retired
      @basic_salaries = BasicSalaryRecord.find(:all,:order => "id DESC", :conditions => conditions)
      @college_benefits = CollegeBeRecord.find(:all, :order => "id DESC", :conditions => conditions)
      @fee_cuttings = FeeCuttingRecord.find(:all, :order => "id DESC", :conditions => conditions)
    else
      @basic_salaries = RetiredBasicSalaryRecord.find(:all, :order => "id DESC", :conditions => conditions)
      @college_benefits = RetiredCollegeBeRecord.find(:all, :order => "id DESC", :conditions => conditions)
      @fee_cuttings = RetiredFeeCuttingRecord.find(:all, :order => "id DESC", :conditions => conditions)
    end
  end

  def total_counting
    @departments = Department.all.collect { |d| [d.name, d.id] }
  end

  def get_total_counting
    if request.post?
      @department_id = params[:department][:id]
      @year = params[:date][:year]
      @month = params[:date][:month]

      @inc_total = CoDetail.get_counting(@year, @month, @department_id, "")
      @ret_total = CoDetail.get_retired_counting(@year, @month, @department_id, "")

      @inc_num = @inc_total[0].to_i
      @inc_fee = @inc_total[1].to_f
      @inc_avg = @inc_total[2].to_f
      @inc_top = @inc_total[3]
      @inc_bot = @inc_total[4]

      if @ret_total.blank?
        @nums = @inc_num
        @fee = @inc_fee
        @avg = @inc_avg
        @top = @inc_top
        @bot = @inc_bot
      else
        @ret_num = @ret_total[0].to_i
        @ret_fee = @ret_total[1].to_f
        @ret_avg = @ret_total[2].to_f
        @ret_top = @ret_total[3]
        @ret_bot = @ret_total[4]

        @nums = @inc_num + @ret_num
        @fee = @inc_fee + @ret_fee
        @avg = ((@inc_avg + @ret_avg) / 2).round(2)
        @top = @inc_top.counting > @ret_top.counting ? @inc_top : @ret_top
        @bot = @inc_bot.counting < @ret_bot.counting ? @inc_bot : @ret_bot
      end
    end
  end
end
