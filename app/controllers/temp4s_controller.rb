class Temp4sController < ApplicationController

  def index
    @temp4s = Temp4.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @temp4s }
      format.json { render :text => get_json }
    end
  end

    private
  def get_json
    load_page_data
    @temp4s = Temp4.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
    count = Temp4.count
    return render_json(@temp4s,count)
  end

end
