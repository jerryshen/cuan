class ClassBePersonnelsController < ApplicationController
  # GET /class_be_personnels
  # GET /class_be_personnels.xml
  def index
    @class_be_personnels = ClassBenefit.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @class_be_personnels }
      format.json { render :text => get_json }
    end
  end

  # GET /class_be_personnels/1
  # GET /class_be_personnels/1.xml
  def show
    @class_be_personnel = ClassBenefit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @class_be_personnel }
    end
  end

  # GET /class_be_personnels/1/edit
  def edit
    @class_be_personnel = ClassBenefit.find(params[:id])
  end

  # PUT /class_be_personnels/1
  # PUT /class_be_personnels/1.xml
  def update
    @class_be_personnel = ClassBenefit.find(params[:id])

    respond_to do |format|
      if @class_be_personnel.update_attributes(params[:class_be_personnel])
        #        flash[:notice] = 'ClassBePersonnel was successfully updated.'
        format.html { redirect_to(@class_be_personnel) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改课时津贴申请！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @class_be_personnel.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@class_be_personnel.errors.to_json}}"}
      end
    end
  end

  # DELETE /class_be_personnels/1
  # DELETE /class_be_personnels/1.xml
  def destroy
    @class_be_personnel = ClassBenefit.find(params[:id])
    @class_be_personnel.destroy

    respond_to do |format|
      format.html { redirect_to(class_be_personnels_url) }
      format.xml  { head :ok }
    end
  end

  def verify
    @class_be_personnel = ClassBenefit.find(params[:id])
    if @class_be_personnel.verify
      render :text =>"true"
    else
      render :text =>"false"
    end
  end

  private
  def get_json
    pagesize = 10
    if(params[:page_size])
      param_pagesize = params[:page_size].to_i
      if param_pagesize > 0 then pagesize = param_pagesize end
    end

    conditions = '1=1'
    condition_values = []
    if(!params[:search_name].blank?)
      if user = User.find_by_name(params[:search_name])
        user_id = user.id
      else
        user_id = 0
      end
      conditions += " AND user_id = ?"
      condition_values << user_id
    end

    if(!params[:search_verify].blank?)
      value=(params[:search_verify].to_i ==0? false : true)
      conditions += " AND is_verified = ? "
      condition_values << value
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @class_be_personnels = ClassBenefit.paginate(:order =>"id DESC", :conditions => option_conditions,:per_page=>pagesize, :page => params[:page] || 1)
      count = @class_be_personnels.length
    else
      @class_be_personnels = ClassBenefit.paginate(:order =>"id DESC",:per_page=>pagesize, :page => params[:page] || 1)
      count = @class_be_personnels.length
    end
    return render_json(@class_be_personnels,count)
  end
end
