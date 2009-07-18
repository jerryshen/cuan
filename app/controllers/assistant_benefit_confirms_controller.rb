class AssistantBenefitConfirmsController < ApplicationController
  # GET /assistant_benefit_confirms
  # GET /assistant_benefit_confirms.xml
  def index
    @assistant_benefit_confirms = AssistantBenefit.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assistant_benefit_confirms }
      format.json { render :text => get_json }
    end
  end

  # GET /assistant_benefit_confirms/1
  # GET /assistant_benefit_confirms/1.xml
  def show
    @assistant_benefit_confirm = AssistantBenefit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @assistant_benefit_confirm }
    end
  end

  # GET /assistant_benefit_confirms/1/edit
  def edit
    @assistant_benefit_confirm = AssistantBenefit.find(params[:id])
  end

  # PUT /assistant_benefit_confirms/1
  # PUT /assistant_benefit_confirms/1.xml
  def update
    @assistant_benefit_confirm = AssistantBenefit.find(params[:id])

    respond_to do |format|
      if @assistant_benefit_confirm.update_attributes(params[:assistant_benefit_confirm])
        format.html { redirect_to(@assistant_benefit_confirm) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功设置辅导员津贴"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @assistant_benefit_confirm.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@assistant_benefit_confirm.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /assistant_benefit_confirms/1
  # DELETE /assistant_benefit_confirms/1.xml
  def destroy
    @assistant_benefit_confirm = AssistantBenefit.find(params[:id])
    @assistant_benefit_confirm.destroy

    respond_to do |format|
      format.html { redirect_to(assistant_benefit_confirms_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

    def verify
    @assistant_benefit_confirm = AssistantBenefit.find(params[:id])
    if @assistant_benefit_confirm.verify
      render :text =>"true"
    else
      render :text =>"false"
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
      @assistant_benefit_confirms = AssistantBenefit.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=>@pagesize, :page => params[:page] || 1)
      count = AssistantBenefit.count(:joins => joins, :conditions => option_conditions)
    else
      @assistant_benefit_confirms = AssistantBenefit.paginate(:order =>"id DESC",:per_page=>@pagesize, :page => params[:page] || 1)
      count = AssistantBenefit.count
    end
    return render_json(@assistant_benefit_confirms,count)
  end
end
