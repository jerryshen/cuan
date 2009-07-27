class PerformanceBenefitRecordsController < ApplicationController
  # GET /performance_benefit_records
  # GET /performance_benefit_records.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @performance_benefit_records }
      format.json { render :text => get_json }
      format.csv { export_csv(@performance_benefit_records,
          { :id => "id", :user_id => "姓名", :term => "发放学期", :fee => "金额",
            :date => "发放日期" }, "绩效津贴记录数据.csv") }
    end
  end

  # GET /performance_benefit_records/1
  # GET /performance_benefit_records/1.xml
  def show
    @performance_benefit_record = PerformanceBenefitRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @performance_benefit_record }
    end
  end

  # GET /performance_benefit_records/new
  # GET /performance_benefit_records/new.xml
  def new
    @performance_benefit_record = PerformanceBenefitRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @performance_benefit_record }
    end
  end

  # GET /performance_benefit_records/1/edit
  def edit
    @performance_benefit_record = PerformanceBenefitRecord.find(params[:id])
  end

  # POST /performance_benefit_records
  # POST /performance_benefit_records.xml
  def create
    @performance_benefit_record = PerformanceBenefitRecord.new(params[:performance_benefit_record])

    respond_to do |format|
      if @performance_benefit_record.save
        format.html { redirect_to(@performance_benefit_record) }
        format.xml  { render :xml => @performance_benefit_record, :status => :created, :location => @performance_benefit_record }
        format.json { render :text => '{status: "success", message: "成功创建绩效津贴记录！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @performance_benefit_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@performance_benefit_record.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /performance_benefit_records/1
  # PUT /performance_benefit_records/1.xml
  def update
    @performance_benefit_record = PerformanceBenefitRecord.find(params[:id])

    respond_to do |format|
      if @performance_benefit_record.update_attributes(params[:performance_benefit_record])
        format.html { redirect_to(@performance_benefit_record) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新绩效津贴记录！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @performance_benefit_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@performance_benefit_record.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /performance_benefit_records/1
  # DELETE /performance_benefit_records/1.xml
  def destroy
    @performance_benefit_record = PerformanceBenefitRecord.find(params[:id])
    @performance_benefit_record.destroy

    respond_to do |format|
      format.html { redirect_to(performance_benefit_records_url) }
      format.xml  { head :ok }
    end
  end

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
      joins = "INNER JOIN users p ON performance_benefit_records.user_id=p.id"
      conditions += " AND p.department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @performance_benefit_records = PerformanceBenefitRecord.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = PerformanceBenefitRecord.count(:joins => joins, :conditions => option_conditions)
    else
      @performance_benefit_records = PerformanceBenefitRecord.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = PerformanceBenefitRecord.count
    end
    return render_json(@performance_benefit_records,count)
  end
end
