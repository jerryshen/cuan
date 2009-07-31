class StationsController < ApplicationController
  # GET /stations
  # GET /stations.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stations }
      format.json { render :text => get_json }
    end
  end

  # GET /stations/1
  # GET /stations/1.xml
  def show
    @station = Station.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @station }
    end
  end

  # GET /stations/new
  # GET /stations/new.xml
  def new
    @station = Station.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @station }
    end
  end

  # GET /stations/1/edit
  def edit
    @station = Station.find(params[:id])
  end

  # POST /stations
  # POST /stations.xml
  def create
    @station = Station.new(params[:station])

    respond_to do |format|
      if @station.save
        format.html { redirect_to(@station) }
        format.xml  { render :xml => @station, :status => :created, :location => @station }
        format.json { render :text => '{status: "success", message: "成功添加岗位"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @station.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@station.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /stations/1
  # PUT /stations/1.xml
  def update
    @station = Station.find(params[:id])

    respond_to do |format|
      if @station.update_attributes(params[:station])
        format.html { redirect_to(@station) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新岗位"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @station.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@station.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /stations/1
  # DELETE /stations/1.xml
  def destroy
    @station = Station.find(params[:id])
    @station.destroy

    respond_to do |format|
      format.html { redirect_to(stations_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  private
  
  def get_json
    load_page_data
    if(!params[:search_name].blank?)
      @stations = Station.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>@pagesize,:page => params[:page] || 1)
      count = Station.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @stations = Station.paginate(:order =>"id DESC",:per_page=>@pagesize,:page => params[:page] || 1)
      count = Station.count
    end
    return render_json(@stations,count)
  end
end
