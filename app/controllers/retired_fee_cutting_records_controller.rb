class RetiredFeeCuttingRecordsController < ApplicationController
  # GET /retired_fee_cutting_records
  # GET /retired_fee_cutting_records.xml
  def index
    @retired_fee_cutting_records = RetiredFeeCuttingRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @retired_fee_cutting_records }
      format.json { render :text => get_json }
      format.csv { export_csv(@retired_fee_cutting_records,
          { :id => "id", :user_id => "姓名", :year => "年度", :month => "月份",
            :other_fee1 => "其他扣款1", :other_fee2 => "其他扣款2", :other_fee3 => "其他扣款3" }, "离退休人员扣款记录数据.csv") }
    end
  end

  # GET /retired_fee_cutting_records/1
  # GET /retired_fee_cutting_records/1.xml
  def show
    @retired_fee_cutting_record = RetiredFeeCuttingRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @retired_fee_cutting_record }
    end
  end
  # GET /retired_fee_cutting_records/new
  # GET /retired_fee_cutting_records/new.xml
  def new
    @retired_fee_cutting_record = RetiredFeeCuttingRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @retired_fee_cutting_record }
    end
  end

  # GET /retired_fee_cutting_records/1/edit
  def edit
    @retired_fee_cutting_record = RetiredFeeCuttingRecord.find(params[:id])
  end

  # POST /retired_fee_cutting_records
  # POST /retired_fee_cutting_records.xml
  def create
    @retired_fee_cutting_record = RetiredFeeCuttingRecord.new(params[:retired_fee_cutting_record])

    respond_to do |format|
      if @retired_fee_cutting_record.save
        format.html { redirect_to(@retired_fee_cutting_record) }
        format.xml  { render :xml => @retired_fee_cutting_record, :status => :created, :location => @retired_fee_cutting_record }
        format.json { render :text => '{status: "success", message: "成功添加离退休人员扣款！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @retired_fee_cutting_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@retired_fee_cutting_record.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /retired_fee_cutting_records/1
  # PUT /retired_fee_cutting_records/1.xml
  def update
    @retired_fee_cutting_record = RetiredFeeCuttingRecord.find(params[:id])

    respond_to do |format|
      if @retired_fee_cutting_record.update_attributes(params[:retired_fee_cutting_record])
        format.html { redirect_to(@retired_fee_cutting_record) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新离退休人员扣款！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @retired_fee_cutting_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@retired_fee_cutting_record.errors.full_messages.to_json}}"}
      end
    end
  end
  # DELETE /retired_fee_cutting_records/1
  # DELETE /retired_fee_cutting_records/1.xml
  def destroy
    @retired_fee_cutting_record = RetiredFeeCuttingRecord.find(params[:id])
    @retired_fee_cutting_record.destroy

    respond_to do |format|
      format.html { redirect_to(retired_fee_cutting_records_url) }
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
      joins = "INNER JOIN users p ON retired_fee_cutting_records.user_id=p.id"
      conditions += " AND p.department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @retired_fee_cutting_records = RetiredFeeCuttingRecord.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = RetiredFeeCuttingRecord.count(:joins => joins, :conditions => option_conditions)
    else
      @retired_fee_cutting_records = RetiredFeeCuttingRecord.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = RetiredFeeCuttingRecord.count
    end
    return render_json(@retired_fee_cutting_records,count)
  end
end
