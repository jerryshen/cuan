class Temp2sController < ApplicationController
  def index
    @temp2s = Temp2.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @temp2s }
      format.json { render :text => get_json }
    end
  end


    private
  def get_json
    load_page_data
    @temp2s = Temp2.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
    count = Temp2.count
    return render_json(@temp2s,count)
  end

end
