class ClassMonthBenefitRecordsController < ApplicationController
  # GET /class_month_benefit_records
  # GET /class_month_benefit_records.xml
  def index
    @class_month_benefit_records = ClassMonthBenefitRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @class_month_benefit_records }
      format.json { render :text => get_json }
      format.csv { export_csv(@class_month_benefit_records,
          { :id => "id", :user_id => "姓名", :fee => "金额", :month => "发放月份",
            :date => "发放日期" }, "月发放课时津贴记录.csv") }
    end
  end

  # GET /class_month_benefit_records/1
  # GET /class_month_benefit_records/1.xml
  def show
    @class_month_benefit_record = ClassMonthBenefitRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @class_month_benefit_record }
    end
  end

  # GET /class_month_benefit_records/new
  # GET /class_month_benefit_records/new.xml
  def new
    @class_month_benefit_record = ClassMonthBenefitRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @class_month_benefit_record }
    end
  end

  # GET /class_month_benefit_records/1/edit
  def edit
    @class_month_benefit_record = ClassMonthBenefitRecord.find(params[:id])
  end

  # POST /class_month_benefit_records
  # POST /class_month_benefit_records.xml
  def create
    @class_month_benefit_record = ClassMonthBenefitRecord.new(params[:class_month_benefit_record])

    respond_to do |format|
      if @class_month_benefit_record.save
        format.html { redirect_to(@class_month_benefit_record) }
        format.xml  { render :xml => @class_month_benefit_record, :status => :created, :location => @class_month_benefit_record }
        format.json { render :text => '{status: "success", message: "成功添加月发放课时津贴！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @class_month_benefit_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@class_month_benefit_record.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /class_month_benefit_records/1
  # PUT /class_month_benefit_records/1.xml
  def update
    @class_month_benefit_record = ClassMonthBenefitRecord.find(params[:id])

    respond_to do |format|
      if @class_month_benefit_record.update_attributes(params[:class_month_benefit_record])
        format.html { redirect_to(@class_month_benefit_record) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改月发放课时津贴！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @class_month_benefit_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@class_month_benefit_record.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /class_month_benefit_records/1
  # DELETE /class_month_benefit_records/1.xml
  def destroy
    @class_month_benefit_record = ClassMonthBenefitRecord.find(params[:id])
    @class_month_benefit_record.destroy

    respond_to do |format|
      format.html { redirect_to(class_month_benefit_records_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  private
  def get_json
    load_page_data

    if(params[:search_name] && params[:search_name].to_s!='')
      @class_month_benefit_records = ClassMonthBenefitRecord.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=> @pagesize,:page => params[:page] || 1)
      count = ClassMonthBenefitRecord.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @class_month_benefit_records = ClassMonthBenefitRecord.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = ClassMonthBenefitRecord.count
    end
    return render_json(@class_month_benefit_records,count)
  end
end
