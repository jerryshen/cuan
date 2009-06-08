class CollegeBeRecordsController < ApplicationController
  protect_from_forgery :except => :index
  skip_before_filter :verify_authenticity_token
  # GET /college_be_records
  # GET /college_be_records.xml
  def index
    @college_be_records = CollegeBeRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @college_be_records }
      format.json { render :text => get_json }
    end
  end

  # GET /college_be_records/1
  # GET /college_be_records/1.xml
  def show
    @college_be_record = CollegeBeRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @college_be_record }
    end
  end

  # GET /college_be_records/new
  # GET /college_be_records/new.xml
  def new
    @college_be_record = CollegeBeRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @college_be_record }
    end
  end

  # GET /college_be_records/1/edit
  def edit
    @college_be_record = CollegeBeRecord.find(params[:id])
  end

  # POST /college_be_records
  # POST /college_be_records.xml
  def create
    @college_be_record = CollegeBeRecord.new(params[:college_be_record])

    respond_to do |format|
      if @college_be_record.save
#        flash[:notice] = 'CollegeBeRecord was successfully created.'
        format.html { redirect_to(@college_be_record) }
        format.xml  { render :xml => @college_be_record, :status => :created, :location => @college_be_record }
        format.json { render :text => '{status: "success"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @college_be_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:'#{@college_be_record.errors}'}"}
      end
    end
  end

  # PUT /college_be_records/1
  # PUT /college_be_records/1.xml
  def update
    @college_be_record = CollegeBeRecord.find(params[:id])

    respond_to do |format|
      if @college_be_record.update_attributes(params[:college_be_record])
#        flash[:notice] = 'CollegeBeRecord was successfully updated.'
        format.html { redirect_to(@college_be_record) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @college_be_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:'#{@college_be_record.errors}'}"}
      end
    end
  end

  # DELETE /college_be_records/1
  # DELETE /college_be_records/1.xml
  def destroy
    @college_be_record = CollegeBeRecord.find(params[:id])
    @college_be_record.destroy

    respond_to do |format|
      format.html { redirect_to(college_be_records_url) }
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
      @college_be_records = CollegeBeRecord.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>pagesize,:page => params[:page] || 1)
      count = CollegeBeRecord.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @college_be_records = CollegeBeRecord.paginate(:order =>"id DESC",:per_page=>pagesize,:page => params[:page] || 1)
      count = CollegeBeRecord.count
    end
    return render_json(@college_be_records,count)
  end
end
