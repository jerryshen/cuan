class BasicSalariesController < ApplicationController
  # GET /basic_salaries
  # GET /basic_salaries.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @basic_salaries }
      format.json { render :text => get_json }
      format.csv { export_csv(@basic_salaries,
          { :id => "id", :user_id => "姓名", :station_sa => "岗位工资", :position_sa => "职务工资",
            :station_be => "岗位津贴", :foreign_be => "其他国家出台津补贴", :region_be => "地方出台津补贴",
            :hard_be => "艰苦边远", :stay_be => "公改保留补贴" }, "教职工基本工资数据.csv") }
    end
  end

  # GET /basic_salaries/1
  # GET /basic_salaries/1.xml
  def show
    @basic_salary = BasicSalary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @basic_salary }
    end
  end

  # GET /basic_salaries/new
  # GET /basic_salaries/new.xml
  def new
    @basic_salary = BasicSalary.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @basic_salary }
    end
  end

  # GET /basic_salaries/1/edit
  def edit
    @basic_salary = BasicSalary.find(params[:id])
  end

  # POST /basic_salaries
  # POST /basic_salaries.xml
  def create
    @basic_salary = BasicSalary.new(params[:basic_salary])

    respond_to do |format|
      if @basic_salary.save
        format.html { redirect_to(@basic_salary) }
        format.xml  { render :xml => @basic_salary, :status => :created, :location => @basic_salary }
        format.json { render :text => '{status: "success", message: "成功创建基本工资！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @basic_salary.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@basic_salary.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /basic_salaries/1
  # PUT /basic_salaries/1.xml
  def update
    @basic_salary = BasicSalary.find(params[:id])

    respond_to do |format|
      if @basic_salary.update_attributes(params[:basic_salary])
        format.html { redirect_to(@basic_salary) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改基本工资！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @basic_salary.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@basic_salary.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /basic_salaries/1
  # DELETE /basic_salaries/1.xml
  def destroy
    @basic_salary = BasicSalary.find(params[:id])
    @basic_salary.destroy

    respond_to do |format|
      format.html { redirect_to(basic_salaries_url) }
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
      joins = "INNER JOIN users p ON basic_salaries.user_id=p.id"
      conditions += " AND p.department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @basic_salaries = BasicSalary.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = BasicSalary.count(:joins => joins, :conditions => option_conditions)
    else
      @basic_salaries = BasicSalary.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = BasicSalary.count
    end
    return render_json(@basic_salaries,count)
  end
end
