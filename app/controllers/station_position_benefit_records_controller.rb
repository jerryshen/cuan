class StationPositionBenefitRecordsController < ApplicationController
  protect_from_forgery :except => [:prev, :next, :last]
  # GET /station_position_benefit_records
  # GET /station_position_benefit_records.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @station_position_benefit_records }
      format.json { render :text => get_json }
      format.csv { export_csv(@station_position_benefit_records,
          { :id => "id", :user_id => "姓名", :year => "年度", :month => "月份",
            :station_be => "岗位津贴", :position_be => "职务津贴" }, "岗位－职务津贴记录数据.csv") }
    end
  end

  # GET /station_position_benefit_records/1
  # GET /station_position_benefit_records/1.xml
  def show
    @station_position_benefit_record = StationPositionBenefitRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @station_position_benefit_record }
    end
  end

  def new
    @station_position_benefit_record = StationPositionBenefitRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @station_position_benefit_record }
    end
  end

  def edit
    @station_position_benefit_record = StationPositionBenefitRecord.find(params[:id])
  end

  def prev
    @station_position_benefit_record = StationPositionBenefitRecord.find(:last, :conditions => ["id < ?", params[:id]], :order => "id ASC")
    if @station_position_benefit_record
      render :action => "edit"
    else
      render :text => "nodata"
    end
  end

  def next
    @station_position_benefit_record =  StationPositionBenefitRecord.find(:first, :conditions => ["id > ?", params[:id]], :order => "id ASC")
    if @station_position_benefit_record
      render :action => "edit"
    else
      render :text => "nodata"
    end
  end

  def last
    @station_position_benefit_record =  StationPositionBenefitRecord.last
    if @station_position_benefit_record
      render :action => "edit"
    else
      render :text => "nodata"
    end
  end

  def create
    @station_position_benefit_record = StationPositionBenefitRecord.new(params[:station_position_benefit_record])

    respond_to do |format|
      if @station_position_benefit_record.save
        format.html { redirect_to(@station_position_benefit_record) }
        format.xml  { render :xml => @station_position_benefit_record, :status => :created, :location => @station_position_benefit_record }
        format.json { render :text => '{status: "success", message: "成功申请科研津贴记录！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @station_position_benefit_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@station_position_benefit_record.errors.full_messages.to_json}}"}
      end
    end
  end

  def update
    @station_position_benefit_record = StationPositionBenefitRecord.find(params[:id])

    respond_to do |format|
      if @station_position_benefit_record.update_attributes(params[:station_position_benefit_record])
        format.html { redirect_to(@station_position_benefit_record) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新科研津贴记录！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @station_position_benefit_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@station_position_benefit_record.full_messages.errors.to_json}}"}
      end
    end
  end

  # DELETE /station_position_benefit_records/1
  # DELETE /station_position_benefit_records/1.xml
  def destroy
    @station_position_benefit_record = StationPositionBenefitRecord.find(params[:id])
    @station_position_benefit_record.destroy

    respond_to do |format|
      format.html { redirect_to(station_position_benefit_records_url) }
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

    if(!params[:search_department_id].blank?)
      joins = "INNER JOIN users p ON station_position_benefit_records.user_id=p.id"
      conditions += " AND p.department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @station_position_benefit_records = StationPositionBenefitRecord.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = StationPositionBenefitRecord.count(:joins => joins, :conditions => option_conditions)
    else
      @station_position_benefit_records = StationPositionBenefitRecord.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = StationPositionBenefitRecord.count
    end
    return render_json(@station_position_benefit_records,count)
  end
end
