class DegreesController < ApplicationController
  # GET /degrees
  # GET /degrees.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @degrees }
      format.json { render :text => get_json }
    end
  end

  # GET /degrees/1
  # GET /degrees/1.xml
  def show
    @degree = Degree.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @degree }
    end
  end

  # GET /degrees/new
  # GET /degrees/new.xml
  def new
    @degree = Degree.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @degree }
    end
  end

  # GET /degrees/1/edit
  def edit
    @degree = Degree.find(params[:id])
  end

  # POST /degrees
  # POST /degrees.xml
  def create
    @degree = Degree.new(params[:degree])

    respond_to do |format|
      if @degree.save
        format.html { redirect_to(@degree) }
        format.xml  { render :xml => @degree, :status => :created, :location => @degree }
        format.json { render :text => '{status: "success", message: "成功添加学位"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @degree.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@degree.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /degrees/1
  # PUT /degrees/1.xml
  def update
    @degree = Degree.find(params[:id])

    respond_to do |format|
      if @degree.update_attributes(params[:degree])
        format.html { redirect_to(@degree) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新学位"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @degree.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@degree.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /degrees/1
  # DELETE /degrees/1.xml
  def destroy
    @degree = Degree.find(params[:id])
    @degree.destroy

    respond_to do |format|
      format.html { redirect_to(degrees_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  private

  def get_json
    load_page_data
    if(!params[:search_name].blank?)
      @degrees = Degree.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>@pagesize,:page => params[:page] || 1)
      count = Degree.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @degrees = Degree.paginate(:order =>"id DESC",:per_page=>@pagesize,:page => params[:page] || 1)
      count = Degree.count
    end
    return render_json(@degrees,count)
  end
end
