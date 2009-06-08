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

  def get_json
    pagesize = 10
    if(params[:page_size])
      param_pagesize = params[:page_size].to_i
      if param_pagesize > 0 then pagesize = param_pagesize end
    end
    if(params[:search_name] && params[:search_name].to_s!='')
      @class_be_personnels = ClassBenefit.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>pagesize,:page => params[:page] || 1)
      count = ClassBenefit.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @class_be_personnels = ClassBenefit.paginate(:order =>"id DESC",:per_page=>pagesize,:page => params[:page] || 1)
      count = ClassBenefit.count
    end
    return render_json(@class_be_personnels,count)
  end
end
