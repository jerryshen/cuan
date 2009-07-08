class Temp2sController < ApplicationController
  def index
    @temp2s = Temp2.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @temp2s }
      format.json { render :text => get_json }
    end
  end

  def show
    @temp2 = Temp2.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @temp2 }
    end
  end

  def destroy
    @temp2 = Temp2.find(params[:id])
    @temp2.destroy

    respond_to do |format|
      format.html { redirect_to(temp2s_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def data_ipmort
    year  = params[:year]
    month = params[:month]
    Temp2.import(year, month)
  end

  private
  def get_json
    load_page_data
    @temp2s = Temp2.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
    count = Temp2.count
    return render_json(@temp2s,count)
  end

end
