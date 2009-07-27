class AssistantBenefitSetsController < ApplicationController
  # GET /assistant_benefit_sets
  # GET /assistant_benefit_sets.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assistant_benefit_sets }
      format.json { render :text => get_json }
    end
  end

  # GET /assistant_benefit_sets/1
  # GET /assistant_benefit_sets/1.xml
  def show
    @assistant_benefit_set = AssistantBenefit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @assistant_benefit_set }
    end
  end

  # GET /assistant_benefit_sets/new
  # GET /assistant_benefit_sets/new.xml
  def new
    @assistant_benefit_set = AssistantBenefit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @assistant_benefit_set }
    end
  end

  # GET /assistant_benefit_sets/1/edit
  def edit
    @assistant_benefit_set = AssistantBenefit.find(params[:id])
  end

  # POST /assistant_benefit_sets
  # POST /assistant_benefit_sets.xml
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

  # PUT /assistant_benefit_sets/1
  # PUT /assistant_benefit_sets/1.xml
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

  # DELETE /assistant_benefit_sets/1
  # DELETE /assistant_benefit_sets/1.xml
  def destroy
    @assistant_benefit_set = AssistantBenefit.find(params[:id])
    @assistant_benefit_set.destroy

    respond_to do |format|
      format.html { redirect_to(assistant_benefit_sets_url) }
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
