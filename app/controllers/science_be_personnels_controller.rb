class ScienceBePersonnelsController < ApplicationController
  # GET /science_be_personnels
  # GET /science_be_personnels.xml
  def index
    @science_be_personnels = ScienceBenefit.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @science_be_personnels }
      format.json { render :text => get_json }
    end
  end

  # GET /science_be_personnels/1
  # GET /science_be_personnels/1.xml
  def show
    @science_be_personnel = ScienceBenefit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @science_be_personnel }
    end
  end

  # GET /science_be_personnels/1/edit
  def edit
    @science_be_personnel = ScienceBenefit.find(params[:id])
  end

  # PUT /science_be_personnels/1
  # PUT /science_be_personnels/1.xml
  def update
    @science_be_personnel = ScienceBenefit.find(params[:id])

    respond_to do |format|
      if @science_be_personnel.update_attributes(params[:science_be_personnel])
        flash[:notice] = 'ScienceBePersonnel was successfully updated.'
        format.html { redirect_to(@science_be_personnel) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改科研津贴申请！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @science_be_personnel.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@science_be_personnel.errors.to_json}}"}
      end
    end
  end

  # DELETE /science_be_personnels/1
  # DELETE /science_be_personnels/1.xml
  def destroy
    @science_be_personnel = ScienceBenefit.find(params[:id])
    @science_be_personnel.destroy

    respond_to do |format|
      format.html { redirect_to(science_be_personnels_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def get_json
    pagesize = 10
    if(params[:page_size])
      param_pagesize = params[:page_size].to_i
      if param_pagesize > 0 then pagesize = param_pagesize end
    end
    if(params[:search_name] && params[:search_name].to_s!='')
      @science_be_personnels = ScienceBenefit.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>pagesize,:page => params[:page] || 1)
      count = ScienceBenefit.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @science_be_personnels = ScienceBenefit.paginate(:order =>"id DESC",:per_page=>pagesize,:page => params[:page] || 1)
      count = ScienceBenefit.count
    end
    return render_json(@science_be_personnels,count)
  end
end
