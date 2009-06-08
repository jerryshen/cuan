class RetiredCollegeBeRecordsController < ApplicationController
  # GET /retired_college_be_records
  # GET /retired_college_be_records.xml
  def index
    @retired_college_be_records = RetiredCollegeBeRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @retired_college_be_records }
      format.json { render :text => get_json }
    end
  end

  # GET /retired_college_be_records/1
  # GET /retired_college_be_records/1.xml
  def show
    @retired_college_be_record = RetiredCollegeBeRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @retired_college_be_record }
    end
  end


  # DELETE /retired_college_be_records/1
  # DELETE /retired_college_be_records/1.xml
  def destroy
    @retired_college_be_record = RetiredCollegeBeRecord.find(params[:id])
    @retired_college_be_record.destroy

    respond_to do |format|
      format.html { redirect_to(retired_college_be_records_url) }
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
      @retired_college_be_records = RetiredCollegeBeRecord.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>pagesize,:page => params[:page] || 1)
      count = RetiredCollegeBeRecord.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @retired_college_be_records = RetiredCollegeBeRecord.paginate(:order =>"id DESC",:per_page=>pagesize,:page => params[:page] || 1)
      count = RetiredCollegeBeRecord.count
    end
    return render_json(@retired_college_be_records,count)
  end
end
