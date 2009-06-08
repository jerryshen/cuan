class RetiredFeeCuttingRecordsController < ApplicationController
  # GET /retired_fee_cutting_records
  # GET /retired_fee_cutting_records.xml
  def index
    @retired_fee_cutting_records = RetiredFeeCuttingRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @retired_fee_cutting_records }
      format.json { render :text => get_json }
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
    pagesize = 10
    if(params[:page_size])
      param_pagesize = params[:page_size].to_i
      if param_pagesize > 0 then pagesize = param_pagesize end
    end
    if(params[:search_name] && params[:search_name].to_s!='')
      @retired_fee_cutting_records = RetiredFeeCuttingRecord.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>pagesize,:page => params[:page] || 1)
      count = RetiredFeeCuttingRecord.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @retired_fee_cutting_records = RetiredFeeCuttingRecord.paginate(:order =>"id DESC",:per_page=>pagesize,:page => params[:page] || 1)
      count = RetiredFeeCuttingRecord.count
    end
    return render_json(@retired_fee_cutting_records,count)
  end
end
