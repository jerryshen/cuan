class PerformanceBenefitStdsController < ApplicationController
  # GET /performance_benefit_stds
  # GET /performance_benefit_stds.xml
  def index
    @performance_benefit_stds = PerformanceBenefitStd.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @performance_benefit_stds }
      format.json { render :text => get_json }
    end
  end

  # GET /performance_benefit_stds/1
  # GET /performance_benefit_stds/1.xml
  def show
    @performance_benefit_std = PerformanceBenefitStd.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @performance_benefit_std }
    end
  end

  # GET /performance_benefit_stds/new
  # GET /performance_benefit_stds/new.xml
  def new
    @performance_benefit_std = PerformanceBenefitStd.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @performance_benefit_std }
    end
  end

  # GET /performance_benefit_stds/1/edit
  def edit
    @performance_benefit_std = PerformanceBenefitStd.find(params[:id])
  end

  # POST /performance_benefit_stds
  # POST /performance_benefit_stds.xml
  def create
    @performance_benefit_std = PerformanceBenefitStd.new(params[:performance_benefit_std])

    respond_to do |format|
      if @performance_benefit_std.save
        format.html { redirect_to(@performance_benefit_std) }
        format.xml  { render :xml => @performance_benefit_std, :status => :created, :location => @performance_benefit_std }
        format.json { render :text => '{status: "success", message: "成功创建绩效津贴标准！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @performance_benefit_std.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@performance_benefit_std.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /performance_benefit_stds/1
  # PUT /performance_benefit_stds/1.xml
  def update
    @performance_benefit_std = PerformanceBenefitStd.find(params[:id])

    respond_to do |format|
      if @performance_benefit_std.update_attributes(params[:performance_benefit_std])
        format.html { redirect_to(@performance_benefit_std) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新绩效津贴标准！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @performance_benefit_std.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@performance_benefit_std.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /performance_benefit_stds/1
  # DELETE /performance_benefit_stds/1.xml
  def destroy
    @performance_benefit_std = PerformanceBenefitStd.find(params[:id])
    @performance_benefit_std.destroy

    respond_to do |format|
      format.html { redirect_to(performance_benefit_stds_url) }
      format.xml  { head :ok }
    end
  end

  private
  def get_json
    pagesize = 10
    if(params[:page_size])
      param_pagesize = params[:page_size].to_i
      if param_pagesize > 0 then pagesize = param_pagesize end
    end

    conditions = '1=1'
    condition_values = []
    if(!params[:search_name].blank?)
      if user = User.find_by_name(params[:search_name])
        user_id = user.id
      else
        user_id = 0
      end
      joins = ""
      conditions += " AND user_id = ?"
      condition_values << user_id
    end
    
    if(!params[:search_title_id].blank?)
      joins = "INNER JOIN users p ON performance_benefit_stds.user_id=p.id"
      conditions += " AND p.title_id = ? "
      condition_values << params[:search_title_id]
    end

    if(!params[:search_position_id].blank?)
      joins = "INNER JOIN users p ON performance_benefit_stds.user_id=p.id"
      conditions += " AND p.position_id = ? "
      condition_values << params[:search_position_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @performance_benefit_stds = PerformanceBenefitStd.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=>pagesize, :page => params[:page] || 1)
      count = PerformanceBenefitStd.count(:joins => joins, :conditions => option_conditions)
    else
      @performance_benefit_stds = PerformanceBenefitStd.paginate(:order =>"id DESC",:per_page=>pagesize, :page => params[:page] || 1)
      count = PerformanceBenefitStd.count
    end
    return render_json(@performance_benefit_stds,count)
  end
  
end
