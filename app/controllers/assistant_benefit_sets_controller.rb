class AssistantBenefitSetsController < ApplicationController
  protect_from_forgery :except => [:generate_assistant_benefits]

  def index
    respond_to do |format|
      format.html
      format.xml  { render :xml => @assistant_benefit_sets }
      format.json { render :text => get_json }
    end
  end

  def show
    @assistant_benefit_set = AssistantBenefit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @assistant_benefit_set }
    end
  end


  def new
    @assistant_benefit_set = AssistantBenefit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @assistant_benefit_set }
    end
  end

  def edit
    @assistant_benefit_set = AssistantBenefit.find(params[:id])
  end


  def create
    @assistant_benefit_set = AssistantBenefit.new(params[:assistant_benefit_set])

    respond_to do |format|
      if @assistant_benefit_set.save
        format.html { redirect_to(@assistant_benefit_set) }
        format.xml  { render :xml => @assistant_benefit_set, :status => :created, :location => @assistant_benefit_set }
        format.json { render :text => '{status: "success", message: "成功设置辅导员津贴"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @assistant_benefit_set.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@assistant_benefit_set.errors.full_messages.to_json}}"}
      end
    end
  end

  def update
    @assistant_benefit_set = AssistantBenefit.find(params[:id])

    respond_to do |format|
      if @assistant_benefit_set.update_attributes(params[:assistant_benefit_set])
        format.html { redirect_to(@assistant_benefit_set) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功设置辅导员津贴"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @assistant_benefit_set.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@assistant_benefit_set.errors.full_messages.to_json}}"}
      end
    end
  end

  def destroy
    @assistant_benefit_set = AssistantBenefit.find(params[:id])
    @assistant_benefit_set.destroy

    respond_to do |format|
      format.html { redirect_to(assistant_benefit_sets_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def generate_assistant_benefits
    assistant_benefit_stds = AssistantBenefitStandard.all
    if assistant_benefit_stds.blank?
      render :json => {:status => "fail",:msg => "无辅导员津贴标准数据，操作失败！"}
    else
      assistant_benefit_records = AssistantBenefit.all
      year_month = []
      unless assistant_benefit_records.blank?
        assistant_benefit_records.each do |d|
          year_month.push(d.year.to_s + "-" + d.month.to_s)
        end
      
        if year_month.uniq.include? Time.now.year.to_s + "-" + Time.now.month.to_i.to_s
          render :json => {:status => "fail", :msg=>"已存在当月辅导员津贴数据！"}
        else
          begin
            count = AssistantBenefitStandard.count
            AssistantBenefitStandard.generate_assistant_benefit(assistant_benefit_stds)
            render :json => {:status => "success", :msg=>"成功生成#{count}个辅导员的基本津贴！"}
          rescue
            render :json => {:status => "fail",:msg => "操作失败"}
          end
        end
      else
        begin
          count = AssistantBenefitStandard.count
          AssistantBenefitStandard.generate_assistant_benefit(assistant_benefit_stds)
          render :json => {:status => "success", :msg=>"成功生成#{count}个辅导员的基本津贴！"}
        rescue
          render :json => {:status => "fail",:msg => "操作失败"}
        end

      end
    end
  end

  private
  def get_json
    load_page_data

    conditions = '1=1'
    condition_values = []
    joins = "INNER JOIN assistants aa INNER JOIN users bb ON assistant_benefits.assistant_id = aa.id and aa.user_id = bb.id"
    if(!params[:search_name].blank?)
      if user = User.find_by_name(params[:search_name])
        assistant_id = Assistant.find_by_user_id(user.id).id
      else
        assistant_id = 0
      end
      conditions += " AND assistant_benefits.assistant_id = ?"
      condition_values << assistant_id
    end

    if(!params[:search_department_id].blank?)
      conditions += " AND bb.department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(!params[:search_verify].blank?)
      value=(params[:search_verify].to_i == 0? false : true)
      conditions += " AND assistant_benefits.is_verified = ?"
      condition_values << value
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @assistant_benefit_sets = AssistantBenefit.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=>@pagesize, :page => params[:page] || 1)
      count = AssistantBenefit.count(:joins => joins, :conditions => option_conditions)
    else
      @assistant_benefit_sets = AssistantBenefit.paginate(:order =>"id DESC",:per_page=>@pagesize, :page => params[:page] || 1)
      count = AssistantBenefit.count
    end
    return render_json(@assistant_benefit_sets,count)
  end
end
