class StationPositionBenefitsController < ApplicationController

  def index
    @station_position_benefits = StationPositionBenefit.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @station_position_benefits }
      format.json { render :text => get_json }
    end
  end


  def show
    @station_position_benefit = StationPositionBenefit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @station_position_benefit }
    end
  end

  # GET /roles/new
  # GET /roles/new.xml
  def new
    @station_position_benefit = StationPositionBenefit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @station_position_benefit }
    end
  end

  def edit
    @station_position_benefit = StationPositionBenefit.find(params[:id])
  end

  def create
    @station_position_benefit = StationPositionBenefit.new(params[:station_position_benefit])

    respond_to do |format|
      if @station_position_benefit.save
        #        flash[:notice] = 'Role was successfully created.'
        format.html { redirect_to(@station_position_benefit) }
        format.xml  { render :xml => @station_position_benefit, :status => :created, :location => @station_position_benefit }
        format.json { render :text => '{status: "success", message: "成功申请科研津贴！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @station_position_benefit.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@station_position_benefit.errors.to_json}}"}
      end
    end
  end

  def update
    @station_position_benefit = StationPositionBenefit.find(params[:id])

    respond_to do |format|
      if @station_position_benefit.update_attributes(params[:station_position_benefit])
        #        flash[:notice] = 'Role was successfully updated.'
        format.html { redirect_to(@station_position_benefit) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新科研津贴！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @station_position_benefit.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@station_position_benefit.errors.to_json}}"}
      end
    end
  end

  def destroy
    @station_position_benefit = StationPositionBenefit.find(params[:id])
    @station_position_benefit.destroy

    respond_to do |format|
      format.html { redirect_to(station_position_benefits_url) }
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
      @station_position_benefits = StationPositionBenefit.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>pagesize,:page => params[:page] || 1)
      count = StationPositionBenefit.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @station_position_benefits = StationPositionBenefit.paginate(:order =>"id DESC",:per_page=>pagesize,:page => params[:page] || 1)
      count = StationPositionBenefit.count
    end
    return render_json(@station_position_benefits,count)
  end
end
