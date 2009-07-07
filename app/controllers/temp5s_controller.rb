class Temp5sController < ApplicationController

  def index
    @temp5s = Temp5.all

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

  def destroy
    @temp5 = Temp5.find(params[:id])
    @temp5.destroy

    respond_to do |format|
      format.html { redirect_to(temp5s_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  private
  def get_json
    load_page_data
    @temp5s = Temp5.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
    count = Temp5.count
    return render_json(@temp5s,count)
  end

end
