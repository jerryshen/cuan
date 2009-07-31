class EducationsController < ApplicationController
  # GET /educations
  # GET /educations.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @educations }
      format.json { render :text => get_json }
    end
  end

  # GET /educations/1
  # GET /educations/1.xml
  def show
    @education = Education.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @education }
    end
  end

  # GET /educations/new
  # GET /educations/new.xml
  def new
    @education = Education.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @education }
    end
  end

  # GET /educations/1/edit
  def edit
    @education = Education.find(params[:id])
  end

  # POST /educations
  # POST /educations.xml
  def create
    @education = Education.new(params[:education])

    respond_to do |format|
      if @education.save
        format.html { redirect_to(@education) }
        format.xml  { render :xml => @education, :status => :created, :location => @education }
        format.json { render :text => '{status: "success", message: "成功添加学历"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @education.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@education.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /educations/1
  # PUT /educations/1.xml
  def update
    @education = Education.find(params[:id])

    respond_to do |format|
      if @education.update_attributes(params[:education])
        format.html { redirect_to(@education) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新学历"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @education.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@education.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /educations/1
  # DELETE /educations/1.xml
  def destroy
    @education = Education.find(params[:id])
    @education.destroy

    respond_to do |format|
      format.html { redirect_to(educations_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  private

  def get_json
    load_page_data
    if(!params[:search_name].blank?)
      @educations = Education.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>@pagesize,:page => params[:page] || 1)
      count = Education.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @educations = Education.paginate(:order =>"id DESC",:per_page=>@pagesize,:page => params[:page] || 1)
      count = Education.count
    end
    return render_json(@educations,count)
  end
end
