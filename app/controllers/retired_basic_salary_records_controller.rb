class RetiredBasicSalaryRecordsController < ApplicationController
protect_from_forgery :except => [:generate_retired_salaries]

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @retired_basic_salary_records }
      format.json { render :text => get_json }
      format.csv { export_csv(@retired_basic_salary_records,
          { :id => "id", :user_id => "姓名", :year => "年度", :month => "月份", :basic_fee => "月基本退休费", :stay_be => "工改保留补贴_93年",
            :foreign_be => "其他国家出台津补贴", :region_be => "地方出台津补贴" }, "离退休人员基本工资记录数据.csv") }
    end
  end

  # GET /retired_basic_salary_records/1
  # GET /retired_basic_salary_records/1.xml
  def show
    @retired_basic_salary_record = RetiredBasicSalaryRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @retired_basic_salary_record }
    end
  end

  # GET /retired_basic_salary_records/new
  # GET /retired_basic_salary_records/new.xml
  def new
    @retired_basic_salary_record = RetiredBasicSalaryRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @retired_basic_salary_record }
    end
  end

  # GET /retired_basic_salary_records/1/edit
  def edit
    @retired_basic_salary_record = RetiredBasicSalaryRecord.find(params[:id])
  end

  # POST /retired_basic_salary_records
  # POST /retired_basic_salary_records.xml
  def create
    @retired_basic_salary_record = RetiredBasicSalaryRecord.new(params[:retired_basic_salary_record])

    respond_to do |format|
      if @retired_basic_salary_record.save
        format.html { redirect_to(@retired_basic_salary_record) }
        format.xml  { render :xml => @retired_basic_salary_record, :status => :created, :location => @retired_basic_salary_record }
        format.json { render :text => '{status: "success",message: "成功添加离退休人员基本工资记录！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @retired_basic_salary_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@retired_basic_salary_record.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /retired_basic_salary_records/1
  # PUT /retired_basic_salary_records/1.xml
  def update
    @retired_basic_salary_record = RetiredBasicSalaryRecord.find(params[:id])

    respond_to do |format|
      if @retired_basic_salary_record.update_attributes(params[:retired_basic_salary_record])
        format.html { redirect_to(@retired_basic_salary_record) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success",message: "成功修改离退休人员基本工资记录！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @retired_basic_salary_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@retired_basic_salary_record.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /retired_basic_salary_records/1
  # DELETE /retired_basic_salary_records/1.xml
  def destroy
    @retired_basic_salary_record = RetiredBasicSalaryRecord.find(params[:id])
    @retired_basic_salary_record.destroy

    respond_to do |format|
      format.html { redirect_to(retired_basic_salary_records_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def confirm
    @retired_basic_salary_record = RetiredBasicSalaryRecord.find(params[:id])
    if @retired_basic_salary_record.update_attributes(:confirm => !@retired_basic_salary_record.confirm)
      render :text =>"true"
    else
      render :text =>"false"
    end
  end

  def generate_reitred_salaries
    salary_stds = RetiredBasicSalary.all
    if salary_stds.blank?
      render :json => {:status => "fail",:msg => "无工资标准数据，操作失败！"}
    else
      salary_records = RetiredBasicSalaryRecord.all
      year_month = []
      salary_records.each do |d|
        year_month.push(d.year.to_s + "-" + d.month.to_s)
      end

      if year_month.uniq.include? Time.now.year.to_s + "-" + Time.now.month.to_i.to_s
        render :json => {:status => "fail", :msg=>"已存在当月工资数据！"}
      else
        begin
          count = RetiredBasicSalary.count
          RetiredBasicSalaryRecord.generate_retired_salaries(salary_stds)
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
      joins = "INNER JOIN users p ON retired_basic_salary_records.user_id=p.id"
      conditions += " AND p.department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @retired_basic_salary_records = RetiredBasicSalaryRecord.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = RetiredBasicSalaryRecord.count(:joins => joins, :conditions => option_conditions)
    else
      @retired_basic_salary_records = RetiredBasicSalaryRecord.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = RetiredBasicSalaryRecord.count
    end
    return render_json(@retired_basic_salary_records,count)
  end
end
