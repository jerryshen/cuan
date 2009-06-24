class AssistantsController < ApplicationController
  # GET /assistants
  # GET /assistants.xml
  def index
    @assistants = Assistant.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assistants }
      format.json { render :text => get_json }
      format.csv { export_csv(@assistants,
          { :id => "id", :user_id => "姓名", :benefit => "辅导员津贴", :other => "辅导员其他" }, "辅导员数据.csv") }
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
        format.html { redirect_to(@assistant) }
        format.xml  { render :xml => @assistant, :status => :created, :location => @assistant }
        format.json { render :text => '{status: "success", message: "成功添加辅导员！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @assistant.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@assistant.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /assistants/1
  # PUT /assistants/1.xml
  def update
    @assistant = Assistant.find(params[:id])

    respond_to do |format|
      if @assistant.update_attributes(params[:assistant])
        format.html { redirect_to(@assistant) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改辅导员！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @assistant.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@assistant.errors.full_mesages.to_json}}"}
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
    load_page_data
    conditions = '1=1'
    condition_values = []
    if(!params[:search_name].blank?)
      if user = User.find_by_name(params[:search_name])
        user_id = user.id
      else
        user_id = 0
      end
      joins = ""
      conditions += " AND user_id = ?"
      condition_values << user_id
    end

    if(!params[:search_department_id].blank?)
      joins = "INNER JOIN users p ON assistants.user_id=p.id"
      conditions += " AND p.department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @assistants = Assistant.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=>@pagesize, :page => params[:page] || 1)
      count = Assistant.count(:joins => joins, :conditions => option_conditions)
    else
      @assistants = Assistant.paginate(:order =>"id DESC",:per_page=>@pagesize, :page => params[:page] || 1)
      count = Assistant.count
    end
    return render_json(@assistants,count)
  end
end
