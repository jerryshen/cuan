class FeeCuttingRecordsController < ApplicationController
  #  protect_from_forgery :except => :index
  #  skip_before_filter :verify_authenticity_token
  # GET /fee_cutting_records
  # GET /fee_cutting_records.xml
  def index
    @fee_cutting_records = FeeCuttingRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fee_cutting_records }
      format.json { render :text => get_json }
      format.csv { export_csv(@fee_cutting_records,
          { :id => "id", :user_id => "姓名", :year => "年度", :month => "月份",
            :room_fee => "住房公积金", :med_fee => "医疗保险", :elc_fee => "水电气费",
            :net_fee => "上网费", :job_fee => "失业保险", :selfedu_fee => "职工个人教育费",
            :other_fee1 => "其他扣款一", :other_fee2 => "其他扣款二", :other_fee3 => "其他扣款三",
            :self_tax => "个人所得税"}, "扣款记录数据.csv") }
    end
  end

  # GET /fee_cutting_records/1
  # GET /fee_cutting_records/1.xml
  def show
    @fee_cutting_record = FeeCuttingRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fee_cutting_record }

    end
  end

  # GET /fee_cutting_records/new
  # GET /fee_cutting_records/new.xml
  def new
    @fee_cutting_record = FeeCuttingRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @fee_cutting_record }
    end
  end

  # GET /fee_cutting_records/1/edit
  def edit
    @fee_cutting_record = FeeCuttingRecord.find(params[:id])
  end

  # POST /fee_cutting_records
  # POST /fee_cutting_records.xml
  def create
    @fee_cutting_record = FeeCuttingRecord.new(params[:fee_cutting])

    respond_to do |format|
      if @fee_cutting_record.save
        format.html { redirect_to(@fee_cutting_record) }
        format.xml  { render :xml => @fee_cutting_record, :status => :created, :location => @fee_cutting_record }
        format.json { render :text => '{status: "success", message: "成功创建扣款！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @fee_cutting_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@fee_cutting_record.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /fee_cutting_records/1
  # PUT /fee_cutting_records/1.xml
  def update
    @fee_cutting_record = FeeCuttingRecord.find(params[:id])

    respond_to do |format|
      if @fee_cutting_record.update_attributes(params[:fee_cutting])
        format.html { redirect_to(@fee_cutting_record) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新扣款！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @fee_cutting_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@fee_cutting_record.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /fee_cutting_records/1
  # DELETE /fee_cutting_records/1.xml
  def destroy
    @fee_cutting_record = FeeCuttingRecord.find(params[:id])
    @fee_cutting_record.destroy

    respond_to do |format|
      format.html { redirect_to(fee_cutting_records_url) }
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
      joins = "INNER JOIN users p ON ffee_cutting_records.user_id=p.id"
      conditions += " AND p.department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @fee_cutting_records = FeeCuttingRecord.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=>@pagesize, :page => params[:page] || 1)
      count = FeeCuttingRecord.count(:joins => joins, :conditions => option_conditions)
    else
      @fee_cutting_records = FeeCuttingRecord.paginate(:order =>"id DESC",:per_page=>@pagesize, :page => params[:page] || 1)
      count = FeeCuttingRecord.count
    end
    return render_json(@fee_cutting_records,count)
  end
end
