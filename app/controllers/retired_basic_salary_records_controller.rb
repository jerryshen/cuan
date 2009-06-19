class RetiredBasicSalaryRecordsController < ApplicationController
  # GET /retired_basic_salary_records
  # GET /retired_basic_salary_records.xml
  def index
    @retired_basic_salary_records = RetiredBasicSalaryRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @retired_basic_salary_records }
      format.json { render :text => get_json }
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

  # GET /retired_basic_salaries/new
  # GET /retired_basic_salaries/new.xml
  def new
    @retired_basic_salary_record = RetiredBasicSalaryRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @retired_basic_salary_record }
    end
  end

  # GET /retired_basic_salaries/1/edit
  def edit
    @retired_basic_salary_record = RetiredBasicSalaryRecord.find(params[:id])
  end

  # POST /retired_basic_salaries
  # POST /retired_basic_salaries.xml
  def create
    @retired_basic_salary_record = RetiredBasicSalaryRecord.new(params[:retired_basic_salary])

    respond_to do |format|
      if @retired_basic_salary_record.save
        #        flash[:notice] = 'RetiredBasicSalary was successfully created.'
        format.html { redirect_to(@retired_basic_salary_record) }
        format.xml  { render :xml => @retired_basic_salary_record, :status => :created, :location => @retired_basic_salary_record }
        format.json { render :text => '{status: "success",message: "成功添加离退休人员基本工资记录！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @retired_basic_salary_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@retired_basic_salary_record.errors.to_json}}"}
      end
    end
  end

  # PUT /retired_basic_salaries/1
  # PUT /retired_basic_salaries/1.xml
  def update
    @retired_basic_salary_record = RetiredBasicSalaryRecord.find(params[:id])

    respond_to do |format|
      if @retired_basic_salary_record.update_attributes(params[:retired_basic_salary])
        #        flash[:notice] = 'RetiredBasicSalary was successfully updated.'
        format.html { redirect_to(@retired_basic_salary_record) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success",message: "成功修改离退休人员基本工资记录！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @retired_basic_salary_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@retired_basic_salary_record.errors.to_json}}"}
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

    if(!params[:search_department_id].blank?)
      joins = "INNER JOIN users p ON retired_basic_salary_records.user_id=p.id"
      conditions += " AND p.department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @retired_basic_salary_records = RetiredBasicSalaryRecord.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=>pagesize, :page => params[:page] || 1)
      count = RetiredBasicSalaryRecord.count(:joins => joins, :conditions => option_conditions)
    else
      @retired_basic_salary_records = RetiredBasicSalaryRecord.paginate(:order =>"id DESC",:per_page=>pagesize, :page => params[:page] || 1)
      count = RetiredBasicSalaryRecord.count
    end
    return render_json(@retired_basic_salary_records,count)
  end
end
