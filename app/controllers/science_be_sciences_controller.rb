class ScienceBeSciencesController < ApplicationController
  # GET /science_be_sciences
  # GET /science_be_sciences.xml
  def index
    @science_be_sciences = ScienceBenefit.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @science_be_sciences }
      format.json { render :text => get_json }
    end
  end

  # GET /science_be_sciences/1
  # GET /science_be_sciences/1.xml
  def show
    @science_be_science = ScienceBenefit.find_by_id_and_user_id(params[:id],@current_user.id)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @science_be_science }
    end
  end

  # GET /science_be_sciences/new
  # GET /science_be_sciences/new.xml
  def new
    @science_be_science = ScienceBenefit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @science_be_science }
    end
  end

  # GET /science_be_sciences/1/edit
  def edit
    @science_be_science = ScienceBenefit.find_by_id_and_user_id(params[:id],@current_user.id)
  end

  # POST /science_be_sciences
  # POST /science_be_sciences.xml
  def create
    @science_be_science = ScienceBenefit.new(params[:science_be_science])
    if is_admin?
      @science_be_science.user_id = @current_user.id
    end

    respond_to do |format|
      if @science_be_science.save
        format.html { redirect_to(@science_be_science) }
        format.xml  { render :xml => @science_be_science, :status => :created, :location => @science_be_science }
        format.json { render :text => '{status: "success", message: "成功提交科研津贴申请！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @science_be_science.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@science_be_science.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /science_be_sciences/1
  # PUT /science_be_sciences/1.xml
  def update
    @science_be_science = ScienceBenefit.find_by_id_and_user_id(params[:id],@current_user.id)

    respond_to do |format|
      if @science_be_science.update_attributes(params[:science_be_science])
        format.html { redirect_to(@science_be_science) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改科研津贴！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @science_be_science.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@science_be_science.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /science_be_sciences/1
  # DELETE /science_be_sciences/1.xml
  def destroy
    @science_be_science = ScienceBenefit.find_by_id_and_user_id(params[:id],@current_user.id)
    @science_be_science.destroy

    respond_to do |format|
      format.html { redirect_to(science_be_sciences_url) }
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
    if(!params[:search_verify].blank?)
      value=(params[:search_verify].to_i == 0? false : true)
      condition = ["user_id = ? and is_verified = ?", @current_user.id, value]
      @science_be_sciences = ScienceBenefit.paginate(:order =>"id DESC", :conditions => condition,:per_page=>pagesize,:page => params[:page] || 1)
      count = ScienceBenefit.count(:conditions => condition)
    else
      condition = ["user_id =?", @current_user.id]
      @science_be_sciences = ScienceBenefit.paginate(:order =>"id DESC",:conditions => condition ,:per_page=>pagesize,:page => params[:page] || 1)
      count = ScienceBenefit.count(:conditions => condition)
    end
    return render_json(@science_be_sciences,count)
  end
end
