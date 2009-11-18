class AssistantBenefitStandardsController < ApplicationController

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assistant_benefit_standards }
      format.json { render :text => get_json }
    end
  end

  def show
    @assistant_benefit_standard = AssistantBenefitStandard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @assistant_benefit_standard }
    end
  end

  def new
    @assistant_benefit_standard = AssistantBenefitStandard.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @assistant_benefit_standard }
    end
  end

  def edit
    @assistant_benefit_standard = AssistantBenefitStandard.find(params[:id])
  end

  def create
    @assistant_benefit_standard = AssistantBenefitStandard.new(params[:assistant_benefit_standard])

    respond_to do |format|
      if @assistant_benefit_standard.save
        format.html { redirect_to(@assistant_benefit_standard) }
        format.xml  { render :xml => @assistant_benefit_standard, :status => :created, :location => @assistant_benefit_standard }
        format.json { render :text => '{status: "success", message: "成功添加辅导员津贴标准！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @assistant_benefit_standard.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@assistant_benefit_standard.errors.full_messages.to_json}}"}
      end
    end
  end

  def update
    @assistant_benefit_standard = AssistantBenefitStandard.find(params[:id])

    respond_to do |format|
      if @assistant_benefit_standard.update_attributes(params[:assistant_benefit_standard])
        format.html { redirect_to(@assistant_benefit_standard) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改辅导员津贴标准！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @assistant_benefit_standard.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@assistant_benefit_standard.errors.full_messages.to_json}}"}
      end
    end
  end

  def destroy
    @assistant_benefit_standard = AssistantBenefitStandard.find(params[:id])
    @assistant_benefit_standard.destroy

    respond_to do |format|
      format.html { redirect_to(assistant_benefit_standards_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
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

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @assistant_benefit_standards = AssistantBenefitStandard.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=>@pagesize, :page => params[:page] || 1)
      count = AssistantBenefitStandard.count(:joins => joins, :conditions => option_conditions)
    else
      @assistant_benefit_standards = AssistantBenefitStandard.paginate(:order =>"id DESC",:per_page=>@pagesize, :page => params[:page] || 1)
      count = AssistantBenefitStandard.count
    end
    return render_json(@assistant_benefit_standards,count)
  end


end
