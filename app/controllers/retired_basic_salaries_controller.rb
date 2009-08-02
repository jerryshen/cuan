class RetiredBasicSalariesController < ApplicationController
  # GET /retired_basic_salaries
  # GET /retired_basic_salaries.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @retired_basic_salaries }
      format.json { render :text => get_json }
      format.csv { export_csv(@retired_basic_salaries,
          { :id => "id", :user_id => "姓名", :basic_fee => "月基本退休费", :stay_be => "工改保留补贴_93年",
            :foreign_be => "其他国家出台津补贴", :region_be => "地方出台津补贴" }, "离退休人员基本工资数据.csv") }
    end
  end

  # GET /retired_basic_salaries/1
  # GET /retired_basic_salaries/1.xml
  def show
    @retired_basic_salary = RetiredBasicSalary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @retired_basic_salary }
    end
  end

  # GET /retired_basic_salaries/new
  # GET /retired_basic_salaries/new.xml
  def new
    @retired_basic_salary = RetiredBasicSalary.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @retired_basic_salary }
    end
  end

  # GET /retired_basic_salaries/1/edit
  def edit
    @retired_basic_salary = RetiredBasicSalary.find(params[:id])
  end

  # POST /retired_basic_salaries
  # POST /retired_basic_salaries.xml
  def create
    @retired_basic_salary = RetiredBasicSalary.new(params[:retired_basic_salary])

    respond_to do |format|
      if @retired_basic_salary.save
        format.html { redirect_to(@retired_basic_salary) }
        format.xml  { render :xml => @retired_basic_salary, :status => :created, :location => @retired_basic_salary }
        format.json { render :text => '{status: "success",message: "成功添加离退休人员基本工资！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @retired_basic_salary.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@retired_basic_salary.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /retired_basic_salaries/1
  # PUT /retired_basic_salaries/1.xml
  def update
    @retired_basic_salary = RetiredBasicSalary.find(params[:id])

    respond_to do |format|
      if @retired_basic_salary.update_attributes(params[:retired_basic_salary])
        format.html { redirect_to(@retired_basic_salary) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success",message: "成功修改离退休人员基本工资！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @retired_basic_salary.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@retired_basic_salary.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /retired_basic_salaries/1
  # DELETE /retired_basic_salaries/1.xml
  def destroy
    @retired_basic_salary = RetiredBasicSalary.find(params[:id])
    @retired_basic_salary.destroy

    respond_to do |format|
      format.html { redirect_to(retired_basic_salaries_url) }
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
      users = User.find(:all, :conditions => ["name like ? AND is_retired = ?", "%#{params[:search_name]}%", true])
      unless users.blank?
        ids = []
        users.each do |u|
          ids.push(u.id)
        end
      else
        ids = []
      end
      idss = ids.join(",")
      conditions += " AND user_id in (#{idss})"
      condition_values << []
    end

    if(!params[:search_department_id].blank?)
      joins = "INNER JOIN users p ON retired_basic_salaries.user_id=p.id"
      conditions += " AND p.department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @retired_basic_salaries = RetiredBasicSalary.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = RetiredBasicSalary.count(:joins => joins, :conditions => option_conditions)
    else
      @retired_basic_salaries = RetiredBasicSalary.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = RetiredBasicSalary.count
    end
    return render_json(@retired_basic_salaries,count)
  end

end
