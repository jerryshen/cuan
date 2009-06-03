class BasicSalaryRecordsController < ApplicationController
  protect_from_forgery :except => :index
  skip_before_filter :verify_authenticity_token
  # GET /basic_salary_records
  # GET /basic_salary_records.xml
  def index
    @basic_salary_records = BasicSalaryRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @basic_salary_records }
      format.json { render :text => get_json }
    end
  end

  # GET /basic_salary_records/1
  # GET /basic_salary_records/1.xml
  def show
    @basic_salary_record = BasicSalaryRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @basic_salary_record }
    end
  end

  # DELETE /basic_salary_records/1
  # DELETE /basic_salary_records/1.xml
  def destroy
    @basic_salary_record = BasicSalaryRecord.find(params[:id])
    @basic_salary_record.destroy

    respond_to do |format|
      format.html { redirect_to(basic_salary_records_url) }
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
      @basic_salary_records = BasicSalaryRecord.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>pagesize,:page => params[:page] || 1)
      count = BasicSalaryRecord.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @basic_salary_records = BasicSalaryRecord.paginate(:order =>"id DESC",:per_page=>pagesize,:page => params[:page] || 1)
      count = BasicSalaryRecord.count
    end
    return render_json @basic_salary_records,count
  end
end
