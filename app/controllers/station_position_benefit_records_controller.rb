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
    if(params[:search_name] && params[:search_name].to_s!='')
      @station_position_benefit_records = StationPositionBenefitRecord.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>pagesize,:page => params[:page] || 1)
      count = StationPositionBenefitRecord.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @station_position_benefit_records = StationPositionBenefitRecord.paginate(:order =>"id DESC",:per_page=>pagesize,:page => params[:page] || 1)
      count = StationPositionBenefitRecord.count
    end
    return render_json(@station_position_benefit_records,count)
  end
end
