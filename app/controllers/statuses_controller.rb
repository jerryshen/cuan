class StatusesController < ApplicationController
  # GET /statuses
  # GET /statuses.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @statuses }
      format.json { render :text => get_json }
    end
  end

  # GET /statuses/1
  # GET /statuses/1.xml
  def show
    @status = Status.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @status }
    end
  end

  # GET /statuses/new
  # GET /statuses/new.xml
  def new
    @status = Status.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @status }
    end
  end

  # GET /statuses/1/edit
  def edit
    @status = Status.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.xml
  def create
    @status = Status.new(params[:status])

    respond_to do |format|
      if @status.save
        format.html { redirect_to(@status) }
        format.xml  { render :xml => @status, :status => :created, :location => @status }
        format.json { render :text => '{status: "success", message: "成功添加身份"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @status.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@status.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.xml
  def update
    @status = Status.find(params[:id])

    respond_to do |format|
      if @status.update_attributes(params[:status])
        format.html { redirect_to(@status) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改身份"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @status.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@status.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.xml
  def destroy
    @status = Status.find(params[:id])
    @status.destroy

    respond_to do |format|
      format.html { redirect_to(statuses_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  private

  def get_json
    load_page_data
    if(!params[:search_name].blank?)
      @statuses = Status.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>@pagesize,:page => params[:page] || 1)
      count = Status.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @statuses = Status.paginate(:order =>"id DESC",:per_page=>@pagesize,:page => params[:page] || 1)
      count = Status.count
    end
    return render_json(@statuses,count)
  end
end
