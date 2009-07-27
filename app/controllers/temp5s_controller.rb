class Temp5sController < ApplicationController

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @temp5s }
      format.json { render :text => get_json }
    end
  end

  def show
    @temp5 = Temp5.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @temp5 }
    end
  end

  def edit
    @temp5 = Temp5.find(params[:id])
  end

  def update
    @temp5 = Temp5.find(params[:id])

    respond_to do |format|
      if @temp5.update_attributes(params[:temp5])
        format.html { redirect_to(@temp5) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新记录"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @temp5.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@temp5.errors.full_messages.to_json}}"}
      end
    end
  end

  def destroy
    @temp5 = Temp5.find(params[:id])
    @temp5.destroy

    respond_to do |format|
      format.html { redirect_to(temp5s_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end


  def data_ipmort
    year  = params[:year]
    month = params[:month]
    Temp5.import(year, month)
  end

  private
  def get_json
    load_page_data
    @temp5s = Temp5.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
    count = Temp5.count
    return render_json(@temp5s,count)
  end

end
