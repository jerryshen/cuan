class StationPositionBenefitRecordsController < ApplicationController
  # GET /station_position_benefit_records
  # GET /station_position_benefit_records.xml
  def index
    @station_position_benefit_records = StationPositionBenefitRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @station_position_benefit_records }
      format.json { render :text => get_json }
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

  def create
    @station_position_benefit_record = StationPositionBenefitRecord.new(params[:station_position_benefit_record])

    respond_to do |format|
      if @station_position_benefit_record.save
        #        flash[:notice] = 'Role was successfully created.'
        format.html { redirect_to(@station_position_benefit_record) }
        format.xml  { render :xml => @station_position_benefit_record, :status => :created, :location => @station_position_benefit_record }
        format.json { render :text => '{status: "success", message: "成功申请科研津贴记录！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @station_position_benefit_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@station_position_benefit_record.errors.to_json}}"}
      end
    end
  end

  def update
    @station_position_benefit_record = StationPositionBenefitRecord.find(params[:id])

    respond_to do |format|
      if @station_position_benefit_record.update_attributes(params[:station_position_benefit_record])
        #        flash[:notice] = 'Role was successfully updated.'
        format.html { redirect_to(@station_position_benefit_record) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新科研津贴记录！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @station_position_benefit_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@station_position_benefit_record.errors.to_json}}"}
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
    pagesize = 10
    if(params[:page_size])
      param_pagesize = params[:page_size].to_i
      if param_pagesize > 0 then pagesize = param_pagesize end
    end
    if(!params[:search_name].blank? && params[:search_department_id].blank?)
      if user = User.find_by_name(params[:search_name])
        user_id = user.id
      else
        user_id = 0
      end
      @station_position_benefit_records = StationPositionBenefitRecord.paginate(:order =>"id DESC", :conditions => ["user_id =?",user_id],:per_page=>pagesize, :page => params[:page] || 1)
      count = @station_position_benefit_records.length
    elsif(!params[:search_department_id].blank? && params[:search_name].blank?)
      @station_position_benefit_records = StationPositionBenefitRecord.paginate(:order => "id DESC", :joins =>"INNER JOIN users p ON station_position_benefit_records.user_id=p.id" , :conditions =>["p.department_id =?",params[:search_department_id]],:per_page=>pagesize, :page => params[:page] || 1 )
      count = @station_position_benefit_records.length
    elsif(!params[:search_department_id].blank? && !params[:search_name].blank?)
      @station_position_benefit_records = StationPositionBenefitRecord.paginate(:order => "id DESC", :joins =>"INNER JOIN users p ON station_position_benefit_records.user_id=p.id" , :conditions =>["p.department_id =? and p.name like ?",params[:search_department_id],"%#{params[:search_name]}%"],:per_page=>pagesize, :page => params[:page] || 1 )
      count = @station_position_benefit_records.length
    else
      @station_position_benefit_records = StationPositionBenefitRecord.paginate(:order =>"id DESC",:per_page=>pagesize, :page => params[:page] || 1)
      count = StationPositionBenefitRecord.count
    end
    return render_json(@station_position_benefit_records,count)
  end
end
