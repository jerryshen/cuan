class AssistantsController < ApplicationController
  # GET /assistants
  # GET /assistants.xml
  def index
    @assistants = Assistant.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assistants }
      format.json { render :text => get_json }
    end
  end

  # GET /assistants/1
  # GET /assistants/1.xml
  def show
    @assistant = Assistant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @assistant }
    end
  end

  # GET /assistants/new
  # GET /assistants/new.xml
  def new
    @assistant = Assistant.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @assistant }
    end
  end

  # GET /assistants/1/edit
  def edit
    @assistant = Assistant.find(params[:id])
  end

  # POST /assistants
  # POST /assistants.xml
  def create
    @assistant = Assistant.new(params[:assistant])

    respond_to do |format|
      if @assistant.save
        flash[:notice] = 'Assistant was successfully created.'
        format.html { redirect_to(@assistant) }
        format.xml  { render :xml => @assistant, :status => :created, :location => @assistant }
        format.json { render :text => '{status: "success", message: "成功添加辅导员！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @assistant.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@assistant.errors.to_json}}"}
      end
    end
  end

  # PUT /assistants/1
  # PUT /assistants/1.xml
  def update
    @assistant = Assistant.find(params[:id])

    respond_to do |format|
      if @assistant.update_attributes(params[:assistant])
        flash[:notice] = 'Assistant was successfully updated.'
        format.html { redirect_to(@assistant) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改辅导员！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @assistant.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@assistant.errors.to_json}}"}
      end
    end
  end

  # DELETE /assistants/1
  # DELETE /assistants/1.xml
  def destroy
    @assistant = Assistant.find(params[:id])
    @assistant.destroy

    respond_to do |format|
      format.html { redirect_to(assistants_url) }
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
      @assistants = Assistant.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>pagesize,:page => params[:page] || 1)
      count = AssistantAssistant.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @assistants = Assistant.paginate(:order =>"id DESC",:per_page=>pagesize,:page => params[:page] || 1)
      count = Assistant.count
    end
    return render_json(@assistants,count)
  end
end
