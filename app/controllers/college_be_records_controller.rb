class CollegeBeRecordsController < ApplicationController
  protect_from_forgery :except => [:generate_benefits]
  
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @college_be_records }
      format.json { render :text => get_json }
      format.csv { export_csv(@college_be_records,
          { :id => "id", :user_id => "姓名", :year => "年度", :month => "月份",
            :life_be => "生活补贴", :diff_be => "补贴补差", :livesa_be => "活工资补贴",
            :tv_be => "电视补贴", :beaulty_be  => "驻蓉补贴", :other_be => "其他" }, "学院补贴记录数据.csv") }
    end
  end

  # GET /college_be_records/1
  # GET /college_be_records/1.xml
  def show
    @college_be_record = CollegeBeRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @college_be_record }
    end
  end

  # GET /college_be_records/new
  # GET /college_be_records/new.xml
  def new
    @college_be_record = CollegeBeRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @college_be_record }
    end
  end

  # GET /college_be_records/1/edit
  def edit
    @college_be_record = CollegeBeRecord.find(params[:id])
  end

  # POST /college_be_records
  # POST /college_be_records.xml
  def create
    @college_be_record = CollegeBeRecord.new(params[:college_be_record])

    respond_to do |format|
      if @college_be_record.save
        format.html { redirect_to(@college_be_record) }
        format.xml  { render :xml => @college_be_record, :status => :created, :location => @college_be_record }
        format.json { render :text => '{status: "success", message: "成功创建学院补贴记录！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @college_be_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@college_be_record.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /college_be_records/1
  # PUT /college_be_records/1.xml
  def update
    @college_be_record = CollegeBeRecord.find(params[:id])

    respond_to do |format|
      if @college_be_record.update_attributes(params[:college_be_record])
        format.html { redirect_to(@college_be_record) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改学院补贴记录记录！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @college_be_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@college_be_record.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /college_be_records/1
  # DELETE /college_be_records/1.xml
  def destroy
    @college_be_record = CollegeBeRecord.find(params[:id])
    @college_be_record.destroy

    respond_to do |format|
      format.html { redirect_to(college_be_records_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def confirm
    @college_be_record = CollegeBeRecord.find(params[:id])
    if @college_be_record.update_attributes(:confirm => !@college_be_record.confirm)
      render :text =>"true"
    else
      render :text =>"false"
    end
  end

  def generate_benefits
    benefit_stds = CollegeBenefit.all
    if benefit_stds.blank?
      render :json => {:status => "fail",:msg => "无学院补贴标准数据，操作失败！"}
    else
      benefit_records = CollegeBeRecord.all
      year_month = []
      benefit_records.each do |d|
        year_month.push(d.year.to_s + "-" + d.month.to_s)
      end

      if year_month.uniq.include? Time.now.year.to_s + "-" + Time.now.month.to_i.to_s
        render :json => {:status => "fail", :msg=>"已存在当月学院补贴数据！"}
      else
        begin
          count = CollegeBenefit.count
          CollegeBeRecord.generate_benefits(benefit_stds)
          render :json => {:status => "success", :msg=>"成功生成#{count}个员工的基本学院补贴！"}
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
      joins = "INNER JOIN users p ON college_be_records.user_id=p.id"
      conditions += " AND p.department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @college_be_records = CollegeBeRecord.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = CollegeBeRecord.count(:joins => joins, :conditions => option_conditions)
    else
      @college_be_records = CollegeBeRecord.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = CollegeBeRecord.count
    end
    return render_json(@college_be_records,count)
  end
end
