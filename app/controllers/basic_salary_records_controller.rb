class BasicSalaryRecordsController < ApplicationController
  #  protect_from_forgery :except => :index
  #  skip_before_filter :verify_authenticity_token
  # GET /basic_salary_records
  # GET /basic_salary_records.xml
  def index
    @basic_salary_records = BasicSalaryRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @basic_salary_records }
      format.json { render :text => get_json }
    end
  end

  # GET /basic_salary_records/1
  # GET /basic_salary_records/1.xml
  def show
    @basic_salary_record = BasicSalaryRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @basic_salary_record }
    end
  end

  # GET /basic_salary_records/new
  # GET /basic_salary_records/new.xml
  def new
    @basic_salary_record = BasicSalaryRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @basic_salary_record }
    end
  end

  # GET /basic_salary_records/1/edit
  def edit
    @basic_salary_record = BasicSalaryRecord.find(params[:id])
  end

  # POST /basic_salaries
  # POST /basic_salaries.xml
  def create
    @basic_salary_record = BasicSalaryRecord.new(params[:basic_salary_record])

    respond_to do |format|
      if @basic_salary_record.save
        #        flash[:notice] = 'BasicSalary was successfully created.'
        format.html { redirect_to(@basic_salary_record) }
        format.xml  { render :xml => @basic_salary_record, :status => :created, :location => @basic_salary_record }
        format.json { render :text => '{status: "success", message: "成功创建基本工资！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @basic_salary_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@basic_salary_record.errors.to_json}}"}
      end
    end
  end

  # PUT /basic_salary_records/1
  # PUT /basic_salary_records/1.xml
  def update
    @basic_salary_record = BasicSalaryRecord.find(params[:id])

    respond_to do |format|
      if @basic_salary_record.update_attributes(params[:basic_salary_record])
        #        flash[:notice] = 'BasicSalary was successfully updated.'
        format.html { redirect_to(@basic_salary_record) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改基本工资！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @basic_salary_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:'#{@basic_salary_record.errors}'}"}
      end
    end
  end

  # DELETE /basic_salary_records/1
  # DELETE /basic_salary_records/1.xml
  def destroy
    @basic_salary_record = BasicSalaryRecord.find(params[:id])
    @basic_salary_record.destroy

    respond_to do |format|
      format.html { redirect_to(basic_salary_records_url) }
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
      joins = "INNER JOIN users p ON basic_salary_records.user_id=p.id"
      conditions += " AND p.department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @basic_salary_records = BasicSalaryRecord.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=>pagesize, :page => params[:page] || 1)
      count = @basic_salary_records.length
    else
      @basic_salary_records = BasicSalaryRecord.paginate(:order =>"id DESC",:per_page=>pagesize, :page => params[:page] || 1)
      count = @basic_salary_records.length
    end
    return render_json(@basic_salary_records,count)
  end
end
