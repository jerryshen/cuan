class FeeCuttingRecordsController < ApplicationController
  protect_from_forgery :except => :index
  skip_before_filter :verify_authenticity_token
  # GET /fee_cutting_records
  # GET /fee_cutting_records.xml
  def index
    @fee_cutting_records = FeeCuttingRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fee_cutting_records }
      format.json { render :text => get_json }
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
    pagesize = 10
    if(params[:page_size])
      param_pagesize = params[:page_size].to_i
      if param_pagesize > 0 then pagesize = param_pagesize end
    end
    if(params[:search_name] && params[:search_name].to_s!='')
      @fee_cutting_records = FeeCuttingRecord.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>pagesize,:page => params[:page] || 1)
      count = FeeCuttingRecord.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @fee_cutting_records = FeeCuttingRecord.paginate(:order =>"id DESC",:per_page=>pagesize,:page => params[:page] || 1)
      count = FeeCuttingRecord.count
    end
    return render_json @fee_cutting_records,count
  end
end
