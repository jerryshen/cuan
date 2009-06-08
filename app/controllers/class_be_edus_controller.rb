class ClassBeEdusController < ApplicationController
  # GET /class_be_edus
  # GET /class_be_edus.xml
  def index
    @class_be_edus = ClassBenefit.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @class_be_edus }
      format.json { render :text => get_json }
    end
  end

  # GET /class_be_edus/1
  # GET /class_be_edus/1.xml
  def show
    @class_be_edu = ClassBenefit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @class_be_edu }
    end
  end

  # GET /class_be_edus/new
  # GET /class_be_edus/new.xml
  def new
    @class_be_edu = ClassBenefit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @class_be_edu }
    end
  end

  # GET /class_be_edus/1/edit
  def edit
    @class_be_edu = ClassBenefit.find(params[:id])
  end

  # POST /class_be_edus
  # POST /class_be_edus.xml
  def create
    @class_be_edu = ClassBenefit.new(params[:class_be_edu])

    respond_to do |format|
      if @class_be_edu.save
#        flash[:notice] = 'ClassBeEdu was successfully created.'
        format.html { redirect_to(@class_be_edu) }
        format.xml  { render :xml => @class_be_edu, :status => :created, :location => @class_be_edu }
        format.json { render :text => '{status: "success", message: "成功提交课时津贴申请！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @class_be_edu.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@class_be_edu.errors.to_json}}"}
      end
    end
  end

  # PUT /class_be_edus/1
  # PUT /class_be_edus/1.xml
  def update
    @class_be_edu = ClassBenefit.find(params[:id])

    respond_to do |format|
      if @class_be_edu.update_attributes(params[:class_be_edu])
#        flash[:notice] = 'ClassBeEdu was successfully updated.'
        format.html { redirect_to(@class_be_edu) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改课时津贴申请！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @class_be_edu.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@class_be_edu.errors.to_json}}"}
      end
    end
  end

  # DELETE /class_be_edus/1
  # DELETE /class_be_edus/1.xml
  def destroy
    @class_be_edu = ClassBenefit.find(params[:id])
    @class_be_edu.destroy

    respond_to do |format|
      format.html { redirect_to(class_be_edus_url) }
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
      @class_be_edus = ClassBenefit.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>pagesize,:page => params[:page] || 1)
      count = ClassBenefit.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @class_be_edus = ClassBenefit.paginate(:order =>"id DESC",:per_page=>pagesize,:page => params[:page] || 1)
      count = ClassBenefit.count
    end
    return render_json(@class_be_edus,count)
  end
end
