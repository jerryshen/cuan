class TitlesController < ApplicationController
  # GET /titles
  # GET /titles.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @titles }
      format.json { render :text => get_json }
    end
  end

  # GET /titles/1
  # GET /titles/1.xml
  def show
    @title = Title.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @title }
    end
  end

  # GET /titles/new
  # GET /titles/new.xml
  def new
    @title = Title.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @title }
    end
  end

  # GET /titles/1/edit
  def edit
    @title = Title.find(params[:id])
  end

  # POST /titles
  # POST /titles.xml
  def create
    @title = Title.new(params[:title])

    respond_to do |format|
      if @title.save
        format.html { redirect_to(@title) }
        format.xml  { render :xml => @title, :status => :created, :location => @title }
        format.json { render :text => '{status: "success",message: "成功创建职称！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @title.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@department.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /titles/1
  # PUT /titles/1.xml
  def update
    @title = Title.find(params[:id])

    respond_to do |format|
      if @title.update_attributes(params[:title])
        format.html { redirect_to(@title) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success",message: "成功更新职称！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @title.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@department.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /titles/1
  # DELETE /titles/1.xml
  def destroy
    @title = Title.find(params[:id])
    @title.destroy

    respond_to do |format|
      format.html { redirect_to(titles_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end
  
  private
  def get_json
    load_page_data
    if(params[:search_name] && params[:search_name].to_s!='')
      @titles = Title.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=> @pagesize,:page => params[:page] || 1)
      count = Title.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @titles = Title.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = Title.count
    end
    return render_json(@titles,count)
  end
end
