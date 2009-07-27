class CollegeBenefitsController < ApplicationController
  #  protect_from_forgery :except => :index
  #  skip_before_filter :verify_authenticity_token
  # GET /college_benefits
  # GET /college_benefits.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @college_benefits }
      format.json { render :text => get_json }
      format.csv { export_csv(@college_benefits,
          { :id => "id", :user_id => "姓名",
            :life_be => "生活补贴", :diff_be => "补贴补差", :livesa_be => "活工资补贴",
            :tv_be => "电视补贴", :beaulty_be  => "驻蓉补贴", :other_be => "其他" }, "学院补贴数据.csv") }
    end
  end

  # GET /college_benefits/1
  # GET /college_benefits/1.xml
  def show
    @college_benefit = CollegeBenefit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @college_benefit }
    end
  end

  # GET /college_benefits/new
  # GET /college_benefits/new.xml
  def new
    @college_benefit = CollegeBenefit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @college_benefit }
    end
  end

  # GET /college_benefits/1/edit
  def edit
    @college_benefit = CollegeBenefit.find(params[:id])
  end

  # POST /college_benefits
  # POST /college_benefits.xml
  def create
    @college_benefit = CollegeBenefit.new(params[:college_benefit])

    respond_to do |format|
      if @college_benefit.save
        format.html { redirect_to(@college_benefit) }
        format.xml  { render :xml => @college_benefit, :status => :created, :location => @college_benefit }
        format.json { render :text => '{status: "success", message: "成功创建学院补贴！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @college_benefit.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@college_benefit.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /college_benefits/1
  # PUT /college_benefits/1.xml
  def update
    @college_benefit = CollegeBenefit.find(params[:id])

    respond_to do |format|
      if @college_benefit.update_attributes(params[:college_benefit])
        format.html { redirect_to(@college_benefit) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新学院补贴！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @college_benefit.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@college_benefit.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /college_benefits/1
  # DELETE /college_benefits/1.xml
  def destroy
    @college_benefit = CollegeBenefit.find(params[:id])
    @college_benefit.destroy

    respond_to do |format|
      format.html { redirect_to(college_benefits_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  private
  def get_json
    load_page_data

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

    if(!params[:search_department_id].blank?)
      joins = "INNER JOIN users p ON college_benefits.user_id=p.id"
      conditions += " AND p.department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @college_benefits = CollegeBenefit.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = CollegeBenefit.count(:joins => joins, :conditions => option_conditions)
    else
      @college_benefits = CollegeBenefit.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = CollegeBenefit.count
    end
    return render_json(@college_benefits,count)
  end
end
