class BasicSalaryRecordsController < ApplicationController
   protect_from_forgery :except => [:generate_salaries]

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @basic_salary_records }
      format.json { render :text => get_json }
      format.csv { export_csv(@basic_salary_records,
          { :id => "id", :user_id => "姓名", :year => "年度", :month => "月份",
            :station_sa => "岗位工资", :position_sa => "职务工资",:station_be => "岗位津贴",
            :foreign_be => "其他国家出台津补贴", :region_be => "地方出台津补贴",:hard_be => "艰苦边远",
            :stay_be => "公改保留补贴" }, "教职工基本工资记录数据.csv") }
    end
  end

  def show
    @basic_salary_record = BasicSalaryRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @basic_salary_record }
    end
  end

  def new
    @basic_salary_record = BasicSalaryRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @basic_salary_record }
    end
  end

  def edit
    @basic_salary_record = BasicSalaryRecord.find(params[:id])
  end

  def create
    @basic_salary_record = BasicSalaryRecord.new(params[:basic_salary_record])

    respond_to do |format|
      if @basic_salary_record.save
        format.html { redirect_to(@basic_salary_record) }
        format.xml  { render :xml => @basic_salary_record, :status => :created, :location => @basic_salary_record }
        format.json { render :text => '{status: "success", message: "成功创建基本工资！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @basic_salary_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@basic_salary_record.errors.full_messages.to_json}}"}
      end
    end
  end

  def update
    @basic_salary_record = BasicSalaryRecord.find(params[:id])

    respond_to do |format|
      if @basic_salary_record.update_attributes(params[:basic_salary_record])
        format.html { redirect_to(@basic_salary_record) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改基本工资！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @basic_salary_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@basic_salary_record.errors.full_messages.to_json}}"}
      end
    end
  end

  def destroy
    @basic_salary_record = BasicSalaryRecord.find(params[:id])
    @basic_salary_record.destroy

    respond_to do |format|
      format.html { redirect_to(basic_salary_records_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def confirm
    @basic_salary_record = BasicSalaryRecord.find(params[:id])
    if @basic_salary_record.update_attributes(:confirm => !@basic_salary_record.confirm)
      render :text =>"true"
    else
      render :text =>"false"
    end
  end

  def generate_salaries
    salary_stds = BasicSalary.all
    if salary_stds.blank?
      render :json => {:status => "fail",:msg => "无工资标准数据，操作失败！"}
    else
      salary_records = BasicSalaryRecord.all
      year_month = []
      salary_records.each do |d|
        year_month.push(d.year.to_s + "-" + d.month.to_s)
      end

      if year_month.uniq.include? Time.now.year.to_s + "-" + Time.now.month.to_i.to_s
        render :json => {:status => "fail", :msg=>"已存在当月工资数据！"}
      else
        begin
          count = BasicSalary.count
          BasicSalaryRecord.generate_basic_salaries(salary_stds)
          render :json => {:status => "success", :msg=>"成功生成#{count}个员工的基本工资！"}
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
    if(!params[:search_name].blank?)
      users = User.find(:all, :conditions => ["name like ?", "%#{params[:search_name]}%"])
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

    if(!params[:search_year].blank?)
      joins = ""
      conditions += " AND year = ?"
      condition_values << params[:search_year]
    end

    if(!params[:search_month].blank?)
      joins = ""
      conditions += " AND month = ?"
      condition_values << params[:search_month]
    end

    if(!params[:search_confirm].blank?)
      value=(params[:search_confirm].to_i ==0? false : true)
      conditions += " AND confirm = ? "
      condition_values << value
    end

    if(!params[:search_department_id].blank?)
      joins = "INNER JOIN users p ON basic_salary_records.user_id=p.id"
      conditions += " AND p.department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @basic_salary_records = BasicSalaryRecord.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = BasicSalaryRecord.count(:joins => joins, :conditions => option_conditions)
    else
      @basic_salary_records = BasicSalaryRecord.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = BasicSalaryRecord.count
    end
    return render_json(@basic_salary_records,count)
  end
end
