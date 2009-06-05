class RetiredFeeCuttingRecordsController < ApplicationController
  # GET /retired_fee_cutting_records
  # GET /retired_fee_cutting_records.xml
  def index
    @retired_fee_cutting_records = RetiredFeeCuttingRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @retired_fee_cutting_records }
    end
  end

  # GET /retired_fee_cutting_records/1
  # GET /retired_fee_cutting_records/1.xml
  def show
    @retired_fee_cutting_record = RetiredFeeCuttingRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @retired_fee_cutting_record }
    end
  end

  # GET /retired_fee_cutting_records/new
  # GET /retired_fee_cutting_records/new.xml
  def new
    @retired_fee_cutting_record = RetiredFeeCuttingRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @retired_fee_cutting_record }
    end
  end

  # GET /retired_fee_cutting_records/1/edit
  def edit
    @retired_fee_cutting_record = RetiredFeeCuttingRecord.find(params[:id])
  end

  # POST /retired_fee_cutting_records
  # POST /retired_fee_cutting_records.xml
  def create
    @retired_fee_cutting_record = RetiredFeeCuttingRecord.new(params[:retired_fee_cutting_record])

    respond_to do |format|
      if @retired_fee_cutting_record.save
        flash[:notice] = 'RetiredFeeCuttingRecord was successfully created.'
        format.html { redirect_to(@retired_fee_cutting_record) }
        format.xml  { render :xml => @retired_fee_cutting_record, :status => :created, :location => @retired_fee_cutting_record }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @retired_fee_cutting_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /retired_fee_cutting_records/1
  # PUT /retired_fee_cutting_records/1.xml
  def update
    @retired_fee_cutting_record = RetiredFeeCuttingRecord.find(params[:id])

    respond_to do |format|
      if @retired_fee_cutting_record.update_attributes(params[:retired_fee_cutting_record])
        flash[:notice] = 'RetiredFeeCuttingRecord was successfully updated.'
        format.html { redirect_to(@retired_fee_cutting_record) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @retired_fee_cutting_record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /retired_fee_cutting_records/1
  # DELETE /retired_fee_cutting_records/1.xml
  def destroy
    @retired_fee_cutting_record = RetiredFeeCuttingRecord.find(params[:id])
    @retired_fee_cutting_record.destroy

    respond_to do |format|
      format.html { redirect_to(retired_fee_cutting_records_url) }
      format.xml  { head :ok }
    end
  end
end
