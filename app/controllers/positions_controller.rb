class PositionsController < ApplicationController
#  protect_from_forgery :except => :index
#  skip_before_filter :verify_authenticity_token
  # GET /positions
  # GET /positions.xml
  def index
    @positions = Position.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @positions }
      format.json { render :text => get_json }
    end
  end

  # GET /positions/1
  # GET /positions/1.xml
  def show
    @position = Position.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @position }
    end
  end

  # GET /positions/new
  # GET /positions/new.xml
  def new
    @position = Position.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @position }
    end
  end

  # GET /positions/1/edit
  def edit
    @position = Position.find(params[:id])
  end

  # POST /positions
  # POST /positions.xml
  def create
    @position = Position.new(params[:position])

    respond_to do |format|
      if @position.save
        flash[:notice] = 'Position was successfully created.'
        format.html { redirect_to(@position) }
        format.xml  { render :xml => @position, :status => :created, :location => @position }
        format.json { render :text => '{status: "success", message: "成功创建职务！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @position.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@position.errors.to_json}}"}
      end
    end
  end

  # PUT /positions/1
  # PUT /positions/1.xml
  def update
    @position = Position.find(params[:id])

    respond_to do |format|
      if @position.update_attributes(params[:position])
        flash[:notice] = 'Position was successfully updated.'
        format.html { redirect_to(@position) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新职务！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @position.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@position.errors.to_json}}"}
      end
    end
  end

  # DELETE /positions/1
  # DELETE /positions/1.xml
  def destroy
    @position = Position.find(params[:id])
    @position.destroy

    respond_to do |format|
      format.html { redirect_to(positions_url) }
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
      @positions = Position.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>pagesize,:page => params[:page] || 1)
      count = Position.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @positions = Position.paginate(:order =>"id DESC",:per_page=>pagesize,:page => params[:page] || 1)
      count = Position.count
    end
    return render_json @positions,count
  end
end
