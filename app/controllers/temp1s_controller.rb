class Temp1sController < ApplicationController

  def index
    @temp1s = Temp1.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @temp1s }
      format.json { render :text => get_json }
    end
  end

  def show
    @temp1 = Temp1.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @temp1 }
    end
  end

  def destroy
    @temp1 = Temp1.find(params[:id])
    @temp1.destroy

    respond_to do |format|
      format.html { redirect_to(temp1s_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def data_ipmort
    Temp1.import
  end

  private
  def get_json
    load_page_data
    @temp1s = Temp1.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
    count = Temp1.count
    return render_json(@temp1s,count)
  end

end
